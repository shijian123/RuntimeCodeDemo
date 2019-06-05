//
//  ViewController.m
//  RuntimeCodeDome
//
//  Created by zcy on 2019/5/14.
//  Copyright © 2019 CY. All rights reserved.
//

#import "ViewController.h"
#import "CYPerson.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 动态方法解析
    //类方法
    [CYPerson name:@"CY"];
    //实例方法
    CYPerson *person = [[CYPerson alloc] init];
    [person learn:@"Art"];
    
    // 备用接收者
    [self performSelector:@selector(work)];
    
    // 完整消息转发
    [self performSelector:@selector(travel)];
}

/*
 
 // ****************** 备用接收者 *************************
 
 + (BOOL)instancesRespondToSelector:(SEL)aSelector {
 //返回YES，没有动态方法解析，进入下一步
 return YES;
 }
 
 //此方法中替换消息的接受者为其他对象
 - (id)forwardingTargetForSelector:(SEL)aSelector {
 
 if (aSelector == @selector(work)) {
 return [[CYPerson alloc] init];
 }
 return  [super forwardingTargetForSelector:aSelector];
 }
 
 // 如果想替换类方法的接受者
 + (id)forwardingTargetForSelector:(SEL)aSelector {
 if (aSelector == @selector(work)) {
 return NSClassFromString(@"Person");
 }
 return  [super forwardingTargetForSelector:aSelector];
 }
 */

// ****************** 完整消息转发 *************************

+ (BOOL)instancesRespondToSelector:(SEL)aSelector {
    //返回YES，没有动态方法解析，进入下一步
    return YES;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    
    //完整消息转发可直接返回 nil，下面的代码为了适配备用接收者流程
    //设置 work函数 的备用接收者
    if (aSelector == @selector(work)) {
        return [[CYPerson alloc] init];
    }
    return  [super forwardingTargetForSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if ([NSStringFromSelector(aSelector) isEqualToString:@"travel"]) {
        // 签名，进入forwardInvocation
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}

// 消息转发
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL sel = anInvocation.selector;
    
    CYPerson *person = [[CYPerson alloc] init];
    if ([person respondsToSelector:sel]) {
        [anInvocation invokeWithTarget:person];
    }else {
        [self doesNotRecognizeSelector:sel];
    }
    
}

@end

