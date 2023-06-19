//
//  ViewController.m
//  nemosprite
//
//  Created by Daniel Fortes on 18/06/23.
//

#import <AppKit/AppKit.h>
#import <MetalKit/MetalKit.h>
#import "view_controller.h"
#include "nemo_view_delegate.h"
#include "nemo_view.h"
#include "../zig/include/nemo_zig_lib.h"

@interface NemoWindowDelegate : NSObject<NSWindowDelegate>
@end

@implementation NemoWindowDelegate
- (void)windowDidResize:(NSNotification *)notification {
    NSLog(@"window did resize");
}
@end

@implementation ViewController {
    NemoView *nemo_view;
    NemoWindowDelegate *nemo_win_dlg;
    NemoViewDelegate *view_delegte;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    nemo_view = (NemoView *) self.view;
    nemo_win_dlg = [[ NemoWindowDelegate alloc ]init];
}

- (void)viewDidAppear {
    NSWindow *window = [nemo_view window];
    [window setDelegate:nemo_win_dlg];
    window.acceptsMouseMovedEvents = YES;
}

@end
