###1由于最近需求是左滑编辑cell单元格，如果用系统提供的api可能几行代码就能写好，但是提交上去后和需求不符于是自定义cell单元格
![image](https://github.com/Davisjy/images4Gif/blob/master/02-scrollCell.gif)
我的封装利用了几个通知，用来对单元格的打开与合并进行处理，可能通知的方法是比较耗性能的，还望有大牛提供指出。
<pre>
1.#define JYTableViewCellNotificationChangeToUnexpanded @"JYTableViewCellNotificationChangeToUnexpanded"
这个通知用来外部假如点击了当前cell或者点击了修改，让cell重新回到合并状态

2.#define JYTableViewCellNotificationEnableScroll @"JYTableViewCellNotificationEnableScroll"
这种情况代表单元格合并之后的状态，内部通知所有的cell可以滚动scrollView了

3.#define JYTableViewCellNotificationUnenableScroll @"JYTableViewCellNotificationUnenableScroll"
单元格打开的时候，内部通知所有的cell不可以滚动scrollView(除当前编辑的这个外)

还有设置静态变量cell代表当前动的是哪个cell
static JYTableViewCell *_editingCell;

主要用的接口
/**
 *  自定义Cell
 *
 *  @param style             cell的样式
 *  @param reuseIdentifier   cell的重用标示符
 *  @param delegate          JYTableViewCellDelegate代理
 *  @param tableView         tableView
 *  @param rowHeight         每一行cell的高度
 *  @param rightButtonTitles 右边按钮的标题数组
 *  @param rightButtonColors 右边按钮的背景颜色数组
 *
 *  @return 返回cell
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                     delegate:(id<JYTableViewCellDelegate>)delegate
                  inTableView:(UITableView *)tableView
                 withRowHight:(CGFloat)rowHeight
        withRightButtonTitles:(NSArray*)rightButtonTitles
        withRightButtonColors:(NSArray *)rightButtonColors
<code>
###切除矩形的其中某个圆角方法
<pre>
`
CAShapeLayer *layer = [CAShapeLayer layer];
UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:bgView.bounds byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerBottomLeft) cornerRadii:CGSizeMake(5, 5)];
layer.path = path.CGPath;
bgView.layer.mask = layer;
`
<code>
***
###2更改推送样式
![image](https://github.com/Davisjy/images4Gif/blob/master/01-notification.gif)
最近的需求醉死了，系统的都不能用，都要自己写，心好累。。。
刚接到原型图时有点心累，没做过也没看过这种样式的通知(可能自己见的app少吧)，不知道如何下手去做，开始写demo用UIView盖上去可是会透过来，后来查资料往上面盖UIWindow的做法，自己写了一下。原谅我都是采用一种投机取巧的方法。
<pre>
1.#pragma mark - 懒加载
`
- (UIWindow *)overlayWindow {
    if(!_overlayWindow) {
        _overlayWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
        _overlayWindow.backgroundColor = [UIColor clearColor];
        _overlayWindow.userInteractionEnabled = YES;
        // 设置windowlevel等级比默认高就行，这样就能显示在当前界面最上方
        _overlayWindow.windowLevel = UIWindowLevelStatusBar;
    }
    return _overlayWindow;
}
`
同时也是了解了一个设置视图动画场合的方法
// 在视图进入之前的处理动画
`
- (void)didMoveToSuperview
{
    self.overlayWindow.center = CGPointMake(self.overlayWindow.center.x, self.overlayWindow.center.y-10);
    [UIView animateWithDuration:0.5 animations:^{
self.overlayWindow.center=CGPointMake(self.overlayWindow.center.x, self.overlayWindow.center.y+10);
    }];
}
`
//当加入视图完成后调用
```
(void)didAddSubview:(UIView *)subview  
//当视图移动完成后调用  
(void)didMoveToSuperview  
//当视图移动到新的WINDOW后调用  
(void)didMoveToWindow  
//在删除视图之前调用  
(void)willRemoveSubview:(UIView *)subview  
//当移动视图之前调用  
(void)didMoveToSuperview:(UIView *)subview  
//当视图移动到WINDOW之前调用  
(void)willMoveToWindow  
```
如果想要demo可以联系我或者自行下载[demo](https://github.com/Davisjy/images4Gif)顺便给个star哦  

<code>