//
//  Service_Post.h
//  CYShared
//
//  Created by Chenyun on 14/11/19.
//  Copyright (c) 2014年 geek-zoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Service_Post : NSObject
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * text;
@property (nonatomic, strong) id		 photo;
@property (nonatomic, strong) id		 thum;
@property (nonatomic, strong) NSString * url;

- (void)copyFrom:(Service_Post *)post;
- (void)clear;

@end
