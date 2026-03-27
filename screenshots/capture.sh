#!/bin/bash
# Open each HTML file in Chrome at exact viewport size and screenshot
# Requires Chrome installed

for mode in kids-mode innovator-mode history-mode; do
    /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
        --headless --disable-gpu \
        --window-size=1920,1080 \
        --screenshot="screenshots/${mode}.png" \
        "file://$(pwd)/screenshots/${mode}.html"
    echo "Captured ${mode}.png"
done

