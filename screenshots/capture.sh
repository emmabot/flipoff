#!/bin/bash
# Capture App Store screenshots using Chrome headless
# Requires Chrome installed. Run from repo root.

for mode in kids-mode innovator-mode history-mode mode-picker riddle-mode; do
    /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
        --headless --disable-gpu \
        --window-size=1920,1080 \
        --screenshot="screenshots/${mode}.png" \
        "file://$(pwd)/screenshots/${mode}.html"
    echo "Captured ${mode}.png"
done

echo ""
echo "Verifying dimensions..."
sips -g pixelWidth -g pixelHeight screenshots/*.png

