//
//  ServiceShare.h
//  CYShared
//
//  Created by Chenyun on 14/11/20.
//  Copyright (c) 2014年 geek-zoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "sharedModel.h"
#import "Shared_Post.h"

typedef	void	(^ServiceBlock)( void );
typedef	void	(^ServiceBlockN)( id first, ... );

@interface ServiceShare : NSObject

AS_SINGLETON( ServiceShare );

@property (nonatomic, strong) Shared_Post * post;

@property (nonatomic, copy) NSString * appKey;
@property (nonatomic, copy) NSString * appId;
@property (nonatomic, copy) NSString * redirectUrl;

@property (nonatomic, copy) ServiceBlock					whenShareBegin;
@property (nonatomic, copy) ServiceBlock					whenShareSucceed;
@property (nonatomic, copy) ServiceBlock					whenShareFailed;
@property (nonatomic, copy) ServiceBlock					whenShareCancelled;

- (void)powerOn;

@end
