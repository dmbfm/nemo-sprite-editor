//
//  nemo_view_delegate.m
//  nemosprite
//
//  Created by Daniel Fortes on 18/06/23.
//

#import <Foundation/Foundation.h>
#include "nemo_view_delegate.h"
#include "../zig/include/nemo_zig_lib.h"

@implementation NemoViewDelegate
- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size {
}

- (void)drawInMTKView:(nonnull MTKView *)view {
}

- (void)mouseDown:(NSEvent *)event {
    NSLog(@"mouse down!");
}
@end
