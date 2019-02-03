FROM ruby:alpine

RUN gem install asciidoctor-pdf --pre \
 && gem install coderay \
 && gem install concurrent-ruby \
 && asciidoctor-pdf -v \
 && chmod a+x /bin/sh \
 && rm -rf /var/cache/apk/*


ENTRYPOINT ["asciidoctor-pdf"]
CMD ["-v"]
