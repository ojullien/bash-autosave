# Bash-AutoSave

Simple tool for saving system logs and web logs into a timestamped bz2 archive and sending it to a ftp server.

*Note: I use this script for my own projects, it contains only the features I need.*

## Table of Contents

[Installation](#installation) | [Features](#features) | [Test](#test) | [Contributing](#contributing) | [License](#license)

## Installation

Requires: a Debian/Ubuntu version of linux and a Bash version ~4.4. [bash-sys](https://github.com/ojullien/bash-sys), [bash-clean](https://github.com/ojullien/bash-clean) and [bash-manageservices](https://github.com/ojullien/bash-manageservices) are installed.

1. [Download a release](https://github.com/ojullien/bash-autosave/releases) or clone this repository.
2. Use [scripts/install.sh](scripts/install.sh) to automatically install the application in the /opt/oju/bash project folder.
3. If needed, add `PATH="$PATH:/opt/oju/bash/bin"` to the .profile files.
4. Update the [config.sh](src/app/autosave/config.sh) configuration file.

## Features

This tool allows you to build timestamped compressed archive with system logs, web logs and send it to a ftp server. Clean the system log after that. The credentials are defined in the [config.sh](src/app/autosave/config.sh) file.

```bash
Usage: autosave.sh [options]

options
  -h | --help           Show this help.
  -l | --active-log     Log mode. Content outputs are logged in a file.
  -n | --no-display     Display mode. Nothing is displayed in terminal.
  -v | --version        Show the version.
  -w | --wait           Wait user. Wait for user input between actions.
```

## Test

I didn't write any line of 'unit test' code. Sorry.

## Contributing

Thanks you for taking the time to contribute. Please fork the repository and make changes as you'd like.

As I use these scripts for my own projects, they contain only the features I need. But If you have any ideas, just open an [issue](https://github.com/ojullien/bash-autosave/issues/new/choose) and tell me what you think. Pull requests are also warmly welcome.

If you encounter any **bugs**, please open an [issue](https://github.com/ojullien/bash-autosave/issues/new/choose).

Be sure to include a title and clear description,as much relevant information as possible, and a code sample or an executable test case demonstrating the expected behavior that is not occurring.

## License

This project is open-source and is licensed under the [MIT License](LICENSE).
