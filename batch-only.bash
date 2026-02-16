# This script only has the batching mechanism and is still takes the same execution time as the original script.
# This is here for learning and if you want to see the faster script, run the batch+parallelism.bash script.

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

process-file() {
  local file=$1

  # Simulate some work for each file
  sleep 0.01 # Reduced sleep for quicker demonstration
}

shopt -s globstar nullglob

echo 'finding files...'
# Using /usr/bin for demonstration as it usually contains many files. Replace with any directory with lots of files
files=(/usr/bin/*)
len=${#files[@]}
echo "found $len files"

# --- Batch system implementation ---
batch_size=10 # <--- Set your desired batch size here!

total_processed=0

echo "Processing files in batches of $batch_size..."

# Loop through files in batches
for ((i = 0; i < len; i += batch_size)); do
  # Determine the end index for the current batch, ensuring it doesn't go past the total number of files
  # This is how we deal with any reminders
  batch_end=$((i + batch_size - 1))
  if ((batch_end >= len)); then
    batch_end=$((len - 1))
  fi

  # Process files within the current batch
  for ((j = i; j <= batch_end; j++)); do
    file="${files[j]}"
    process-file "$file"
    ((total_processed++))                  # Increment total processed count
    progress-bar "$total_processed" "$len" # Update progress bar with total processed
  done
done

printf "\nDone processing all $len files in $SECONDS seconds!"
