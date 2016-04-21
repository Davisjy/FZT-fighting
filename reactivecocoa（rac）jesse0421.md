##ReactiveCocoa（RAC） HELLO WORLD
######GitHub开源项目，具有`函数式编程`和`响应式编程`的特性。
`我RAC虽然是 hello world 级别。但是 hello world 也是可以分级别的。自我感觉应该是一个偏向中级的 hello world。`

	注意: RAC的版本问题，最新版的RAC已经支持Swift了，但是在OC的程序安装最新版的RAC可能跑不起来，所以推荐大家使用2.5.0版本以下的RAC。
	
	1. 监听事件:rac_signalForControlEvents：
	2. 监听代理:rac_signalForSelector：
	3. 代替KVO :rac_valuesAndChangesForKeyPath：
	4. 代替通知:rac_addObserverForName:
	5. 监听文本框文字改变:rac_textSignal:
	6. 监听手势:rac_gestureSignal：


####1.监听事件
`以UITextFild为例 其他控件相似`

* 首先 #import <ReactiveCocoa/ReactiveCocoa.h>
* 然后用

		[[self.textFild rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(id x){
			NSLog(@"change");
		}];		
* 代替

		[self.investMoneyTextField addTarget:self action:@selector(jxChange:) forControlEvents:UIControlEventEditingChanged];
		- (void)jxChange:(UITextField *)textField
		{
		     NSLog(@"change");
		};
* 一两个控件看不出来区别 整个项目下来 得省多少代码

####2.监听代理
`界面有多个alertview 每个alertview又有不一样的按钮  每个按钮又有不一样的事件  用系统代理需要写多少代码`

	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"sure" message:@"message" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"other", nil];
    /**
     *  @selector 是指这次事件监听的方法
     *  fromProtocol指依赖的代理
     *  tuple.first 是alertview对象
     *  tuple.second是ButtonAtIndex中Button的序号
     *  @return
     */
    [[self rac_signalForSelector:@selector(alertView:clickedButtonAtIndex:) fromProtocol:@protocol(UIAlertViewDelegate)] subscribeNext:^(RACTuple *tuple) {
        NSLog(@"%@",tuple.first);
    	NSLog(@"%@",tuple.second);
    	NSLog(@"%@",tuple.third);
    }];
    [alertView show];
####3.代替KVO

	UIScrollView *scrolView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 200, 400)];
    scrolView.contentSize = CGSizeMake(200, 800);
    scrolView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:scrolView];
    [RACObserve(scrolView, contentOffset) subscribeNext:^(id x) {
        NSLog(@"success");
        // RACObserve(TARGET, KEYPATH)这种形式，TARGET是监听目标，KEYPATH是要观察的属性值
    }];
####4.代替通知

	[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"jesse" object:nil] subscribeNext:^(NSNotification *sender) {
        // 当监听到名字是jesse的通知，会执行block里面的方法
        // RAC中的通知不需要remove observer,因为在rac_add方法中他已经写了remove
    }];
####5.监听文本框文字改变

	[[self.textFild rac_textSignal] subscribeNext:^(id x) {
		NSLog(@"change");
	}];
####6.监听手势
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
       // 监听手势
    }];
