//
//  nemo_app.m
//  nemosprite
//
//  Created by Daniel Fortes on 20/06/23.
//

#import <Foundation/Foundation.h>
#include "nemo_app.h"
#include "../zig/include/nemo_zig_lib.h"

typedef struct NemoApp {
    NemoView *view;
    struct {
        int width;
        int height;
        f64 scale_factor;
        bool resized;
    } window;
    struct {
        f64 x;
        f64 y;
        bool is_dragging;
    } mouse;
} NemoApp;

static NemoApp app;

int NemoApp_windowWidth(void) {
    return app.window.width;
}

int NemoApp_windowHeight(void) {
    return app.window.width;
}

f64 NemoApp_windowScaleFactor(void) {
    return app.window.scale_factor;
}

bool NemoApp_windowResized(void) {
    return app.window.resized;
}

f64 NemoApp_mouseX(void) {
    return app.mouse.x;
}

f64 NemoApp_mouseY(void) {
    return app.mouse.y;
}

bool NemoApp_mouseIsDragging(void) {
    return app.mouse.is_dragging;
}

const void* NemoApp_currentDrawable(void) {
    return (__bridge const void *)[app.view currentDrawable];
}

const void* NemoApp_currentRenderPassDescriptor(void) {
    return (__bridge const void *)[app.view currentRenderPassDescriptor];
}

void NemoApp_setClearColor(MTLClearColor color) {
    [app.view setClearColor:color];
}

@implementation NemoAppDelegate
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end

@implementation NemoView
- (void)updateMouseFromEvent: (NSEvent *)event {
    NSPoint location = [self convertPoint:[event locationInWindow] fromView:nil];
    app.mouse.x = location.x;
    app.mouse.y = location.y;
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

- (void)updateContext {
    app.view = self;

    NSRect bounds = [self bounds];

    if (app.window.width != bounds.size.width || app.window.height != bounds.size.height) {
        app.window.resized = true;
    } else {
        app.window.resized = false;
    }

    app.window.width = (int)bounds.size.width;
    app.window.height = (int)bounds.size.height;
}

- (void)drawRect:(NSRect)dirtyRect {
    [self updateContext];
    nemoFrame();
}

@end


@implementation NemoViewController {
    NemoView *nemo_view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    nemo_view = (NemoView *) self.view;
    nemoInit();
    nemo_view.device = (__bridge id<MTLDevice>) nemoMetalDevice();
}

- (void)viewDidAppear {
    NSWindow *window = [nemo_view window];
    window.acceptsMouseMovedEvents = YES;
}
@end


