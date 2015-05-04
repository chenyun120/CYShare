//
//  WXChat.m
//  CYShared
//
//  Created by Chenyun on 14/11/20.
//  Copyright (c) 2014年 geek-zoo. All rights reserved.
//

#define KAppKey @"243839795ab071506527afee1c32c9c2"
#define KAppId @"wx67389d6a38a4bf60"

#import "CYWXChatShared.h"

@implementation CYWXChatShared

DEF_SINGLETON( WXChatShared );

#pragma mark -

+ (void)load
{
	[[CYWXChatShared sharedInstance] wxChatInit];
}

- (void)wxChatInit
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sourceApplication:) name:@"sourceApplication" object:nil];

	self.whenShareBegin = [CYServiceShare sharedInstance].whenShareBegin;
	self.whenShareFailed = [CYServiceShare sharedInstance].whenShareFailed;
	self.whenShareSucceed = [CYServiceShare sharedInstance].whenShareSucceed;
	self.whenShareCancelled = [CYServiceShare sharedInstance].whenShareCancelled;
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

#pragma mark - 得到用户信息

- (void)getuserInfo
{
	if ( NO == [WXApi isWXAppInstalled] )
	{
		NSLog(@"请安装微信客户端");

		return;
	}

	SendAuthReq* req =[[SendAuthReq alloc ] init];
	req.scope = @"snsapi_userinfo";
	req.state = @"1024";

	// 第三方向微信终端发送一个SendAuthReq消息结构
	[WXApi sendReq:req];
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
		return;
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
		message.description = self.post.text;

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
	account.vendor = VENDOR_WEIXIN;
	account.auth_key = self.appKey;
	account.auth_token = self.accessToken;
	account.user_id = self.openid;
	account.expires = self.expiresIn;

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
	else if ( [resp isKindOfClass:[SendAuthResp class]] )
	{
		SendAuthResp *aresp = (SendAuthResp *)resp;

		if (aresp.errCode== 0)
		{
			self.weiXincode = aresp.code;

			if ( self.weiXincode )
			{
				[self getAccessToken];
			}
			else
			{
				[self notifyGetUserInfoFailed];
			}
		}
		else
		{
			NSLog(@"授权失败");
			[self notifyGetUserInfoFailed];
		}
	}
}

-(void)getAccessToken
{
	NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", self.appId, self.appKey, self.weiXincode];

	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

		NSURL *zoneUrl = [NSURL URLWithString:url];
		NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
		NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];

		dispatch_async(dispatch_get_main_queue(), ^{
			if ( data )
			{
				NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
				
				self.accessToken = [dic objectForKey:@"access_token"];
				self.openid = [dic objectForKey:@"openid"];
				self.expiresIn = [dic objectForKey:@"expires_in"];
				if ( self.accessToken )
				{
					[self notifyGetUserInfoSucceed];
				}
				else
				{
					[self notifyGetUserInfoFailed];
				}
			}
			else
			{
				[self notifyGetUserInfoFailed];
			}
		});
	});
}



@end
