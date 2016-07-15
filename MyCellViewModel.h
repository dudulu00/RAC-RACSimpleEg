//
//  MyCellViewModel.h
//  HongXiaoBao
//
//  Created by hoomsun on 16/7/5.
//  Copyright © 2016年 hongxb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCellViewModel : NSObject

@property (nonatomic, strong, readonly) NSString *tweetAuthorFullName;
@property (nonatomic, strong, readonly) UIImage *tweetAuthorAvatarImage;
@property (nonatomic, strong, readonly) NSString *tweetContent;


@end
