###1.先分享下自制alertview（封装了iOS7、8的不同使用方法）

<https://github.com/WowJesse/JXAlertViewTool.git>

###2.如果以后项目中的接口不是使用接口名，而是后台给个head参数
#####当你使用AFN时候可以
	[session.requestSerializer setValue:@"后台给的cmd参数" forHTTPHeaderField:@"cmd"];
	设置之后 在使用POST...方法时的URL设置你们的BaseURL即可
###3.尽量减少写界面的代码量
	过多的UILabel、UIButton、UITableView的各种alloc，其实好多地方使用时候都是最基本的设置，把这些最基本的设置封装为便捷方法写进各个控件的分类即可。撸主深有感触。

###4.基类的重要性
	每个复杂的控制器被pop出来之后原来的菊花不应该转了吧、一个项目几十个VC大部分VC的背景色都一样吧、要让导航栏透明时候下边的一条黑线不用每个VC都写了吧、从服务器获取到的json转成自己的model难道你还在每个model都写
	-(instancetype) initWithDict:(NSDictionary *)dict;
	+(instancetype) modelWith:(NSDictionary *)dict; 吗？
###5.push进去多个VC，每个VC的back按钮是不是大都一样
	可以让rootVC的导航VC使用自己建的类。在里边设置leftview（注意：程序会先执行VC的viewDidLoad再执行这个代理）
	- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
	
###6.记得当多个不同的VC中都用到了相似的Tableview时，记得把delegate和datasource设置为一个单独的VC(!!!!注意这个VC的引用，没设置属性引用的话 return cell；代理方法不执行!!!!)，这样不用每个使用Tableview的VC都写那几个够够的数据源方法。

----
##亲身体验:
* view里的layoutSubviews在iPhone4上方法前后都要调用[super layoutSubviews];不然容易报百度前八页都找不到答案的错误。
* tableview设置了正确的return rowsCount;但是不走return cell;就要注意你的tableview的初始frame，frame放不下你的cell时候return cell;不执行。
