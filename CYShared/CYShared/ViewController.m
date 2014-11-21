//
//  ViewController.m
//  CYShared
//
//  Created by Chenyun on 14/11/19.
//  Copyright (c) 2014年 geek-zoo. All rights reserved.
//

#import "ViewController.h"
#import "SinganWeibo.h"
#import "TencentOpenShared.h"
#import "WXChatShared.h"

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
	[SinganWeibo sharedInstance].post = [self tPost];

	[SinganWeibo sharedInstance].whenShareBegin = ^{
		NSLog(@"开始分享");
	};

	[SinganWeibo sharedInstance].whenShareSucceed = ^{
		// 分享成功
		NSLog(@"分享成功");
	};

	[SinganWeibo sharedInstance].whenShareFailed = ^{
		// 分享失败
		NSLog(@"分享失败");
	};

	[[SinganWeibo sharedInstance] sharedSin];
}

// QQ好友分享
- (IBAction)qqFriendsShared:(id)sender
{
	[TencentOpenShared sharedInstance].post = [self tPost];
	
	[TencentOpenShared sharedInstance].whenShareBegin =^{
		// 开始分享
		NSLog(@"开始分享");
	};
	
	[TencentOpenShared sharedInstance].whenShareSucceed = ^{
		// 分享成功
		NSLog(@"分享成功");
	};
	
	[TencentOpenShared sharedInstance].whenShareFailed = ^{
		// 分享失败
		NSLog(@"分享失败");
	};

	[[TencentOpenShared sharedInstance] shareQq];
}

// QQ空间分享
- (IBAction)qqSpaceShared:(id)sender
{
	[TencentOpenShared sharedInstance].post = [self tPost];

	[TencentOpenShared sharedInstance].whenShareBegin =^{
		// 开始分享
		NSLog(@"开始分享");
	};

	[TencentOpenShared sharedInstance].whenShareSucceed = ^{
		// 分享成功
		NSLog(@"分享成功");
	};

	[TencentOpenShared sharedInstance].whenShareFailed = ^{
		// 分享失败
		NSLog(@"分享失败");
	};

	[[TencentOpenShared sharedInstance] shareQzone];
}

// 微信好友分享
- (IBAction)weixinFriendsShared:(id)sender
{
	[WXChatShared sharedInstance].post = [self tPost];
	
	[WXChatShared sharedInstance].whenShareBegin =^{
		// 开始分享
		NSLog(@"开始分享");
	};
	
	[WXChatShared sharedInstance].whenShareSucceed = ^{
		// 分享成功
		NSLog(@"分享成功");
	};
	
	[WXChatShared sharedInstance].whenShareFailed = ^{
		// 分享失败
		NSLog(@"分享失败");
	};
	
	[[WXChatShared sharedInstance] shareFriend];
}

// 微信朋友圈分享
- (IBAction)weixinRingShared:(id)sender
{
	[WXChatShared sharedInstance].post = [self tPost];

	[WXChatShared sharedInstance].whenShareBegin =^{
		// 开始分享
		NSLog(@"开始分享");
	};

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

- (Service_Post *)tPost
{
	Service_Post * post = [[Service_Post alloc] init];
	post.title = @"title";
	post.text  = @"text";
	post.photo = [UIImage imageNamed:@"1.png"];
	post.thum  = [UIImage imageNamed:@"Icon.png"];
	post.url  = @"www.baidu.com";
	return post;
}

@end
































