<code>
###给亲爱的凯子整理的支付宝集成
* 将alipaySDK导入工程
* 在【Build Settings】里面搜Enable Bitcode 我这里设置的是NO，但是我不知道为什么官方的给的是YES
* 添加依赖库![image](https://github.com/Davisjy/images4Gif/blob/master/%E4%BE%9D%E8%B5%96%E5%BA%93.png)
* 在info里面添加LSApplicationQueriesSchemes这个键，对应的数组里面存放alipay
* 配置partner（合作身份者ID）、seller（收款账号，这里注意必须与partner对应）、privateKey（商户私钥）、等基本信息参数
* [官方文档](http://openclub.alipay.com/read.php?tid=16&fid=7)
* 虽然我也不懂，但是跟着官方文档集成就好了撒
* `ps:我真的不懂凯子为什么推不上来，求解，求告知！！！`
* 微信支付的审核的情况比支付宝难，方法调用比支付宝简单的多，暂时不好给凯子写demo，但是感觉跟着官方文档走应该没什么问题吧。
* 如果有大神路过这里，我希望可以抱住您的大腿😳😳😳
</pre>