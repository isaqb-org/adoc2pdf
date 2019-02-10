# Generate PDF  From Asciidoc

# Docker based conversion from AsciiDoc to PDF for iSAQB curricula


## Native transformation using asciidoc-pdf

We convert from asciidoc to pdf using the [AsciiDoctor-PDF](https://asciidoctor.org/docs/asciidoctor-pdf) utility, embedded into a Docker container.

As a prerequisite, you need to build the container.

    ./buid-container.sh

## Usage

Call the `adoc2pdf.sh` script from the command line.

* file: full path of the input file.
* language: what language (DE, EN or all) 
* stage: dev (include remarks and comments in output)
* attributes: other asciidoc attributes (not yet implemented):


## How it works

The main script is `configure-and-convert-in-container.sh`, which is located in `./assets`. That script is copied into the Docker container during the build process and is its `ENTRYPOINT`.



## PDF Styling

We customized a theme mimicking the original iSAQB documents (minus special fonts).

See the [AsciiDoctor pdf guide](https://github.com/asciidoctor/asciidoctor-pdf/blob/master/docs/theming-guide.adoc) for extensive documentation on styling options.

For conversion to pdf we use our custom pdf theme, named *isaqb-theme.yml*. This theme is located in:

    ./style


## Requirements

The scripts and container are tailored around some specific requirements:

* convert documents written in several (at least EN and DE) languages
* distinguish between _development_ (dev) and _production_ (prod) versions of the target documents: _dev_ versions need to contain comments and remarks, which are contained within the asciidoc source documents.


## License and Copyright

This work has been initiated by the _Foundation Level Working Group_ of the [iSAQB e.V.](https://isaqb.org),
a non-profit organization to advance the area of software architecture.

Initially created by Peter Götz and Gernot Starke.

