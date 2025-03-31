# PROJET RESEAU 14 - L'impact des ROI (regions of interest) dans le streaming vidéo

## Lancer le serveur

`py serverVideo.py --host=0.0.0.0 --port=8000`

## Passer d'une vidéo 1080p à d'autres qualités

`ffmpeg -i <input>.mp4 -vf "scale=<pxLong>:<pxLarg>" -c:v libx264 -preset fast -b:v <bitrate>k -c:a aac -b:a <bitrateAudio>k <output>.mp4`
Avec des exemples de bitrates :
360p : 500 - 1000 kbps
480p : 1000 - 1500 kbps
720p : 2000 - 2500 kbps
1080p : 3500 - 5000 kbps
\
En général le bitrate audio est à 128k\

Pour créer un mpd à partir d'UNE source vidéo :
`ffmpeg -i video/video1.mp4 -map 0 -c:a aac -b:a 128k -c:v libx264 -b:v 5000k -s 1920x1080 -f dash video/output.mpd`