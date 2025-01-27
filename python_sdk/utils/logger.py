import logging
import os

# Set up a log directory if it doesn't exist
log_dir = 'logs'
if not os.path.exists(log_dir):
    os.makedirs(log_dir)

# Define the log file path
log_file_path = os.path.join(log_dir, 'app.log')

# Create a custom logger
logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)

# Create a file handler that logs debug messages and higher to a file
file_handler = logging.FileHandler(log_file_path)
file_handler.setLevel(logging.DEBUG)

# Create a console handler that logs warnings and higher to the console
console_handler = logging.StreamHandler()
console_handler.setLevel(logging.WARNING)

# Define the log format
log_format = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')

# Set the formatter for the handlers
file_handler.setFormatter(log_format)
console_handler.setFormatter(log_format)

# Add the handlers to the logger
logger.addHandler(file_handler)
logger.addHandler(console_handler)

def get_logger():
    """
    Function to retrieve the logger instance.
    """
    return logger
