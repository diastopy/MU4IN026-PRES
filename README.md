# PROJET RESEAU 14 - L'impact des ROI (regions of interest) dans le streaming vidéo

## Lancer le serveur

`py serverVideo.py`

## Passer d'une vidéo 1080p à d'autres qualités

```ffmpeg -i <input>.mp4 -vf "scale=<pxLong>:<pxLarg>" -c:v libx264 -preset fast -b:v <bitrate>k -c:a aac -b:a <bitrateAudio>k <output>.mp4```\
Avec des exemples de bitrates :\
360p : 500 - 1000 kbps\
480p : 1000 - 1500 kbps\
720p : 2000 - 2500 kbps\
1080p : 3500 - 5000 kbps\
\
En général le bitrate audio est à 128k  

## Créer un mpd

### et n'avoir qu'une qualité

```ffmpeg -i video/video1.mp4 -map 0 -c:a aac -b:a 128k -c:v libx264 -b:v 5000k -s 1920x1080 -f dash video/output.mpd```

### et avoir plusieurs qualités (ici 360p, 480p, 720p et 1080p)

```ffmpeg -i video4/video4.mp4 -map 0:v:0 -map 0:v:0 -map 0:v:0 -map 0:v:0 -map 0:a:0 -c:v libx264 -c:a aac -ar 48000 -ac 2 -b:v:0 800k  -s:v:0 640x360  -preset fast -profile:v:0 baseline -b:v:1 1200k -s:v:1 854x480  -preset fast -profile:v:1 main -b:v:2 2500k -s:v:2 1280x720 -preset fast -profile:v:2 high -b:v:3 5000k -s:v:3 1920x1080 -preset fast -profile:v:3 high -b:a 128k -f dash -adaptation_sets "id=0,streams=v id=1,streams=a" video4/output.mpd```

## Pour la v5

(Pour ceux comme moi qui n'ont pas Flash dans leur environnement python, avant de démarrer le serveur entrez : source venv/bin/activate)

aller dans video5 -> lancer le script ./decoupage2.sh -> puis lancer le serveur serverV5.py
