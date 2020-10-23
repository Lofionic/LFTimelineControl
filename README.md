# LFTimelineControl

<!-- [![CI Status](https://img.shields.io/travis/Chris/LFTimelineControl.svg?style=flat)](https://travis-ci.org/Chris/LFTimelineControl) -->
[![Version](https://img.shields.io/cocoapods/v/LFTimelineControl.svg?style=flat)](https://cocoapods.org/pods/LFTimelineControl)
[![License](https://img.shields.io/cocoapods/l/LFTimelineControl.svg?style=flat)](https://cocoapods.org/pods/LFTimelineControl)
[![Platform](https://img.shields.io/cocoapods/p/LFTimelineControl.svg?style=flat)](https://cocoapods.org/pods/LFTimelineControl)

## Description
LFTimelineControl is a custom UIKit control designed primarily to be used as a timeline scrubber for tempo-based audio.

The timeline is displayed with demarkations of beats and bars, bars are numbered. Scrolling is infinite.

The timeline supports inertial scrolling, and deceleration will always come to rest on a bar marker. Panning will also snap to a the closest bar marker when completed.

## Dependancies
LFTimelineControl is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'LFTimelineControl'
```

**Important**: LFTimelineControl has a dependancy on a the '*Pop*' animation library.

For the deceleration snapping to work, a forked version of the '*Pop*' library must be used. The fork is hosted [here](https://github.com/Lofionic/pop/tree/).

This external source dependency should be added to your podfile, *before* running `pod install`:
```ruby 
pod 'pop', :git => 'https://github.com/lofionic/pop.git', :branch => 'dev'
```
## TODOs
- Add usage documentation
- Add unit tests
- Improve example app

## Author
Chris Rivers, chris@lofionic.co.uk

## License
LofiUI is available under the MIT license. See the LICENSE file for more info.
