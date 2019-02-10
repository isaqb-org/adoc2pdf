#! /bin/bash
#
# this script is intended to run within a docker container.
#
# It requires:
#  * an interactive terminal to read user options at runtime
#  * ncurses for colored output
#  
# the following parameters
#
# $1 LANGUAGE (2-letter format, e.g. DE or EN)
# $2 STAGE, e.g. dev or prod
# $3 INPUTFILE, input filename
# (not yet implemented): additional parameters to be passed as asciidoc attributes

ARGNUM=3
EXPECTED="expect LANGUAGE, STAGE and FILE (in that order)"

# set available languages
AVAILABLELANGUAGES=['DE','EN','all']

# set available stages
AVAILABLESTAGES=['dev','prod']

# some colors to highlight certain output
GREEN=`tput setaf 2`
RED=`tput setaf 1`
BLUE=`tput setaf 6`
YELLOW=`tput setaf 3`
MAGENTA=`tput setaf 5`
BOLD=`tput bold`
RESET=`tput sgr0`


# check input params
# ==================

if [ $# -lt $ARGNUM ]
  then
  echo "too few arguments given, $EXPECTED"
  exit 1
fi

if [ $# -gt $ARGNUM ]
  then
  echo "more then $ARGNUM arguments given..."
fi


if [ $# -eq $ARGNUM ]
  then
    LANGUAGE=$1 # i.e. DE
    STAGE=$2    # i.e. dev
    FILE=$3     # i.e. foundation-curriculum.adoc
    
fi


##
## utility functions
##

function convertHostDirectory () {
 
  # convert given directory path if running in WSL
  if grep -qE "(Microsoft|WSL)" /proc/version &> /dev/null ; then
    echo $(wslpath -m $(realpath $1))
  else
    echo $1
  fi
}



function convert_adoc2pdf() {
   
   # if STAGE="prod" we need to exclude remarks and comments
   if [[ $STAGE = "prod" ]]
   then
     WITHREMARKS=""
   else
     WITHREMARKS="-a withRemarks"
   fi
  
   echo "converting asciidoc to pdf"
   asciidoctor-pdf \
   -a pdf-stylesdir=/style/themes \
   -a pdf-style=isaqb \
   -a pdf-fontsdir=/style/fonts  \
   -a imagesdir=/documents/images \
   ${WITHREMARKS} \
   -a language=$LANGUAGE \
   --verbose \
   --failure-level=WARN\
   -D /build \
   --out-file=$OUTFILE \
   /documents/$FILE_NAME.adoc || { echo "asciidoc-pdf conversion failed"; exit 1; }
}

function change_language {
  echo "available languages: ${BLUE}$AVAILABLELANGUAGES$RESET"
  read -p "Enter ${BLUE}language ${RESET}: " NEWLANGUAGE

  # check if correct language was given
  if [[ ${AVAILABLELANGUAGES[*]} =~ $NEWLANGUAGE ]]
  then
    LANGUAGE=$NEWLANGUAGE
  fi
}

function change_stage {
  echo "available stages: ${GREEN}dev, prod ${RESET}."
  read -p "Enter ${GREEN}stage ${RESET}: " NEWSTAGE

  # check if correct stage was given
  if [[ ${AVAILABLESTAGES[*]} =~ $NEWSTAGE ]]
  then
    STAGE=$NEWSTAGE
  fi
}

function change_outfile {
  read -p "Enter ${RED}output file name ${RESET}: " TEMPOUTFILE

  # check if input is plausible: empty strings are not allowed
  if [ ! -z "$TEMPOUTFILE" -a "$TEMPOUTFILE" != "" ]; then
        echo "new outfile given"
        OUTFILE=$TEMPOUTFILE
  fi
}


##
## main loop
##


FILE_PATH=${3:-example.adoc}
FILE=$(basename "$FILE_PATH")
OUTFILE=$FILE
ADOC_DIR=`dirname "$FILE_PATH"`
FILE_NAME="${FILE%.*}"

STYLE_DIR="/style"
BUILD_DIR="${PWD}/build"

mkdir -p $BUILD_DIR

while true; do
    clear
    echo "$RED iSAQB$YELLOW Docker container to convert asciidoc to pdf$RESET"
    echo "$YELLOW$BOLD====================================================$RESET"
    echo "Current settings:"
    echo ""
    echo "${RED}FILES$RESET -----------------------------------"
    echo "Input file    : ${RED}$FILE ${RESET}"
    echo "Input dir     : $ADOC_DIR"
    echo "Output file   : $RED$OUTFILE$RESET"
    echo "Output dir    : $BUILD_DIR"
    echo "pdf style dir : $STYLE_DIR"
    echo ""
    echo "${BLUE}LANGUAGE$RESET -------------------------------"
    echo "Target language: ${BLUE}${BOLD}${LANGUAGE}${RESET}, available: ${BLUE}${AVAILABLELANGUAGES}$RESET"
    echo ""
    echo "${GREEN}STAGE$RESET -----------------------------------"
    echo "Output stage   : $BOLD${GREEN}${STAGE} ${RESET}"
    echo "available: ${GREEN}dev${RESET} (containg internal remarks), ${GREEN}prod${RESET} (release-version)"
    echo ""
    echo "Please select:"
    echo
    echo "start  $MAGENTA(c)onversion$RESET to pdf"
    echo "change ${RED}(o)utput$RESET filename"
    echo "change $BLUE(l)anguage ${RESET}"
    echo "change $GREEN(s)tage ${RESET}"
    echo "(q)uit..."
    echo ""
    
    read -p "Enter your selection (c,o,l,s, default: quit, q) : " choice
    
    
    if [[ -z $choice ]]; then
        choice='quit'
    fi
    
    case "$choice" in
      c|C|onvert)   echo "converting to pdf"
                    convert_adoc2pdf
                    ;;
      o|O|output)  echo "change output file"
                    change_outfile
                    ;;
      l|L|anguage)  echo "change language"
                    change_language
                    ;;
      s|S|tage)     echo "change stage"
                    change_stage
                    ;;
      q|Q|quit)     echo "quit"
                    exit 1
                    ;;
      # catchall: abort
      *)            echo "${RED} unknown option $choice ${RESET}, aborted."
                    ;;
    esac
done