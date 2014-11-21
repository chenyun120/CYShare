//
//  Service_Post.m
//  CYShared
//
//  Created by Chenyun on 14/11/19.
//  Copyright (c) 2014年 geek-zoo. All rights reserved.
//

#import "Shared_Post.h"

@implementation Shared_Post

- (void)copyFrom:(Shared_Post *)post
{
	if ( post.title )
	{
		self.title = post.title;
	}
	
	if ( post.text )
	{
		self.text = post.text;
	}
	
	if ( post.photo )
	{
		self.photo = post.photo;
	}
	
	if ( post.thum )
	{
		self.thum = post.thum;
	}
	
	if ( post.url )
	{
		self.url = post.url;
	}
}

- (void)clear
{
	self.title = nil;
	self.text = nil;
	self.photo = nil;
	self.thum = nil;
	self.url = nil;
}
@end
