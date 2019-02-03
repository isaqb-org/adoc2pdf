FROM ruby:alpine

VOLUME ["/pdf"]

RUN gem install asciidoctor-pdf --pre \
 && gem install coderay \
 && asciidoctor-pdf -v


ENTRYPOINT ["asciidoctor-pdf"]
