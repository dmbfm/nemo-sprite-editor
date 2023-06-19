//
//  nemo_view.m
//  nemosprite
//
//  Created by Daniel Fortes on 18/06/23.
//

#import <Foundation/Foundation.h>
#include "nemo_view.h"
#include "../zig/include/nemo_zig_lib.h"
#include "metal_bindings.h"

@implementation NemoView

- (void)mouseMoved:(NSEvent *)event {
    NSLog(@"mouse moved!");
}

- (void)mouseDown:(NSEvent *)event {
    NSLog(@"mouse down!");
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (void)drawRect:(NSRect)dirtyRect {
    //NSLog(@"[NemoView][drawRect]");
    //MetalViewContext ctx = { self };
    nemoFrame((void *)0);
}

@end
