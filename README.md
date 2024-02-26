<p align="center">
  <img src="https://github.com/js/Differati/blob/main/Differati/Assets.xcassets/AppIcon.appiconset/Icon-256.png?raw=true" height="128">
  <h1 align="center">Differati</h1>
</p>

Differati is a macOS app for visually showing differences between two images. _Differati sees all change (between two images)_

## Motivation

It was born out of frustration working with [`swift-snapshot-testing`](https://github.com/pointfreeco/swift-snapshot-testing) test failures within Xcode.

Differati comes with a command line utility to easily open image diffs, it can be installed from the main macOS app. By setting the `differati` command line tool as `SnapshotTesting.diffTool` image snapshots tests can easily be diffed from failed tests, and the saved snapshot can be updated.

It is probably useful for other snapshot testing scenarios using a similar approach.

## Features

- 2-Up: Side by side comparison: 
- Swipe: swipe left right to reveal differences
- Onion: change opacity to reveal differences
- Difference: Only differences between the two images are shown, optioncally with false color
- Easily overwrite old image with new, or the other way around

## License

Licensed under the MIT license. See [LICENSE.md](https://github.com/js/Differati/blob/main/LICENSE.md) for details.

## Orignal Author

[Johan Sørensen](https://github.com/js)
