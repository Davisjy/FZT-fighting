//
//  MessageScrollView.h
//  消息轮播
//
//  Created by 张永刚 on 16/7/20.
//  Copyright © 2016年 只是路过. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

@interface MessageScrollView : UIScrollView

//把数据源传进来即可
@property (nonatomic, strong) NSArray <MessageModel *> *messageModelArray;
//时间间隔
@property (nonatomic, assign) CGFloat duration;

@end
