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
- (BOOL)gotWeatherInfo:(NSDictionary *)weather;
@end


@interface networkWeather : NSObject

@property (nonatomic, weak) id <weatherDelegate> delegate;

+ (instancetype)sharedInstance;

/****************************
 Location based ,obtain weather info automaticlly.
 ****************************/
- (void)obtainWeaterInfoLocationBased;

- (BOOL)getWeather:(NSString *)URLString;
@end
