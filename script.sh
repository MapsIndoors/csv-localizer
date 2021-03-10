#!/bin/bash

readonly TOOL="csv-localizer"
readonly FILES=(*.json)
readonly CSV_FILE=(*.csv)
readonly MISC_FILES=""
CLEANUP_ANSWER=""

function generate_json() {
    printf "Fetching csv localization tool...\n"

    curl -sS https://raw.githubusercontent.com/MapsIndoors/csv-localizer/modify-script-json/csv-localizer -o $TOOL
    chmod +x $TOOL

    printf "Running localization tool...\n"

    RED="\033[0;31m"
    SUCCESS="\033[1;32m"
    NC="\033[0m"
    COMPLETE_STMT="${SUCCESS}Cleanup complete.${NC}\n"

    python $TOOL -p json -i . -o .
    sleep 0.1

    if [ $? == 0 ]; then
        file_count = 0

        printf "${SUCCESS}Done${NC}\n\n"

        printf "Generated files:\n"
        for file in ${FILES[@]}; do
            let "file_count+=1"
            printf -- "- ${file} ($file_count)\n"
        done

        # Perform cleanup
        printf "\nCleanup procedure:\n"
        printf -- "- %-25s %s\n" "/output" "(deleted)" "${TOOL}" "(deleted)"
        rm -rf ./output
        rm "${TOOL}"

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
        # printf "\nPlease check that you only have one csv file in the current directory.\n"
    fi
}

function short_circuit() {
    # Check if there's a csv file in the current directory.
    if [[ $CSV_FILE == "*.csv" ]]; then
        printf "No csv file detected. Tool cancelled.\n"
    else
        generate_json
    fi
}

short_circuit
