//
//  WeatherUI.h
//  PicturesqueScene
//
//  Created by Sara on 5/16/14.
//  Copyright (c) 2014 Stan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBShimmeringView.h"

typedef NS_ENUM(NSUInteger, weatherType) {
    Sunny = 0,
    Cloudy,
    Rainy,
    Snowy,
    Foggy,
};
@interface weatherDataItem : NSObject
//{
//    NSString*   city;
//    NSString*   cityNumber;
//    NSString*   weather;//晴天 雨天 雪天
//    NSInteger   mainTemperature;
//    NSInteger   upTemperature;
//    NSInteger   downTemperature;
//    NSInteger   humidity;
//    NSInteger   wind;
//}
@property(nonatomic,copy) NSString*     city;
@property(nonatomic,copy) NSString*     cityNumber;
@property(nonatomic,readwrite) weatherType   weather;
@property(nonatomic,readwrite) NSInteger    mainTemperature;
@property(nonatomic,readwrite) NSInteger    upTemperature;
@property(nonatomic,readwrite) NSInteger    downTemperature;
@property(nonatomic,readwrite) NSInteger    humidity;
@property(nonatomic,readwrite) NSInteger    wind;

@property(nonatomic,readonly) UIImage*      weatherImage;

@end

@interface weatherInfoDetailView : UIView
{
    UILabel*                        cityLabel;
    UIImageView*                    weatherImageV;
    FBShimmeringView*               mainTempView;
    FBShimmeringView*               mainCView;
    
    UIImageView*                    line;
    
    UIImageView*                    upTempIcon;
    UIImageView*                    downTempIcon;
    UIImageView*                    perecitationIcon;
    UIImageView*                    windPowerIcon;
    
    UILabel*                        upTmpLabel;
    UILabel*                        downTmpLabel;
    UILabel*                        humidityLabel ;
    UILabel*                        windLabel;
    
}
@property(nonatomic,retain)weatherDataItem* dataItem;
@end
