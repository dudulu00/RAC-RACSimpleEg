////
////  RACTestVC.m
////  HongXiaoBao
////
////  Created by hoomsun on 16/7/1.
////  Copyright © 2016年 hongxb. All rights reserved.
////
//
//#import "RACTestVC.h"
//#import <ReactiveCocoa/RACSignal.h>
//#import <ReactiveCocoa/RACSubject.h>
//
//@implementation RACTestVC
//
//-(void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//    
//}
//
//- (void)makeSignal
//{
//    // RACSignal使用步骤：
//    // 1.创建信号 + (RACSignal *)createSignal:(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe
//    // 2.订阅信号,才会激活信号. - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
//    // 3.发送信号 - (void)sendNext:(id)value
//    
//    // RACSignal底层实现：
//    // 1.创建信号，首先把didSubscribe保存到信号中，还不会触发。
//    // 2.当信号被订阅，也就是调用signal的subscribeNext:nextBlock
//    // 2.2 subscribeNext内部会创建订阅者subscriber，并且把nextBlock保存到subscriber中。
//    // 2.1 subscribeNext内部会调用siganl的didSubscribe
//    // 3.siganl的didSubscribe中调用[subscriber sendNext:@1];
//    // 3.1 sendNext底层其实就是执行subscriber的nextBlock
//    
//    // 1.创建信号
//    RACSignal *siganl = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        
//        // block调用时刻：每当有订阅者订阅信号，就会调用block。
//        // 2.发送信号
//        [subscriber sendNext:@1];
//        
//        // 如果不在发送数据，最好发送信号完成，内部会自动调用[RACDisposable disposable]取消订阅信号。
//        [subscriber sendCompleted];
//        
//        return [RACDisposable disposableWithBlock:^{
//            
//            // block调用时刻：当信号发送完成或者发送错误，就会自动执行这个block,取消订阅信号。
//            // 执行完Block后，当前信号就不在被订阅了。
//            NSLog(@"信号被销毁");
//            
//        }];
//    }];
//    
//    // 3.订阅信号,才会激活信号.
//    [siganl subscribeNext:^(id x) {
//        // block调用时刻：每当有信号发出数据，就会调用block.
//        NSLog(@"接收到数据:%@",x);
//    }];
//    
//    
//}
//
//- (void)makeSubject
//{
//    // RACSubject使用步骤
//    // 1.创建信号 [RACSubject subject]，跟RACSiganl不一样，创建信号时没有block。
//    // 2.订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
//    // 3.发送信号 sendNext:(id)value
//    
//    // RACSubject:底层实现和RACSignal不一样。
//    // 1.调用subscribeNext订阅信号，只是把订阅者保存起来，并且订阅者的nextBlock已经赋值了。
//    // 2.调用sendNext发送信号，遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。
//    
//    // 1.创建信号
//    RACSubject *subject = [RACSubject subject];
//    
//    // 2.订阅信号
//    [subject subscribeNext:^(id x) {
//        // block调用时刻：当信号发出新值，就会调用.
//        NSLog(@"第一个订阅者%@",x);
//    }];
//    [subject subscribeNext:^(id x) {
//        // block调用时刻：当信号发出新值，就会调用.
//        NSLog(@"第二个订阅者%@",x);
//    }];
//    
//    // 3.发送信号
//    [subject sendNext:@"1"];
//    
//    
//    // RACReplaySubject使用步骤:
//    // 1.创建信号 [RACSubject subject]，跟RACSiganl不一样，创建信号时没有block。
//    // 2.可以先订阅信号，也可以先发送信号。
//    // 2.1 订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
//    // 2.2 发送信号 sendNext:(id)value
//    
//    // RACReplaySubject:底层实现和RACSubject不一样。
//    // 1.调用sendNext发送信号，把值保存起来，然后遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。
//    // 2.调用subscribeNext订阅信号，遍历保存的所有值，一个一个调用订阅者的nextBlock
//    
//    // 如果想当一个信号被订阅，就重复播放之前所有值，需要先发送信号，在订阅信号。
//    // 也就是先保存值，在订阅值。
//    
//    // 1.创建信号
//    RACReplaySubject *replaySubject = [RACReplaySubject subject];
//    
//    // 2.发送信号
//    [replaySubject sendNext:@1];
//    [replaySubject sendNext:@2];
//    
//    // 3.订阅信号
//    [replaySubject subscribeNext:^(id x) {
//        
//        NSLog(@"第一个订阅者接收到的数据%@",x);
//    }];
//    
//    // 订阅信号
//    [replaySubject subscribeNext:^(id x) {
//        
//        NSLog(@"第二个订阅者接收到的数据%@",x);
//    }];
//}
//
//- (void)tupleAndSequence
//{
//    
//    
//    
//}
//
//
//@end
//
//
//
//
//
//
//#pragma mark - 用RACSubject代替代理
//// 需求:
//// 1.给当前控制器添加一个按钮，modal到另一个控制器界面
//// 2.另一个控制器view中有个按钮，点击按钮，通知当前控制器
//
////步骤一：在第二个控制器.h，添加一个RACSubject代替代理。
//@interface TwoViewController : UIViewController
//
//@property (nonatomic, strong) RACSubject *delegateSignal;
//
//@end
//
////步骤二：监听第二个控制器按钮点击
//@implementation TwoViewController
//- (IBAction)notice:(id)sender {
//    // 通知第一个控制器，告诉它，按钮被点了
//    
//    // 通知代理
//    // 判断代理信号是否有值
//    if (self.delegateSignal) {
//        // 有值，才需要通知
//        [self.delegateSignal sendNext:nil];
//    }
//}
//@end
//
////步骤三：在第一个控制器中，监听跳转按钮，给第二个控制器的代理信号赋值，并且监听.
//@implementation OneViewController
//- (IBAction)btnClick:(id)sender {
//    
//    // 创建第二个控制器
//    TwoViewController *twoVc = [[TwoViewController alloc] init];
//    // 设置代理信号
//    twoVc.delegateSignal = [RACSubject subject];
//    // 订阅代理信号
//    [twoVc.delegateSignal subscribeNext:^(id x) {
//        
//        NSLog(@"点击了通知按钮");
//    }];
//    
//    // 跳转到第二个控制器
//    [self presentViewController:twoVc animated:YES completion:nil];
//}
//
//
//@end
//
//
//
//
