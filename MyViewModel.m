//
//  MyViewModel.m
//  HongXiaoBao
//
//  Created by hoomsun on 16/7/5.
//  Copyright © 2016年 hongxb. All rights reserved.
//

#import "MyViewModel.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation MyViewModel

- (instancetype)init
{
    if (self = [super init]) {
        
        RACSignal *nameSign = RACObserve(self, username);
        RAC(self, usernameValid) = [nameSign map:^id(NSString * value) {
            return [value isEqualToString:@"njm"]? @0:@1;
        }];
        
    }
    return self;
}

-(BOOL)isUsernameValid
{
    
    
    if ([self.username  isEqual: @"njm"]) {
        return NO;
    } else {
        return YES;
    }
}

- (void)getTweetsForCurrentUsername {
    DLog(@"curr-name:%@",self.username);
}

- (void)loadMoreTweets {
    DLog(@"loading more data:%@",self.tweets);
}

@end
