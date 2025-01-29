from flask import Flask, request, jsonify
from utils.web3_validator import connect_to_blockchain, validate_wallet_address, get_token_balance
import random

# Initialize Flask app
app = Flask(__name__)

# Blockchain provider URL (e.g., Infura, Alchemy)
PROVIDER_URL = 'https://mainnet.infura.io/v3/YOUR_INFURA_PROJECT_ID'

# Token contract address (e.g., USDT contract address on Ethereum mainnet)
TOKEN_CONTRACT_ADDRESS = '0xTokenContractAddress'

# This function simulates spawning a coin character with token ownership validation
@app.route('/spawn_coin', methods=['POST'])
def spawn_coin_character():
    # Extract parameters from the request
    wallet_address = request.json.get('wallet_address')
    behavior = request.json.get('behavior')
    speed = request.json.get('speed')
    size = request.json.get('size')
    strength = request.json.get('strength')
    
    # Connect to the blockchain
    w3 = connect_to_blockchain(PROVIDER_URL)
    if not w3:
        return jsonify({"error": "Failed to connect to the blockchain"}), 500
    
    # Validate the wallet address
    if not validate_wallet_address(w3, wallet_address):
        return jsonify({"error": "Invalid wallet address"}), 400
    
    # Check token ownership (you can define a minimum threshold for the token balance)
    token_balance = get_token_balance(w3, wallet_address, TOKEN_CONTRACT_ADDRESS)
    if token_balance is None or token_balance <= 0:
        return jsonify({"error": "Insufficient token balance for spawning a coin character"}), 400
    
    # If validation passes, proceed with spawning the coin character
    character_id = random.randint(10000, 99999)  # Simulating a unique character ID
    spawn_location = generate_random_spawn_location()

    # Validate additional attributes
    if speed is not None and (speed < 0 or speed > 10):
        return jsonify({"error": "Invalid speed value, must be between 0 and 10"}), 400
    if size is not None and size not in ['small', 'medium', 'large']:
        return jsonify({"error": "Invalid size, must be 'small', 'medium', or 'large'"}), 400
    if strength is not None and (strength < 0 or strength > 100):
        return jsonify({"error": "Invalid strength value, must be between 0 and 100"}), 400

    # Assign default values if attributes are not provided
    speed = speed if speed is not None else random.uniform(0, 10)
    size = size if size is not None else random.choice(['small', 'medium', 'large'])
    strength = strength if strength is not None else random.randint(1, 100)

    # Simulate the coin character properties
    character_attributes = {
        'behavior': behavior,
        'speed': speed,
        'size': size,
        'strength': strength,
        'color': random.choice(['gold', 'silver', 'bronze']),
        'rarity': 'common' if behavior[0][0] > 0.5 else 'rare',
    }

    # Simulate the spawn action
    spawn_details = {
        'character_id': character_id,
        'attributes': character_attributes,
        'spawn_location': spawn_location,
        'spawned_at': 'Roblox Game World'
    }

    return jsonify(spawn_details)

def generate_random_spawn_location():
    """
    Simulates the generation of a random spawn location within the game world.
    """
    x = random.uniform(-100, 100)  # Random x coordinate
    y = random.uniform(0, 50)     # Random y coordinate (height or ground level)
    z = random.uniform(-100, 100)  # Random z coordinate
    return {'x': x, 'y': y, 'z': z}

if __name__ == '__main__':
    app.run(debug=True)
