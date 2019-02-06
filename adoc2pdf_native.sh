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

STYLE_DIR="${PWD}/asciidoctorpdf/style"
BUILD_DIR="${PWD}/build"

echo "Transforming $FILE to PDF"
echo "file basename      : $FILE"
echo "asciidoc input dir : $ADOC_DIR"
echo "internal build dir : $BUILD_DIR"
echo "pdf style dir      : $STYLE_DIR"
echo "*******************************************************\n\n"

mkdir -p $BUILD_DIR

printf "calling asciidoc-pdf "
docker run --rm \
   -v $(convertHostDirectory $BUILD_DIR):/build   \
   -v $(convertHostDirectory $ADOC_DIR):/documents:ro \
   -v $(convertHostDirectory $STYLE_DIR):/style:ro \
   isaqb-adoc2pdf \
   -a pdf-stylesdir=/style/themes \
   -a pdf-style=isaqb \
   -a pdf-fontsdir=/style/fonts  \
   -a imagesdir=/documents/images \
   --verbose \
   -D /build \
   /documents/$FILE_NAME.adoc || { echo "asciidoc-pdf conversion failed"; exit 1; }
printf "...done\n\n"
