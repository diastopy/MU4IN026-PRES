from flask import Flask, Response, render_template, request, send_from_directory
import os

app = Flask(__name__)

# Dossier contenant les vidéos
VIDEO_FOLDER = "video"

@app.route('/')
def index():
    """ Liste les vidéos disponibles dans le dossier /video """
    videos = [f for f in os.listdir(VIDEO_FOLDER) if f.endswith(('.mp4', '.webm', '.avi'))]
    return render_template('index.html', videos=videos)

@app.route('/video/<filename>')
def video(filename):
    """ Sert la vidéo sélectionnée """
    return send_from_directory(VIDEO_FOLDER, filename, mimetype="video/mp4")

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000, debug=True)
