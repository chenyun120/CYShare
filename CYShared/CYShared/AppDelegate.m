//
//  AppDelegate.m
//  CYShared
//
//  Created by Chenyun on 14/11/19.
//  Copyright (c) 2014年 geek-zoo. All rights reserved.
//

#import "AppDelegate.h"
#import "SinaWeibo.h"
#import "WXChatShared.h"
#import "TencentOpenShared.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

	// 分享配置
	[self setShared];

	return YES;
}

- (void)setShared
{
	ALIAS( [SinaWeibo sharedInstance], singan );
	ALIAS( [WXChatShared sharedInstance], wxchat );
	ALIAS( [TencentOpenShared sharedInstance], tencent );

	// 新浪微博分享
	singan.appKey = @"2716041576";
	[singan powerOn];

	// 微信分享
	wxchat.appId = @"wx67389d6a38a4bf60";
	[wxchat powerOn];

	// QQ分享
	tencent.appId = @"101027797";
	[tencent powerOn];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
	if ( url || sourceApplication )
	{
		NSDictionary * params = @{@"url" : url,
								  @"source" : sourceApplication
								 };
		[[NSNotificationCenter defaultCenter] postNotificationName:@"sourceApplication" object:nil userInfo:params];
	}

	return YES;
}

@end
