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
        with open('lang.json', 'r') as f:
            return json.load(f)
    except Exception as e:
        print(f"Error loading JSON: {e}")
        sys.exit(0)

data = load_json()

def print_export(key, value):
    """ Helper function to print an export statement """
    print(f"export {key}='{value}'")

exclude_paths = data.get('exclude_paths', [])

exclude_flags = ' '.join(f'-i"{path}"' for path in exclude_paths)

print_export("DEF_EXCLUDE", exclude_flags)

print_export("DEF_INCLUDE", data.get('include_paths', ''))
print_export("TLIGPAC_DIR", data.get('include_dir', ''))
print_export("__SAMP_PLUGIN_DIR", data.get('plugins_dir', ''))

print_export("CHATBOT_TOKEN", data.get('bot_token', ''))
print_export("CHATBOT_BIODATA", data.get('bot_profile', ''))
print_export("__SAMP_LOG", data.get('samp_log', ''))
print_export("SERVER_CONF", data.get('server_conf', ''))
print_export("__SAMP_EXEC", data.get('samp_executable', ''))

amx_opt = data.get('amx_flags', [])
print_export("AMX_OPT_F", ' '.join(amx_opt))

valid_token_regex = re.compile("^[a-zA-Z0-9_-]{1,62}$")

chatbot_token = data.get('bot_token', '')

if not valid_token_regex.match(chatbot_token):
    sys.exit(0)

if len(chatbot_token) > 62:
    sys.exit(0)

print_export("CHATBOT_MODEL", data.get('bot_model', ''))

if __name__ == '__main__':
    """ Ensure the script runs only when executed directly, not when imported """
    
    # Check if the number of command-line arguments is not equal to 2
    if len(sys.argv) != 2:
        """ Exit with no error (0) if the argument count is incorrect """
        sys.exit(0)
