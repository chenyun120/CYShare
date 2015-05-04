//
//  ServiceShare.m
//  CYShared
//
//  Created by Chenyun on 14/11/20.
//  Copyright (c) 2014年 geek-zoo. All rights reserved.
//

#import "CYServiceShare.h"

#pragma mark - ACCOUNT;

@implementation ACCOUNT;
@end

@implementation CYServiceShare
DEF_SINGLETON( ServiceShare );

- (void)dealloc
{
	self.whenShareBegin		= nil;
	self.whenShareSucceed	= nil;
	self.whenShareFailed	= nil;
	self.whenShareCancelled	= nil;
	
	self.whenFollowBegin	 = nil;
	self.whenFollowSucceed	 = nil;
	self.whenFollowFailed	 = nil;
	self.whenFollowCancelled = nil;
	
	self.whenGetUserInfoBegin     = nil;
	self.whenGetUserInfoSucceed   = nil;
	self.whenGetUserInfoFailed	  = nil;
	self.whenGetUserInfoCancelled = nil;
}

- (void)powerOn
{
	
}

@end
