#!/usr/bin/bash

__handleOS() {
    if [ "$__OS_STATUS" != 1 ]; then
        OS_TYPE=$(uname)

        if [[ "$OS_TYPE" == "Linux" ]]; then
            cat /etc/os-release &>/dev/null
            __LINUX=1
            __PAWNCC="pawncc"
            __OS_STATUS=1
            __DIS_GNU_NANO="false"
        elif [[ "$OS_TYPE" == "Darwin" ]]; then
            __DARWIN=1
            __PAWNCC="pawncc"
            __DIS_GNU_NANO="true"
            __OS_STATUS=1

            if ! command -v docker &>/dev/null; then
                echo -e "$(bash_coltext_r "crit:") Docker not found!.."
                echo "Install first!. See: https://github.com/vilksons/triops/wiki/Get-Started"
            fi
        elif [ -d "/c/Windows/System32" ] || [ -d "/mnt/c/Windows/System32" ] || [ -d "/Windows/System32" ]; then
            __WINDOWS=1
            __PAWNCC="pawncc.exe"
            __DIS_GNU_NANO="true"
            __OS_STATUS=1
        fi

        if { [ "$__WINDOWS" == 1 ] && [ "$__LINUX" == 1 ]; } || 
           [ "$__DARWIN" == 1 ] || 
           { [ "$__LINUX" == 1 ] && [ "$__DARWIN" == 1 ]; }; then
            
            echo -e "$(bash_coltext_a ":: System detected both Windows and Linux / MacOS (Darwin). Which one will you choose?")"
            read -r -p "Choose OS for Triops Y) Windows, B) GNU/Linux, X) Darwin (Mac): " PERMISSION_NEED_OS

            while true; do
                case "$PERMISSION_NEED_OS" in
                    [Yy]) 
                        __PAWNCC="pawncc.exe"
                        __DIS_GNU_NANO="true"
                        __WINDOWS=1
                        __LINUX=0
                        __DARWIN=0
                        __OS_STATUS=1
                        break 
                        ;;
                    [Bb]) 
                        __PAWNCC="pawncc"
                        __DIS_GNU_NANO="false"
                        __WINDOWS=0
                        __LINUX=1
                        __DARWIN=0
                        __OS_STATUS=1
                        break 
                        ;;
                    [Xx]) 
                        __PAWNCC="pawncc"
                        __DIS_GNU_NANO="true"
                        __WINDOWS=0
                        __LINUX=0
                        __DARWIN=1
                        __OS_STATUS=1
                        break 
                        ;;
                    *) 
                        echo -e "$(bash_coltext_r "err:") Invalid selection. Please enter the correct option!"
                        read -r -p "Choose OS for Triops Y) Windows, B) GNU/Linux, X) Darwin (Mac): " PERMISSION_NEED_OS 
                        ;;
                esac
            done
        fi
        
        SAMP_FOUND=$(find . -maxdepth 1 -type f \( -name "samp03svr" -o -name "samp-server.exe" \) | head -n 1)
    
        if [[ -n "$SAMP_FOUND" ]]; then
            __SAMP_SERVER=1
            __CONF_SAMP ""
        else
            echo -e "$(bash_coltext_r "crit:") server not found!. You can get this in \`gamemode\`"

            __CONF_SAMP ""

            sleep 1
        fi
    fi
}

__CONF_SAMP() {
    __SAMP_EXEC="$(basename "$SAMP_FOUND")"

    if [ ! -f "lang.json" ]; then
        python3 -c '
import json
data = {
    "amx_flags": [
        "-;+",
        "-(+",
        "-d3"
    ],
    "include_paths": "pawno/include",
    "exclude_paths": [
        "includes",
        "includes2",
        "includes3"
    ],
    "include_dir": "pawno/include",
    "plugins_dir": "plugins",
    "bot_token": "gsk_abcd",
    "bot_model": "qwen-2.5-32b",
    "bot_profile": "",
    "samp_log": "server_log.txt",
    "server_conf": "server.cfg"
}
with open("lang.json", "w") as f:
    json.dump(data, f, indent=4)
'
fi
}