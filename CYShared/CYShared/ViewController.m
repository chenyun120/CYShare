//
//  ViewController.m
//  CYShared
//
//  Created by Chenyun on 14/11/19.
//  Copyright (c) 2014年 geek-zoo. All rights reserved.
//

#import "ViewController.h"
#import "CYSinaWeibo.h"
#import "CYWXChatShared.h"
#import "CYTencentOpenShared.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
}

- (IBAction)followSinAction:(id)sender
{
	ALIAS( [CYSinaWeibo sharedInstance], singan );

	singan.whenFollowBegin = ^{
		// 开始关注
	};

	singan.whenFollowSucceed = ^{
		// 关注成功
	};

	singan.whenFollowFailed = ^{
		// 关注失败
	};

	[singan followWithName:@"Vogue服饰与美容"];
}

// 新浪微博分享
- (IBAction)sharedSinAction:(id)sender
{
	ALIAS( [CYSinaWeibo sharedInstance], singan );

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
	ALIAS( [CYTencentOpenShared sharedInstance], tencent );

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
	ALIAS( [CYTencentOpenShared sharedInstance], tencent );

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
	ALIAS( [CYWXChatShared sharedInstance], wxchat );

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
	[CYWXChatShared sharedInstance].post = [self tPost];

	[CYWXChatShared sharedInstance].whenShareSucceed = ^{
		// 分享成功
		NSLog(@"分享成功");
	};

	[CYWXChatShared sharedInstance].whenShareFailed = ^{
		// 分享失败
		NSLog(@"分享失败");
	};

	[[CYWXChatShared sharedInstance] shareTimeline];
}

- (CYSharedPost *)tPost
{
	CYSharedPost * post = [[CYSharedPost alloc] init];
	post.title = @"title";
	post.text  = @"text";
	post.photo = [UIImage imageNamed:@"1.png"];
	post.thum  = [UIImage imageNamed:@"Icon.png"];
	post.url  = @"www.baidu.com";

	return post;
}

#pragma mark - Login

- (IBAction)sinLogin:(id)sender
{
	ALIAS( [CYSinaWeibo sharedInstance], singan );

	singan.whenGetUserInfoSucceed = ^(id data){
		NSLog(@"信息获取成功");
//		ACCOUNT * account = (ACCOUNT *)data;
	};

	singan.whenGetUserInfoFailed = ^{
		NSLog(@"信息获取失败");
	};

	[singan getUserInfo];
}

- (IBAction)qqLogin:(id)sender
{
	ALIAS( [CYTencentOpenShared sharedInstance], tencent );

	tencent.whenGetUserInfoSucceed = ^(id data){
		NSLog(@"信息获取成功");
//		ACCOUNT * account = (ACCOUNT *)data;
	};

	tencent.whenGetUserInfoFailed = ^{
		NSLog(@"信息获取失败");
	};

	[tencent getUserInfo];
}

- (IBAction)weixinLogin:(id)sender
{
	ALIAS( [CYWXChatShared sharedInstance], wxchat );

	wxchat.whenGetUserInfoSucceed = ^(id data){
		NSLog(@"信息获取成功");
//		ACCOUNT * account = (ACCOUNT *)data;
	};

	wxchat.whenGetUserInfoFailed = ^{
		NSLog(@"信息获取失败");
	};

	[wxchat getuserInfo];
}


@end