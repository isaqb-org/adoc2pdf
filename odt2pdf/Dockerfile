FROM ubuntu:18.04

RUN apt-get update && apt-get -y install libreoffice
RUN mkdir /documents

WORKDIR /documents

VOLUME [ "/documents" ]

ENTRYPOINT [ "soffice", "--headless", "--convert-to", "pdf" ]

CMD [ "lorem-ipsum.odt" ]
