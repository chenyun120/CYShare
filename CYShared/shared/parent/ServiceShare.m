//
//  ServiceShare.m
//  CYShared
//
//  Created by Chenyun on 14/11/20.
//  Copyright (c) 2014年 geek-zoo. All rights reserved.
//

#import "ServiceShare.h"

@implementation ServiceShare
DEF_SINGLETON( ServiceShare );

- (void)dealloc
{
	self.whenShareBegin		= nil;
	self.whenShareSucceed	= nil;
	self.whenShareFailed	= nil;
	self.whenShareCancelled	= nil;
}

@end
