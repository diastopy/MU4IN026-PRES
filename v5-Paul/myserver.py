from flask import Flask, send_from_directory
import os

app = Flask(__name__)

DOSSIER_FICHIERS = os.path.abspath(".")  # Le dossier courant

@app.route('/<path:filename>')
def servir_fichier(filename):
    return send_from_directory(DOSSIER_FICHIERS, filename)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
