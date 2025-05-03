#!/bin/bash

INPUT="video5.mp4"
OUTPUT_DIR="dash_output"
mkdir -p "$OUTPUT_DIR"

# Step 1: Split into 16 tiles and encode
ffmpeg -i "$INPUT" \
  -filter_complex "
    [0:v]split=16[v1][v2][v3][v4][v5][v6][v7][v8][v9][v10][v11][v12][v13][v14][v15][v16];
    [v1]crop=iw/4:ih/4:0:0[tile1];
    [v2]crop=iw/4:ih/4:iw/4:0[tile2];
    [v3]crop=iw/4:ih/4:iw/2:0[tile3];
    [v4]crop=iw/4:ih/4:iw*3/4:0[tile4];
    [v5]crop=iw/4:ih/4:0:ih/4[tile5];
    [v6]crop=iw/4:ih/4:iw/4:ih/4[tile6];
    [v7]crop=iw/4:ih/4:iw/2:ih/4[tile7];
    [v8]crop=iw/4:ih/4:iw*3/4:ih/4[tile8];
    [v9]crop=iw/4:ih/4:0:ih/2[tile9];
    [v10]crop=iw/4:ih/4:iw/4:ih/2[tile10];
    [v11]crop=iw/4:ih/4:iw/2:ih/2[tile11];
    [v12]crop=iw/4:ih/4:iw*3/4:ih/2[tile12];
    [v13]crop=iw/4:ih/4:0:ih*3/4[tile13];
    [v14]crop=iw/4:ih/4:iw/4:ih*3/4[tile14];
    [v15]crop=iw/4:ih/4:iw/2:ih*3/4[tile15];
    [v16]crop=iw/4:ih/4:iw*3/4:ih*3/4[tile16]
  " \
  -map "[tile1]" -c:v libx264 -b:v 500k -maxrate 1000k -bufsize 2000k "$OUTPUT_DIR/tile1.mp4" \
  -map "[tile2]" -c:v libx264 -b:v 500k -maxrate 1000k -bufsize 2000k "$OUTPUT_DIR/tile2.mp4" \
  -map "[tile3]" -c:v libx264 -b:v 500k -maxrate 1000k -bufsize 2000k "$OUTPUT_DIR/tile3.mp4" \
  -map "[tile4]" -c:v libx264 -b:v 500k -maxrate 1000k -bufsize 2000k "$OUTPUT_DIR/tile4.mp4" \
  -map "[tile5]" -c:v libx264 -b:v 1000k -maxrate 1500k -bufsize 3000k "$OUTPUT_DIR/tile5.mp4" \
  -map "[tile6]" -c:v libx264 -b:v 5000k -maxrate 6000k -bufsize 12000k -s 1920x1080 "$OUTPUT_DIR/tile6.mp4" \
  -map "[tile7]" -c:v libx264 -b:v 5000k -maxrate 6000k -bufsize 12000k -s 1920x1080 "$OUTPUT_DIR/tile7.mp4" \
  -map "[tile8]" -c:v libx264 -b:v 1000k -maxrate 1500k -bufsize 3000k "$OUTPUT_DIR/tile8.mp4" \
  -map "[tile9]" -c:v libx264 -b:v 1000k -maxrate 1500k -bufsize 3000k "$OUTPUT_DIR/tile9.mp4" \
  -map "[tile10]" -c:v libx264 -b:v 5000k -maxrate 6000k -bufsize 12000k -s 1920x1080 "$OUTPUT_DIR/tile10.mp4" \
  -map "[tile11]" -c:v libx264 -b:v 5000k -maxrate 6000k -bufsize 12000k -s 1920x1080 "$OUTPUT_DIR/tile11.mp4" \
  -map "[tile12]" -c:v libx264 -b:v 1000k -maxrate 1500k -bufsize 3000k "$OUTPUT_DIR/tile12.mp4" \
  -map "[tile13]" -c:v libx264 -b:v 500k -maxrate 1000k -bufsize 2000k "$OUTPUT_DIR/tile13.mp4" \
  -map "[tile14]" -c:v libx264 -b:v 500k -maxrate 1000k -bufsize 2000k "$OUTPUT_DIR/tile14.mp4" \
  -map "[tile15]" -c:v libx264 -b:v 500k -maxrate 1000k -bufsize 2000k "$OUTPUT_DIR/tile15.mp4" \
  -map "[tile16]" -c:v libx264 -b:v 500k -maxrate 1000k -bufsize 2000k "$OUTPUT_DIR/tile16.mp4" \
  -map 0:a -c:a aac -b:a 128k "$OUTPUT_DIR/audio.m4a"

# Step 2: Generate DASH manifest (alternative without SRD)
MP4Box -dash 4000 -profile dashavc264:onDemand \
  -segment-name 'tile_$RepresentationID$_$Number$' \
  "$OUTPUT_DIR/tile1.mp4" "$OUTPUT_DIR/tile2.mp4" "$OUTPUT_DIR/tile3.mp4" "$OUTPUT_DIR/tile4.mp4" \
  "$OUTPUT_DIR/tile5.mp4" "$OUTPUT_DIR/tile6.mp4" "$OUTPUT_DIR/tile7.mp4" "$OUTPUT_DIR/tile8.mp4" \
  "$OUTPUT_DIR/tile9.mp4" "$OUTPUT_DIR/tile10.mp4" "$OUTPUT_DIR/tile11.mp4" "$OUTPUT_DIR/tile12.mp4" \
  "$OUTPUT_DIR/tile13.mp4" "$OUTPUT_DIR/tile14.mp4" "$OUTPUT_DIR/tile15.mp4" "$OUTPUT_DIR/tile16.mp4" \
  "$OUTPUT_DIR/audio.m4a" \
  -out "$OUTPUT_DIR/output.mpd"
