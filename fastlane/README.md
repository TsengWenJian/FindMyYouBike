fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios release

```sh
[bundle exec] fastlane ios release
```

將正式台打包到AppStore準備送審

參數:scheme, version_number, build_number, identifier

### ios beta

```sh
[bundle exec] fastlane ios beta
```

選擇打包Prod,IT,WS打包上傳到Fabric及蒲公英

參數:scheme, version_number, build_number, identifier, build_ID

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
