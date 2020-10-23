# LFTimelineControl

<!-- [![CI Status](https://img.shields.io/travis/Chris/LofiUI.svg?style=flat)](https://travis-ci.org/Chris/LFTimeline)
[![Version](https://img.shields.io/cocoapods/v/LofiUI.svg?style=flat)](https://cocoapods.org/pods/LFTimeline)
[![License](https://img.shields.io/cocoapods/l/LofiUI.svg?style=flat)](https://cocoapods.org/pods/LFTimeline)
[![Platform](https://img.shields.io/cocoapods/p/LofiUI.svg?style=flat)](https://cocoapods.org/pods/LFTimeline) -->

## Description
LFTimelineControl is a custom UIKit control designed primarily to be used as a timeline scrubber for tempo-based audio.

The timeline is displayed with demarkations of beats and bars, bars are numbered. 

The timeline supports inertial scrolling, and deceleration will always come to rest on a bar marker. Panning will also snap to a the closest bar marker when completed.

## Dependancies
LFTimelineControl has a dependancy on a the '*Pop*' animation library.

For the deceleration snapping to work, a forked version of the '*Pop*' library must be used. The fork is hosted [here](https://github.com/Lofionic/pop/tree/).

This external source dependency should be added to your podfile:
```ruby 
pod 'pop', :git => 'https://github.com/lofionic/pop.git', :branch => 'dev'
```

<!-- ## Installation

TimelineControl is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'TimelineControl'
``` -->

## Author
Chris Rivers, chris@lofionic.co.uk

## License
LofiUI is available under the MIT license. See the LICENSE file for more info.
