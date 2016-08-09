//
//  MessageModel.m
//  消息轮播
//
//  Created by 张永刚 on 16/7/20.
//  Copyright © 2016年 只是路过. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

- (instancetype)initWithText:(NSString *)text{
    if (self = [super init]) {
        self.text = text;
    }
    return self;
}

@end
