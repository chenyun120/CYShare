/*

// AppKey和url等设置在.m文件中  例如新浪微博：SinganWeibo.m中：

// #define KAppKey @"2716041576"

// #define KRedirectURI @"https://api.weibo.com/oauth2/default.html"


// 导入后加入通知
// - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
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


// 新浪微博分享
// - (IBAction)sharedSinAction:(id)sender
//{
//	[SinganWeibo sharedInstance].post = [self tPost];
//
//	[SinganWeibo sharedInstance].whenShareBegin = ^{
//		NSLog(@"开始分享");
//	};

//	[SinganWeibo sharedInstance].whenShareSucceed = ^{
//		// 分享成功
//		NSLog(@"分享成功");
//	};
//
//	[SinganWeibo sharedInstance].whenShareFailed = ^{
//		// 分享失败
//		NSLog(@"分享失败");
//	};
//
//	[[SinganWeibo sharedInstance] sharedSin];
//}




*/
