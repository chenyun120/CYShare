//
//  WXChat.m
//  CYShared
//
//  Created by Chenyun on 14/11/20.
//  Copyright (c) 2014年 geek-zoo. All rights reserved.
//

#define KAppKey @"243839795ab071506527afee1c32c9c2"
#define KAppId @"wx67389d6a38a4bf60"

#import "WXChatShared.h"

@implementation WXChatShared

DEF_SINGLETON( WXChatShared );

#pragma mark -

+ (void)load
{
	[[WXChatShared sharedInstance] wxChatInit];
}

- (void)wxChatInit
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sourceApplication:) name:@"sourceApplication" object:nil];

	self.whenShareBegin = [ServiceShare sharedInstance].whenShareBegin;
	self.whenShareFailed = [ServiceShare sharedInstance].whenShareFailed;
	self.whenShareSucceed = [ServiceShare sharedInstance].whenShareSucceed;
	self.whenShareCancelled = [ServiceShare sharedInstance].whenShareCancelled;
}

- (void)powerOn
{
	[WXApi registerApp:self.appId];
}

- (void)sourceApplication:(NSNotification *)notifi
{
	NSDictionary * params = notifi.userInfo;
	
	
	if ( params )
	{
		NSURL * url			= [params objectForKey:@"url"];
		NSString * source	= [params objectForKey:@"source"];

		if ( [[url absoluteString] hasSuffix:@"wechat"] || [source hasPrefix:@"com.tencent.xin"] )
		{
			BOOL succeed = [WXApi handleOpenURL:url delegate:self];
			if ( NO == succeed )
			{

			}
		}
		else
		{
		}
	}
	else
	{
	}
}

#pragma mark - 

- (void)shareFriend
{
	[self share:WXSceneSession];
}

- (void)shareTimeline
{
	[self share:WXSceneTimeline];
}

- (void)share:(enum WXScene)scene
{
	if ( NO == [WXApi isWXAppInstalled] )
	{
		NSLog(@"请安装微信");
	}

	if ( self.post.photo || self.post.thum || self.post.url )
	{
		SendMessageToWXReq *	req = [[SendMessageToWXReq alloc] init];
		WXMediaMessage *		message = [WXMediaMessage message];

		if ( self.post.thum )
		{
			NSData * thumbData = nil;

			if ( [self.post.thum isKindOfClass:[UIImage class]] )
			{
				thumbData = UIImagePNGRepresentation(self.post.thum);
			}
			else if ( [self.post.thum isKindOfClass:[NSData class]] )
			{
				thumbData = (NSData *)self.post.thum;
			}

			[message setThumbData:thumbData];
		}
		
		if ( self.post.url )
		{
			WXWebpageObject * webObject = [WXWebpageObject object];
			
			webObject.webpageUrl = self.post.url;
			
			message.mediaObject = webObject;
		}
		
		message.title = self.post.title && self.post.title.length ? self.post.title : self.post.text;
		
		req.message = message;
		req.bText = NO;
		req.scene = scene;
		
		BOOL succeed = [WXApi sendReq:req];
		
		if ( succeed )
		{
			[self notifyShareBegin];
		}
		else
		{
			[self notifyShareFailed];
		}
	}
	else if ( self.post.text )
	{
		SendMessageToWXReq * req = [[SendMessageToWXReq alloc] init];
		
		if ( self.post.title && self.post.title.length )
		{
			req.text = self.post.title;
		}
		
		if ( self.post.text && self.post.text.length )
		{
			req.text = self.post.text;
		}
		
		req.bText = YES;
		req.scene = scene;
		
		BOOL succeed = [WXApi sendReq:req];
		if ( succeed )
		{
			[self notifyShareBegin];
		}
		else
		{
			[self notifyShareFailed];
		}
	}
	else
	{
		[self notifyShareFailed];
	}

}


- (void)clearPost
{
	[self.post clear];
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

#pragma mark - WXApiDelegate

- (void)onReq:(BaseReq*)req
{
	
}

- (void)onResp:(BaseResp*)resp
{
	if ( [resp isKindOfClass:[SendMessageToWXResp class]] )
	{
		if ( WXSuccess == resp.errCode )
		{
			[self notifyShareSucceed];
		}
		else if ( WXErrCodeUserCancel == resp.errCode )
		{
			[self notifyShareFailed];
		}
		else
		{
			[self notifyShareFailed];
		}
	}
}

@end
