# Workshop: Terminal Mastery & Bash Scripting

## Build a Dynamic Progress Bar

This repository contains a guided tutorial on creating a lightweight, terminal-based progress bar. We leverage the power of **Bash** and **CLI editors** to build a tool that feels like a modern package manager but runs with zero dependencies.

---

## 1. Prerequisites

Ensure you are in a Unix-like environment (WSL, Linux, or macOS).

```bash
# Update your package manager (Ubuntu/Debian example)
sudo apt update

# Ensure you have the 'fancy' editors available
sudo apt install vim neovim nano -y

```

---

## 2. Preparation of Work Environment

Run these commands to generate the dummy data we will "process" and create our script file.

```bash
# 1. Create a messy directory structure
mkdir -p foo bar baz

# 2. Populate with target and non-target files
touch foo/1.jpg foo/2.txt
touch bar/foo-{1..500}-cache
touch baz/dont-delete-me

# 3. Create the script file
touch progress-bar

# 4. Open with a lightweight editor (Pick your level)
nano progress-bar   # Beginner
vim progress-bar    # Intermediate
nvim progress-bar   # Advanced

```

---

## 3. Step-by-Step Code Breakdown

### Step I: The Shebang

Every script starts with this line. It tells the OS which interpreter to use to execute the file.

```bash
#!/usr/bin/env bash

```

### Step II: File Discovery & Loops

Before the UI, we need data. We use `globstar` to find files recursively.

```bash
shopt -s globstar nullglob

echo 'Scanning for files...'
files=(./**/*cache)
len=${#files[@]}
echo "Found $len files to process."

# A basic loop to test discovery
i=0
for file in "${files[@]}"; do
    echo "Processing: $file"
    ((i++))
done

```

### Step III: The Progress Bar Function

We replace the simple `echo` with a function. In Bash, variables inside functions should be declared as `local` to avoid polluting the global scope.

```bash
progress-bar() {
    local current=$1
    local len=$2
    local length=50 # Total width of the bar in characters
    
    # Arithmetic Expansion $(( ... )) for the math
    local perc_done=$((current * 100 / len))
    local num_bars=$((perc_done * length / 100))
}

```

### Step IV: Logic & ANSI Colors

We use a `for` loop to build a string `s`. Note the `\e[31m` (Red) and `\e[0m` (Reset) codes.

* **The Magic Flag:** `echo -ne ... \r`
* `-n`: Do not print a newline.
* `-e`: Enable interpretation of backslash escapes.
* `\r`: Carriage return. This moves the cursor back to the start of the line so we can overwrite it.



### Step V: Simulation Logic

We add a `sleep` command to `process-file`. Without this, Bash would process 500 files so fast you wouldn't even see the bar move!

```bash
process-file() {
    local file=$1
    sleep .01 # Simulate 10ms of work
}

```

### Step VI: The Final Touch

After the loop finishes, we add a final `echo`. Since the progress bar ends with `\r`, the cursor is still at the beginning of that line. A blank `echo` moves the cursor to a fresh line so the terminal prompt doesn't overwrite your beautiful progress bar.

---

## 4. The Challenge: Batching

Currently, our script processes files one by one. In a production environment, this is often inefficient.

**Your Task:**
Can you modify the script to process files in **batches of 10**?

* How would you update the progress bar to reflect 10 steps at once?
* How would you handle a remainder (e.g., if there are 503 files)?

*No code provided for this—use your man pages and Google!*

---
