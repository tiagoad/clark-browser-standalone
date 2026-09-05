# clark-standalone

This is a helper package to download [clark-browser](https://github.com/clark-labs-inc/clark-browser) binaries for standalone usage.

<!-- start usage -->
```
Usage:
  clark-standalone versions
    Lists versions available for download

  clark-standalone download [OPTIONS] DIRECTORY
    Downloads clark to the provided DIRECTORY.

    Note: A file will be written to DIRECTORY/clark-exe-path containing
    the relative path to the browser executable.

    Options:
      DIRECTORY
        Output directory for the downloaded browser
      -v, --version=VERSION
        Version to download. default=latest
      -p, --platform
        Browser platform (windows/linux/darwin) default=darwin
      -a, --arch
        Browser architecture (arm64/x64) default=arm64
      --overwrite
        Allow DIRECTORY to already exist
      --keep-archive
        Keeps the downloaded archive in the output directory
      --no-extract
        Skips extracting the archive to the output directory
```
<!-- end usage -->
