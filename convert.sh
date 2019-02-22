#!/bin/sh

convertHostDirectory () {

  # convert given directory path if running in WSL
  if grep -qE "(Microsoft|WSL)" /proc/version &> /dev/null ; then
    echo $(wslpath -m $(realpath $1))
  else
    echo $1
  fi
}


FILE_PATH=${1:-example.adoc}
FILE=$(basename "$FILE_PATH")
ADOC_DIR=`dirname "$FILE_PATH"`
FILE_NAME="${FILE%.*}"

STYLE_DIR="${PWD}/pdf-theme"
BUILD_DIR="${PWD}/build"

echo "Transforming $FILE to PDF"
echo "file basename      : $FILE"
echo "asciidoc input dir : $ADOC_DIR"
echo "internal build dir : $BUILD_DIR"
echo "pdf style dir      : $STYLE_DIR"
echo "*******************************************************\n\n"

mkdir -p $BUILD_DIR

printf "calling asciidoc-pdf "
docker run --rm -i -t \
   -v $(convertHostDirectory $BUILD_DIR):/build   \
   -v $(convertHostDirectory $ADOC_DIR):/documents:ro \
   -v $(convertHostDirectory $STYLE_DIR):/style:ro \
   isaqb-adoc2pdf \
   EN \
   dev \
   $1
printf "...done\n\n"
