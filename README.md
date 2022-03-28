# RFC Tools
Inspired by [paulej/rfctools](https://github.com/paulej/rfctools), this
repository builds a docker image with tools for creating Internet Drafts based
on [kramdown-rfc](https://github.com/cabo/kramdown-rfc) and
[xml2rfc](https://xml2rfc.tools.ietf.org).

This is intended for running RFC Tools in a CI/CI pipeline. You can get the
pre-built image from Docker Hub by pulling the "samjakob/rfctools" container,
or you can build it manually using the Dockerfile in this repository.

## Usage:
```bash
docker run -v $(pwd):/rfc -w /rfc docker.io/samjakob/rfctools mkd2rfc my_file.mkd
```
