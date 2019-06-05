//
//  UIViewController+Swizzling.m
//  RuntimeCodeDome
//
//  Created by zcy on 2019/5/14.
//  Copyright © 2019 CY. All rights reserved.
//

#import "UIViewController+Swizzling.h"
#import <objc/runtime.h>

@implementation UIViewController (Swizzling)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        Class class = [self class];
        
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(cy_viewWillApper:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {        //用到method_getImplementation去获取class_getInstanceMethod里面的方法实现。然后再进行class_replaceMethod来实现Swizzling。
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        }else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
    
}

#pragma mark - Method Swizzling

- (void)cy_viewWillApper:(BOOL)animated {
    [self cy_viewWillApper:animated];
    NSLog(@"viewWillAppear: %@", self);
}

@end
