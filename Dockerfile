# Build the rfctools container.
FROM alpine:3.14
LABEL org.opencontainers.image.authors="me@samjakob.com"
LABEL org.opencontainers.image.description="Docker image for creating RFC Internet Drafts from Kramdown markdown documents."
LABEL org.opencontainers.image.source="https://github.com/SamJakob/rfctools"
LABEL org.opencontainers.image.licenses="MIT"

# Install dependencies for xml2rfc.
RUN apk add python3 py3-pip pango gcc musl-dev py3-wheel python3-dev \
    libffi-dev zlib-dev jpeg-dev libxml2-dev libxslt-dev cairo-dev curl

# Install xml2rfc
RUN python3 -m pip install xml2rfc && \
    python3 -m pip install 'pycairo>=1.18' 'weasyprint<=0.42.3' && \
    rm -rf /root/.cache && \
    mkdir -p /var/cache/xml2rfc && \
    chmod 777 /var/cache/xml2rfc

# Get the 'Noto' and 'Roboto' fonts
# (per xml2rfc's instructions).
RUN curl https://noto-website-2.storage.googleapis.com/pkgs/Noto-unhinted.zip \
    >/tmp/noto.zip && \
    mkdir -p /usr/share/fonts/noto && \
    unzip -d /usr/share/fonts/noto /tmp/noto.zip && \
    rm -rf /tmp/noto.zip && \
    chmod o+r /usr/share/fonts/noto/* && \
    curl https://fonts.google.com/download?family=Roboto%20Mono \
    >/tmp/roboto.zip && \
    mkdir -p /usr/share/fonts/roboto && \
    unzip -d /usr/share/fonts/roboto /tmp/roboto.zip && \
    rm -f /tmp/roboto.zip && \
    find /usr/share/fonts/roboto -exec chmod o+r {} \; && \
    mkdir -p /.fontconfig && \
    find /.fontconfig -exec chmod o+w {} \; && \
    fc-cache -f -v

# Install dependencies for kramdown-rfc
RUN apk add ruby

# Install kramdown-rfc 
RUN gem install kramdown-rfc

# Copy the mkd2rfc script.
COPY bin/mkd2rfc /usr/bin/
RUN chmod +x /usr/bin/mkd2rfc

# Specify the working directory.
WORKDIR /rfc
