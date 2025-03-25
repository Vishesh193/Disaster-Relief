from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_socketio import SocketIO
from flask_cors import CORS

db = SQLAlchemy()
migrate = Migrate()
socketio = SocketIO()
cors = CORS()

def init_extensions(app):
    db.init_app(app)
    migrate.init_app(app, db)
    cors.init_app(app)
    socketio.init_app(app, cors_allowed_origins="*") 