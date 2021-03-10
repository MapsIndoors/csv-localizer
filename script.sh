#!/bin/bash

readonly FILE="csv-localizer"
readonly FILES=(*.json)
readonly CSV_FILE=(*.csv)
readonly MISC_FILES=""
CLEANUP_ANSWER=""

printf "Fetching csv localization tool...\n"

curl -sS https://raw.githubusercontent.com/MapsIndoors/csv-localizer/modify-script-json/csv-localizer -o $FILE
chmod +x $FILE

printf "Running localization tool...\n"

function generate_json() {
    RED="\033[0;31m"
    SUCCESS="\033[1;32m"
    NC="\033[0m"
    COMPLETE_STMT="${SUCCESS}Cleanup complete.${NC}\n"

    python $FILE -p json -i . -o .
    sleep 0.1

    if [ $? == 0 ]; then
        printf "${SUCCESS}Done${NC}\n\n"

        printf "Generated files:\n"
        for file in ${FILES[@]}; do
            printf -- "- ${file}\n"
        done

        # Perform cleanup
        printf "\nRunning cleanup...\n"
        printf -- "- Deleted /output\n"
        rm -rf ./output
        printf -- "- Deleted '${FILE}' script\n"
        rm "${FILE}"

        printf "\n"

        read -p "Would you like to delete '${CSV_FILE}'? [y/n] " CLEANUP_ANSWER

        while [[ $CLEANUP_ANSWER != "y" ]] || [[ $CLEANUP_ANSWER != "n" ]]; do
            if [[ $CLEANUP_ANSWER == "y" ]]; then
                rm "${CSV_FILE}"
                printf "\nDeleted '${CSV_FILE}'\n"
                break
            elif [[ $CLEANUP_ANSWER == "n" ]]; then
                break
            else
                read -p "Please specify yes or no [y/n]: " CLEANUP_ANSWER
            fi
        done

        printf "${SUCCESS}Cleanup complete.${NC}\n"
    else
        printf "${RED}Something went wrong during localization. Exiting.${NC}\n"
        printf "\nPlease check that you only have one csv file in the current directory.\n"
    fi
}

generate_json
