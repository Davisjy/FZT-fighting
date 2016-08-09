//
//  CustomSecondView.h
//  消息轮播
//
//  Created by 张永刚 on 16/7/20.
//  Copyright © 2016年 只是路过. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

@interface CustomSecondView : UIView

- (void)configMessageWith:(MessageModel *)model index:(NSInteger)index messageCount:(NSInteger)count;

@end
