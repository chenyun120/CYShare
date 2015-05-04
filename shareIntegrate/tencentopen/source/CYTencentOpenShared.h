//
//  TencentOpenShared.h
//  CYShared
//
//  Created by Chenyun on 14/11/20.
//  Copyright (c) 2014年 geek-zoo. All rights reserved.
//

#import "CYServiceShare.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentOAuthObject.h>
#import <TencentOpenAPI/TencentMessageObject.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>

typedef NS_ENUM(NSUInteger, TencentOpenSence) {
	TencentOpenSenceQQ,
	TencentOpenSenceQZone
};

@interface CYTencentOpenShared : CYServiceShare <TencentSessionDelegate, QQApiInterfaceDelegate,TencentLoginDelegate>

AS_SINGLETON( TencentOpenShared );

@property (nonatomic, retain) TencentOAuth *                tencentOAuth;
@property (nonatomic, strong) NSDictionary *				responseDic;

- (void)shareQq;
- (void)shareQzone;

- (void)getUserInfo;

@end
