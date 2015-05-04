//
//  ServiceShare.h
//  CYShared
//
//  Created by Chenyun on 14/11/20.
//  Copyright (c) 2014年 geek-zoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CYSharedModel.h"
#import "CYSharedPost.h"

typedef NS_ENUM(NSUInteger, VENDOR) {
	VENDOR_UNKNOWN = 0,
	VENDOR_WEIXIN = 1,
	VENDOR_WEIBO = 2,
	VENDOR_QQ = 3
};

typedef	void	(^ServiceBlock)( void );
typedef	void	(^ServiceBlockN)( id first );

@interface ACCOUNT : NSObject
@property (nonatomic, assign) VENDOR vendor;
@property (nonatomic, strong) NSString * auth_key;
@property (nonatomic, strong) NSString * auth_token;
@property (nonatomic, strong) NSString * user_id;
@property (nonatomic, strong) NSString * expires;
@end

@interface CYServiceShare : NSObject

AS_SINGLETON( ServiceShare );

@property (nonatomic, strong) CYSharedPost * post;

@property (nonatomic, copy) NSString * appKey;
@property (nonatomic, copy) NSString * appId;
@property (nonatomic, copy) NSString * redirectUrl;

@property (nonatomic, copy) ServiceBlock					whenShareBegin;
@property (nonatomic, copy) ServiceBlock					whenShareSucceed;
@property (nonatomic, copy) ServiceBlock					whenShareFailed;
@property (nonatomic, copy) ServiceBlock					whenShareCancelled;

@property (nonatomic, copy) ServiceBlock					whenFollowBegin;
@property (nonatomic, copy) ServiceBlock					whenFollowSucceed;
@property (nonatomic, copy) ServiceBlock					whenFollowFailed;
@property (nonatomic, copy) ServiceBlock					whenFollowCancelled;

@property (nonatomic, copy) ServiceBlock					whenGetUserInfoBegin;
@property (nonatomic, copy) ServiceBlockN					whenGetUserInfoSucceed;
@property (nonatomic, copy) ServiceBlock					whenGetUserInfoFailed;
@property (nonatomic, copy) ServiceBlock					whenGetUserInfoCancelled;

- (void)powerOn;

@end
