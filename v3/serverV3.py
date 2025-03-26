from flask import Flask, send_from_directory, render_template

app = Flask(__name__)

# Dossier où sont stockés les fichiers DASH
VIDEO_FOLDER = "video"

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/video/<path:filename>')
def video(filename):
    """ Sert les fichiers vidéo DASH """
    return send_from_directory(VIDEO_FOLDER, filename)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000, debug=True)
