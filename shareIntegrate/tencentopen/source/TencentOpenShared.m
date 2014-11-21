//
//  TencentOpenShared.m
//  CYShared
//
//  Created by Chenyun on 14/11/20.
//  Copyright (c) 2014年 geek-zoo. All rights reserved.
//

#define KAppKey @"cf6c9a2d437ec76fa20669293a5c640a"
#define KAppId @"101027797"

#import "TencentOpenShared.h"

@implementation TencentOpenShared
DEF_SINGLETON( TencentOpenShared );

#pragma mark -

+ (void)load
{
	[[TencentOpenShared sharedInstance] TencentOpenInit];
}

- (void)TencentOpenInit
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sourceApplication:) name:@"sourceApplication" object:nil];

	self.whenShareBegin = [ServiceShare sharedInstance].whenShareBegin;
	self.whenShareFailed = [ServiceShare sharedInstance].whenShareFailed;
	self.whenShareSucceed = [ServiceShare sharedInstance].whenShareSucceed;
	self.whenShareCancelled = [ServiceShare sharedInstance].whenShareCancelled;
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
}

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
	else if ( [ServiceShare sharedInstance].whenShareBegin )
	{
		[ServiceShare sharedInstance].whenShareBegin();
	}
}

- (void)notifyShareSucceed
{
	if ( self.whenShareSucceed )
	{
		self.whenShareSucceed();
	}
	else if ( [ServiceShare sharedInstance].whenShareSucceed )
	{
		[ServiceShare sharedInstance].whenShareSucceed();
	}

	[self clearPost];
}

- (void)notifyShareFailed
{
	if ( self.whenShareFailed )
	{
		self.whenShareFailed();
	}
	else if ( [ServiceShare sharedInstance].whenShareFailed )
	{
		[ServiceShare sharedInstance].whenShareFailed();
	}
	
	[self clearPost];
}

- (void)clearPost
{
	[self.post clear];
}

#pragma mark - WXApiDelegate

- (void)onReq:(QQBaseReq*)req
{
	
}

- (void)onResp:(QQBaseReq*)resp
{
	switch (resp.type)
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

@end
