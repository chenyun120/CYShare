//
//  TencentOpenShared.m
//  CYShared
//
//  Created by Chenyun on 14/11/20.
//  Copyright (c) 2014年 geek-zoo. All rights reserved.
//

#import "CYTencentOpenShared.h"

@implementation CYTencentOpenShared
DEF_SINGLETON( TencentOpenShared );

#pragma mark -

+ (void)load
{
	[[CYTencentOpenShared sharedInstance] TencentOpenInit];
}

- (void)TencentOpenInit
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sourceApplication:) name:@"sourceApplication" object:nil];

	self.whenShareBegin = [CYServiceShare sharedInstance].whenShareBegin;
	self.whenShareFailed = [CYServiceShare sharedInstance].whenShareFailed;
	self.whenShareSucceed = [CYServiceShare sharedInstance].whenShareSucceed;
	self.whenShareCancelled = [CYServiceShare sharedInstance].whenShareCancelled;
}

- (void)powerOn
{
	self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:self.appId andDelegate:self];
}

- (void)sourceApplication:(NSNotification *)notifi
{
	NSDictionary * params = notifi.userInfo;
	[QQApiInterface handleOpenURL:params[@"url"] delegate:(id<QQApiInterfaceDelegate>)self];
	[TencentOAuth CanHandleOpenURL:params[@"url"]];
	[TencentOAuth HandleOpenURL:params[@"url"]];
}

#pragma mark - 得到用户信息

- (void)getUserInfo
{
	if ( NO == [TencentOAuth iphoneQQInstalled] )
	{
		NSLog(@" 请安装QQ客户端 ");
		return;
	}

	NSArray * permissions = @[kOPEN_PERMISSION_GET_INFO,
							  kOPEN_PERMISSION_GET_USER_INFO,
							  kOPEN_PERMISSION_GET_SIMPLE_USER_INFO
							 ];

	[self.tencentOAuth authorize:permissions inSafari:NO];
}

#pragma mark -

- (void)shareQq
{
	[self share:TencentOpenSenceQQ];
}

- (void)shareQzone
{
	[self share:TencentOpenSenceQZone];
}

#pragma mark -

- (void)share:(TencentOpenSence)scene
{
	//分享到QQ
	if ( NO == [TencentOAuth iphoneQQInstalled] )
	{
		NSLog(@"请安装QQ");
		return;
	}

	if ( self.post.photo || self.post.thum || self.post.url )
	{
		NSData * imageData = nil;
		
		if ( [self.post.photo isKindOfClass:[NSData class]] )
		{
			imageData = self.post.photo;
		}
		else if ( [self.post.photo isKindOfClass:[UIImage class]] )
		{
			imageData = UIImageJPEGRepresentation(self.post.photo, 0.6);
		}

		NSString * title = self.post.title;

		if ( title.length > 140 )
		{
			title = [title substringToIndex:140];
		}
		
		NSString * text = self.post.text;
		
		if ( text.length > 140 )
		{
			text = [text substringToIndex:140];
		}

		QQApiNewsObject *newsObj ;

		if ( [self.post.photo isKindOfClass:[NSString class]] )
		{
			newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:self.post.url ? : @""]
											   title:title ? : @"分享"
										 description:text ? : @"分享"
									 previewImageURL:[NSURL URLWithString:self.post.photo]];
		}
		else
		{
			newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:self.post.url ? : @""]
											   title:title ? : @"分享"
										 description:text ? : @"分享"
									previewImageData:imageData];
		}

		SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];

		QQApiSendResultCode sent = 0;

		if ( TencentOpenSenceQZone == scene )
		{
			//分享到QZone
			sent = [QQApiInterface SendReqToQZone:req];
		}
		else if ( TencentOpenSenceQQ == scene )
		{
			//分享到QQ
			sent = [QQApiInterface sendReq:req];
		}

		[self handleSendResult:sent];
	}
	else
	{
		[self notifyShareFailed];
	}

}

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
	switch (sendResult)
	{
		case EQQAPIAPPNOTREGISTED:
		{
			NSLog(@"App未注册");
			[self notifyShareFailed];
			break;
		}
		case EQQAPIMESSAGECONTENTINVALID:
		case EQQAPIMESSAGECONTENTNULL:
		case EQQAPIMESSAGETYPEINVALID:
		{
			NSLog(@"发送参数错误");
			[self notifyShareFailed];
			break;
		}
		case EQQAPIQQNOTINSTALLED:
		{
			NSLog(@"未安装手Q");
			[self notifyShareFailed];
			break;
		}
		case EQQAPIQQNOTSUPPORTAPI:
		{
			NSLog(@"API接口不支持");
			[self notifyShareFailed];
			break;
		}
		case EQQAPISENDFAILD:
		{
			NSLog(@"发送失败");
			[self notifyShareFailed];
			break;
		}
		case EQQAPIQZONENOTSUPPORTTEXT:
		case EQQAPIQZONENOTSUPPORTIMAGE:
		{
			NSLog(@"空间分享不支持纯文本分享，请使用图文分享");
			[self notifyShareFailed];
			break;
		}
		default:
			break;
	}
}

#pragma mark - 

#pragma mark -

- (void)notifyShareBegin
{
	if ( self.whenShareBegin )
	{
		self.whenShareBegin();
	}
	else if ( [CYServiceShare sharedInstance].whenShareBegin )
	{
		[CYServiceShare sharedInstance].whenShareBegin();
	}
}

- (void)notifyShareSucceed
{
	if ( self.whenShareSucceed )
	{
		self.whenShareSucceed();
	}
	else if ( [CYServiceShare sharedInstance].whenShareSucceed )
	{
		[CYServiceShare sharedInstance].whenShareSucceed();
	}

	[self clearPost];
}

- (void)notifyShareFailed
{
	if ( self.whenShareFailed )
	{
		self.whenShareFailed();
	}
	else if ( [CYServiceShare sharedInstance].whenShareFailed )
	{
		[CYServiceShare sharedInstance].whenShareFailed();
	}
	
	[self clearPost];
}

- (void)clearPost
{
	[self.post clear];
}

#pragma mark - 

- (void)notifyGetUserInfoBegin
{
	if ( self.whenGetUserInfoBegin )
	{
		self.whenGetUserInfoBegin();
	}
	else if ( [CYServiceShare sharedInstance].whenGetUserInfoBegin )
	{
		[CYServiceShare sharedInstance].whenGetUserInfoBegin();
	}
}

- (void)notifyGetUserInfoSucceed
{
	ACCOUNT * account = [[ACCOUNT alloc] init];
	account.vendor = VENDOR_QQ;
	account.auth_key = self.appKey;
	account.auth_token = self.tencentOAuth.accessToken;
	account.user_id = self.tencentOAuth.openId;
	NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[self.tencentOAuth.expirationDate timeIntervalSince1970]];
	account.expires = timeSp;

	if ( self.whenGetUserInfoSucceed )
	{
		self.whenGetUserInfoSucceed(account);
	}
	else if ( [CYServiceShare sharedInstance].whenGetUserInfoSucceed )
	{
		[CYServiceShare sharedInstance].whenGetUserInfoSucceed(account);
	}
}

- (void)notifyGetUserInfoFailed
{
	if ( self.whenGetUserInfoFailed )
	{
		self.whenGetUserInfoFailed();
	}
	else if ( [CYServiceShare sharedInstance].whenGetUserInfoFailed )
	{
		[CYServiceShare sharedInstance].whenGetUserInfoFailed();
	}
}

#pragma mark - WXApiDelegate

- (void)onReq:(QQBaseReq*)req
{
	
}

- (void)onResp:(QQBaseReq*)resp
{
	switch ( resp.type )
	{
		case ESENDMESSAGETOQQRESPTYPE:
		{
			SendMessageToQQResp* sendResp = (SendMessageToQQResp*)resp;

			if ( sendResp.result.integerValue == 0 )
			{
				[self notifyShareSucceed];
			}
			else
			{
				[self notifyShareFailed];
			}
			break;
		}
		default:
		{
			break;
		}
	}
}

- (void)isOnlineResponse:(NSDictionary *)response
{
	
}

- (void)tencentDidLogin
{
	if ( self.tencentOAuth.accessToken && self.tencentOAuth.accessToken.length )
	{
		NSLog(@"accessToken:%@", self.tencentOAuth.accessToken);

		// 获取用户具体信息
		[self.tencentOAuth getUserInfo];
	}
	else
	{
		[self  notifyGetUserInfoFailed];
		NSLog(@"登录失败");
	}
}

// 没有网络
- (void)tencentDidNotNetWork
{
	[self  notifyGetUserInfoFailed];
}

// 登录失败  用户取消
- (void)tencentDidNotLogin:(BOOL)cancelled
{
	if ( cancelled )
	{
		NSLog(@"用户取消登录");
		[self  notifyGetUserInfoFailed];
	}
	else
	{
		NSLog(@"登录失败");
		[self  notifyGetUserInfoFailed];
	}
}

// 获取用户具体信息的回调
- (void)getUserInfoResponse:(APIResponse*) response
{
	if ( response.detailRetCode == kOpenSDKErrorSuccess )
	{
		self.responseDic = response.jsonResponse;
		[self  notifyGetUserInfoSucceed];
	}
	else
	{
		[self  notifyGetUserInfoFailed];
	}
}

@end
