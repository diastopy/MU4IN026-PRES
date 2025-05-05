from flask import Flask, send_from_directory, request
import os

app = Flask(__name__)

@app.route('/')
def index():
    return send_from_directory('templates', 'index.html')

@app.route('/video4/<path:filename>')
def video(filename):
    print(f"📡 Segment demandé : {filename}")  # Debug : voir quels fichiers sont demandés
    return send_from_directory('video4', filename)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000, debug=True)
