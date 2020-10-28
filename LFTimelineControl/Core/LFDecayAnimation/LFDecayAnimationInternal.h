/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.

 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import "POPDecayAnimationInternal.h"

struct _LFDecayAnimationState : _POPDecayAnimationState
{
    void computeDeceleration() {
        VectorRef targetVec = toVec;
        computeToValue();
        
        double fromValue = fromVec->data()[0];
        double toValue = toVec->data()[0];
        double targetValue = targetVec->data()[0];
        
        double inverseScalar = (targetValue - fromValue) / (toValue - fromValue);
        deceleration = powf(deceleration, 1.0 / inverseScalar);
        
        computeDuration();
        computeToValue();
    }
};

typedef struct _LFDecayAnimationState LFDecayAnimationState;
