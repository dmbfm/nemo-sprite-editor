//
//  nemo_app.h
//  nemosprite
//
//  Created by Daniel Fortes on 20/06/23.
//

#ifndef nemo_app_h
#define nemo_app_h

#import <AppKit/AppKit.h>
#import <MetalKit/MetalKit.h>
#include <stdbool.h>

typedef float f32;
typedef double f64;

@interface NemoAppDelegate : NSObject <NSApplicationDelegate>
@end

@interface NemoView : MTKView
@end

@interface NemoViewController : NSViewController
@end

#endif /* nemo_app_h */
