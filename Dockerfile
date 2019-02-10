# build with "docker build -t isaqb-adoc2pdf --force-rm ."
FROM ruby:alpine

LABEL version="0.1.2"
LABEL description="convert iSAQB curricula from asciidoc to pdf"
LABEL vendor="iSAQB FLWG, Gernot Starke"

COPY assets/configure-and-convert-in-container.sh .

RUN apk update \
 && apk add bash ncurses \
 && gem install asciidoctor-pdf --pre \
 && gem install coderay \
 && gem install concurrent-ruby \
 && gem install asciidoctor-rouge --pre \
 && asciidoctor-pdf -v \
 && chmod a+x /bin/sh \
 && rm -rf /var/cache/apk/*

    
ENTRYPOINT ["./configure-and-convert-in-container.sh"]
CMD ["EN", "dev", "example.adoc"]
