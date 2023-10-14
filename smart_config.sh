#!/bin/bash
# wget -O - https://raw.githubusercontent.com/jumping2000/ha-packages/main/smart_config.sh | bash
###########################################################
#                                                         #
#                       AUTO_DOWNLOAD                     #
#          Copyright @ 2023 github.com/jumping2000        #
#                   All rights reserved                   #
#  Do not copy, distribute, or modify without permission  #
#                                                         #
###########################################################
set -e

RED_COLOR='\033[0;31m'
GREEN_COLOR='\033[0;32m'
GREEN_YELLOW='\033[1;33m'
NO_COLOR='\033[0m'

declare haPath
declare -a paths=(
    "$PWD"
    "$PWD/config"
    "/config"
    "$HOME/.homeassistant"
    "/usr/share/hassio/homeassistant"
)
declare elettrodomestici=("Washing_Machine / Lavatrice" "Dryer / Asciugatrice" "Dishwasher / Lavastoviglie" "Oven / Forno")
declare temp_dir="temp_dir"

function info () { echo -e "${GREEN_COLOR}INFO: $1${NO_COLOR}";}
function warn () { echo -e "${GREEN_YELLOW}WARN: $1${NO_COLOR}";}
function error () { echo -e "${RED_COLOR}ERROR: $1${NO_COLOR}"; if [ "$2" != "false" ]; then exit 1;fi; }
function checkRequirement () {
    if [ -z "$(command -v "$1")" ]; then
        error "'$1' is not installed"
    fi
}
function copy_folder() {
    local source_path="$1"
    local dest_path="$2"
    local file_name=$(basename "$source_path")
    # Se il file o la cartella di destinazione esiste, chiedi all'utente se vuole sovrascriverlo
    if [ -e "$dest_path/$file_name" ]; then
        while true; do
            read -p "Vuoi sovrascrivere i file del pack Elettrodomestici contenuti in $file_name? (Sì/No): " overwrite
            case $overwrite in
                [Ss]* ) cp -rf "$source_path" "$dest_path"; break;;
                [Nn]* ) return;;
                * ) warn "Per favore, rispondi Sì o No.";;
            esac
        done
    fi
    cp -rn "$source_path" "$dest_path"
}
function replace_string() {
    local stringa_old="$1"
    local stringa_new="$2"
    local file="$3"
    if [ ! -e "$file" ]; then
        warn "Il file $file non esiste."
        return 1
    fi
    sed -i "s/$stringa_old/$stringa_new/g" "$file"
    info "Sostituzione dei tag completata nel file $file."
}
function check_arch() {
    if [[ $(arch) == "aarch"* ]]; then
        info "Running on a Raspberry Pi"
        return "pi"
    else
        info "Running on an x86-based machine."
        return "x86"
    fi
}
function rename_keys() {
    local appliance="$1"
    local dir="$haPath/packages"
    # Loop through files in the directory and copy if search_string is found
    for file in "$dir"/*; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        if [[ "$filename" == *"$appliance"* ]]; then
        cp "$file" "$directory/keys.txt"
        info "Copied '$filename' to 'keys.txt'"
        fi
    fi
    done
}

checkRequirement "wget"
checkRequirement "unzip"
checkRequirement "sed"
checkRequirement "awk"
checkRequirement "arch"

echo "Automatic download of packages and cards v1.0 - Copyright @ 2023 github.com/jumping2000. All rights reserved"
# Verifica che sia stato fornito un argomento
if [ $# -eq 0 ]; then
  echo "Utilizzo: $0 [download] oppure $0 [config]"
  exit 1
fi

# Leggi l'argomento dalla linea di comando
option="$1"

case "$option" in
    "download")

        info "Trying to find the correct directory..."
        for path in "${paths[@]}"; do
            if [ -n "$haPath" ]; then
                break
            fi
            if [ -f "$path/.HA_VERSION" ]; then
                haPath="$path"
            fi
        done
        if [ -n "$haPath" ]; then
            info "Found Home Assistant configuration directory at '$haPath'"
            cd "$haPath" || error "Could not change path to $haPath"

            if [ -d "$temp_dir" ]; then
                warn "Remove temporary dir: $temp_dir"
                rm -rf "$temp_dir"
            fi
            if [ ! -d "$temp_dir" ]; then
                info "Creating temporary dir: $temp_dir"
                mkdir -p "$temp_dir"
            fi

            info "Downloading Elettrodomestici Smart 2023"
            wget "https://github.com/jumping2000/ha-packages/releases/latest/download/elettrodomestici_2023.zip"
            info "Unpacking Elettrodomestici Smart 2023..."
            unzip "$haPath/elettrodomestici_2023.zip" -d "$temp_dir" >/dev/null 2>&1
            # Copia i file e le cartelle dalla directory temporanea alla directory di destinazione
            for item in "$temp_dir"/*; do
            if [ -d "$item" ]; then
                copy_folder "$item" "$haPath"
            elif [ -f "$item" ]; then
                copy_folder "$item" "$haPath"
            fi
            done

            echo
            info "Removing Elettrodomestici Smart 2023 zip file..."
            rm -f "$haPath/elettrodomestici_2023.zip"
            rm -rf "$temp_dir"
            info "Download files complete / Copia file completata."

            echo "Choose a package: / Scegli un package da installare dalla lista:"
            select choice in "${elettrodomestici[@]}"; do
                case "$REPLY" in
                    1|2|3|4)
                        selected_appliance="$choice"
                        break
                        ;;
                    *)
                        warn "Scelta non valida. Seleziona le opzioni da 1 a 4."
                        ;;
                esac
            done
            
            info "Hai scelto: $selected_appliance"
            # Scegli sensore energia
            read -p "[REQUIRED] Enter energy sensor for the chosen appliance / [OBBLIGATORIO] Inserisci il sensore di energia per l'elettrodomestico scelto: " energy_sensor
            info "Il sensore inserito è: $energy_sensor"
            result=$(echo "$selected_appliance" | awk '{print $1}' | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]')
            replace_string "TAG_02" "$energy_sensor" "$haPath/packages/elettrodomestici/$result.yaml"
            echo
            rename_keys "$result"
            info "Now you can restart Home Assistant / Prima parte della configurazione finita, riavvia Home Assistant e continua con la configurazione"
        else
            echo
            error "Could not find the directory for Home Assistant" false
            echo "Manually change the directory to the root of your Home Assistant configuration"
            echo "With the user that is running Home Assistant"
            echo "and run the script again"
            exit 1
        fi
        ;;
    "config")
        if [ "$check_arch" == "pi" ]; 
        then
            chmod +x /config/packages/autoconfig_x86_64/auto_config.py
            python /config/packages/autoconfig_x86_64/auto_config.py -v
        else
            chmod +x /config/packages/autoconfig_rpi/auto_config.py
            python /config/packages/autoconfig_rpi/auto_config.py -v
        fi
        ;;
    *)
        echo "Opzione non valida"
        exit 1
        ;;
esac