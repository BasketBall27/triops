#!/usr/bin/env python3

import os
import hashlib
import json
import sys

def double_sha256():
    """ Double SHA256 - simple, like blockchain """
    rand_bytes = os.urandom(32)
    hash1 = hashlib.sha256(rand_bytes).digest()
    hash2 = hashlib.sha256(hash1).hexdigest()
    return hash2

SERVER_DOUBLE_SHA256 = double_sha256()
SHELL_DOUBL_SHA255 = double_sha256()

""" Export all double_sha256 to bash """
print(f"export SERVER_DOUBLE_SHA256={SERVER_DOUBLE_SHA256}")
print(f"export SHELL_DOUBL_SHA255={SHELL_DOUBL_SHA255}")

def load_json():
    """ Load json for lang.json """
    try:
        with open('lang.json', 'r') as f:
            return json.load(f)
    except Exception as e:
        print(f"Error loading JSON: {e}")
        sys.exit(1)

data = load_json()

def print_export(key, value):
    print(f"export {key}='{value}'")
    
exclude_paths = data.get('exclude_paths', [])
exclude_flags = ' '.join(f"-i{path}" for path in exclude_paths)

print_export("DEF_EXCLUDE", exclude_flags)

print_export("DEF_INCLUDE", data.get('include_paths', ''))
print_export("TLIGPAC_DIR", data.get('include_dir', ''))
print_export("TLIGPAC_PLUGINS", data.get('plugins_dir', ''))
print_export("CHATBOT_TOKEN", data.get('bot_token', ''))
print_export("CHATBOT_MODEL", data.get('bot_model', ''))
print_export("__SAMP_LOG", data.get('samp_log', ''))
print_export("SERVER_CONF", data.get('server_conf', ''))

print_export("DEF_INCLUDE", data.get('include_paths', ''))

amx_opt = data.get('amx_flags', [])
print_export("AMX_OPT_F", ' '.join(amx_opt))

if __name__ == '__main__':
    """ Ensure the script runs only when executed directly, not when imported """
    
    if len(sys.argv) != 2:
        """ Exit with no error (0) if the argument count is incorrect """
        sys.exit(0)