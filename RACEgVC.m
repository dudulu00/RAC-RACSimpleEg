////
////  RACEgVC.m
////  HongXiaoBao
////
////  Created by hoomsun on 16/7/4.
////  Copyright © 2016年 hongxb. All rights reserved.
////
//
//#import "RACEgVC.h"
//
//#import <ReactiveCocoa/ReactiveCocoa.h>
//
//@class MyViewModel;
//
//@interface RACEgVC ()
//@property(nonatomic, strong) MyViewModel *viewModel;
//
//@end
//
//@implementation RACEgVC
//
//-(void)viewDidLoad
//{
//    
//}
//
//
////RAC SubscribeNext
//- (void)eg1
//{
////    // create and get a reference to the signal
////    RACSignal *usernameValidSignal = RACObserve(self.viewModel,  isUsernameValid);
////    // update the local property when this value changes
////    [usernameValidSignal subscribeNext: ^(NSNumber *isValidNumber) {
////        self.usernameIsValid = isValidNumber.boolValue;
////    }];
//    
//    
//   
//    
//}
//
//- (void)eg2
//{
////    RAC(self,  usernameIsValid) = RACObserve(self.viewModel,  isUsernameValid);
//}
//
//- (void)eg3
//{
////    RACSignal *usernameIsValidSignal = RACObserve(self.viewModel, isUsernameValid);
////    RAC(self.goButton, enabled) = usernameIsValidSignal;
////    RAC(self.goButton, alpha) = [usernameIsValidSignal
////                                 map:^id(NSNumber *usernameIsValid) {
////                                     return usernameIsValid.boolValue ? @1.0 : @0.5;
////                                 }];
//    
//}
//
//
////RACSignal
//- (void)eg1
//{
//    //networkSignal.m
//    //    RACSignal *networkSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//    //        NetworkOperation *operation = [NetworkOperation getJSONOperationForURL:@"http://someurl"];
//    //        [operation setCompletionBlockWithSuccess:^(NetworkOperation *theOperation, id *result) {
//    //            [subscriber sendNext:result];
//    //            [subscriber sendCompleted];
//    //        } failure:^(NetworkOperation *theOperation, NSError *error) {
//    //            [subscriber sendError:error];
//    //        }];
//    //    }];
//    
//}
//
//- (void)eg2
//{
//    //    RACSignal *usernameValidSignal = RACObserve(self.viewModel,  usernameIsValid);
//    
//}
//
//- (void)eg3
//{
//    //signals.m
//    RACSignal *controlUpdate = [myButton rac_signalForControlEvents:UIControlEventTouchUpInside];
//    // signals for UIControl events send the control event value (UITextField, UIButton, UISlider, etc)
//    // subscribeNext:^(UIButton *button) { NSLog(@"%@", button); // UIButton instance }
//    
//    RACSignal *textChange = [myTextField rac_textSignal];
//    // some special methods are provided for commonly needed control event values off certain controls
//    // subscribeNext:^(UITextField *textfield) { NSLog(@"%@", textfield.text); // "Hello!" }
//    
//    RACSignal *alertButtonClicked = [myAlertView rac_buttonClickedSignal];
//    // signals for some delegate methods send the delegate params as the value
//    // e.g. UIAlertView, UIActionSheet, UIImagePickerControl, etc
//    // (limited to methods that return void)
//    // subscribeNext:^(NSNumber *buttonIndex) { NSLog(@"%@", buttonIndex); // "1" }
//    
//    RACSignal *viewAppeared = [self rac_signalForSelector:@selector(viewDidAppear:)];
//    // signals for arbitrary selectors that return void, send the method params as the value
//    // works for built in or your own methods
//    // subscribeNext:^(NSNumber *animated) { NSLog(@"viewDidAppear %@", animated); // "viewDidAppear 1" }
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
