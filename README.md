### FZT-Liucc  
#BLE4.0--BabyBluetooth的使用心得

我这周就来介绍一下我最近用的这个第三方库：[BabyBluetooth](https://github.com/coolnameismy/BabyBluetooth )    
我主要使用的是中心模式，外设模式只是看过没有真正的使用过。所以这里我只简单的介绍一下APP里使用中心模式的方法。  
####1. 这个库主要使用的是链式函数去调用方法，用的是Block来接收BLE 4.0的回调。
他的使用方式也很简单，你需要先根据你的需求实现Block回调方法(类似于实现代理方法)用来接收扫描到的结果  
<pre><code>//设备状态改变的委托，例如下面表格里的就是常用的方法
-(void)setBlockOnCentralManagerDidUpdateState:(void (^)(CBCentralManager *central))block{
    [[babySpeaker callback]setBlockOnCentralManagerDidUpdateState:block];
}
//找到Peripherals的委托
-(void)setBlockOnDiscoverToPeripherals:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary *advertisementData, NSNumber *RSSI))block{
    [[babySpeaker callback]setBlockOnDiscoverPeripherals:block];
}
//连接Peripherals成功的委托
-(void)setBlockOnConnected:(void (^)(CBCentralManager *central,CBPeripheral *peripheral))block{
    [[babySpeaker callback]setBlockOnConnectedPeripheral:block];
}
//连接Peripherals失败的委托
-(void)setBlockOnFailToConnect:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error))block{
    [[babySpeaker callback]setBlockOnFailToConnect:block];
}
//断开Peripherals的连接
-(void)setBlockOnDisconnect:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error))block{
    [[babySpeaker callback]setBlockOnDisconnect:block];
}
//设置查找服务回叫
-(void)setBlockOnDiscoverServices:(void (^)(CBPeripheral *peripheral,NSError *error))block{
    [[babySpeaker callback]setBlockOnDiscoverServices:block];
}
//设置查找到Characteristics的block
-(void)setBlockOnDiscoverCharacteristics:(void (^)(CBPeripheral *peripheral,CBService *service,NSError *error))block{
    [[babySpeaker callback]setBlockOnDiscoverCharacteristics:block];
}
//设置获取到最新Characteristics值的block
-(void)setBlockOnReadValueForCharacteristic:(void (^)(CBPeripheral *peripheral,CBCharacteristic *characteristic,NSError *error))block{
    [[babySpeaker callback]setBlockOnReadValueForCharacteristic:block];
}
//设置查找到Characteristics描述的block
-(void)setBlockOnDiscoverDescriptorsForCharacteristic:(void (^)(CBPeripheral *peripheral,CBCharacteristic *service,NSError *error))block{
    [[babySpeaker callback]setBlockOnDiscoverDescriptorsForCharacteristic:block];
}
//设置读取到Characteristics描述的值的block
-(void)setBlockOnReadValueForDescriptors:(void (^)(CBPeripheral *peripheral,CBDescriptor *descriptorNSError,NSError *error))block{
    [[babySpeaker callback]setBlockOnReadValueForDescriptors:block];
}

//写Characteristic成功后的block
-(void)setBlockOnDidWriteValueForCharacteristic:(void (^)(CBCharacteristic *characteristic,NSError *error))block{
    [[babySpeaker callback]setBlockOnDidWriteValueForCharacteristic:block];
}
//写descriptor成功后的block
-(void)setBlockOnDidWriteValueForDescriptor:(void (^)(CBDescriptor *descriptor,NSError *error))block{
    [[babySpeaker callback]setBlockOnDidWriteValueForDescriptor:block];
}
//characteristic订阅状态改变的block
-(void)setBlockOnDidUpdateNotificationStateForCharacteristic:(void (^)(CBCharacteristic *characteristic,NSError *error))block{
    [[babySpeaker callback]setBlockOnDidUpdateNotificationStateForCharacteristic:block];
}

</code></pre>   
在设置完这些东西后就可以进行开始扫描了，设置扫描这块用的是链式语法。下面的代码就是一个简单的开始扫描外设的链式函数。
<pre><code>//设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态。
    baby.scanForPeripherals().begin();
</code></pre>  
在扫描到你想要的Peripherals之后你可以通过下面这些方法搜索外设的具体的特征值   
<pre><code>//连接设备并扫描服务和特征值
        baby.having(peripheral).and.connectToPeripherals().discoverServices().discoverCharacteristics().begin();
</code></pre>  
还有其他的一些函数，你可以按住command点开文档，找到你需要的接上去就可以了。  
当然链式函数开始的时候需要一个BabyBluetooth的单例对象baby做开头,需要一个begin()作为结束语，中间的with与and都是没有用的谓词。
####2. 在设置完上面的东西后你需要做的工作就是在你的Block回调里找到你需要的服务与特征值并进行你想要的操作，例如我会把他保存下来并进行监听与写操作  
<pre><code>/设置扫描到设备的委托
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
//        YYLog(@"开始扫描到设备");
          //用于发现新的设备
        if(![weaknewPeripherals containsObject:peripheral]){

            [weaknewPeripherals addObject:peripheral];
        }
        
        
        //用于蓝牙重连
        if([peripheral.identifier isEqual:weakSelf.currNSUUID]){
            [weakSelf ConnectedPeripheral:peripheral];
        }

    }];
    
    //设置设备连接成功的委托
    [baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        //调用连接成功的处理方法
        [weakSelf ConnectSucceed];
    }];
    //设置设备连接失败的委托
    [baby setBlockOnFailToConnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        //调用连接失败的处理方法
        [weakSelf ConnectDefeated];
        //Block传递消息
        if(weakSelf.blockOnFailToConnect){
            weakSelf.blockOnFailToConnect(central,peripheral,error);
        }
       
    }];
    //设置设备断开连接的委托
    [baby setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        //调用连接中断的处理方法
        [weakSelf ConnectIntermit];
        //Block传递消息
        if(weakSelf.blockOnDisconnect){
            weakSelf.blockOnDisconnect(central,peripheral,error);
        }
        
        //        YYLog(@"断开连接");
        
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--连接断开",peripheral.name]];
        
    }];
    
    
    
    //设置发现设备的Services的委托
    [baby setBlockOnDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
        //        for (CBService *service in peripheral.services) {
        //            NSLog(@"搜索到服务:%@",service.UUID.UUIDString);
        //        }
    }];
    //设置发现设service的Characteristics的委托
    [baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        
        //筛选有用的特征值
        if ([service.UUID.UUIDString isEqual:@"FFF0"]) {
            for (CBCharacteristic *characteristic in service.characteristics) {
                //                NSLog(@"charateristic name is :%@",characteristic.UUID);
                
                //保存写的特征
                if ([characteristic.UUID.UUIDString isEqual:@"FFF6"]) {
                    weakSelf.writeCharacteristic = characteristic;
                            if(weakSelf.blockOnConnectedPeripheral){
                                weakSelf.blockOnConnectedPeripheral(nil,peripheral);
                            }

                }
                //保存读的特征
                if ([characteristic.UUID.UUIDString isEqual:@"FFF7"]) {
                    weakSelf.readCharacteristic = characteristic;
                    //调用监听通知的方法
                    [weakSelf NotifyOnReadCharacteristic];
                }
            }
</code></pre>   
下面是写数据的代码,writeCharacteristic与readCharacteristic就是之前保存下来的读写的特征值
<pre><code>  //判断读写是否准备好
    if (self.writeCharacteristic && self.readCharacteristic) {
        //    写数据
        [self.currperipheral writeValue:data forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
        YYLog(@"读写准备好了");
        self.blockOnDidWriteValueForCharacteristic = success;
    }else{
       YYLog@"读写没有准备好");
        
    }
 </code></pre>     
 而读的特征也可以叫做监听特征值  监听一个特征值之后如果蓝牙给你发送消息之后就会调用下面的这个Block回调，你在这里面处理你的数据就可以了
 <pre><code> //设置监听特定的特征值
-(void)NotifyOnReadCharacteristic{

    [baby notify:self.currperipheral
  characteristic:self.readCharacteristic
           block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
              
               //将接受的数据发出去
               if (self.blockOnReadValueForCharacteristic) {
                   self.blockOnReadValueForCharacteristic(peripheral,characteristics,error);
               }
           }];
}
</code></pre>  
      好了 今天先写到这些 后面在写其他的操作，毕竟我是加班半小时写的。
