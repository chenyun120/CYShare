//
//  ServiceShare.h
//  CYShared
//
//  Created by Chenyun on 14/11/20.
//  Copyright (c) 2014年 geek-zoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CYSharedModel.h"
#import "CYSharedPost.h"

typedef	void	(^ServiceBlock)( void );
typedef	void	(^ServiceBlockN)( id first, ... );

@interface CYServiceShare : NSObject

AS_SINGLETON( ServiceShare );

@property (nonatomic, strong) CYSharedPost * post;

@property (nonatomic, copy) NSString * appKey;
@property (nonatomic, copy) NSString * appId;
@property (nonatomic, copy) NSString * redirectUrl;

@property (nonatomic, copy) ServiceBlock					whenShareBegin;
@property (nonatomic, copy) ServiceBlock					whenShareSucceed;
@property (nonatomic, copy) ServiceBlock					whenShareFailed;
@property (nonatomic, copy) ServiceBlock					whenShareCancelled;

@property (nonatomic, copy) ServiceBlock					whenFollowBegin;
@property (nonatomic, copy) ServiceBlock					whenFollowSucceed;
@property (nonatomic, copy) ServiceBlock					whenFollowFailed;
@property (nonatomic, copy) ServiceBlock					whenFollowCancelled;

- (void)powerOn;

@end
