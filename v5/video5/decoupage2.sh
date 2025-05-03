#!/bin/bash

# Vérification de l'existence du dossier et suppression s'il existe
OUTPUT_DIR="dash_output"
if [ -d "$OUTPUT_DIR" ]; then
  rm -rf "$OUTPUT_DIR"
fi

# Création du répertoire de sortie
mkdir -p "$OUTPUT_DIR"

# Input vidéo
INPUT="video5.mp4"

# Étape 1 : Split en 16 tuiles avec différents débits et encodage séparé
ffmpeg -i "$INPUT" -filter_complex "
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
  [v16]crop=iw/4:ih/4:iw*3/4:ih*3/4[tile16];
" \
-map "[tile1]" -c:v libx264 -b:v 200k -maxrate 400k -bufsize 800k "$OUTPUT_DIR/tile1.mp4" \
-map "[tile2]" -c:v libx264 -b:v 200k -maxrate 400k -bufsize 800k "$OUTPUT_DIR/tile2.mp4" \
-map "[tile3]" -c:v libx264 -b:v 200k -maxrate 400k -bufsize 800k "$OUTPUT_DIR/tile3.mp4" \
-map "[tile4]" -c:v libx264 -b:v 200k -maxrate 400k -bufsize 800k "$OUTPUT_DIR/tile4.mp4" \
-map "[tile5]" -c:v libx264 -b:v 2000k -maxrate 4000k -bufsize 8000k "$OUTPUT_DIR/tile5.mp4" \
-map "[tile6]" -c:v libx264 -b:v 2000k -maxrate 4000k -bufsize 8000k "$OUTPUT_DIR/tile6.mp4" \
-map "[tile7]" -c:v libx264 -b:v 2000k -maxrate 4000k -bufsize 8000k "$OUTPUT_DIR/tile7.mp4" \
-map "[tile8]" -c:v libx264 -b:v 2000k -maxrate 4000k -bufsize 8000k "$OUTPUT_DIR/tile8.mp4" \
-map "[tile9]" -c:v libx264 -b:v 2000k -maxrate 4000k -bufsize 8000k "$OUTPUT_DIR/tile9.mp4" \
-map "[tile10]" -c:v libx264 -b:v 2000k -maxrate 4000k -bufsize 8000k "$OUTPUT_DIR/tile10.mp4" \
-map "[tile11]" -c:v libx264 -b:v 2000k -maxrate 4000k -bufsize 8000k "$OUTPUT_DIR/tile11.mp4" \
-map "[tile12]" -c:v libx264 -b:v 2000k -maxrate 4000k -bufsize 8000k "$OUTPUT_DIR/tile12.mp4" \
-map "[tile13]" -c:v libx264 -b:v 200k -maxrate 400k -bufsize 800k "$OUTPUT_DIR/tile13.mp4" \
-map "[tile14]" -c:v libx264 -b:v 200k -maxrate 400k -bufsize 800k "$OUTPUT_DIR/tile14.mp4" \
-map "[tile15]" -c:v libx264 -b:v 200k -maxrate 400k -bufsize 800k "$OUTPUT_DIR/tile15.mp4" \
-map "[tile16]" -c:v libx264 -b:v 200k -maxrate 400k -bufsize 800k "$OUTPUT_DIR/tile16.mp4"

# Vérification si les fichiers vidéo des tuiles sont bien créés
for tile in "$OUTPUT_DIR/tile"*.mp4; do
  if [ ! -f "$tile" ]; then
    echo "Erreur : Le fichier $tile n'a pas été créé."
    exit 1
  fi
done

# Étape 2 : Combinaison des tuiles en une seule vidéo
ffmpeg -i "$OUTPUT_DIR/tile1.mp4" -i "$OUTPUT_DIR/tile2.mp4" -i "$OUTPUT_DIR/tile3.mp4" -i "$OUTPUT_DIR/tile4.mp4" \
-i "$OUTPUT_DIR/tile5.mp4" -i "$OUTPUT_DIR/tile6.mp4" -i "$OUTPUT_DIR/tile7.mp4" -i "$OUTPUT_DIR/tile8.mp4" \
-i "$OUTPUT_DIR/tile9.mp4" -i "$OUTPUT_DIR/tile10.mp4" -i "$OUTPUT_DIR/tile11.mp4" -i "$OUTPUT_DIR/tile12.mp4" \
-i "$OUTPUT_DIR/tile13.mp4" -i "$OUTPUT_DIR/tile14.mp4" -i "$OUTPUT_DIR/tile15.mp4" -i "$OUTPUT_DIR/tile16.mp4" \
-filter_complex "
  [0:v][1:v][2:v][3:v]hstack=inputs=4[top];
  [4:v][5:v][6:v][7:v]hstack=inputs=4[middle_top];
  [8:v][9:v][10:v][11:v]hstack=inputs=4[middle_bottom];
  [12:v][13:v][14:v][15:v]hstack=inputs=4[bottom];
  [top][middle_top]vstack=inputs=2[full_top];
  [middle_bottom][bottom]vstack=inputs=2[full_bottom];
  [full_top][full_bottom]vstack=inputs=2[output]" \
-map "[output]" -c:v libx264 -b:v 500k -maxrate 1000k -bufsize 2000k "$OUTPUT_DIR/combined_video.mp4"

# Étape 3 : Extraction de l'audio
ffmpeg -i "$INPUT" -vn -acodec aac -b:a 128k "$OUTPUT_DIR/audio.m4a"

# Vérification si l'audio est bien extrait
if [ ! -f "$OUTPUT_DIR/audio.m4a" ]; then
  echo "Erreur : L'audio n'a pas été extrait."
  exit 1
fi

# Étape 4 : Emballage DASH
MP4Box -dash 4000 -segment-name 'tile_$RepresentationID$_$Number$' \
  "$OUTPUT_DIR/combined_video.mp4" "$OUTPUT_DIR/audio.m4a" \
  -out "$OUTPUT_DIR/output.mpd"

# Vérification de l'existence du fichier MPD
if [ ! -f "$OUTPUT_DIR/output.mpd" ]; then
  echo "Erreur : Le fichier MPD n'a pas été créé."
  exit 1
fi

echo "Processus terminé avec succès."
