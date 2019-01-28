# Generate PDF Documentation From Asciidoc

Generate PDF documents from Asciidoc via `asciidoctor`, `pandoc` and `libreoffice`.

## adoc2docbook

    docker run --rm -v ${PWD}:/documents/ asciidoctor/docker-asciidoctor asciidoctor -b docbook5 <ADOK Input File>

## docbook2odt

    docker run --rm -v ${PWD}:/source/ jagregory/pandoc -f docbook -t odt --reference-odt=/source/dockbook2odt/template.odt <XML Input File> -o <ODT Output File>

## odt2pdf

Since there doesn't seem to be a simple Docker image to convert an OpenDocument file into a PDF, this repository offers a simple Dockerfile to do that in the folder `odt2pdf`.

### Build the Docker Image

    cd odt2pdf && docker build -t libreoffice . && cd ..

### Run the Transformation

    docker run --rm -v ${PWD}:/documents libreoffice <ODT Input File>

## Complete Transformation

The steps described above can be executed one by one manually. There is also a little script that can be used to transform an Asciidoc file directly into a PDF.

### Mac / Linux

    ./adoc2pdf.sh

### Windows

    TBD: Implement
