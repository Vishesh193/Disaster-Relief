from flask import Flask, jsonify, request
from extensions import db, migrate, socketio, cors
from dotenv import load_dotenv
import os
from datetime import datetime, timedelta

# Load environment variables
load_dotenv()

def create_app():
    app = Flask(__name__)

    # Database configuration
    app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv('DATABASE_URL', 'mysql://root:arora@localhost/disaster_relief')
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    app.config['SECRET_KEY'] = os.getenv('JWT_SECRET', 'your-secret-key')

    # Initialize extensions
    db.init_app(app)
    migrate.init_app(app, db)
    cors.init_app(app)
    socketio.init_app(app, cors_allowed_origins="*")

    # Import models
    from models.user import User
    from models.alert import DisasterAlert
    from models.report import Report
    from models.aid_request import AidRequest
    from models.donation import Donation
    from models.voucher import Voucher, VoucherRedemption

    # Import routes
    from routes.alerts import alerts_bp
    from routes.reports import reports_bp
    from routes.aid import aid_bp
    from routes.vouchers import vouchers_bp
    from routes.users import users_bp

    # Register blueprints
    app.register_blueprint(alerts_bp, url_prefix='/api/alerts')
    app.register_blueprint(reports_bp, url_prefix='/api/reports')
    app.register_blueprint(aid_bp, url_prefix='/api/aid')
    app.register_blueprint(vouchers_bp, url_prefix='/api/vouchers')
    app.register_blueprint(users_bp, url_prefix='/api/users')

    # WebSocket events
    @socketio.on('connect')
    def handle_connect():
        print('Client connected')

    @socketio.on('disconnect')
    def handle_disconnect():
        print('Client disconnected')

    @socketio.on('joinAlertRoom')
    def handle_join_alert(alert_id):
        print(f'Client joined alert room: {alert_id}')
        socketio.join_room(f'alert:{alert_id}')

    @socketio.on('joinAidRoom')
    def handle_join_aid(request_id):
        print(f'Client joined aid room: {request_id}')
        socketio.join_room(f'aid:{request_id}')

    # Error handlers
    @app.errorhandler(404)
    def not_found_error(error):
        return jsonify({'error': 'Not found'}), 404

    @app.errorhandler(500)
    def internal_error(error):
        db.session.rollback()
        return jsonify({'error': 'Internal server error'}), 500

    # Health check endpoint
    @app.route('/health')
    def health_check():
        return jsonify({
            'status': 'healthy',
            'timestamp': datetime.utcnow().isoformat(),
            'database': 'connected' if db.engine.pool.checkedout() == 0 else 'error'
        })

    return app

if __name__ == '__main__':
    app = create_app()
    with app.app_context():
        # Create database tables
        db.create_all()
    
    # Run the application
    port = int(os.getenv('PORT', 5000))
    socketio.run(app, host='0.0.0.0', port=port, debug=os.getenv('FLASK_ENV') == 'development') 