#! /bin/bash
#
# helper, so you don't need to remember docker syntax...

# some parameters
LANGUAGE=DE
STAGE=dev

STYLE_DIR="${PWD}/pdf-theme"
BUILD_DIR="${PWD}/build"

if [ $# -lt 1 ]
  then
  echo "too few arguments given, need a filename!"
  exit 1
fi

FILE_PATH=${1:-example.adoc}
FILE=$(basename "$FILE_PATH")
ADOC_DIR=`dirname "$FILE_PATH"`
FILE_NAME="${FILE%.*}"



function convertHostDirectory () {

  # convert given directory path if running in WSL
  if grep -qE "(Microsoft|WSL)" /proc/version &> /dev/null ; then
    echo $(wslpath -m $(realpath $1))
  else
    echo $1
  fi
}


echo "Transforming $FILE to PDF"
echo "file basename      : $FILE"
echo "asciidoc input dir : $ADOC_DIR"
echo "internal build dir : $BUILD_DIR"
echo "pdf style dir      : $STYLE_DIR"
echo "language           : $LANGUAGE"
echo "*******************************************************\n\n"

mkdir -p $BUILD_DIR


# we need to override the default ENTRYPOINT plus give some command line parameters
# with the strange syntax for it. See https://medium.com/@oprearocks/how-to-properly-override-the-entrypoint-using-docker-run-2e081e5feb9d

docker run --rm \
   -v $(convertHostDirectory $BUILD_DIR):/build   \
   -v $(convertHostDirectory $ADOC_DIR):/documents:ro \
   -v $(convertHostDirectory $STYLE_DIR):/style:ro \
   --entrypoint asciidoctor-pdf \
   isaqb-adoc2pdf \
   -a pdf-stylesdir=/style/themes \
   -a pdf-style=isaqb \
   -a pdf-fontsdir=/style/fonts  \
   -a imagesdir=/documents/images \
   -a withRemarks \
   -a language=$LANGUAGE \
   --verbose \
   --failure-level=WARN\
   -D /build \
   /documents/$FILE_NAME.adoc || { echo "asciidoc-pdf conversion failed"; exit 1; }
printf "...done\n\n"
