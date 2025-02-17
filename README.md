# Pipeline Components: Hlint for Haskell

![Project Stage][project-stage-shield]
![Project Maintenance][maintenance-shield]
[![License][license-shield]](LICENSE)

[![GitLab CI][gitlabci-shield]][gitlabci]

## Docker status

[![Docker Pulls][pulls-shield]][dockerhub]

## Usage

The image is for running haskell-hlint.
The image is based on alpine:3.15.

A configfile called `.hlint.yaml` is required, and a default can ben generated with:

`docker run --rm -ti pipelinecomponents/haskell-hlint:latest hlint -d > .hlint.yaml`

## Examples

```yaml
haskell-hlint:
  stage: linting
  image: registry.gitlab.com/pipeline-components/haskell-hlint:latest
  script:
    - hlint .
```

To use parallel processing

```yaml
haskell-hlint:
  stage: linting
  image: registry.gitlab.com/pipeline-components/haskell-hlint:latest
  script:
    - hlint -j .
```

For more information about hlint commandline see [Hlint documentation](https://github.com/ndmitchell/hlint#installing-and-running-hlint)

## Versioning

This project uses [Semantic Versioning][semver] for its version numbering.

## Support

Got questions?

Check the [discord channel][discord]

You could also [open an issue here][issue]

## Contributing

This is an active open-source project. We are always open to people who want to
use the code or contribute to it.

We've set up a separate document for our [contribution guidelines](CONTRIBUTING.md).

Thank you for being involved! :heart_eyes:

## Authors & contributors

The original setup of this repository is by [Robbert Müller][mjrider].

The Build pipeline is large based on [Community Hass.io Add-ons
][hassio-addons] by [Franck Nijhof][frenck].

For a full list of all authors and contributors,
check [the contributor's page][contributors].

## License

MIT License

Copyright (c) 2018 Robbert Müller

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

[commits]: https://gitlab.com/pipeline-components/haskell-hlint/-/commits/main
[contributors]: https://gitlab.com/pipeline-components/haskell-hlint/-/graphs/main
[dockerhub]: https://hub.docker.com/r/pipelinecomponents/haskell-hlint
[license-shield]: https://img.shields.io/badge/License-MIT-green.svg
[mjrider]: https://gitlab.com/mjrider
[discord]: https://discord.gg/vhxWFfP
[gitlabci-shield]: https://img.shields.io/gitlab/pipeline/pipeline-components/haskell-hlint.svg
[gitlabci]: https://gitlab.com/pipeline-components/haskell-hlint/-/commits/main
[issue]: https://gitlab.com/pipeline-components/haskell-hlint/issues
[keepchangelog]: http://keepachangelog.com/en/1.0.0/
[maintenance-shield]: https://img.shields.io/maintenance/yes/2025.svg
[project-stage-shield]: https://img.shields.io/badge/project%20stage-production%20ready-brightgreen.svg
[pulls-shield]: https://img.shields.io/docker/pulls/pipelinecomponents/haskell-hlint.svg
[releases]: https://gitlab.com/pipeline-components/haskell-hlint/tags
[repository]: https://gitlab.com/pipeline-components/haskell-hlint
[semver]: http://semver.org/spec/v2.0.0.html

[frenck]: https://github.com/frenck
[hassio-addons]: https://github.com/hassio-addons
