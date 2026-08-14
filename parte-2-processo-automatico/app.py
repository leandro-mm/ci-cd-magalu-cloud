# pequena aplicação Flask com dois endpoints

from flask import Flask, jsonify

app = Flask(__name__)

#dentifica a aplicação e sua versão
@app.route("/")
def index():
 return jsonify({
    "application": "Meu Pipeline",
    "version": "1.0.0",
    "provider": "Magalu Cloud"
 })

#health check simples
@app.route("/health")
def health():
    return jsonify({"status": "UP"})

if __name__ == "__main__":
 app.run(host="0.0.0.0", port=5000)