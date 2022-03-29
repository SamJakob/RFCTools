# RFC Tools
Inspired by [paulej/rfctools](https://github.com/paulej/rfctools), this
repository builds a docker image with tools for creating Internet Drafts based
on [kramdown-rfc](https://github.com/cabo/kramdown-rfc) and
[xml2rfc](https://xml2rfc.tools.ietf.org).

This is intended for running RFC Tools in a CI/CI pipeline. You can get the
pre-built image from Docker Hub by pulling the `samjakob/rfctools` container,
or you can build it manually using the Dockerfile in this repository.

## Usage
You can simply execute the container with `docker run`. The command below maps
the current working directory into `/rfc` in the container (which is the
default working directory), then calls the `mkd2rfc` script on the specified
Kramdown file.

```bash
docker run -v $(pwd):/rfc -w /rfc docker.io/samjakob/rfctools mkd2rfc my_file.mkd
```

### GitHub Actions Example
```yaml
# .github/workflows/generate_rfc.yml

name: Generate RFC

# Runs when a user pushes to the GitHub repository.
on: [push]

jobs:
  # Generate RFC job.
  generate_rfc:
    runs-on: ubuntu-latest

    # Uses Docker Hub image 'samjakob/rfctools'
    container: samjakob/rfctools:amd64

    steps:
      # Check out the files in the repository.
      - name: Checkout repository
        uses: actions/checkout@v2

      # Call the bin/mkd2rfc script to generate the RFC.
      #
      # These commands are executed in the rfctools container and the mkd2rfc
      # script is copied to /usr/bin in the container so you can simply call it
      # with 'mkd2rfc'.
      - name: Generate RFC

        # Remember to replace my_file.mkd with the file you wish to generate
        # the RFC for!
        run: |
          echo "Generating RFC..."
          mkd2rfc my_file.mkd
          echo "Generate complete."

      # Upload the generated artifacts to the job output.
      # You could replace this with the gh-pages action to publish to GitHub
      # Pages automatically, for example.
      - name: Archive artifacts
        uses: actions/upload-artifact@v3
        with:
          name: rfc-files
          path: out/**/*

```

### GitLab CI Example
```yaml
# .gitlab-ci.yml

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

    # Remember to replace my_file.mkd with the file you wish to generate the
    # RFC for!
    - mkd2rfc my_file.mkd

    - echo "Generate complete."

  # Add the pipeline artifacts.
  artifacts:
    expire_in: 6m
    paths:
      # Remember to replace my_file with the basename of your kramdown file!
      # e.g., if your input file was 'test.mkd', these would be 'test.txt',
      # etc.,
      - out/my_file.txt
      - out/my_file.html
      - out/my_file.pdf

```
