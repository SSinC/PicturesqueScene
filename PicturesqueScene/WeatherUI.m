//
//  WeatherUI.m
//  PicturesqueScene
//
//  Created by Sara on 5/16/14.
//  Copyright (c) 2014 Stan. All rights reserved.
//

#import "WeatherUI.h"

@implementation weatherDataItem
//@synthesize city,cityNumber,mainTemperature,upTemperature,downTemperature,humidity,wind;
-(id)init
{
    self = [super init];
    if (self) {
        _city = @"";
        _cityNumber = @"0";
        _weather = Sunny;
        //_weatherImage = [UIImage imageNamed:@""];
        _mainTemperature = 20;
        _upTemperature = 0;
        _downTemperature = 0;
        _humidity = 0;
        _wind = 0;
    }
    return self;
}
-(id)initByItem:(weatherDataItem*)item
{
    self = [super init];
    if (self) {
        _city = item.city;
        _cityNumber = item.cityNumber;
        _weather = item.weather;
        _mainTemperature = item.mainTemperature;
        _upTemperature = item.upTemperature;
        _downTemperature = item.downTemperature;
        _humidity = item.humidity;
        _wind = item.wind;
        
        _weatherImage = item.weatherImage;
    }
    return self;
}

-(void)setWeather:(weatherType)weather
{
    if (_weather == weather) {
        return;
    }
    _weather = weather;
    
    switch (_weather) {
        case Sunny:
            _weatherImage = [UIImage imageNamed:@"sunny_big.png"];
            break;
        case Cloudy:
            _weatherImage = [UIImage imageNamed:@"cloudy_big.png"];
            break;
        case Rainy:
            _weatherImage = [UIImage imageNamed:@"rainy_big.png"];
            break;
        case Snowy:
            _weatherImage = [UIImage imageNamed:@"snowy_big.png"];
            break;
        case Foggy:
            _weatherImage = [UIImage imageNamed:@"foggy_big.png"];
            break;
            
        default:
            break;
    }
}

@end


@implementation weatherInfoDetailView

-(id)initWithFrame:(CGRect)frame{
    
    weatherDataItem* item = [[weatherDataItem alloc]init];//todo
    
    return  [self initWithFrame:frame withDataItem:item];
    
}

-(id)initWithFrame:(CGRect)frame withDataItem:(weatherDataItem*)item
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.cornerRadius = self.bounds.size.width / 4 ;
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.65];
        if (!item) return self;
        
        if (self.dataItem == nil) {
            self.dataItem = [[weatherDataItem alloc]init];
        }
        self.dataItem = item;
        
        
    }
    
    return self;
}
-(void)setDataItem:(weatherDataItem *)newitem
{
    _dataItem.city = newitem.city;
    _dataItem.cityNumber = newitem.cityNumber;
    _dataItem.weather = newitem.weather;
    _dataItem.mainTemperature = newitem.mainTemperature;
    _dataItem.upTemperature = newitem.upTemperature;
    _dataItem.downTemperature = newitem.downTemperature;
    _dataItem.humidity = newitem.humidity;
    _dataItem.wind = newitem.wind;
}

-(UILabel*)cityLabel
{
    if (cityLabel) {
        return cityLabel;
    }
    cityLabel = [[UILabel alloc]init];
    cityLabel.text = self.dataItem.city;
    cityLabel.textColor = [UIColor whiteColor];
    cityLabel.font = [UIFont boldSystemFontOfSize:20.0];
    cityLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:cityLabel];
    
    return cityLabel;
}

-(UIImageView*)weatherImageV
{
    if (weatherImageV) {
        return weatherImageV;
    }
    weatherImageV = [[UIImageView alloc]initWithImage:self.dataItem.weatherImage];
    [self addSubview:weatherImageV];
    return weatherImageV;
}

-(FBShimmeringView*)mainTempView
{
    if (mainTempView) {
        return mainTempView;
    }
    UILabel* label = [[UILabel alloc]init];
    [label setText:[NSString stringWithFormat:@"%i",self.dataItem.mainTemperature]];
    [label setTextColor:[UIColor whiteColor]];
    label.font = [UIFont boldSystemFontOfSize:70];
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    mainTempView = [[FBShimmeringView alloc]init];
    mainTempView.contentView = label;
    [self addSubview:mainTempView];
    return mainTempView;
}

-(FBShimmeringView*)mainCView
{
    if (mainCView) {
        return mainCView;
    }
    UILabel* label = [[UILabel alloc]init];
    [label setText:@"℃"];
    [label setTextColor:[UIColor whiteColor]];
    label.font = [UIFont boldSystemFontOfSize:30];
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    mainCView = [[FBShimmeringView alloc]init];
    mainCView.contentView = label;
    [self addSubview:mainCView];
    return mainCView;
}

-(UIImageView*)line
{
    if (line) {
        return line;
    }
    line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line1"]];
    line.alpha = 0.5;
    [self addSubview:line];
    return  line;
}

-(UIImageView*)upTempIcon
{
    if (upTempIcon) {
        return upTempIcon;
    }
    upTempIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"upWeather"]];
    [self addSubview:upTempIcon];
    return upTempIcon;
}

-(UIImageView*)downTempIcon
{
    if (downTempIcon) {
        return downTempIcon;
    }
    downTempIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"downWeather"]];
    [self addSubview:downTempIcon];
    return downTempIcon;
}

-(UIImageView*)perecitationIcon
{
    if (perecitationIcon) {
        return perecitationIcon;
    }
    perecitationIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"precipitation_main"]];
    [self addSubview:perecitationIcon];
    return perecitationIcon;
}

-(UIImageView*)windPowerIcon
{
    if (windPowerIcon) {
        return windPowerIcon;
    }
    windPowerIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"windPower_main"]];
    [self addSubview:windPowerIcon];
    return windPowerIcon;
}

-(UILabel*)upTmpLabel
{
    if (upTmpLabel) {
        return upTmpLabel;
    }
    upTmpLabel = [[UILabel alloc]init];
    [upTmpLabel setText:[NSString stringWithFormat:@"%d℃",self.dataItem.upTemperature]];
    [upTmpLabel setTextColor:[UIColor whiteColor]];
    upTmpLabel.textAlignment = NSTextAlignmentCenter;
    upTmpLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:upTmpLabel];
    
    return upTmpLabel;
}

-(UILabel*)downTmpLabel
{
    if (downTmpLabel) {
        return downTmpLabel;
    }
    downTmpLabel = [[UILabel alloc]init];
    [downTmpLabel setText:[NSString stringWithFormat:@"%d℃",self.dataItem.downTemperature]];
    [downTmpLabel setTextColor:[UIColor whiteColor]];
    downTmpLabel.textAlignment = NSTextAlignmentCenter;
    downTmpLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:downTmpLabel];
    
    return upTmpLabel;
}

-(UILabel*)humidityLabel
{
    if (humidityLabel) {
        return humidityLabel;
    }
    humidityLabel = [[UILabel alloc]init];
    [humidityLabel setText:[NSString stringWithFormat:@"%d%%",self.dataItem.humidity]];
    [humidityLabel setTextColor:[UIColor whiteColor]];
    humidityLabel.textAlignment = NSTextAlignmentCenter;
    humidityLabel.adjustsFontSizeToFitWidth = YES;
    humidityLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    [self addSubview:humidityLabel];
    
    return upTmpLabel;
}

-(UILabel*)windLabel
{
    if (windLabel) {
        return windLabel;
    }
    windLabel = [[UILabel alloc]init];
    [windLabel setText:[NSString stringWithFormat:@"%dkm/h",self.dataItem.wind]];
    [windLabel setTextColor:[UIColor whiteColor]];
    windLabel.textAlignment = NSTextAlignmentCenter;
    windLabel.adjustsFontSizeToFitWidth = YES;
    windLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    [self addSubview:windLabel];
    
    return upTmpLabel;
}

-(void)layoutSubviews
{
    CGRect rc = self.bounds;
    CGFloat  version = [[[UIDevice currentDevice] systemVersion] floatValue];
    BOOL isiOS7Later = version >= 7.0 ? YES : NO;
    
    CGSize citySZ,mainTempSZ,mainCSZ,upTempSZ,downTemPSZ,humiditySZ,windSZ;
    if (isiOS7Later) {
        citySZ = [cityLabel.text sizeWithAttributes:@{NSFontAttributeName:cityLabel.font}];
        //        mainTempSZ = [mainTempView.contentView.text sizeWithAttributes:@{NSFontAttributeName:mainTempView.contentView.font}];
        //        mainCSZ = [cityLabel.text sizeWithAttributes:@{NSFontAttributeName:mainCSZ.font}];
        //        citySZ = [cityLabel.text sizeWithAttributes:@{NSFontAttributeName:cityLabel.font}];
        //        citySZ = [cityLabel.text sizeWithAttributes:@{NSFontAttributeName:cityLabel.font}];
        //        citySZ = [cityLabel.text sizeWithAttributes:@{NSFontAttributeName:cityLabel.font}];
        
    }
    else
    {
        citySZ = [cityLabel.text sizeWithFont:cityLabel.font];
        
    }
}



@end
