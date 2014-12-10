//
//  WXChat.h
//  CYShared
//
//  Created by Chenyun on 14/11/20.
//  Copyright (c) 2014年 geek-zoo. All rights reserved.
//

#import "CYServiceShare.h"
#import "WXApi.h"

@interface CYWXChatShared : CYServiceShare <WXApiDelegate>

AS_SINGLETON( WXChatShared );

- (void)shareFriend;
- (void)shareTimeline;

@end
