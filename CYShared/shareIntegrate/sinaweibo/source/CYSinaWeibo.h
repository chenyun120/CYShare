//
//  singanWeibo.h
//  CYShared
//
//  Created by Chenyun on 14/11/19.
//  Copyright (c) 2014年 geek-zoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CYServiceShare.h"
#import "WeiboSDK.h"

@interface CYSinaWeibo : CYServiceShare <WeiboSDKDelegate,WBHttpRequestDelegate>

AS_SINGLETON(SinaWeibo);

@property (nonatomic, copy)   NSString *						authCode;
@property (nonatomic, copy)   NSString *						accessToken;
@property (nonatomic, copy)   NSString *						expiresIn;
@property (nonatomic, copy)   NSString *						remindIn;
@property (nonatomic, copy)   NSString *						uid;

@property (nonatomic, readonly) BOOL							isExpired;

- (void)sharedSin;
+ (BOOL)isWeiboAppInstalled;
- (void)followWithName:(NSString *)name;
@end
