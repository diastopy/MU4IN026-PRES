from flask import Flask, send_from_directory, request
import os

app = Flask(__name__)

@app.route('/')
def index():
    return send_from_directory('templates', 'index.html')

# Sert les fichiers DASH (manifest, segments vidéo et audio)
@app.route('/video5/dash_output/<path:filename>')
def dash_video(filename):
    print(f"📡 Fichier DASH demandé : {filename}")
    return send_from_directory('video5/dash_output', filename)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000, debug=True)
