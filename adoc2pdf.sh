#!/bin/sh

FILE_PATH=${1:-example.txt}
FILE=$(basename "$FILE_PATH")
FILE_NAME="${FILE%.*}"

echo "Transforming $FILE_PATH to PDF"

# adoc2docbook
docker run --rm -v ${PWD}:/documents/ asciidoctor/docker-asciidoctor asciidoctor -b docbook5 $FILE_PATH

# docbook2odt
docker run --rm -v ${PWD}:/source/ jagregory/pandoc -f docbook -t odt --reference-odt=/source/docbook2odt/template.odt $FILE_NAME.xml -o $FILE_NAME.odt

# odt2pdf
cd odt2pdf && docker build -t libreoffice . && cd ..
docker run --rm -v ${PWD}:/documents libreoffice $FILE_NAME.odt
