"""from flask import Flask, send_file, render_template

app = Flask(__name__)

# Route pour afficher la page vidéo
@app.route('/')
def index():
    return render_template('index.html')

# Route pour diffuser la vidéo
def generate():
    with open("video.mp4", "rb") as video_file:
        chunk = video_file.read(1024)
        while chunk:
            yield chunk
            chunk = video_file.read(1024)

@app.route('/video')
def video():
    return send_file("video/video1.mp4", mimetype='video/mp4')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
"""

"""import os
from flask import Flask, send_file, render_template, request, jsonify

app = Flask(__name__)

VIDEO_FOLDER = "video"  # Dossier où sont stockées les vidéos

@app.route('/')
def index():
    # Récupère la liste des fichiers vidéo dans le dossier
    videos = [f for f in os.listdir(VIDEO_FOLDER) if f.endswith(('.mp4', '.webm', '.ogg'))]
    return render_template('index.html', videos=videos)

@app.route('/video/<filename>')
def video(filename):
    video_path = os.path.join(VIDEO_FOLDER, filename)
    if os.path.exists(video_path):
        return send_file(video_path, mimetype='video/mp4')
    else:
        return "Vidéo non trouvée", 404

if __name__ == '__main__':
    app.run(debug=True)
"""

from flask import Flask, render_template, send_from_directory

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/dash/<path:filename>')
def serve_dash(filename):
    return send_from_directory('static/dash', filename)

if __name__ == '__main__':
    app.run(debug=True)
