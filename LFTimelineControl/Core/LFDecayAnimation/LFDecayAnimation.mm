/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.

 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import "LFDecayAnimation.h"
#import "LFDecayAnimationInternal.h"

@implementation LFDecayAnimation

#pragma mark - Lifecycle

#undef __state
#define __state ((LFDecayAnimationState *)_state)

- (void)setToValue:(id)aValue
{
    POPPropertyAnimationState *s = __state;
    VectorRef vec = POPUnbox(aValue, s->valueType, s->valueCount, YES);

    if (!vec_equal(vec, s->toVec)) {
      s->toVec = vec;

      // invalidate to dependent state
      s->didReachToValue = false;
      s->distanceVec = NULL;

      if (s->tracing) {
        [s->tracer updateToValue:aValue];
      }

      // automatically unpause active animations
      if (s->active && s->paused) {
        s->setPaused(false);
      }
    }
    
    [self _computeDeceleration];
}

- (void)_computeDeceleration
{
    __state->computeDeceleration();
}

@end

@implementation LFDecayAnimation (NSCopying)

- (instancetype)copyWithZone:(NSZone *)zone {
  
    LFDecayAnimation *copy = [super copyWithZone:zone];
  
  if (copy) {
    // Set the velocity to the animation's original velocity, not its current.
    copy.velocity = self.originalVelocity;
    copy.deceleration = self.deceleration;
    
  }
  
  return copy;
}

@end
