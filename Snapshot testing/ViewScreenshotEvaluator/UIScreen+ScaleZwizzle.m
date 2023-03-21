//
//  UIScreen+ScaleZwizzle.m
//  ViewScreenshotEvaluator
//
//  Created by Andreas Guenther on 17.04.20.
//  Copyright © 2020 Andreas Guenther. All rights reserved.
//

#import "UIScreen+ScaleZwizzle.h"

@import ObjectiveC;
@import UIKit;

// https://bryce.co/swizzle-all-uikit/
@implementation UIScreen (ScaleZwizzle)

+ (void)load {
    method_exchangeImplementations(
        class_getInstanceMethod(self, @selector(scale)),
        class_getInstanceMethod(self, @selector(swizzled_scale))
    );
}

- (CGFloat)swizzled_scale {
    NSLog(@"-[UIScreen swizzled_scale] Called!");
    return 5;
}

@end
