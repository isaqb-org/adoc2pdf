# Generate PDF  From Asciidoc

We currently have several options here, all are based upon Docker:

1.) ODT-based: adoc -> docbook -> openoffice odt "plain" -> openoffice "styled"
2.) native, using the asciidoc-pdf processor itself (which is still beta software)

## ODT-based

Generate PDF documents from Asciidoc via `asciidoctor`, `pandoc` and `libreoffice`.

### adoc2docbook

    docker run --rm -v ${PWD}:/documents/ asciidoctor/docker-asciidoctor asciidoctor -b docbook5 <ADOK Input File>

### docbook2odt

    docker run --rm -v ${PWD}:/source/ jagregory/pandoc -f docbook -t odt --reference-odt=/source/dockbook2odt/template.odt <XML Input File> -o <ODT Output File>

### odt2pdf

Since there doesn't seem to be a simple Docker image to convert an OpenDocument file into a PDF, this repository offers a simple Dockerfile to do that in the folder `odt2pdf`.

#### Build the Docker Image

    cd odt2pdf && docker build -t libreoffice . && cd ..

#### Run the Transformation

    docker run --rm -v ${PWD}:/documents libreoffice <ODT Input File>

### Complete Transformation

The steps described above can be executed one by one manually. There is also a little script that can be used to transform an Asciidoc file directly into a PDF.

You need to call the script with the **absolute file path** of the file to be transformed!

#### Mac / Linux

    ./adoc2pdf_odt.sh

#### Windows

    TBD: Implement the script

## Native transformation using asciidoc-pdf

As a prerequisite, you need to build the container.

    cd asciidoctorpdf
    ./buid-container.sh
    cd ..

Then you can start the transformation:

    ./adoc2pdf_native.sh <path+file>

For example:

    ./adoc2pdf_native.sh /Users/<your-id>/projects/isaqb/asciidoctor-pdf/examples/chronicles-example.adoc

In the background we use a custom pdf style, see the script for details. These styles
are located in:

    ./asciidoctorpdf/style



See the [AsciiDoctor pdf guide](https://github.com/asciidoctor/asciidoctor-pdf/blob/master/docs/theming-guide.adoc) for extensive documentation on styling options.
