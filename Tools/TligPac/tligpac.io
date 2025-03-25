#!/usr/bin/bash

function mode_TLIGPAC() {
    : '
        @mode.TLIGPAC
    '

    save_TITLE "TligPac Mode"

    : '
        @Send.Permissions.Typing
    '

    echo -n "$(bash_coltext_y "$SHUSERS")"
    echo -n ":~$ "
    read -r tligpac_OPTION_FLAGS
    bash_TligPac ""
}
export mode_TLIGPAC

function bash_TligPac()
{
    : '
        TligPac Mode
    '

    local tligpac_TRIGGER="tligpac"
    local tligpac_UnknownHOST=0

    case "$tligpac_OPTION_FLAGS" in
        "install"*)
            save_TITLE "Install Packages"

            tligpac_repository_url="${tligpac_OPTION_FLAGS#"install "}"
            tligpac_repository_url="${tligpac_repository_url#install }"

            if [[ -n "$tligpac_repository_url" && "$tligpac_repository_url" != "install" ]]; then
                tligpac_URLS=("$tligpac_repository_url")
            else
                tligpac_URLS=()

                if [ -f "tligpac.json" ]; then
                    while IFS= read -r line; do
                        tligpac_URLS+=("$line")
                    done < <(python3 -c 'import json, sys; data = json.load(sys.stdin); print("\n".join(data["package"]))' < tligpac.json)
                elif [ -f "tligpac.toml" ]; then
                    while IFS= read -r line; do
                        tligpac_URLS+=("$line")
                    done < <(tomlq -r '.package.urls[]' tligpac.toml)
                fi
            fi

            for tligpac_repository_url in "${tligpac_URLS[@]}"; do
                : ' array to variable '

                if [[ "$tligpac_repository_url" != https://* ]]; then
                : ' TligPac: package URL to https
                '
                    if [[ "$tligpac_repository_url" == github/* ]]; then
                        : ' github '
                        tligpac_repository_url="https://github.com/${tligpac_repository_url#github/}"
                    elif [[ "$tligpac_repository_url" == gitlab/* ]]; then
                        : ' gitlab '
                        tligpac_repository_url="https://gitlab.com/${tligpac_repository_url#gitlab/}"
                    elif [[ "$tligpac_repository_url" == sourceforge/* ]]; then
                        : ' sourceforge '
                        tligpac_repository_url="https://sourceforge.net/projects/${tligpac_repository_url#sourceforge/}"
                    else
                        : ' unknown '
                        echo "$(bash_coltext_g "warn:") host url unknown's: $tligpac_repository_url..."
                        tligpac_UnknownHOST=1
                        continue
                    fi
                fi
                
                if [[ "$tligpac_repository_url" == *"/releases/download/"* ]]; then
                    tligpac_archive_url="$tligpac_repository_url"
                elif [[ "$tligpac_repository_url" == *"/releases/tag/"* ]]; then
                    tligpac_REPO_NAME=$(echo "$tligpac_repository_url" | awk -F '/' '{print $(NF-3) "/" $(NF-2)}')
                    tligpac_TAG_VERSION=$(echo "$tligpac_repository_url" | awk -F '/' '{print $NF}')
                
                    if [[ "$tligpac_repository_url" == *"github.com"* ]]; then
                        : ' github '
                        tligpac_API_URL="https://api.github.com/repos/$tligpac_REPO_NAME/git/refs/tags/$tligpac_TAG_VERSION"
                    elif [[ "$tligpac_repository_url" == *"gitlab.com"* ]]; then
                        : ' gitlab '
                        tligpac_API_URL="https://gitlab.com/api/v4/projects/$(echo "$tligpac_REPO_NAME" | tr '/' '%2F')/releases/$tligpac_TAG_VERSION"
                    elif [[ "$tligpac_repository_url" == *"sourceforge.net"* ]]; then
                        : ' sourceforge '
                        tligpac_API_URL="https://sourceforge.net/projects/$tligpac_REPO_NAME/files/latest/download"
                    else
                        : ' unknown '
                        echo "$(bash_coltext_g "warn:") host url unknown's: $tligpac_repository_url..."
                        tligpac_UnknownHOST=1
                        continue
                    fi
                
                    if [ $tligpac_UnknownHOST == 1 ]; then
                        [[ -z "$tligpac_archive_url" ]] && tligpac_archive_url=$(curl -s "$tligpac_repository_url" | grep "browser_download_url" | grep -E ".zip|.tar.gz" | awk -F '"' '{print $4}' | head -n 1)
                    elif [ $tligpac_UnknownHOST == 0 ]; then
                        [[ -z "$tligpac_archive_url" ]] && tligpac_archive_url=$(curl -s "$tligpac_API_URL" | grep "browser_download_url" | grep -E ".zip|.tar.gz" | awk -F '"' '{print $4}' | head -n 1)
                    fi
                else
                    tligpac_REPO_NAME=$(echo "$tligpac_repository_url" | awk -F '/' '{print $(NF-1) "/" $NF}')
                
                    if [[ "$tligpac_repository_url" == *"github.com"* ]]; then
                        : ' github '
                        tligpac_API_URL="https://api.github.com/repos/$tligpac_REPO_NAME/releases/latest"
                    elif [[ "$tligpac_repository_url" == *"gitlab.com"* ]]; then
                        : ' gitlab '
                        tligpac_API_URL="https://gitlab.com/api/v4/projects/$(echo "$tligpac_REPO_NAME" | tr '/' '%2F')/releases/permalink/latest"
                    elif [[ "$tligpac_repository_url" == *"sourceforge.net"* ]]; then
                        : ' sourceforge '
                        tligpac_archive_url="https://sourceforge.net/projects/$tligpac_REPO_NAME/files/latest/download"
                    else
                        : ' unknown '
                        echo "$(bash_coltext_g "warn:") host url unknown's: $tligpac_repository_url..."
                        tligpac_UnknownHOST=1
                        continue
                    fi

                    if [ $tligpac_UnknownHOST == 1 ]; then
                        [[ -z "$tligpac_archive_url" ]] && tligpac_archive_url=$(curl -s "$tligpac_repository_url" | grep "browser_download_url" | grep -E ".zip|.tar.gz" | awk -F '"' '{print $4}' | head -n 1)
                    elif [ $tligpac_UnknownHOST == 0 ]; then
                        [[ -z "$tligpac_archive_url" ]] && tligpac_archive_url=$(curl -s "$tligpac_API_URL" | grep "browser_download_url" | grep -E ".zip|.tar.gz" | awk -F '"' '{print $4}' | head -n 1)
                    fi
                fi

                tligpac_EXTRACT_DIR=".tcache"

                rm -rf "$tligpac_EXTRACT_DIR"
                mkdir -p "$tligpac_EXTRACT_DIR"

                if [ -n "$TLIGPAC_DIR" ]; then
                    if [ ! -f "$TLIGPAC_DIR" ]; then
                        mkdir -p "$TLIGPAC_DIR"
                    fi
                else
                    if [ ! -f "$TLIGPAC_DIR" ]; then
                        mkdir -p "pawno/include"
                        TLIGPAC_DIR="pawno/include"
                    fi
                fi
                if [ ! -f "$__SAMP_PLUGIN_DIR" ]; then
                   mkdir -p "$__SAMP_PLUGIN_DIR"
                fi

                tligpac_PACKAGES=$(basename "$tligpac_repository_url")
                tligpac_PACKAGES="${tligpac_PACKAGES%.*}"
                __tligpac_VERSION_REPO=""

                if [[ "$tligpac_repository_url" == *"/releases/tag/"* ]]; then
                    tligpac_VERSION_REPO=$(echo "$tligpac_repository_url" | awk -F '/' '{print $NF}')
                elif [[ "$tligpac_repository_url" == *"/releases/download/"* ]]; then
                    tligpac_VERSION_REPO=$(echo "$tligpac_repository_url" | awk -F '/' '{print $(NF-1)}')
                else
                    tligpac_VERSION_REPO="Unknown's"
                fi

                tligpac_VERSION_REPO=${tligpac_VERSION_REPO#v}
                __tligpac_VERSION_REPO="$tligpac_VERSION_REPO"

                if ! [[ "$tligpac_VERSION_REPO" =~ [0-9] ]]; then
                    tligpac_VERSION_REPO=""
                    __tligpac_VERSION_REPO="Unknown's"
                fi

                if [[ -z "$tligpac_PACKAGES" ]]; then
                    tligpac_PACKAGES="Unknown's"
                fi

                __tligpac_PACKAGES="$tligpac_PACKAGES"

                sleep 0.1
                
                tligpac_PACKAGES=$(basename "$tligpac_repository_url")
                tligpac_PACKAGES="${tligpac_PACKAGES%%-*}"

                if [[ "$tligpac_archive_url" =~ \.zip$ ]]; then
                    tligpac_ARCHIVE_FILE="$__tligpac_PACKAGES.zip"
                elif [[ "$tligpac_archive_url" =~ \.tar\.gz$ ]]; then
                    tligpac_ARCHIVE_FILE="$__tligpac_PACKAGES.tar.gz"
                else
                    tligpac_ARCHIVE_FILE="$__tligpac_PACKAGES.zip"
                fi

                echo -e "$(bash_coltext_y "Downloading") $__tligpac_PACKAGES $tligpac_VERSION_REPO"
                
                wget -q --show-progress -O "$tligpac_ARCHIVE_FILE" "$tligpac_archive_url"

                if file "$tligpac_ARCHIVE_FILE" | grep -q "Zip archive data"; then
                    unzip -q "$tligpac_ARCHIVE_FILE" -d "$tligpac_EXTRACT_DIR"
                elif file "$tligpac_ARCHIVE_FILE" | grep -q "gzip compressed data"; then
                    mkdir -p "$tligpac_EXTRACT_DIR"
                    tar -xzf "$tligpac_ARCHIVE_FILE" -C "$tligpac_EXTRACT_DIR" --strip-components=1
                else
                    echo -e "$(bash_coltext_r "crit:") Downloaded file is not a valid ZIP or TAR.GZ.."
                    rm -rf "$tligpac_ARCHIVE_FILE" "$tligpac_EXTRACT_DIR"
                    continue
                fi

                tligpac_EXTRACT_SUBDIR=$(find "$tligpac_EXTRACT_DIR" -mindepth 1 -maxdepth 1 -type d | head -n 1)
                
                if [[ -d "$tligpac_EXTRACT_SUBDIR" ]]; then
                    mv "$tligpac_EXTRACT_SUBDIR"/* "$tligpac_EXTRACT_DIR/"
                    rm -rf "$tligpac_EXTRACT_SUBDIR"
                fi

                if [ -d "$TLIGPAC_DIR" ]; then
                    find "$tligpac_EXTRACT_DIR" -type f -name "*.inc" | while IFS= read -r inc_file; do
                        tligpac_REAL_PATH=$(realpath --relative-to="$tligpac_EXTRACT_DIR" "$inc_file" 2> /dev/null || echo "$inc_file")

                        if [[ "$tligpac_REAL_PATH" =~ (^|/)include/ ]]; then
                            tligpac_REAL_PATH="${tligpac_REAL_PATH#*include/}"
                        fi
                        if [[ "$tligpac_REAL_PATH" == */* ]]; then
                            tligpac_DEST_PATH="$TLIGPAC_DIR/$(dirname "$tligpac_REAL_PATH")"
                        else
                            tligpac_DEST_PATH="$TLIGPAC_DIR"
                        fi

                        mkdir -p "$tligpac_DEST_PATH"
                        mv "$inc_file" "$tligpac_DEST_PATH/"
                    done

                    find "$tligpac_EXTRACT_DIR" -type f \( -name "*.dll" -o -name "*.so" \) -exec mv {} "$__SAMP_PLUGIN_DIR/" \;

                    rm -rf "$tligpac_ARCHIVE_FILE" "$tligpac_EXTRACT_DIR"
                    echo -e "$(bash_coltext_y "Complete!.") Packages: $__tligpac_PACKAGES | $__tligpac_VERSION_REPO"
                fi
            done

            echo -e "$(bash_coltext_y "[All packages installed]")"

            sleep 0.1

            tligpac_NEWPLG=()
            
            while IFS= read -r line; do
                if [[ "$line" =~ \.so$|\.dll$ ]]; then
                    plugin_name="$(basename "$line" | sed 's/\.[^.]*$//')"
                    tligpac_NEWPLG+=("$plugin_name")
                fi
            done < "$__tligpac_PACKAGES"

if [ $__SAMP_SERVER == 1 ]; then
            if [ ${#tligpac_NEWPLG[@]} -gt 0 ]; then
                if ! grep -q "^plugins " "$SERVER_CONF"; then
                    sed -i '1i plugins ' "$SERVER_CONF"
                fi
                
                _tligpac_EXTPLG=$(grep -oP '(?<=plugins ).*' "$SERVER_CONF" | tr ' ' '\n' | sort -u)

                _tligpac_NEWPLG=()
                for PLUGIN in "${tligpac_NEWPLG[@]}"; do
                    if ! echo "$_tligpac_EXTPLG" | grep -qx "$PLUGIN"; then
                        _tligpac_NEWPLG+=("$PLUGIN")
                    fi
                done

                if [ ${#_tligpac_NEWPLG[@]} -gt 0 ]; then
                    tligpac_UPDATED_PLUGINS=$(echo "$_tligpac_EXTPLG" "${_tligpac_NEWPLG[@]}" | tr '\n' ' ' | xargs -n1 | sort -u | xargs)
                    sed -i "s/^plugins .*/plugins $tligpac_UPDATED_PLUGINS/" "$SERVER_CONF"
                    echo " Added new plugins to $SERVER_CONF: ${_tligpac_NEWPLG[*]}"
                else
                    echo -e "$(bash_coltext_y "dbg:") No new plugins need to be added."
                fi
            else
                echo -e "$(bash_coltext_y "dbg:") No valid plugins found in $__tligpac_PACKAGES."
            fi
elif [ $__SAMP_SERVER == 2 ]; then
            if [ ${#tligpac_NEWPLG[@]} -gt 0 ]; then
                _tligpac_EXTPLG=$(sed -nE 's/"legacy_plugins": \[(.*)\]/\1/p' config.json | tr -d '"' | tr ',' '\n' | sort -u)

                _tligpac_NEWPLG=()
                for PLUGIN in "${tligpac_NEWPLG[@]}"; do
                    if ! echo "$_tligpac_EXTPLG" | grep -qx "$PLUGIN"; then
                        _tligpac_NEWPLG+=("$PLUGIN")
                    fi
                done

                if [ ${#_tligpac_NEWPLG[@]} -gt 0 ]; then
                    tligpac_UPDATED_PLUGINS=$(echo "$_tligpac_EXTPLG" "${_tligpac_NEWPLG[@]}" | tr ' ' '\n' | sort -u | tr '\n' ',' | sed 's/,$//')

                    python3 -c '
import json
import re

f = "config.json"
with open(f) as file:
    data = file.read()

data = re.sub(r"\"legacy_plugins\": \[.*?\]", f"\"legacy_plugins\": [{tligpac_UPDATED_PLUGINS}]", data)

with open(f, "w") as file:
    file.write(data)
'


                    echo "Added new plugins to config.json: ${_tligpac_NEWPLG[*]}"
                else
                    echo -e "$(bash_coltext_y "dbg:") No new plugins need to be added."
                fi
            else
                echo -e "$(bash_coltext_y "dbg:") No valid plugins found in $__tligpac_PACKAGES."
            fi
fi
            
            mode_TLIGPAC ""
            ;;
        "remove"*)
            save_TITLE "Remove Packages"

            local find_ARGS_FROM="${tligpac_OPTION_FLAGS#"remove "}"
            local find_ARGS_FROM="${find_ARGS_FROM#remove }"

            if [[ -n "$find_ARGS_FROM" ]]; then
                tligpac_REMOVE_PATTERN="$find_ARGS_FROM"
            else
                echo ":: Enter the name pattern of the include/plugin to remove:"
                read -r -p ">>> " tligpac_REMOVE_PATTERN
            fi
            
            tligpac_FILTER_REMOVE_FILES() {
                local pattern="$1"
                while read -r __file; do
                    __filename=$(basename "$__file")
                    if [[ "$__filename" =~ ^$pattern(\.[a-z]+)?$ || "$__filename" =~ .*-?$pattern(\.[a-z]+)?$ ]]; then
                        echo "$__file"
                    fi
                done
            }

            tligpac_INC_FILES=$(find "$TLIGPAC_DIR" -type f -name "*.inc" | tligpac_FILTER_REMOVE_FILES "$tligpac_REMOVE_PATTERN")

            if [[ -n "$tligpac_INC_FILES" ]]; then
                echo "$tligpac_INC_FILES" | xargs rm -rf
                echo -e "$(bash_coltext_y "[OK] ") Removed includes: $tligpac_INC_FILES"
            else
                echo -e "$(bash_coltext_y "dbg:") No matching include files found: $tligpac_REMOVE_PATTERN"
            fi

            tligpac_PLUGIN_FILES=$(find "$__SAMP_PLUGIN_DIR" -type f \( -name "*.dll" -o -name "*.so" \) | tligpac_FILTER_REMOVE_FILES "$tligpac_REMOVE_PATTERN")

            if [[ -n "$tligpac_PLUGIN_FILES" ]]; then
                echo "$tligpac_PLUGIN_FILES" | xargs rm -rf
                echo -e "$(bash_coltext_y "[OK] ") Removed plugins: $tligpac_PLUGIN_FILES"
            else
                echo -e "$(bash_coltext_y "dbg:") No matching plugins files found: $tligpac_REMOVE_PATTERN"
            fi

if [ __SAMP_SERVER == 1 ]; then
            if [[ -f "$SERVER_CONF" ]]; then
                if grep -q "^plugins" "$SERVER_CONF"; then
                    sed -i "/^plugins /s/\b$tligpac_REMOVE_PATTERN\(\.so\|\.dll\|\)//g" "$SERVER_CONF"
                    sed -i 's/  / /g' "$SERVER_CONF"
                    sed -i 's/^plugins *$/plugins /' "$SERVER_CONF"
                    echo -e "$(bash_coltext_y "[OK] ") Removed $tligpac_REMOVE_PATTERN from $SERVER_CONF"
                else
                    echo -e "$(bash_coltext_y "dbg:") No 'plugins' entry found in $SERVER_CONF"
                fi
            else
                echo -e "$(bash_coltext_g "warn:") $SERVER_CONF not found"
            fi
fi
            
            mode_TLIGPAC ""
            ;;
        "$shell_OPTION -C" | "clear" | "cc")
            clear; echo -ne "\033[3J"
            mode_TLIGPAC ""
            ;;
        "$tligpac_TRIGGER" | "$tligpac_TRIGGER " | "" | " ")
            bash_help2
            mode_TLIGPAC ""
            ;;
        "help")
            shell_TITLE="help"
            bash_title "$SHUSERS:~/ $shell_TITLE"

            bash_help2
            mode_TLIGPAC ""
            ;;
       "exit")
            bash_typeof ""
            ;;
        *)
            echo "error: $tligpac_OPTION_FLAGS: command not found"
            mode_TLIGPAC ""
            ;;
    esac
}