#!/bin/sh

FILE_PATH=${1:-example.txt}
FILE=$(basename "$FILE_PATH")
ADOC_DIR=`dirname "$FILE_PATH"`
FILE_NAME="${FILE%.*}"


BUILD_PATH="${PWD}/build/"
XML_FILE=$FILE_NAME.xml
ODT_FILE=$FILE_NAME.odt

echo "Transforming $FILE to PDF"
echo "file basename      : $FILE"
echo "asciidoc input dir : $ADOC_DIR"
echo "internal build path: $BUILD_PATH"
echo "docbook xml file   : $XML_FILE"
echo "odt file           : $ODT_FILE"
echo "*******************************************************\n\n"

mkdir $BUILD_PATH

# adoc2docbook
# docker -v: mapping directories from host to container
# asciidoctor -D: output directory
printf "Step 1: converting adoc -> docbook xml..."
docker run --rm \
   -v $BUILD_PATH:/build   \
   -v $ADOC_DIR:/documents:ro   \
   asciidoctor/docker-asciidoctor asciidoctor \
   --verbose \
   -b docbook5           \
   -D /build             \
   /documents/$FILE_NAME.adoc || { echo "Asciidoc conversion failed"; exit 1; }
printf "...done\n\n"

# docbook2odt
printf "Step 2: converting docbook -> odt"
docker run --rm -v ${PWD}:/template/:ro \
   -v $BUILD_PATH:/build \
   jagregory/pandoc -f docbook -t odt --reference-odt=/template/docbook2odt/template.odt \
   /build/$XML_FILE \
   -o /build/$ODT_FILE || { echo "odt generation failed"; exit 1; }
printf "...done\n\n"

# odt2pdf
echo "Step 3: converting odt to pdf"
#cd odt2pdf && docker build -t libreoffice . && cd ..
docker run --rm \
   -v $BUILD_PATH:/documents \
   libreoffice $ODT_FILE

echo "...done"
