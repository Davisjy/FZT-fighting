#项目中遇到的案例
###类型1

![Mou icon](https://github.com/WowJesse/images-Gifs/blob/master/jesse3.gif?raw=true)


>`获取验证码的倒计时`

1.写一个接口

		+(void)getVertifyCountDownWithBtn:(UIButton *)getVertifyBtn
		{
		    //执行倒计时
		    getVertifyBtn.enabled = NO;
		    SnGetVertifyCountDown *getVertify = [[SnGetVertifyCountDown alloc] init];
		    getVertify.getVertifyBtn = getVertifyBtn;
		    getVertify.countDownTime = 60;
		    getVertify.timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:getVertify selector:@selector(countDown) userInfo:nil repeats:YES];
		}
		- (void)countDown
		{
		    [self.getVertifyBtn setTitle:[NSString stringWithFormat:@"(%dS)",self.countDownTime] forState:UIControlStateNormal];
		    self.countDownTime --;
		    if (self.countDownTime == -1) {
	        [self.timer invalidate];
	        self.timer = nil;
	        [self.getVertifyBtn setTitle:@"重新获取" forState:UIControlStateNormal];
	        self.getVertifyBtn.enabled = YES;
	    }
	}

2.点击获取验证码之后调用即可

	//获取验证码成功
     [SVProgressHUD showSuccessWithStatus:@"验证码已发送!"];
     //开始执行倒计时
     [SnGetVertifyCountDown getVertifyCountDownWithBtn:getVerificationBtn];
     
     
###类型2

![Mou icon](https://github.com/WowJesse/images-Gifs/blob/master/jesse1.gif?raw=true)


>`宝付支付`

1.添加依赖库（`BaoFooPay.framework`）

2.点击充值之后执行

	    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    [session POST:@"http://tgw.baofoo.com/rsa/merchantPost.action" parameters:@{@"txn_amt":[NSString stringWithFormat:@"%d",[topUpNum intValue] * 100],@"pay_code":@"CCB",@"acc_no":@"6227************0",@"id_card":@"412************0",@"id_holder":@"jesse",@"mobile":@"183********8"} progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        [SVProgressHUD dismiss];
        if ([[responseObject objectForKey:@"retCode"] isEqualToString:@"0000"]) {
            BaoFooPayController *web = [[BaoFooPayController alloc] init];
            web.PAY_TOKEN = [responseObject objectForKey:@"tradeNo"];
            web.delegate = self;
            if (![self.textorture isEqualToString:@"0"]) {
                web.PAY_BUSINESS = @"true";
                NSLog(@"正式环境");
            } else {
                web.PAY_BUSINESS = @"fals";
                NSLog(@"测试环境");
            }
            [self presentViewController:web animated:YES completion:^{
            }];
        } else {
            NSString*str = [responseObject objectForKey:@"retMsg"];
            if (!str) {
                str = @"创建订单号失败";
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
    }];
3.如项目真遇到宝付支付，可以联系committer，我这有详细文档


###类型3

![Mou icon](https://github.com/WowJesse/images-Gifs/blob/master/jesse.gif?raw=true)


>`多个界面的共同界面抽取（包含tableview）`

1.首页创建好公共的界面

			-(instancetype)initWithFrame:(CGRect)frame andItmes:(NSArray *)items andDelegaeVC:(UIViewController <UITableViewDelegate,UITableViewDataSource>*)theDelegateVC
		{
		    if (self = [super initWithFrame:frame]) {
		        _theDelegateVC = theDelegateVC;

		        self.tableViewArr = [NSMutableArray array];
		        //seg
		        FinancialTopSegView *segment = [FinancialTopSegView segmentWithFrame: CGRectMake(15, 70, SCREEN_WIDTH - 30, 40) item:items financialSelectedWhichOne:^(NSInteger whichType) {
		            if (self.selectedScrollPage) {
		                self.selectedScrollPage(whichType);
		            }
		            //点击了哪一个类型
		            [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * whichType, 0) animated:YES];
		        }];
		        [self addSubview:segment];
		        //滑动结束调用
		        __block AccountSegmentAndScrollView *blockSelf = self;
		        self.delegateVC.scrollEnd = ^(NSInteger page){
		            segment.selectedSegmentIndex = page;
		            if (blockSelf.selectedScrollPage) {
		                blockSelf.selectedScrollPage(page);
		            }
		        };
		
		        
		        //scroll
		        CGFloat scrollViewHeight = SCREEN_HEIGHT - CGRectGetMaxY(segment.frame) - 5;
		        
		        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(segment.frame) + 5, SCREEN_WIDTH, scrollViewHeight)];
		        self.scrollView.delegate = self.delegateVC;
		        self.scrollView.contentSize = CGSizeMake(items.count * SCREEN_WIDTH, scrollViewHeight);
		        [self addSubview:self.scrollView];
		        
		        
		        
		        //3.28
		        for (int i = 0; i < items.count; i ++) {
		            UITableView *tableView = [self getTableViewWithFrame:CGRectMake(SCREEN_WIDTH * i + 10, 5, SCREEN_WIDTH - 20, scrollViewHeight - 10)];
		            [self.scrollView addSubview:tableView];
		        }
		    }
		    return self;
		}
		
		- (UITableView *)getTableViewWithFrame:(CGRect)frame
		{
		    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
		    
		    tableView.delegate = _theDelegateVC;
		    tableView.dataSource = _theDelegateVC;
		    
		    [self.tableViewArr addObject:tableView];
		    return tableView;
		}
		
2.在界面使用（`注:如果多个界面相似度低，可以设置tableview的datasource和delegate为各个界面的VC，反之则可以设置到同一个VC`）
	
	//center
    self.centerView = [[AccountSegmentAndScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) andItmes:@[@"投资中",@"还款中",@"还款结束",@"逾期"] andDelegaeVC:self];
    __block AccountMyDirectInvestmentVC *blockSelf = self;
    self.centerView.selectedScrollPage = ^(NSInteger page){
        //选择了第几个page
        _selectedPage = page;
        [blockSelf requestData];
    };
    [self.view addSubview:self.centerView];

#附加:
###贡献出项目中用到的宏定义

	
		//get the  size of the Screen
		//#define SCREEN_HEIGHT [[UIScreen mainScreen]bounds].size.height
		//#define SCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width
		
		
		
		//#ifdef DEBUG // 开发
		//#define JXLog(...) NSLog(__VA_ARGS__)
		//#else // 发布
		//#define JXLog(...)
		//#endif
		
		
		//#define FONT(a) [UIFont systemFontOfSize:a]
		//a 是字符串  b是字的大小
		//#define kLabelWidth(a,b) [a sizeWithFont:FONT(b) Size:CGSizeMake(SCREEN_WIDTH, 20)].width
		//#define WEAKSELF __weak __typeof(&*self)weakSelf_SC = self;
		
		//#define USER_DEFAULT [NSUserDefaults standardUserDefaults]  
		
		//#pragma mark ---- AppDelegate
		//AppDelegate
		//#define APPDELEGATE [(AppDelegate*)[UIApplication sharedApplication]  delegate]
		//UIApplication
		//#define APPD  [UIApplication sharedApplication]
		//#define rootTabBarVC (UITabBarController*)[[[[UIApplication sharedApplication] delegate] window] rootViewController]
		
		//#pragma mark ---- String  functions
		//#define EMPTY_STRING        @""
		
		//#pragma mark ---- UIImage  UIImageView  functions
		//#define IMG(name) [UIImage imageNamed:name]



