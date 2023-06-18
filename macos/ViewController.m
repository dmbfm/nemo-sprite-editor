//
//  ViewController.m
//  nemosprite
//
//  Created by Daniel Fortes on 18/06/23.
//

#import "ViewController.h"
#include "../zig/include/nemo_zig_lib.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    nemoInit();
    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
