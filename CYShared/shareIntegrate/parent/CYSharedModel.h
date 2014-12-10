//
//  sharedModel.h
//  CYShared
//
//  Created by Chenyun on 14/11/21.
//  Copyright (c) 2014年 geek-zoo. All rights reserved.
//

#undef	AS_SINGLETON
#define AS_SINGLETON( ... ) \
- (instancetype)sharedInstance; \
+ (instancetype)sharedInstance;

#undef	DEF_SINGLETON
#define DEF_SINGLETON( ... ) \
- (instancetype)sharedInstance \
{ \
return [[self class] sharedInstance]; \
} \
+ (instancetype)sharedInstance \
{ \
static dispatch_once_t once; \
static id __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[self alloc] init]; } ); \
return __singleton__; \
}

#undef	ALIAS
#define	ALIAS( __a, __b ) \
__typeof__(__a) __b = __a;
