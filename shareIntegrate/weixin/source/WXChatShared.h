//
//  WXChat.h
//  CYShared
//
//  Created by Chenyun on 14/11/20.
//  Copyright (c) 2014年 geek-zoo. All rights reserved.
//

#import "ServiceShare.h"
#import "WXApi.h"

@interface WXChatShared : ServiceShare <WXApiDelegate>

AS_SINGLETON( WXChatShared );

- (void)shareFriend;
- (void)shareTimeline;

@end
