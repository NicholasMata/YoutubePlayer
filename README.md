# YoutubePlayer
A port of youtube-ios-player-helper written in Swift with SPM support.

## Integration/Installation
**Swift Package Manager (SPM)**
Add the following line to the `dependencies` array in `Package.swift`.
```swift
.package("https://github.com/NicholasMata/YoutubePlayer")
```
If using Xcode then you can do the following 
 
File -> Swift Packages -> Add Package Dependency

Then enter the Git repo 
`https://github.com/NicholasMata/YoutubePlayer`

## Why another Youtube Player library for iOS?
I created this repo as a Swift port of [youtube-ios-player-helper](https://github.com/youtube/youtube-ios-player-helper) repo the offical youtube player [Google recommends](https://developers.google.com/youtube/v3/guides/ios_youtube_helper). If you don't need SPM or any of the other features this package provides I would recommend you install that package instead. Which does not support SPM and is written in Objective-C. It also has a decent amount of Pull Requests which haven't been merged with valuable features.

## Contributing
All contributors are welcome!

Just follow the "fork-and-pull-request" Git workflow.

 1. **Fork** the repo.
 2. **Clone** your forked repo to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull request** from your forked branch into `main` so that we can review your changes