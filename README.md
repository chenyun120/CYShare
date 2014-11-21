<pre>
 第一步：
 
 在AppDelegate.m中：

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
	// 发送通知
	if ( url || sourceApplication )
	{
		NSDictionary * params = @{@"url" : url,
								  @"source" : sourceApplication
								 };
		[[NSNotificationCenter defaultCenter] postNotificationName:@"sourceApplication" object:nil userInfo:params];
	}

	return YES;
}

第二步:

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


</pre>
