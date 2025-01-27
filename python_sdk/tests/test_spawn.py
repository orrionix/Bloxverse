import unittest
from flask import Flask, jsonify
from server.controllers.spawn_controller import spawn_coin_character
from utils.validators import validate_request_data
from unittest.mock import patch

class SpawnControllerTestCase(unittest.TestCase):

    def setUp(self):
        """Setup a test client for the Flask application"""
        self.app = Flask(__name__)
        self.app.add_url_rule('/spawn', 'spawn', spawn_coin_character, methods=['POST'])
        self.client = self.app.test_client()

    def test_valid_spawn_request(self):
        """Test that a valid spawn request returns a success response"""
        valid_data = {
            "coin_features": {
                "name": "Golden Coin",
                "appearance": {
                    "color": "gold",
                    "size": "medium"
                },
                "behavior": {
                    "movement": "float",
                    "interactions": "bouncy"
                }
            }
        }

        response = self.client.post('/spawn', json=valid_data)

        self.assertEqual(response.status_code, 200)
        self.assertIn('status', response.get_json())
        self.assertEqual(response.get_json()['status'], 'success')

    def test_invalid_request_missing_coin_features(self):
        """Test that a request missing 'coin_features' field returns an error"""
        invalid_data = {}

        response = self.client.post('/spawn', json=invalid_data)

        self.assertEqual(response.status_code, 400)
        self.assertIn('error', response.get_json())
        self.assertEqual(response.get_json()['error'], "Missing 'coin_features' in the request body.")

    def test_invalid_coin_features_format(self):
        """Test that an invalid format for 'coin_features' returns an error"""
        invalid_data = {
            "coin_features": {
                "name": "Golden Coin",
                "appearance": "invalid_format",  # Invalid, should be a dict
                "behavior": {}
            }
        }

        response = self.client.post('/spawn', json=invalid_data)

        self.assertEqual(response.status_code, 400)
        self.assertIn('error', response.get_json())
        self.assertEqual(response.get_json()['error'], "'appearance' must be a dictionary.")

    @patch('coin_ai.server.controllers.spawn_controller.validate_authentication_token')
    def test_valid_auth_token(self, mock_validate_auth_token):
        """Test that a valid authentication token passes validation"""
        mock_validate_auth_token.return_value = (True, "Authentication token is valid.")

        valid_data = {
            "coin_features": {
                "name": "Golden Coin",
                "appearance": {
                    "color": "gold",
                    "size": "medium"
                },
                "behavior": {
                    "movement": "float",
                    "interactions": "bouncy"
                }
            }
        }

        headers = {'Authorization': 'valid_auth_token_12345678901234567890123456789012'}
        response = self.client.post('/spawn', json=valid_data, headers=headers)

        self.assertEqual(response.status_code, 200)
        self.assertIn('status', response.get_json())
        self.assertEqual(response.get_json()['status'], 'success')

    @patch('coin_ai.server.controllers.spawn_controller.validate_authentication_token')
    def test_invalid_auth_token(self, mock_validate_auth_token):
        """Test that an invalid authentication token returns an error"""
        mock_validate_auth_token.return_value = (False, "Invalid authentication token format.")

        valid_data = {
            "coin_features": {
                "name": "Golden Coin",
                "appearance": {
                    "color": "gold",
                    "size": "medium"
                },
                "behavior": {
                    "movement": "float",
                    "interactions": "bouncy"
                }
            }
        }

        headers = {'Authorization': 'invalid_token'}
        response = self.client.post('/spawn', json=valid_data, headers=headers)

        self.assertEqual(response.status_code, 401)
        self.assertIn('error', response.get_json())
        self.assertEqual(response.get_json()['error'], "Invalid authentication token format.")

if __name__ == '__main__':
    unittest.main()
