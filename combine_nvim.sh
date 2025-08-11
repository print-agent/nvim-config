#!/bin/bash
output_file="combined_config.txt"
> "$output_file" # Create or clear the output file

# Find and process .lua and .vim files in the current directory
find . -type f \( -name "*.lua" -o -name "*.vim" \) | while read -r file; do
  echo "===== $file =====" >> "$output_file"
  cat "$file" >> "$output_file"
  echo -e "\n" >> "$output_file"
done

echo "Combined config saved to $output_file"
