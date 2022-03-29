# RFC Tools
Inspired by [paulej/rfctools](https://github.com/paulej/rfctools), this
repository builds a docker image with tools for creating Internet Drafts based
on [kramdown-rfc](https://github.com/cabo/kramdown-rfc) and
[xml2rfc](https://xml2rfc.tools.ietf.org).

This is intended for running RFC Tools in a CI/CI pipeline. You can get the
pre-built image from Docker Hub by pulling the `samjakob/rfctools` container,
or you can build it manually using the Dockerfile in this repository.

## Usage:
```bash
docker run -v $(pwd):/rfc -w /rfc docker.io/samjakob/rfctools mkd2rfc my_file.mkd
```

## GitLab CI Example:
```yaml
stages:
  # Generate RFC stage.
  - generate

# RFC generate job.
generate-job:
  # Part of the generate stage.
  stage: generate

  # Uses Docker Hub image 'samjakob/rfctools'
  image: samjakob/rfctools:amd64

  # Call the bin/mkd2rfc script to generate the RFC.
  # This is copied to /usr/bin in the container so you can simply call it with
  # 'mkd2rfc'.
  script:
    - echo "Generating RFC..."
    - mkd2rfc my_file.mkd
    - echo "Generate complete."

  # Add the pipeline artifacts.
  artifacts:
    expire_in: 6m
    paths:
      - out/my_file.txt
      - out/my_file.html
      - out/my_file.pdf

```
