from flask import Flask, jsonify

def create_app():
    app = Flask(__name__)
    app.config["SECRET_KEY"] = "change-me"  # or read from env

    @app.get("/")
    def index():
        return "Flask is alive! But I'm dead"

    @app.get("/api/health")
    def health():
        return jsonify(status="ok")

    return app
