//
//  singanWeibo.m
//  CYShared
//
//  Created by Chenyun on 14/11/19.
//  Copyright (c) 2014年 geek-zoo. All rights reserved.
//

#define KAppKey @"735351141"
#define KRedirectURI @"https://api.weibo.com/oauth2/default.html"

#import "CYSinaWeibo.h"

@implementation CYSinaWeibo

DEF_SINGLETON(SinaWeibo)

#pragma mark -

+ (void)load
{
	[[CYSinaWeibo sharedInstance] singanWeiboInit];
}

- (void)singanWeiboInit
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sourceApplication:) name:@"sourceApplication" object:nil];

	self.whenShareBegin = [CYServiceShare sharedInstance].whenShareBegin;
	self.whenShareFailed = [CYServiceShare sharedInstance].whenShareFailed;
	self.whenShareSucceed = [CYServiceShare sharedInstance].whenShareSucceed;
	self.whenShareCancelled = [CYServiceShare sharedInstance].whenShareCancelled;
}

- (void)powerOn
{
	[WeiboSDK enableDebugMode:YES];
	[WeiboSDK registerApp:self.appKey];

	[self loadCache];
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
		NSLog(@" 请安装新浪微博客户端 ");
	}
}

+ (BOOL)isWeiboAppInstalled
{
	return [WeiboSDK isWeiboAppInstalled];
}

#pragma mark - 

- (BOOL)isAuthorized
{
	return self.isExpired && self.accessToken && self.uid;
}

- (BOOL)isExpired
{
	if ( self.expiresIn )
	{
	}

	return YES;
}

#pragma mark - 关注账号

- (void)followWithName:(NSString *)name
{
	if ( [self isAuthorized] )
	{
		[self followName:name];
	}
	else
	{
		WBAuthorizeRequest *request = [WBAuthorizeRequest request];
		request.redirectURI = self.redirectUrl;
		request.scope = @"all";
		request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
							 @"Other_Info_1": [NSNumber numberWithInt:123],
							 @"Other_Info_2": @[@"obj1", @"obj2"],
							 @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
		[WeiboSDK sendRequest:request];
	}
}

- (void)followName:(NSString *)name
{
	[self notifyFollowBegin];

	NSDictionary * dict = @{@"screen_name":name,
							@"access_token":_accessToken};

	[WBHttpRequest requestWithURL:@"https://api.weibo.com/2/friendships/create.json"
					   httpMethod:@"POST"
						   params:dict
						 delegate:self
						  withTag:nil];
}

#pragma mark - 得到用户信息

- (void)getUserInfo
{
	if ( [WeiboSDK isWeiboAppInstalled] )
	{
//		if ( [self isAuthorized] )
//		{
//			[self notifyGetUserInfoSucceed];
//		}
//		else
//		{
			WBAuthorizeRequest *request = [WBAuthorizeRequest request];
			request.redirectURI = self.redirectUrl;
			request.scope = @"all";
			request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
								 @"Other_Info_1": [NSNumber numberWithInt:123],
								 @"Other_Info_2": @[@"obj1", @"obj2"],
								 @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
			
			[WeiboSDK sendRequest:request];
//		}
	}
	else
	{
		NSLog(@"请安装新浪微博客户端");
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
		text = [NSString stringWithFormat:@"%@\n%@", text, self.post.text];
	}

	if ( self.post.url && self.post.url.length )
	{
		if ( ![self.post.url hasPrefix:@"http:"] )
		{
			text = [NSString stringWithFormat:@"%@ http://%@", text, self.post.url];
		}
		else
		{
			text = [NSString stringWithFormat:@"%@ %@", text, self.post.url];
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
//		webpage.objectID = @"weiboShareds";
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
	else if ( [CYServiceShare sharedInstance].whenShareBegin )
	{
		[CYServiceShare sharedInstance].whenShareBegin();
	}
}

- (void)notifyShareSucceed
{
	[self clearPost];

	if ( self.whenShareSucceed )
	{
		self.whenShareSucceed();
	}
	else if ( [CYServiceShare sharedInstance].whenShareSucceed )
	{
		[CYServiceShare sharedInstance].whenShareSucceed();
	}
}

- (void)notifyShareFailed
{
	[self clearPost];

	if ( self.whenShareFailed )
	{
		self.whenShareFailed();
	}
	else if ( [CYServiceShare sharedInstance].whenShareFailed )
	{
		[CYServiceShare sharedInstance].whenShareFailed();
	}
}

#pragma mark -

- (void)notifyFollowBegin
{
	if ( self.whenFollowBegin )
	{
		self.whenFollowBegin();
	}
	else if ( [CYServiceShare sharedInstance].whenFollowBegin )
	{
		[CYServiceShare sharedInstance].whenFollowBegin();
	}
}

- (void)notifyFollowSucceed
{	
	if ( self.whenFollowSucceed )
	{
		self.whenFollowSucceed();
	}
	else if ( [CYServiceShare sharedInstance].whenFollowSucceed )
	{
		[CYServiceShare sharedInstance].whenFollowSucceed();
	}
}

- (void)notifyFollowFailed
{
	if ( self.whenFollowFailed )
	{
		self.whenFollowFailed();
	}
	else if ( [CYServiceShare sharedInstance].whenFollowFailed )
	{
		[CYServiceShare sharedInstance].whenFollowFailed();
	}
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
	account.vendor = VENDOR_WEIBO;
	account.auth_key = self.appKey;
	account.auth_token = self.accessToken;
	account.user_id = self.uid;
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
			self.uid = response.userInfo[@"uid"];
			self.accessToken = response.userInfo[@"access_token"];
			//		NSString * date = response.userInfo[@"expires_in"];
			self.expiresIn = response.userInfo[@"expires_in"];//[self asNSString:[NSDate dateWithTimeIntervalSinceNow:date.integerValue]];
			self.remindIn = response.userInfo[@"remind_in"];
			
			[self saveCache];
			
			// 获取信息成功
			[self notifyGetUserInfoSucceed];
		}
		else
		{
			// 获取信息失败
			[self notifyGetUserInfoFailed];
		}
	}
}

#pragma mark -

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
	NSDictionary * resultDic = [self dictionaryWithJsonString:result];

	NSString * error = resultDic[@"error"];

	if ( error && error.length )
	{
		UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"关注提示" message:error delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
		[alertView show];
		[self notifyFollowFailed];
	}
	else
	{
		UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"关注提示" message:@"成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
		[alertView show];
		[self notifyFollowSucceed];
	}
}

- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error;
{
	NSLog(@"请求失败");
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
	if (jsonString == nil) {
		return nil;
	}
	
	NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
	NSError *err;
	NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
														options:NSJSONReadingMutableContainers
														  error:&err];
	if(err) {
		NSLog(@"json解析失败：%@", err);
		return nil;
	}
	return dic;
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
		case WeiboSDKResponseStatusCodeUnsupport:
		{
			NSLog(@"不支持的请求");
		}
			break;
		default:
			break;
	}
}

- (NSDate *)asNSDate:(NSString *)date
{
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	NSLocale *enLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
	[format setLocale:enLocale];

	[format setDateFormat:@"yyyy-HH-dd HH:mm:ss"];
	NSDate *dateTime = [format dateFromString:date];

	return dateTime;
}

- (NSString *)asNSString:(NSDate *)date
{
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	NSLocale *enLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
	[format setLocale:enLocale];

	[format setDateFormat:@"yyyy-HH-dd HH:mm:ss"];
	NSString * dateString = [format stringFromDate:date];
	return dateString;
}

#pragma mark -

- (void)saveCache
{
	[[NSUserDefaults standardUserDefaults] setObject:self.accessToken forKey:@"accessToken"];
	[[NSUserDefaults standardUserDefaults] synchronize];

	[[NSUserDefaults standardUserDefaults] setObject:self.expiresIn forKey:@"expiresIn"];
	[[NSUserDefaults standardUserDefaults] synchronize];

	[[NSUserDefaults standardUserDefaults] setObject:self.remindIn forKey:@"remindIn"];
	[[NSUserDefaults standardUserDefaults] synchronize];

	[[NSUserDefaults standardUserDefaults] setObject:self.uid forKey:@"uid"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadCache
{
	self.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
	self.expiresIn   = [[NSUserDefaults standardUserDefaults] objectForKey:@"expiresIn"];
	self.remindIn    = [[NSUserDefaults standardUserDefaults] objectForKey:@"remindIn"];
	self.uid		 = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
