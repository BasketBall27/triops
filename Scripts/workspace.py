#!/usr/bin/env python3

import os
import hashlib
import json
import sys
import re # security for chatbot_token

def double_sha256():
    """ Double SHA256 - simple, like blockchain """
    # Generate 32 random bytes
    rand_bytes = os.urandom(32)
    
    # Perform the first SHA256 hash on the random bytes
    hash1 = hashlib.sha256(rand_bytes).digest()
    
    # Perform the second SHA256 hash on the result of the first hash and return the hex digest
    hash2 = hashlib.sha256(hash1).hexdigest()
    return hash2

# Generate two random double SHA256 hashes and store them in variables
SERVER_DOUBLE_SHA256 = double_sha256()
SHELL_DOUBL_SHA255 = double_sha256()

# Export the double SHA256 values to the bash environment
print(f"export SERVER_DOUBLE_SHA256={SERVER_DOUBLE_SHA256}")
print(f"export SHELL_DOUBL_SHA255={SHELL_DOUBL_SHA255}")

def load_json():
    """ Load json for lang.json """
    try:
        # Try to open and load the JSON file 'lang.json'
        with open('lang.json', 'r') as f:
            return json.load(f)
    except Exception as e:
        # Print an error message and exit the script if there is an issue loading the JSON file
        print(f"Error loading JSON: {e}")
        sys.exit(0)

# Load the data from the lang.json file
data = load_json()

def print_export(key, value):
    """ Helper function to print an export statement """
    print(f"export {key}='{value}'")

# Retrieve exclude_paths from the JSON data (defaults to an empty list if not found)
exclude_paths = data.get('exclude_paths', [])

# Generate exclude flags by creating a space-separated string of the paths with '-i' prefix
exclude_flags = ' '.join(f'-i"{path}"' for path in exclude_paths)

# Export the DEF_EXCLUDE environment variable with the exclude flags
print_export("DEF_EXCLUDE", exclude_flags)

# Export other configuration values from the JSON file to bash environment variables
print_export("DEF_INCLUDE", data.get('include_paths', ''))
print_export("TLIGPAC_DIR", data.get('include_dir', ''))
print_export("__SAMP_PLUGIN_DIR", data.get('plugins_dir', ''))

# Define a regular expression that allows only alphanumeric characters, underscores, or hyphens
valid_token_regex = re.compile("^[a-zA-Z0-9_-]{1,62}$")

# Validate chatbot_token
chatbot_token = data.get('bot_token', '')

# Check if the token is valid
if not valid_token_regex.match(chatbot_token):
    sys.exit(0)

# Check if the token length is more than 62 characters
if len(chatbot_token) > 62:
    sys.exit(0)

# Export CHATBOT_TOKEN to bash environment variable
print_export("CHATBOT_TOKEN", chatbot_token)

print_export("__SAMP_LOG", data.get('samp_log', ''))
print_export("SERVER_CONF", data.get('server_conf', ''))
print_export("__SAMP_EXEC", data.get('samp_executable', ''))

# Retrieve amx_flags from the JSON data and export it to bash as AMX_OPT_F
amx_opt = data.get('amx_flags', [])
print_export("AMX_OPT_F", ' '.join(amx_opt))

if __name__ == '__main__':
    """ Ensure the script runs only when executed directly, not when imported """
    
    # Check if the number of command-line arguments is not equal to 2
    if len(sys.argv) != 2:
        """ Exit with no error (0) if the argument count is incorrect """
        sys.exit(0)
