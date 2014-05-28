//
//  weatherData.h
//  PicturesqueScene
//
//  Created by Stan on 14-4-17.
//  Copyright (c) 2014年 Stan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface weatherData : NSObject

@end

@interface weatherData1 : NSObject

@property NSString *gif1;
@property NSString *city;
@property NSString *cityCode;
@property NSString *upTemp;
@property NSString *mainWeather;
@property NSString *gif2;
@property NSString *time;
@property NSString *lowTemp;

@end


@interface weatherData2 : NSObject

@property NSString *city;
@property NSString *cityCode;
@property NSString *humidity;
@property NSString *windSpeed;
@property NSString *WSE;
@property NSString *time;
@property NSString *windDirection;
@property NSString *isRadar;
@property NSString *radar;
@property NSString *currentTemp;


@end



typedef NS_ENUM(NSUInteger, weatherType) {
    
    Sunny = 0,
    Cloudy,
    Rainy,
    Snowy,
    Foggy,
};
