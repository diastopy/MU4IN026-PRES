#!/bin/bash

INPUT_MP4="video_q22.mp4"
OUTPUT_MP4="output_with_high.mp4"
TEXT="HIGH"
FONT_SIZE=10
FONT_COLOR="white"

# Temporary directory for extracted tiles
mkdir -p tmp_tiles

# Extract all tiles (Tracks 2-17) using MP4Box
for TRACK in {2..17}; do
    echo "Extracting Track $TRACK..."
    MP4Box -raw $TRACK "$INPUT_MP4" -out "tmp_tiles/tile_${TRACK}.hvc" 2>/dev/null
done

# Add "HIGH" to each tile using FFmpeg
for TRACK in {2..17}; do
    echo "Adding text to Track $TRACK..."
    ffmpeg -i "tmp_tiles/tile_${TRACK}.hvc" -vf \
        "drawtext=text='$TEXT':fontsize=$FONT_SIZE:fontcolor=$FONT_COLOR:x=(w-text_w)/2:y=(h-text_h)/2" \
        -c:v libx265 -tag:v hvc1 -preset fast -crf 18 "tmp_tiles/tile_${TRACK}_with_text.hvc" 2>/dev/null
done

# Rebuild the final MP4 with modified tiles
echo "Rebuilding final MP4..."
MP4Box -add "$INPUT_MP4#1" -new "$OUTPUT_MP4"  # Keep original base track (Track 1)

for TRACK in {2..17}; do
    MP4Box -add "tmp_tiles/tile_${TRACK}_with_text.hvc" "$OUTPUT_MP4" 2>/dev/null
done

# Cleanup temporary files
rm -rf tmp_tiles

echo "Done! Output saved to: $OUTPUT_MP4"