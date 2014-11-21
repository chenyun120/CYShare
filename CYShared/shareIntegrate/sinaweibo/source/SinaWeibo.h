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

@interface SinaWeibo : ServiceShare <WeiboSDKDelegate>
AS_SINGLETON(SinaWeibo);
- (void)sharedSin;
@end
