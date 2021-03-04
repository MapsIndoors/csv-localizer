#!/bin/bash

readonly FILE="test"
readonly MISC_FILES=""

curl https://raw.githubusercontent.com/MapsIndoors/csv-localizer/modify-script-json/csv-localizer -o test
chmod +x $FILE
python $FILE -p json -i . -o .

# perform cleanup
rm -rf ./output
rm $FILE

# Option: remove csv file when tool is done
# Option: verbose - show which files were generated

# if [ "$1" == "-d" ] || [ "$1" == "--delete" ]; then
#   DEL_COUNT=0

#   for item in "${FILES[@]}"; do
#     ele="$(basename $item)"

#     if [ ${ele: -4} != ".pdf" ] && [ ${ele: -4} != ".log" ]; then
#       printf "Deleting $ele file...\n"
#       let DEL_COUNT=$DEL_COUNT+1
#       rm $item
#     fi
#   done

#   printf "\nTotal files deleted: $DEL_COUNT\n\n"
# fi
