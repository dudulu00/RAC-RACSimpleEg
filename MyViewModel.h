//
//  MyViewModel.h
//  HongXiaoBao
//
//  Created by hoomsun on 16/7/5.
//  Copyright © 2016年 hongxb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyViewModel : NSObject

@property (nonatomic, strong, readwrite) NSString *username;

@property (nonatomic, assign, readwrite, getter=isUsernameValid) BOOL usernameValid;

@property (nonatomic, strong, readonly) NSString *userFullName;

@property (nonatomic, strong, readonly) UIImage *userAvatarImage;

@property (nonatomic, strong, readonly) NSArray *tweets;

@property (nonatomic, assign, readonly) BOOL allTweetsLoaded;



- (void)getTweetsForCurrentUsername;
- (void)loadMoreTweets;


@end
