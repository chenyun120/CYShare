//
//  singanWeibo.m
//  CYShared
//
//  Created by Chenyun on 14/11/19.
//  Copyright (c) 2014年 geek-zoo. All rights reserved.
//

#define KAppKey @"2716041576"
#define KRedirectURI @"https://api.weibo.com/oauth2/default.html"

#import "SinaWeibo.h"

@implementation SinaWeibo
DEF_SINGLETON(SinaWeibo)

#pragma mark -

+ (void)load
{
	[[SinaWeibo sharedInstance] singanWeiboInit];
}

- (void)singanWeiboInit
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sourceApplication:) name:@"sourceApplication" object:nil];
	
	self.whenShareBegin = [ServiceShare sharedInstance].whenShareBegin;
	self.whenShareFailed = [ServiceShare sharedInstance].whenShareFailed;
	self.whenShareSucceed = [ServiceShare sharedInstance].whenShareSucceed;
	self.whenShareCancelled = [ServiceShare sharedInstance].whenShareCancelled;
}

- (void)powerOn
{
	[WeiboSDK enableDebugMode:YES];
	[WeiboSDK registerApp:self.appKey];
}

- (void)sourceApplication:(NSNotification *)notifi
{
	NSDictionary * params = notifi.userInfo;
	[WeiboSDK handleOpenURL:params[@"url"] delegate:self];
}

#pragma mark -

- (void)sharedSin
{
	if ( [WeiboSDK isWeiboAppInstalled] )
	{
		WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare]];
		
		request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
							 @"Other_Info_1": [NSNumber numberWithInt:123],
							 @"Other_Info_2": @[@"obj1", @"obj2"],
							 @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
		[WeiboSDK sendRequest:request];

		return;
	}
	else
	{
		NSLog(@"未安装客户端");
//		[self notifyShareBegin];
	}
}

- (WBMessageObject *)messageToShare
{
	WBMessageObject *message = [WBMessageObject message];
	
	NSString * text = @"";
	
	if ( self.post.title && self.post.title.length )
	{
		text = self.post.title;
	}

	if ( self.post.text && self.post.text.length )
	{
		text = [NSString stringWithFormat:@"%@\n%@",text,self.post.text];
	}

	if ( self.post.url && self.post.url.length )
	{
		if ( ![self.post.url hasPrefix:@"http:"] )
		{
			text = [NSString stringWithFormat:@"%@ http://%@",text,self.post.url];
		}
		else
		{
			text = [NSString stringWithFormat:@"%@ %@",text,self.post.url];
		}
	}

	if ( text.length > 140 )
	{
		text = [text substringToIndex:140];
	}

	if ( ![self.post.photo isKindOfClass:[NSString class]] )
	{
		WBImageObject * imageObject = [WBImageObject object];

		imageObject.imageData = self.post.photo;

		if ( [self.post.photo isKindOfClass:[UIImage class]] )
		{
			imageObject.imageData = UIImagePNGRepresentation( self.post.photo );
		}
		else if ( [self.post.photo isKindOfClass:[NSData class]] )
		{
			imageObject.imageData = self.post.photo;
		}

		// 分享图片
		message.imageObject = imageObject;
	}
	
	// 分享文字
	message.text = text;

//	if ( 1 )
//	{
//		WBWebpageObject * webpage = [WBWebpageObject object];
//		webpage.objectID = @"identifier1";
//		webpage.title = self.post.title;
//		webpage.description = self.post.text;
//		if ( [self.post.thum isKindOfClass:[UIImage class]] )
//		{
//			webpage.thumbnailData = UIImagePNGRepresentation(self.post.thum);
//		}
//		webpage.webpageUrl = self.post.url;
//		message.mediaObject = webpage;
//	}

	return message;
}

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
	[self clearPost];

	if ( self.whenShareSucceed )
	{
		self.whenShareSucceed();
	}
	else if ( [ServiceShare sharedInstance].whenShareSucceed )
	{
		[ServiceShare sharedInstance].whenShareSucceed();
	}
}

- (void)notifyShareFailed
{
	[self clearPost];
	
	if ( self.whenShareFailed )
	{
		self.whenShareFailed();
	}
	else if ( [ServiceShare sharedInstance].whenShareFailed )
	{
		[ServiceShare sharedInstance].whenShareFailed();
	}
}

#pragma mark - 

- (void)clearPost
{
	[self.post clear];
}

#pragma mark - weiboDelegate

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
	if ([request isKindOfClass:WBProvideMessageForWeiboRequest.class])
	{
	}
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
	if ( [response isKindOfClass:WBSendMessageToWeiboResponse.class] )
	{
		if ( WeiboSDKResponseStatusCodeSuccess == response.statusCode )
		{
			[self notifyShareSucceed];
		}
		else
		{
			[self failedDescWithresponse:response];
			[self notifyShareFailed];
		}
	}
	else if ( [response isKindOfClass:WBAuthorizeResponse.class] )
	{
		if ( WeiboSDKResponseStatusCodeSuccess == response.statusCode )
		{
			[self notifyShareSucceed];
		}
		else
		{
			[self failedDescWithresponse:response];
			[self notifyShareFailed];
		}
	}
}

#pragma mark - 

- (void)failedDescWithresponse:(WBBaseResponse *)response
{
	switch (response.statusCode) {
		case WeiboSDKResponseStatusCodeUserCancel:
		{
			NSLog(@"用户取消");
		}
			break;
		case WeiboSDKResponseStatusCodeSentFail:
		{
			NSLog(@"发送失败");
		}
			break;
		case WeiboSDKResponseStatusCodeAuthDeny:
		{
			NSLog(@"授权失败");
		}
			break;
		case WeiboSDKResponseStatusCodeUserCancelInstall:
		{
			NSLog(@"用户取消安装微博客户端");
		}
			break;
		case WeiboSDKResponseStatusCodeShareInSDKFailed:
		{
			NSLog(@"分享失败:\n%@",response.userInfo);
		}
			break;
		case WeiboSDKResponseStatusCodeUnsupport:
		{
			NSLog(@"不支持的请求");
		}
			break;
		default:
			break;
	}
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
