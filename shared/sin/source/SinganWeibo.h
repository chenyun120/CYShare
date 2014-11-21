//
//  singanWeibo.h
//  CYShared
//
//  Created by Chenyun on 14/11/19.
//  Copyright (c) 2014年 geek-zoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceShare.h"
#import "WeiboSDK.h"

@interface SinganWeibo : ServiceShare <WeiboSDKDelegate>
AS_SINGLETON(singanWeibo);

@property (nonatomic, readonly) BOOL							isAuthorized;

- (void)sharedSin;

@end
