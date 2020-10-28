/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.

 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import <pop/POPDecayAnimation.h>

/**
 @abstract A concrete decay animation class.
 @discussion Animation is achieved through gradual decay of animation value.
 */
@interface LFDecayAnimation : POPDecayAnimation

- (void)setToValue:(id)toValue;

@end
