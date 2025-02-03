from flask import request


def validate_coin_features(coin_features):
    """
    Validates the coin_features data sent from Roblox.
    Checks for required attributes like name, appearance, and behavior.
    """
    if not isinstance(coin_features, dict):
        return False, "Coin features must be a dictionary."
    
    required_fields = ['name', 'appearance', 'behavior']
    for field in required_fields:
        if field not in coin_features:
            return False, f"Missing required field: {field}"

    # Example: Validate 'name' should be a non-empty string
    if not isinstance(coin_features['name'], str) or not coin_features['name'].strip():
        return False, "'name' must be a non-empty string."

    # Example: Validate 'appearance' should be a dictionary
    if not isinstance(coin_features['appearance'], dict):
        return False, "'appearance' must be a dictionary."

    # Example: Validate 'behavior' should be a dictionary
    if not isinstance(coin_features['behavior'], dict):
        return False, "'behavior' must be a dictionary."

    return True, "Valid coin features."


def validate_request_data():
    """
    Validate the data sent in the request body.
    Returns a tuple of (is_valid, message).
    """
    if not request.is_json:
        return False, "Request must be in JSON format."

    data = request.get_json()

    if 'coin_features' not in data:
        return False, "Missing 'coin_features' in the request body."

    is_valid, message = validate_coin_features(data['coin_features'])
    if not is_valid:
        return is_valid, message

    return True, "Request data is valid."


def validate_authentication_token(auth_token):
    """
    Validate the format of an authentication token (e.g., length and characters).
    """
    # Example: token should be a string with exactly 32 alphanumeric characters
    if not isinstance(auth_token, str) or len(auth_token) != 32 or not auth_token.isalnum():
        return False, "Invalid authentication token format."

    return True, "Authentication token is valid."


def validate_user_input(input_data, input_type='string'):
    """
    Validate user input based on expected type.
    """
    if input_type == 'string':
        if not isinstance(input_data, str) or not input_data.strip():
            return False, "Input must be a non-empty string."
    
    elif input_type == 'integer':
        if not isinstance(input_data, int) or input_data < 0:
            return False, "Input must be a positive integer."
    
    elif input_type == 'float':
        if not isinstance(input_data, float) or input_data < 0:
            return False, "Input must be a positive float."
    
    return True, "User input is valid."


def validate_coin_id(coin_id):
    """
    Validate the format of a coin ID. 
    Coin ID should be a non-empty string, possibly alphanumeric.
    """
    if not isinstance(coin_id, str) or not coin_id.strip():
        return False, "Coin ID must be a non-empty string."

    return True, "Coin ID is valid."


def validate_roblox_character_id(character_id):
    """
    Validate the Roblox character ID format. 
    Assume Roblox character IDs are alphanumeric and have a fixed length.
    """
    if not isinstance(character_id, str) or len(character_id) != 18 or not character_id.isdigit():
        return False, "Invalid Roblox character ID format."

    return True, "Roblox character ID is valid."
