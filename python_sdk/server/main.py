from flask import Flask, request, jsonify
from coin_ai.agent import CoinCharacterAgent, get_coin_behavior
from controllers.spawn_controller import spawn_coin_character
import logging

# Initialize Flask app
app = Flask(__name__)

# Set up basic logging
logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

MODEL_PATH = "path_to_your_model.h5"

@app.route('/')
def home():
    return "Welcome to the Coin Character AI Server!"

# Endpoint to spawn a coin character in Roblox
@app.route('/spawn', methods=['POST'])
def spawn():
    try:
        # Receive data from the request (e.g., features of the coin character)
        data = request.get_json()
        
        # Validate the incoming data (ensure it matches the expected format)
        if not data or 'coin_features' not in data:
            return jsonify({'error': 'Invalid input data'}), 400
        
        # Extract features for coin behavior prediction
        coin_features = data['coin_features']
        
        # Get behavior prediction from the AI model
        behavior = get_coin_behavior(MODEL_PATH, coin_features)
        
        # Spawn the coin character (could be an integration with Roblox API)
        spawn_result = spawn_coin_character(behavior)
        
        # Return the result (e.g., details about the spawned character)
        return jsonify({'status': 'success', 'behavior': behavior, 'spawn_details': spawn_result}), 200

    except Exception as e:
        logger.error(f"Error in /spawn: {str(e)}")
        return jsonify({'error': 'Internal server error'}), 500

# Run the app
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
