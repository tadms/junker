#!/bin/bash

###############################################################################
# Global variables
###############################################################################
LINE_BOLD=$(printf "%0.s#" {1..80})
TXTGRN=$(tput setaf 2)
TXTRST=$(tput sgr0)
TMP_OUTPUT_FILE="/tmp/.junk_file_cleaner.out"
JUNK_FILE_TYPES="*.nfo *.txt *.png *.jpg *.lnk"

###############################################################################
# Utility functions
###############################################################################
function print_help {
  echo "Usage: ./cleaner.sh <DIR>"
  echo "Naughty file types: [ $JUNK_FILE_TYPES ]"
}

function list_junk_files {
  local file="$1"
  find $DIR -type f -name "$file"
}

function delete_junk_files {
  local file="$1"
  find $DIR -type f -name "$file" -delete
}

function list_empty_dirs {
  find $DIR -type d -empty
}

function delete_empty_dirs {
  find $DIR -type d -empty -delete
}

function clean_up_tmp {
  if [ -f $TMP_OUTPUT_FILE ] ; then 
    rm -f $TMP_OUTPUT_FILE
  fi
}

###############################################################################
# Main
###############################################################################
function main {
  DIR=$1

  if [ "$1" == "-h" ] || [ "$1" == "--help" ] ; then 
    print_help
    exit 0
  elif [ -z "$1" ] ; then 
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
  fi

  echo $LINE_BOLD
  echo "FINDING JUNK FILES..."
  echo "[ $JUNK_FILE_TYPES ]"
  echo $LINE_BOLD
  sleep 3

  clean_up_tmp
  touch $TMP_OUTPUT_FILE

  for i in $JUNK_FILE_TYPES ; do
    list_junk_files $i >> $TMP_OUTPUT_FILE
  done

  list_empty_dirs >> $TMP_OUTPUT_FILE

  file_count="$(cat $TMP_OUTPUT_FILE | wc -l)"
  if [ $file_count == "0" ] ; then
    echo "${TXTGRN}ALL CLEAN${TXTRST}"
    exit 0
  fi

  awk '{print $0; system("sleep .01");}' $TMP_OUTPUT_FILE
  echo ""
  echo $LINE_BOLD
  echo "DELETE IT ALL? (y/n)"
  echo $LINE_BOLD
  read ANSWER

  if [ $ANSWER == "y" ] ; then
    for i in $JUNK_FILE_TYPES ; do
      delete_junk_files $i
    done
    delete_empty_dirs
    echo "${TXTGRN}DELETED${TXTRST}"
  else
    echo "${TXTGRN}EXIT${TXTRST}"
  fi
  
  clean_up_tmp
}

main $@
