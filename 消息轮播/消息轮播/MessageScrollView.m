//
//  MessageScrollView.m
//  消息轮播
//
//  Created by 张永刚 on 16/7/20.
//  Copyright © 2016年 只是路过. All rights reserved.
//

#import "MessageScrollView.h"

//自定义view，由于每条轮播数据可能显示样式不同，所以只需要在view上自定义你需要的控件即可
#import "CustomFirstView.h"
#import "CustomSecondView.h"//但是要保证两个自定义view上的控件内容相同

#define kWidth self.scrollViewWidth
#define kHeight self.scrollViewHeight
#define kTwoTimesHeight 2*self.scrollViewHeight
#define kThreeTimesHeight 3*self.scrollViewHeight

@interface MessageScrollView ()

@property (nonatomic, assign) CGFloat scrollViewWidth;
@property (nonatomic, assign) CGFloat scrollViewHeight;

@property (nonatomic, strong) CustomFirstView *firstView;
@property (nonatomic, strong) CustomSecondView *secondView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation MessageScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _index = 3;
        
        _scrollViewWidth = frame.size.width;
        _scrollViewHeight = frame.size.height;
        
        self.contentSize = CGSizeMake(kWidth, kThreeTimesHeight);
        self.pagingEnabled = YES;
        self.contentOffset = CGPointMake(0, kHeight);
        
        self.firstView.frame = CGRectMake(0, kHeight, kWidth, kHeight);
        self.secondView.frame = CGRectMake(0, kTwoTimesHeight, kWidth, kHeight);
    }
    return self;
}

- (void)setMessageModelArray:(NSArray<MessageModel *> *)messageModelArray{
    _messageModelArray = messageModelArray;
    
    //配置第一条数据
    MessageModel *model = messageModelArray[0];
    [self.firstView configFirstData:model.text];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:_duration target:self selector:@selector(changeStatus) userInfo:nil repeats:YES];
}

- (void)changeStatus{
    _index += 1;
    if (_index % 2 == 0) {
        MessageModel *model = _messageModelArray[(_index - 3) % _messageModelArray.count];
        [self.secondView configMessageWith:model index:_index messageCount:_messageModelArray.count];
        [UIView animateWithDuration:1.0 animations:^{
            self.firstView.frame = CGRectMake(0, 0, kWidth, kHeight);
            self.secondView.frame = CGRectMake(0, kHeight, kWidth, kHeight);
        } completion:^(BOOL finished) {
            self.firstView.frame = CGRectMake(0, kTwoTimesHeight, kWidth, kHeight);
        }];
    }else{
        MessageModel *model = _messageModelArray[(_index - 3) % _messageModelArray.count];
        [self.firstView configMessageWith:model index:_index messageCount:_messageModelArray.count];
        [UIView animateWithDuration:1.0 animations:^{
            self.firstView.frame = CGRectMake(0, kHeight, kWidth, kHeight);
            self.secondView.frame = CGRectMake(0, 0, kWidth, kHeight);
        } completion:^(BOOL finished) {
            self.secondView.frame = CGRectMake(0, kTwoTimesHeight, kWidth, kHeight);
        }];
    }
}

- (CustomFirstView *)firstView{
    if (_firstView == nil) {
        _firstView = [[CustomFirstView alloc] init];
        _firstView.backgroundColor = [UIColor greenColor];
        [self addSubview:_firstView];
    }
    return _firstView;
}

- (CustomSecondView *)secondView{
    if (_secondView == nil) {
        _secondView = [[CustomSecondView alloc] init];
        _secondView.backgroundColor = [UIColor grayColor];
        [self addSubview:_secondView];
    }
    return _secondView;
}

@end
