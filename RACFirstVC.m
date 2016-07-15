//
//  RACFirstVC.m
//  HongXiaoBao
//
//  Created by hoomsun on 16/7/4.
//  Copyright © 2016年 hongxb. All rights reserved.
//

#import "RACFirstVC.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "MyViewModel.h"
#import "MyCellViewModel.h"

@interface RACFirstVC ()

@property (nonatomic, strong) MyViewModel *viewModel;

@property (nonatomic, strong) UITextField *myTextfield;
@property (nonatomic, strong) UIButton *goButton;
@property (nonatomic, strong) UILabel *userNameLabel;

@property (nonatomic, strong) UIImageView *avatarImageView;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation RACFirstVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"RAC Test";
    [self initViews];
    [self initViewModel];
    
    // tf-->vm.uername(wr) --> vm.userIsValid --> signal --> btn/label
    
    RAC(self.viewModel, username) = [self.myTextfield rac_textSignal];
    RACSignal *userIsValid = RACObserve(self.viewModel, usernameValid);
    
    RAC(self.goButton, enabled) = userIsValid;
    RAC(self.goButton, alpha) = [userIsValid map:^id(NSNumber *valid) {
        return valid.boolValue? @1:@0.4;
    }];
    [[self.goButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
       
        NSLog(@"btn clicked");
//        [self login];
    }];
    
    
    // 错误的处理方式：异步的网络请求装载在信号中，用map是得不到正确结果的
    // 因为map只是做值的转换，这里subscribe得到的仍是signal(block)，而非signal的输出值
    [[[self.goButton rac_signalForControlEvents:UIControlEventTouchUpInside] map:^id(id value) {
        return [self signInBtn];
        //net req signin
    }] subscribeNext:^(id x) {
        NSLog(@"signin ret:%@",x);
    }];
    // 正确的flattenMap=========
    [[[self.goButton rac_signalForControlEvents:UIControlEventTouchUpInside] flattenMap:^RACStream *(id value) {
        return [self signInSignal];
    }] subscribeNext:^(id x) {
        BOOL success = [x boolValue];
//        self.failureText.hidden = success;
        if (success) {
            // 进入登录成功的页面
        }
    }];
    // 完整操作：添加附加操作doNext(异步请求期间 将登陆按钮置为不可点击) -- side-efficts
    [[[[self.goButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    doNext:^(id x) {
        self.goButton.enabled = NO;
//        self.failureText.hidden = YES;
    }]
    flattenMap:^RACStream *(id value) {
        return [self signInSignal];
    }]
    subscribeNext:^(NSNumber *signedIn) {
        
        self.goButton.enabled = YES;
        BOOL success = [signedIn boolValue];
        //        self.failureText.hidden = success;
        if (success) {
            // 进入登录成功的页面
        }
    }];
    
    //
    RAC(self.userNameLabel, text) = RACObserve(self.viewModel, username);
    
    @weakify(self);
    [[self.goButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel getTweetsForCurrentUsername];
        
    }];
    
    
    [[[RACSignal merge:@[RACObserve(self.viewModel, tweets),RACObserve(self.viewModel, allTweetsLoaded)]] bufferWithTime:0 onScheduler:[RACScheduler mainThreadScheduler]]
    subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
    //=====
//    RAC(self.viewModel,  username) = [self.myTextfield rac_textSignal];
    
//    RACSignal *usernameIsValidSignal = RACObserve(self.viewModel,  usernameValid);
    
//    RAC(self.goButton,  alpha) = [usernameIsValidSignal
//                                  map:  ^(NSNumber *valid) {
//                                      return valid.boolValue ? @1:@0.5;
//                                  }];
    
//    RAC(self.goButton,  enabled) = usernameIsValidSignal;
    
//    RAC(self.avatarImageView,  image) = RACObserve(self.viewModel,  userAvatarImage);
    
//    RAC(self.userNameLabel,  text) = RACObserve(self.viewModel,  userFullName);
    
    

    /**
     eg
     
     - returns: Signal
     */
    //    [[self.myTextfield.rac_textSignal filter:^BOOL(id value) {
    //        NSString *text = value;
    //        return text.length>2;
    //    }] subscribeNext:^(id x) {
    //        NSLog(@"%@",x);
    //    }];


//    [[[self.myTextfield.rac_textSignal map:^id(NSString *value) {
//        return @(value.length);
//    }]
//    filter:^BOOL(id value) {
//        return [value intValue] > 3;
//    }]
//    subscribeNext:^(id x) {
//        NSLog(@"");
//    }];
    
    RACSignal *validSignal = [self.myTextfield.rac_textSignal map:^id(NSString *value) {
        
        return @([self isValidInput:value]);
    }];
    RAC(self.userNameLabel, backgroundColor) = [validSignal map:^id(id value) {
        return [value boolValue] ? [UIColor lightGrayColor]:[UIColor redColor];
    }];
    //信号合并
    RACSignal *combinedSignal = [RACSignal combineLatest:@[validSignal, userIsValid]
                                                  reduce:^id(NSNumber *valid1, NSNumber *valid2){
                                                      // 将两个信号合并成一个信号处理---（比如只有用户名和密码都正确，才能认为可以登录）
                                                      return @([valid1 boolValue]&&[valid2 boolValue]);
                                                  }];
    RAC(self.goButton, enabled) = combinedSignal;
    //
    
}

// 创建一个执行api的内部信号======
- (RACSignal *)signInSignal
{
    return
    [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // signInService 登录serviece-api
        //在complete-block中将处理结果同步返回给subscriber，自己并不做逻辑处理
        [self.signInService signInWithUsername:self.uesrTF.text
                                      password:self.pwdTF.text
                                      complete:^(BOOL success){
                                          
                                          [subscriber sendNext:@(success)];//外部订阅到的值
                                          [subscriber sendCompleted];
                                      
                                      }];
        
        return nil;
    }];
    
}

- (BOOL)isValidInput:(NSString *)text
{
    if ([text isEqualToString:@"njm"]) {
        return false;
    } else {
        return true;
    }
}

- (void)initViewModel
{
    self.viewModel = [[MyViewModel alloc] init];
    
    
}

- (void)initViews
{
    _myTextfield = [[UITextField alloc] initWithFrame:CGRectMake(10, 100, 200, 50)];
    _myTextfield.backgroundColor = [UIColor darkGrayColor];
    
    _goButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _goButton.frame = CGRectMake(10, 200, 50, 50);
    _goButton.titleLabel.text = @"btn";
    _goButton.backgroundColor = [UIColor orangeColor];
    [_goButton setTitle:@"" forState:UIControlStateHighlighted];
    
    _userNameLabel= [[UILabel alloc] initWithFrame:CGRectMake(100, 200, 150, 50)];
    _userNameLabel.backgroundColor = [UIColor grayColor];
    _userNameLabel.tintColor = [UIColor blueColor];
    
    [self.view addSubview:_myTextfield];
    [self.view addSubview:_goButton];
    [self.view addSubview:_userNameLabel];
    
}

//-(UITableViewCell*)tableView: (UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath {
//    // if table section is the tweets section
//    if (indexPath. section == 0) {
//        MYTwitterUserCell *cell =
//        [self.tableView dequeueReusableCellWithIdentifier: @"MYTwitterUserCell" forIndexPath: indexPath];
//        
//        // grab the cell view model from the vc view model and assign it
//        cell.viewModel = self.viewModel. tweets[indexPath. row];
//        return cell;
//    } else {
//        // else if the section is our loading cell
//        MYLoadingCell *cell =
//        [self.tableView dequeueReusableCellWithIdentifier: @"MYLoadingCell" forIndexPath: indexPath];
//        [self.viewModel loadMoreTweets];
//        return cell;
//    }
//}


//
// MYTwitterUserCell
//

// this could also be in cell init
//- (void) awakeFromNib {
//    [super awakeFromNib];
//    
//    RAC(self.avatarImageView,  image) = RACObserve(self,  viewModel. tweetAuthorAvatarImage);
//    RAC(self.userNameLabel,  text) = RACObserve(self,  viewModel. tweetAuthorFullName);
//    RAC(self.tweetTextLabel,  text) = RACObserve(self,  viewModel. tweetContent);
//}


/*
 SOURCE_DEFAULT = 0
 SOURCE_TAOBAO = 1
 SOURCE_GUANWANG = 2
 SOURCE_360 = 3
 SOURCE_YINGYONGBAO = 4
 SOURCE_XIAOMI = 5
 SOURCE_BAIDU = 6
 SOURCE_HUAWEI = 7
 SOURCE_QR_CODE = 8
 SOURCE_OPPO = 9
 SOURCE_WANDOUJIA = 10
 SOURCE_ANDROID = 11
 SOURCE_MEIZU = 12
 SOURCE_ANZHI = 13
 SOURCE_YIYONGHUI = 14
 SOURCE_JIFENG = 15
 SOURCE_LENOVO = 16
 SOURCE_LETV = 17
 SOURCE_SOUGOU = 18
 SOURCE_CESHI = 19
 SOURCE_QQ = 20
 SOURCE_MSG = 21
 SOURCE_91 = 22
 SOURCE_SHARE = 23
 SOURCE_YOUMI = 24
 SOURCE_TOUTIAO = 25
 SOURCE_DIANRU = 26
 SOURCE_WANPU = 27
 SOURCE_APPSTORE = 28
 SOURCE_XIAMI = 29
 
 SOURCE = {
 SOURCE_DEFAULT: '初始用户',
 SOURCE_TAOBAO: '淘宝',
 SOURCE_GUANWANG: '官网',
 SOURCE_360: '360',
 SOURCE_YINGYONGBAO: '应用宝',
 SOURCE_XIAOMI: '小米',
 SOURCE_BAIDU: '百度',
 SOURCE_HUAWEI: '华为',
 SOURCE_QR_CODE: '二维码',
 SOURCE_OPPO: 'OPPO',
 SOURCE_WANDOUJIA: '豌豆荚',
 SOURCE_ANDROID: '安卓',
 SOURCE_MEIZU: '魅族',
 SOURCE_YIYONGHUI: '易用汇',
 SOURCE_ANZHI: '安智',
 SOURCE_JIFENG: '机锋',
 SOURCE_LENOVO: '联想',
 SOURCE_LETV: 'LeTV',
 SOURCE_SOUGOU: '搜狗',
 # SOURCE_CESHI: '测试',
 SOURCE_QQ: 'QQ',
 # SOURCE_MSG: '短信',
 SOURCE_91: '91助手',
 SOURCE_YOUMI: '有米',
 SOURCE_TOUTIAO: '今日头条',
 SOURCE_SHARE: '好友邀请',
 SOURCE_DIANRU: '点入积分墙',
 SOURCE_WANPU: '万普',
 SOURCE_APPSTORE: '苹果商店',
 SOURCE_XIAMI: '虾米'
 }
 */


@end
