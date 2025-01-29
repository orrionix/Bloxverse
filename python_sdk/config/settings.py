import os

# Environment configuration
ENVIRONMENT = os.getenv('ENVIRONMENT', 'development')  # default to 'development'

# Server settings
SERVER_HOST = os.getenv('SERVER_HOST', 'localhost')
SERVER_PORT = int(os.getenv('SERVER_PORT', 8000))

# Database configuration
DATABASE_URL = os.getenv('DATABASE_URL', 'sqlite:///db.sqlite3')  # Example: for local SQLite
DATABASE_USERNAME = os.getenv('DATABASE_USERNAME', '')
DATABASE_PASSWORD = os.getenv('DATABASE_PASSWORD', '')

# API Keys or Tokens (for external services)
API_KEY = os.getenv('API_KEY', '')
SECRET_KEY = os.getenv('SECRET_KEY', 'defaultsecretkey')

# AI Configuration
AI_MODEL_PATH = os.getenv('AI_MODEL_PATH', 'coin_ai/models/model_data.bin')

# Logging Configuration
LOG_LEVEL = os.getenv('LOG_LEVEL', 'DEBUG')  # Default log level
LOG_FILE = os.getenv('LOG_FILE', 'app.log')  # Default log file

# Web3 Configuration for Blockchain Integration
WEB3_RPC_URL = os.getenv('WEB3_RPC_URL', 'https://mainnet.infura.io/v3/YOUR_INFURA_PROJECT_ID')  # Example default for Infura
TOKEN_CONTRACT_ADDRESS = os.getenv('TOKEN_CONTRACT_ADDRESS', '0xTokenContractAddress')  # Example token contract address
