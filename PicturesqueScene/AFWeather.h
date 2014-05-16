//
//  AFWeather.h
//  PicturesqueScene
//
//  Created by stan on 5/12/14.
//  Copyright (c) 2014 stan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AFWeatherAPI) {
    AFWeatherAPIWorldWeatherOnline = 1,
    AFWeatherAPIWeatherUnderground,
    AFWeatherAPIForecast,
    AFWeatherAPIOpenWeatherMap,
    AFWeatherAPIAccuWeather,
    AFWeatherAPITest,
    STANWeatherTest,
};

typedef NS_ENUM(NSInteger, AFWeatherLocationType) {
    AFWeatherLocationTypeName,
    AFWeatherLocationTypeLatLon,
    AFWeatherLocationTypeCurrent
};

@interface AFWeather : NSObject

typedef void (^completionBlock)(NSDictionary *response, NSError *error);

+(instancetype)sharedClient;

-(void)configureClientWithService:(AFWeatherAPI)service withAPIKey:(NSString *)apiKey;

-(void)fetchForecastOfLocationWithName:(NSString *)locationName andCompletionBlock:(completionBlock)completion;
-(void)fetchForecastOfLocationWithLatitude:(NSString *)lat andLogitude:(NSString *)lon andCompletionBlock:(completionBlock)completion;

@end

@interface NSString (AFURLEncoding)

-(NSString *)encodeForURLWithEncoding:(NSStringEncoding)encoding;

@end
