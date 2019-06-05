//
//  CYPerson.h
//  RuntimeCodeDome
//
//  Created by zcy on 2019/5/14.
//  Copyright © 2019 CY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CYPerson : NSObject

/**
 测试 - 动态方法解析
 */
+ (void)name:(NSString *)name;
- (void)learn:(NSString *)str;

/*
 测试 - 备用接受者
 */
- (void)work;

/**
 测试 - 完整消息转发
 */
- (void)travel;

@end

NS_ASSUME_NONNULL_END
