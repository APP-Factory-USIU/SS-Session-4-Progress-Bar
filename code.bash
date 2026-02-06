#!/usr/bin/env bash

progress-bar() {
  local current=$1
  local len=$2

  local bar_char='#'
  local empty_char='-'
  local length=50
  local perc_done=$((current * 100 / len))
  local num_bars=$((perc_done * length / 100))

  local i
  local s='['
  for ((i = 0; i < num_bars; i++)); do
    s+=$'\e[31m'$bar_char$'\e[0m'
  done
  for ((i = num_bars; i < length; i++)); do
    s+=$empty_char
  done
  s+=']'

  echo -ne "$s  $current/$len ($perc_done%)\r"

}

# This function now just processes a single file
process-file() {
  local file=$1
  # Simulate some work for each file
  sleep 0.01
  # For demonstration, let's output something to show it's working
  # echo "Processed: $file" > /dev/null # Redirect to null to avoid cluttering output
}

export -f process-file

shopt -s globstar nullglob

echo 'finding files'
files=(/usr/bin/*) # Using /usr/bin for demonstration
len=${#files[@]}
echo "found $len files"

batch_size=100       # <--- Your desired batch size
max_parallel_jobs=10 # <--- Set how many files to process simultaneously within a batch

total_processed=0

echo "Processing files in batches of $batch_size with $max_parallel_jobs parallel jobs per batch..."

# Loop through files in batches
for ((i = 0; i < len; i += batch_size)); do
  # Determine the end index for the current batch
  batch_end=$((i + batch_size - 1))
  if ((batch_end >= len)); then
    batch_end=$((len - 1))
  fi

  # Create an array for the current batch's files
  current_batch_files=()
  for ((j = i; j <= batch_end; j++)); do
    current_batch_files+=("${files[j]}")
  done

  # Process the current batch in parallel using xargs
  # We use a temporary file to pass the batch files to xargs safely
  # and then process them in parallel.
  # The `process-file` command is called for each file by xargs.
  printf '%s\n' "${current_batch_files[@]}" | xargs -P "$max_parallel_jobs" -I {} bash -c 'process-file "$@"' _ {}

  # Update total processed count after the batch is complete
  total_processed=$((total_processed + ${#current_batch_files[@]}))
  progress-bar "$total_processed" "$len" # Update progress bar

done

echo
printf "Done processing all $len files in $SECONDS seconds!\n"
