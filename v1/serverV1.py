from flask import Flask, Response, render_template

app = Flask(__name__)

# Chemin du fichier vidéo (assure-toi qu'il est bien placé ici)
VIDEO_PATH = "video/video1.mp4"

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/video')
def video():
    def generate():
        with open(VIDEO_PATH, "rb") as video_file:
            while chunk := video_file.read(1024):
                yield chunk
    return Response(generate(), mimetype="video/mp4")

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000, debug=True)
