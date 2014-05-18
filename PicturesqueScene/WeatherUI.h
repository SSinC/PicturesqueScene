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
@property(nonatomic) NSString*     city;
@property(nonatomic) NSString*     cityNumber;
@property(nonatomic,readwrite) weatherType   weather;
@property(nonatomic,readwrite) NSInteger    mainTemperature;
@property(nonatomic,readwrite) NSInteger    upTemperature;
@property(nonatomic,readwrite) NSInteger    downTemperature;
@property(nonatomic,readwrite) NSInteger    humidity;
@property(nonatomic,readwrite) NSInteger    wind;

@property(nonatomic,readonly) UIImage*      weatherImage;

-(id)initByItem:(weatherDataItem*)item;
-(id)initWithCity:(NSString*)cityname weather:( weatherType)weather mainTemp:(NSInteger)temp upTemp:(NSInteger)upTemp downTemp:(NSInteger)downTemp humidity:(NSInteger)humidity wind:(NSInteger)wind ;

@end

@interface weatherInfoDetailView : UIView
{
    UILabel*                        _cityLabel;
    UIImageView*                    _weatherImageV;
    UILabel*                        _contentOfmainTempView;
    FBShimmeringView*               _mainTempView;
    UILabel*                        _contentOfmainCView;
    FBShimmeringView*               _mainCView;
    
    UIImageView*                    _line;
    
    UIImageView*                    _upTempIcon;
    UIImageView*                    _downTempIcon;
    UIImageView*                    _perecitationIcon;
    UIImageView*                    _windPowerIcon;
    
    UILabel*                        _upTmpLabel;
    UILabel*                        _downTmpLabel;
    UILabel*                        _humidityLabel ;
    UILabel*                        _windLabel;
}
@property (strong)weatherDataItem* dataItem;
-(id)initWithFrame:(CGRect)frame withDataItem:(weatherDataItem*)item;

@end
