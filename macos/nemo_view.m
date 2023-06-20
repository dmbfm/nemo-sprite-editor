//
//  nemo_view.m
//  nemosprite
//
//  Created by Daniel Fortes on 18/06/23.
//

#import <Foundation/Foundation.h>
#include "nemo_view.h"
#include "nemo_view_context.h"
#include "../zig/include/nemo_zig_lib.h"
#include "metal_bindings.h"

@implementation NemoView {
    NemoViewContext ctx;
}

- (void)updateMouseFromEvent: (NSEvent *)event {
    NSPoint location = [self convertPoint:[event locationInWindow] fromView:nil];
    ctx.mouse_x = location.x;
    ctx.mouse_y = location.y;
}

- (void)mouseMoved:(NSEvent *)event {
    [self updateMouseFromEvent:event];
}

- (void)mouseDown:(NSEvent *)event {
    [self updateMouseFromEvent:event]; 
}

- (void)mouseUp:(NSEvent *)event {
    [self updateMouseFromEvent:event];
}

- (void)mouseDragged:(NSEvent *)event {
    [self updateMouseFromEvent:event];
}

- (void)mouseExited:(NSEvent *)event {
    [self updateMouseFromEvent:event];
}

- (void)mouseEntered:(NSEvent *)event {
    [self updateMouseFromEvent:event];
}

- (void)rightMouseDown:(NSEvent *)event {
    [self updateMouseFromEvent:event];
}

- (void)rightMouseUp:(NSEvent *)event {
    [self updateMouseFromEvent:event]; 
}

- (void)rightMouseDragged:(NSEvent *)event {
    [self updateMouseFromEvent:event];
}

- (void)otherMouseDown:(NSEvent *)event {
    [self updateMouseFromEvent:event];
}

- (void)otherMouseUp:(NSEvent *)event {
    [self updateMouseFromEvent:event]; 
}

- (void)otherMouseDragged:(NSEvent *)event {
    [self updateMouseFromEvent:event];
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (void)drawRect:(NSRect)dirtyRect {
    ctx.view = (__bridge void *) self;
    nemoFrame(&ctx);
}

@end
