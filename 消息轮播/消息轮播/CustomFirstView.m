//
//  CustomFirstView.m
//  消息轮播
//
//  Created by 张永刚 on 16/7/20.
//  Copyright © 2016年 只是路过. All rights reserved.
//

#import "CustomFirstView.h"

@interface CustomFirstView ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation CustomFirstView

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

- (void)configFirstData:(NSString *)text{
    self.label.text = text;
}

- (void)configMessageWith:(MessageModel *)model index:(NSInteger)index messageCount:(NSInteger)count{
    //如果是第i条数据和其他数据显示样式不同，则判断条件更改为(index - 3)%count == i-1，如果是多条不同，多加几个判断，但是要保证两个自定义view中的判断相同
    if ((index - 3)%count == 0) {
        self.label.text = [NSString stringWithFormat:@"%@",model.text];
    }else{
        self.label.text = model.text;
    }
}

@end
