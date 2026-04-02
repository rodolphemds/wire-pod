# wire-pod

`wire-pod` is fully-featured server software for the Anki (now Digital Dream Labs) [Vector](https://web.archive.org/web/20190417120536if_/https://www.anki.com/en-us/vector) robot. It was created thanks to Digital Dream Labs' [open-sourced code](https://github.com/digital-dream-labs/chipper).

It allows voice commands to work with any Vector 1.0 or 2.0 for no fee, including regular production robots.

## Repository Architecture

```text
wire-pod/
├── README.md
├── compose.yaml
├── dockerfile
├── docker/
├── chipper/
├── vector-cloud/
├── scripts/
├── images/
├── setup.sh
└── update.sh
```

- `README.md`: project overview, links to wiki, and usage notes.
- `compose.yaml`: compose stack to run wire-pod services.
- `dockerfile`: image build instructions for the wire-pod container.
- `docker/`: container helper files and runtime scripts.
- `chipper/`: main backend codebase and service logic used by wire-pod.
- `vector-cloud/`: cloud emulation/compatibility components for Vector APIs.
- `scripts/`: operational helper scripts for setup and maintenance.
- `images/`: image/static resources used by the web interfaces.
- `setup.sh`: initial setup script for first-time installation.
- `update.sh`: update script for refreshing an existing installation.

## Installation

The installation guide exists on the wiki: [Installation guide](https://github.com/kercre123/wire-pod/wiki/Installation)

## Wiki

Check out the [wiki](https://github.com/kercre123/wire-pod/wiki) for more information on what wire-pod is, a guide on how to install wire-pod, troubleshooting, how to develop for it, and for some generally helpful tips.

## Donate

If you want to :P

[![Buy Me A Coffee](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://buymeacoffee.com/kercre123)

## Credits

- [Digital Dream Labs](https://github.com/digital-dream-labs) for open sourcing chipper and creating escape pod (which made this possible)
- [bliteknight](https://github.com/bliteknight) for making wire-pod more accessible with his easy-to-use pre-setup Linux boxes
- [dietb](https://github.com/dietb) for rewriting chipper and giving tips
- [fforchino](https://github.com/fforchino) for adding many features such as localization and multilanguage, and for helping out
- [xanathon](https://github.com/xanathon) for the publicity and web interface help
- Anyone who has opened an issue and/or created a pull request for wire-pod

## Containers 
You can use the compose.yaml file in the root of this project to only run wire-pod container. Otherwise, to run the whole escapepod stack, you should better use the compose.yaml file in the .devcontainer folder. 