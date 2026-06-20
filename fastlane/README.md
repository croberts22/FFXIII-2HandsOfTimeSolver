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

### ios clean_testflight_users

```sh
[bundle exec] fastlane ios clean_testflight_users
```

Cleans up TestFlight users who are not participating in the beta.

### ios remove_testflight_user

```sh
[bundle exec] fastlane ios remove_testflight_user
```



### ios test

```sh
[bundle exec] fastlane ios test
```

Runs package tests. Pass scan:true to also run the app scheme through scan.

### ios scan_app

```sh
[bundle exec] fastlane ios scan_app
```

Runs the app scheme through scan.

### ios build

```sh
[bundle exec] fastlane ios build
```

Builds an App Store archive.

### ios beta

```sh
[bundle exec] fastlane ios beta
```

Submit a new external beta to TestFlight.

### ios submit_beta

```sh
[bundle exec] fastlane ios submit_beta
```



### ios publish_beta

```sh
[bundle exec] fastlane ios publish_beta
```



### ios production

```sh
[bundle exec] fastlane ios production
```

Submits a new version to the App Store.

### ios submit_binary

```sh
[bundle exec] fastlane ios submit_binary
```

Submits metadata for a version whose binary has already been uploaded.

### ios refresh_dsyms

```sh
[bundle exec] fastlane ios refresh_dsyms
```

Refreshes dSYM files by downloading from Apple and uploading to Sentry.

### ios upload_sentry_dsyms_from_archive

```sh
[bundle exec] fastlane ios upload_sentry_dsyms_from_archive
```

Uploads xcarchive dSYMs to Sentry, then uploads App Store Connect dSYMs when available.

### ios upload_symbols

```sh
[bundle exec] fastlane ios upload_symbols
```



### ios match_development

```sh
[bundle exec] fastlane ios match_development
```

Matches up provisioning profiles for development.

### ios match_production

```sh
[bundle exec] fastlane ios match_production
```

Matches up provisioning profiles for App Store distribution.

### ios match_targets

```sh
[bundle exec] fastlane ios match_targets
```

Matches up provisioning profiles.

### ios upload_metadata

```sh
[bundle exec] fastlane ios upload_metadata
```

Uploads metadata.

### ios upload_screenshots

```sh
[bundle exec] fastlane ios upload_screenshots
```

Uploads new screenshots.

### ios submit_for_review

```sh
[bundle exec] fastlane ios submit_for_review
```

Submits the app for review. This assumes the binary has already been uploaded.

### ios create_new_version

```sh
[bundle exec] fastlane ios create_new_version
```

Sets a new version and build number, then pushes the version bump.

NOTE: This must be performed locally. Ensure you are on the right working branch.

ex: fastlane create_new_version version:1.1.0

### ios add_device

```sh
[bundle exec] fastlane ios add_device
```



### ios format

```sh
[bundle exec] fastlane ios format
```



### ios update_build_number

```sh
[bundle exec] fastlane ios update_build_number
```



----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
