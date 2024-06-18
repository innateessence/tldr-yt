#!/usr/bin/env bash

if [ -z "$1" ]; then
  echo "Usage: $0 <youtube-url>"
  exit 1
fi

url=$1
echo "Downloading subtitles..."
yt-dlp --skip-download --write-auto-sub --sub-lang "en" "$url" -o TEMP_SUBS &> /dev/null
cat TEMP_SUBS.en.vtt | tail +5 | grep -v -E '[0-9]+' > trimmed_subtitles.txt
python3 extract-subs.py trimmed_subtitles.txt > extracted_text.txt

echo "starting ollama..."
ollama serve &> /dev/null &

echo "Pulling llama3..."
ollama pull llama3 &> /dev/null

echo "running llama3"
echo -e '\n\n'
ollama run llama3<<EOF

/set template $(cat prompt.txt)
$(cat extracted_text.txt)
EOF

rm -f trimmed_subtitles.txt extracted_text.txt TEMP_SUBS.en.vtt || echo "Failed to cleanup files"
killall ollama || echo "Failed to kill ollama"
