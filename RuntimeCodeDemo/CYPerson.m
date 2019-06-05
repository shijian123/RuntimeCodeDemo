//
//  CYPerson.m
//  RuntimeCodeDome
//
//  Created by zcy on 2019/5/14.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYPerson.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation CYPerson

//******************** 动态方法解析 ****************************

//动态方法解析-类方法
+ (BOOL)resolveClassMethod:(SEL)sel {
    if (sel == @selector(name:)) {
        class_addMethod(object_getClass(self), sel, class_getMethodImplementation(object_getClass(self), @selector(myName:)), "v@:");
        return YES;
    }
    return [class_getSuperclass(self) resolveClassMethod:sel];
}

//动态方法解析-实例方法
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(learn:)) {
        class_addMethod([self class], sel, class_getMethodImplementation([self class], @selector(myLearn:)), "v@:");
        return YES;
    }
    return [super resolveClassMethod:sel];
}

+ (void)myName:(NSString *)name {
    NSLog(@"myName is %@（动态方法解析-类方法）", name);
}

- (void)myLearn:(NSString *)str{
    NSLog(@"Person learn %@（动态方法解析-实例方法）", str);
}

//******************** 备用接收者 ****************************

- (void)work{
    NSLog(@"Person start work（备用接收者）");
}

//******************** 完整消息转发 ****************************

- (void)travel{
    NSLog(@"I want to travel（完整消息转发）");
}

@end
