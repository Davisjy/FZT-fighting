//
//  ViewController.m
//  消息轮播
//
//  Created by 张永刚 on 16/7/20.
//  Copyright © 2016年 只是路过. All rights reserved.
//

#import "ViewController.h"
#import "MessageScrollView.h"
#import "MessageModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //先创建一个背景view，因为image不能放在scrollView上
    UIView *scrollBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 350, 60)];
    scrollBgView.backgroundColor = [UIColor blackColor];
    scrollBgView.center = self.view.center;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 7, 45, 45)];
    imageView.image = [UIImage imageNamed:@"volume-on"];
    
    MessageScrollView *scrollView = [[MessageScrollView alloc] initWithFrame:CGRectMake(50, 0, 300, 60)];
    //只适用于不能滑动的消息轮播
    scrollView.scrollEnabled = NO;
    scrollView.duration = 3.0f;
    
    [self.view addSubview:scrollBgView];
    [scrollBgView addSubview:scrollView];
    [scrollBgView addSubview:imageView];
    
    //把数据放在MessageModel中
    NSArray *array = @[@"我",@"是",@"中",@"国",@"人"];
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSString *text in array) {
        MessageModel *model = [[MessageModel alloc] initWithText:text];
        [modelArray addObject:model];
    }
    
    //把数据传到MessageScrollView中
    scrollView.messageModelArray = modelArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
