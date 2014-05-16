//
//  networkWeater.h
//  PicturesqueScene
//
//  Created by Stan on 14-4-16.
//  Copyright (c) 2014年 Stan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol weatherDelegate <NSObject>
@required
- (void)gotWeatherInfo:(NSString *)weather;
@end


@interface networkWeather : NSObject
@property (nonatomic, weak) id <weatherDelegate> delegate;

+ (instancetype)sharedInstance;
+ (instancetype)alloc;
+ (instancetype)new;

/****************************
 Location based ,obtain weather info automaticlly.
 ****************************/
- (void)obtainWeaterInfoLocationBased;

- (NSString *)getWeather:(NSString *)URLString;
@end
