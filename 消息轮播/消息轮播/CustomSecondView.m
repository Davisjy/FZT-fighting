//
//  CustomSecondView.m
//  消息轮播
//
//  Created by 张永刚 on 16/7/20.
//  Copyright © 2016年 只是路过. All rights reserved.
//

#import "CustomSecondView.h"

@interface CustomSecondView ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation CustomSecondView

- (UILabel *)label{
    if (_label == nil) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
        _label.font = [UIFont systemFontOfSize:12.0f];
        _label.textColor = [UIColor blackColor];
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
    }
    return _label;
}

- (void)configMessageWith:(MessageModel *)model index:(NSInteger)index messageCount:(NSInteger)count{
    if ((index - 3)%count == 0) {
        self.label.text = [NSString stringWithFormat:@"%@",model.text];
    }else{
        self.label.text = model.text;
    }
}

@end
