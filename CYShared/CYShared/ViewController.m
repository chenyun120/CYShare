//
//  ViewController.m
//  CYShared
//
//  Created by Chenyun on 14/11/19.
//  Copyright (c) 2014年 geek-zoo. All rights reserved.
//

#import "ViewController.h"
#import "SinaWeibo.h"
#import "WXChatShared.h"
#import "TencentOpenShared.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
}

// 新浪微博分享
- (IBAction)sharedSinAction:(id)sender
{
	ALIAS( [SinaWeibo sharedInstance], singan );
	
	singan.post = [self tPost];

	singan.whenShareSucceed = ^{
		// 分享成功
		NSLog(@"分享成功");
	};

	singan.whenShareFailed = ^{
		// 分享失败
		NSLog(@"分享失败");
	};

	[singan sharedSin];
}

// QQ好友分享
- (IBAction)qqFriendsShared:(id)sender
{
	ALIAS( [TencentOpenShared sharedInstance], tencent );

	tencent.post = [self tPost];
	
	tencent.whenShareSucceed = ^{
		// 分享成功
		NSLog(@"分享成功");
	};
	
	tencent.whenShareFailed = ^{
		// 分享失败
		NSLog(@"分享失败");
	};

	[tencent shareQq];
}

// QQ空间分享
- (IBAction)qqSpaceShared:(id)sender
{
	ALIAS( [TencentOpenShared sharedInstance], tencent );

	tencent.post = [self tPost];

	tencent.whenShareSucceed = ^{
		// 分享成功
		NSLog(@"分享成功");
	};

	tencent.whenShareFailed = ^{
		// 分享失败
		NSLog(@"分享失败");
	};

	[tencent shareQzone];
}

// 微信好友分享
- (IBAction)weixinFriendsShared:(id)sender
{
	ALIAS( [WXChatShared sharedInstance], wxchat );

	wxchat.post = [self tPost];

	wxchat.whenShareSucceed = ^{
		// 分享成功
		NSLog(@"分享成功");
	};
	
	wxchat.whenShareFailed = ^{
		// 分享失败
		NSLog(@"分享失败");
	};
	
	[wxchat shareFriend];
}

// 微信朋友圈分享
- (IBAction)weixinRingShared:(id)sender
{
	[WXChatShared sharedInstance].post = [self tPost];

	[WXChatShared sharedInstance].whenShareSucceed = ^{
		// 分享成功
		NSLog(@"分享成功");
	};

	[WXChatShared sharedInstance].whenShareFailed = ^{
		// 分享失败
		NSLog(@"分享失败");
	};

	[[WXChatShared sharedInstance] shareTimeline];
}

- (Shared_Post *)tPost
{
	Shared_Post * post = [[Shared_Post alloc] init];
	post.title = @"title";
	post.text  = @"text";
	post.photo = [UIImage imageNamed:@"1.png"];
	post.thum  = [UIImage imageNamed:@"Icon.png"];
	post.url  = @"www.baidu.com";

	return post;
}

@end
