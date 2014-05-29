//
//  WeatherUI.m
//  PicturesqueScene
//
//  Created by Sara on 5/16/14.
//  Copyright (c) 2014 Stan. All rights reserved.
//

#import "WeatherUI.h"
#import "defines.h"

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
//    PSLog(@"self:%@",self);
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
-(id)initWithCity:(NSString*)cityname weather:(weatherType)weather mainTemp:(NSInteger)temp upTemp:(NSInteger)upTemp downTemp:(NSInteger)downTemp humidity:(NSInteger)humidity wind:(NSInteger)wind
{
    self = [super init];
    
    if (self) {
        self.city = cityname;
        self.weather = weather;
        self.mainTemperature = temp;
        self.upTemperature = upTemp;
        self.downTemperature = downTemp;
        self.humidity = humidity;
        self.wind = wind;
    }
    return self;
}

-(void)setWeather:(weatherType)weather
{
    //    if (_weather == weather) {
    //        return;
    //    }
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
- (void)setMainTemperature:(NSInteger)Temperature
{
    _mainTemperature = Temperature;
    
}

@end


@implementation weatherInfoDetailView
//@synthesize dataItem = _dataItem;
- (id)initWithFrame:(CGRect)frame
{
    weatherDataItem* item = [[weatherDataItem alloc] init];//todo
    
    return  [self initWithFrame:frame withDataItem:item];
}

- (id)initWithFrame:(CGRect)frame withDataItem:(weatherDataItem *)item
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.layer.cornerRadius = self.bounds.size.width / 4 ;
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.65];
        // if (!item) return self;
        
        if (_dataItem == nil) {
            _dataItem = [[weatherDataItem alloc] init];
//            PSLog(@"[[weatherDataItem alloc] init]:%@",[[weatherDataItem alloc] init]);
        }
        self.dataItem = item;
        [self initAllViews];
    }
    
    return self;
}
- (void)initAllViews
{
    [self createCityLabel];
    [self createWeatherImageV];
    [self createMainTempView];
    [self createMainCView];
    [self createUpTempIcon];
    [self createUpTmpLabel];
    [self createDownTempIcon];
    [self createDownTmpLabel];
    [self createLine];
    [self createPerecitationIcon];
    [self createHumidityLabel];
    [self createWindPowerIcon];
    [self createWindLabel];
    
}
-(void)setDataItem:(weatherDataItem *)newitem
{
    _dataItem.city = newitem.city;
    //_dataItem.cityNumber = newitem.cityNumber;
    _dataItem.weather = newitem.weather;
    _dataItem.mainTemperature = newitem.mainTemperature;
    _dataItem.upTemperature = newitem.upTemperature;
    _dataItem.downTemperature = newitem.downTemperature;
    _dataItem.humidity = newitem.humidity;
    _dataItem.wind = newitem.wind;
}

-(UILabel*)createCityLabel
{
    
    _cityLabel = [[UILabel alloc]init];
    _cityLabel.text = self.dataItem.city;
    _cityLabel.textColor = [UIColor whiteColor];
    _cityLabel.font = [UIFont boldSystemFontOfSize:20.0];
    _cityLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:_cityLabel];
    
    return _cityLabel;
}

-(UIImageView*)createWeatherImageV
{
    
    _weatherImageV = [[UIImageView alloc]initWithImage:self.dataItem.weatherImage];
    [self addSubview:_weatherImageV];
    return _weatherImageV;
}

-(FBShimmeringView*)createMainTempView
{
    
    _contentOfmainTempView = [[UILabel alloc]init];
    [_contentOfmainTempView setText:[NSString stringWithFormat:@"%i",self.dataItem.mainTemperature]];
    [_contentOfmainTempView setTextColor:[UIColor whiteColor]];
    _contentOfmainTempView.font = [UIFont boldSystemFontOfSize:70];
    _contentOfmainTempView.textAlignment = NSTextAlignmentCenter;
    _contentOfmainTempView.adjustsFontSizeToFitWidth = YES;
    
    _mainTempView = [[FBShimmeringView alloc] initWithFrame:CGRectMake(40, 228, 90, 90)];
    //    FBShimmeringView *shimmeringVieWeather = [[FBShimmeringView alloc] initWithFrame:CGRectMake(40, 228, 90, 90)];
    _mainTempView.contentView = _contentOfmainTempView;
    _mainTempView.shimmeringSpeed = 75;
    _mainTempView.shimmering = YES;
    [self addSubview:_mainTempView];
    return _mainTempView;
}

-(FBShimmeringView*)createMainCView
{
    
    _contentOfmainCView = [[UILabel alloc]init];
    [_contentOfmainCView setText:@"℃"];
    [_contentOfmainCView setTextColor:[UIColor whiteColor]];
    _contentOfmainCView.font = [UIFont boldSystemFontOfSize:30];
    _contentOfmainCView.textAlignment = NSTextAlignmentCenter;
    _contentOfmainCView.adjustsFontSizeToFitWidth = YES;
    _mainCView = [[FBShimmeringView alloc]init];
    _mainCView.shimmeringSpeed = 75;
    //_mainCView.shimmering = YES;
    _mainCView.contentView = _contentOfmainCView;
    [self addSubview:_mainCView];
    return _mainCView;
}

-(UIImageView*)createLine
{
    _line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line1"]];
    _line.alpha = 0.5;
    [self addSubview:_line];
    return  _line;
}

-(UIImageView*)createUpTempIcon
{
    _upTempIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"upWeather"]];
    [self addSubview:_upTempIcon];
    return _upTempIcon;
}

-(UIImageView*)createDownTempIcon
{
    
    _downTempIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"downWeather"]];
    [self addSubview:_downTempIcon];
    return _downTempIcon;
}

-(UIImageView*)createPerecitationIcon
{
    _perecitationIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"precipitation_main"]];
    [self addSubview:_perecitationIcon];
    return _perecitationIcon;
}

-(UIImageView*)createWindPowerIcon
{
    
    _windPowerIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"windPower_main"]];
    [self addSubview:_windPowerIcon];
    return _windPowerIcon;
}

-(UILabel*)createUpTmpLabel
{
    
    _upTmpLabel = [[UILabel alloc]init];
    // _upTmpLabel.backgroundColor = [UIColor redColor];
    [_upTmpLabel setText:[NSString stringWithFormat:@"%d℃",self.dataItem.upTemperature]];
    [_upTmpLabel setTextColor:[UIColor whiteColor]];
    _upTmpLabel.font = [UIFont systemFontOfSize:14.0];
    _upTmpLabel.textAlignment = NSTextAlignmentCenter;
    _upTmpLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_upTmpLabel];
    
    return _upTmpLabel;
}

-(UILabel*)createDownTmpLabel
{
    
    _downTmpLabel = [[UILabel alloc]init];
    // _downTmpLabel.backgroundColor = [UIColor redColor];
    
    [_downTmpLabel setText:[NSString stringWithFormat:@"%d℃",self.dataItem.downTemperature]];
    [_downTmpLabel setTextColor:[UIColor whiteColor]];
    _downTmpLabel.font = [UIFont systemFontOfSize:14.0];
    _downTmpLabel.textAlignment = NSTextAlignmentCenter;
    _downTmpLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_downTmpLabel];
    
    return _upTmpLabel;
}

-(UILabel*)createHumidityLabel
{
    
    _humidityLabel = [[UILabel alloc]init];
    //  _humidityLabel.backgroundColor = [UIColor redColor];
    [_humidityLabel setText:[NSString stringWithFormat:@"%d%%",self.dataItem.humidity]];
    [_humidityLabel setTextColor:[UIColor whiteColor]];
    _humidityLabel.textAlignment = NSTextAlignmentCenter;
    _humidityLabel.adjustsFontSizeToFitWidth = YES;
    _humidityLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [_humidityLabel sizeToFit];
    [self addSubview:_humidityLabel];
    
    return _upTmpLabel;
}

-(UILabel*)createWindLabel
{
    
    _windLabel = [[UILabel alloc]init];
    //_windLabel.backgroundColor = [UIColor redColor];
    
    [_windLabel setText:[NSString stringWithFormat:@"%dkm/h",self.dataItem.wind]];
    [_windLabel setTextColor:[UIColor whiteColor]];
    _windLabel.textAlignment = NSTextAlignmentCenter;
    _windLabel.adjustsFontSizeToFitWidth = YES;
    [_windLabel sizeToFit];
    _windLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    [self addSubview:_windLabel];
    
    return _upTmpLabel;
}

-(void)layoutSubviews
{
    CGRect rc = self.bounds;
    CGFloat  version = [[[UIDevice currentDevice] systemVersion] floatValue];
    BOOL isiOS7Later = version >= 7.0 ? YES : NO;
    
    CGSize citySZ,mainTempSZ,mainCSZ,upTempSZ,downTemPSZ,humiditySZ,windSZ;
    
    if (isiOS7Later) {
        citySZ = [_cityLabel.text sizeWithAttributes:@{NSFontAttributeName:_cityLabel.font}];
        mainTempSZ = [_contentOfmainTempView.text sizeWithAttributes:@{NSFontAttributeName:_contentOfmainTempView.font}];
        mainCSZ = [_contentOfmainCView.text sizeWithAttributes:@{NSFontAttributeName:_contentOfmainCView.font}];
        upTempSZ = [_upTmpLabel.text sizeWithAttributes:@{NSFontAttributeName:_upTmpLabel.font}];
        downTemPSZ = [_downTmpLabel.text sizeWithAttributes:@{NSFontAttributeName:_downTmpLabel.font}];
        humiditySZ = [_humidityLabel.text sizeWithAttributes:@{NSFontAttributeName:_humidityLabel.font}];
        windSZ = [_windLabel.text sizeWithAttributes:@{NSFontAttributeName:_windLabel.font}];
    }
    else
    {
        citySZ = [_cityLabel.text sizeWithFont:_cityLabel.font];
        mainTempSZ = [_contentOfmainTempView.text sizeWithFont: _contentOfmainTempView.font];
        mainCSZ = [_contentOfmainCView.text sizeWithFont:_contentOfmainCView.font];
        upTempSZ = [_upTmpLabel.text sizeWithFont:_upTmpLabel.font];
        downTemPSZ = [_downTmpLabel.text sizeWithFont:_downTmpLabel.font];
        humiditySZ = [_humidityLabel.text sizeWithFont:_humidityLabel.font];
        windSZ = [_windLabel.text sizeWithFont:_windLabel.font];
        
    }
    CGRect rcCity,rcWeather,rcMainT,rcMainC,rcLine;
    CGRect rcUPIcon,rcDownIcon,rcperecitationIcon,rcWindIcon;
    CGRect rcUPLabel,rcDownLabel,rchumidityLabel,rcWindLabel;
    
    rcCity = CGRectMake((rc.size.width - citySZ.width)/2, 20., citySZ.width, citySZ.height);
    rcWeather = CGRectMake((rc.size.width - _weatherImageV.image.size.width)/2, 68, _weatherImageV.image.size.width ,  _weatherImageV.image.size.height);
    rcMainT = CGRectMake(35.0, 230, mainTempSZ.width, mainTempSZ.height);
    rcMainC = CGRectMake(rcMainT.origin.x + rcMainT.size.width + 4.0, 242, mainCSZ.width, mainCSZ.height);
    rcUPIcon = CGRectMake(rcMainC.origin.x + rcMainC.size.width + 15, 252, 10, 12);
    rcDownIcon = CGRectMake(rcUPIcon.origin.x, rcUPIcon.origin.y + rcUPIcon.size.height + 20, 10, 12);
    rcUPLabel = CGRectMake(rcUPIcon.origin.x + rcUPIcon.size.width + 5, 250, upTempSZ.width, upTempSZ.height);
    rcDownLabel = CGRectMake(rcDownIcon.origin.x + rcDownIcon.size.width + 3, rcUPLabel.origin.y + rcUPLabel.size.height + 15, downTemPSZ.width, downTemPSZ.height);
    
    rcLine = CGRectMake(rcUPLabel.origin.x + rcUPLabel.size.width + 10, 246, 1, 58);
    rcperecitationIcon = CGRectMake(rcLine.origin.x + rcLine.size.width + 10, 248, 20, 20);
    rcWindIcon = CGRectMake(rcperecitationIcon.origin.x, rcperecitationIcon.origin.y + rcperecitationIcon.size.height + 10, 20, 20);
    rchumidityLabel = CGRectMake(rcperecitationIcon.origin.x + rcperecitationIcon.size.width + 6, 246, humiditySZ.width, humiditySZ.height);
    rcWindLabel = CGRectMake(rchumidityLabel.origin.x, rchumidityLabel.origin.y + rchumidityLabel.size.height + 10, windSZ.width, windSZ.height);
    
    _cityLabel.frame = rcCity;
    _weatherImageV.frame = rcWeather;
    _mainTempView.frame = rcMainT;//
    _mainCView.frame = rcMainC;
    //_contentOfmainCView.frame = rcMainC;//
    _upTempIcon.frame = rcUPIcon;
    _upTmpLabel.frame = rcUPLabel;
    _downTempIcon.frame = rcDownIcon;
    _downTmpLabel.frame = rcDownLabel;
    _line.frame = rcLine;
    _perecitationIcon.frame = rcperecitationIcon;
    _windPowerIcon.frame = rcWindIcon;
    _humidityLabel.frame = rchumidityLabel;
    _windLabel.frame = rcWindLabel;
    
    
}
-(void)updateUIbyData:(id)item
{
    _cityLabel.text = self.dataItem.city;
    [_weatherImageV setImage:self.dataItem.weatherImage];
    
    [_contentOfmainTempView setText:[NSString stringWithFormat:@"%i",self.dataItem.mainTemperature]];
    //mainTempView.contentView = contentOfmainTempView;
    
    _line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line1"]];
    
    _upTempIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"upWeather"]];
    _perecitationIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"precipitation_main"]];
    _downTempIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"downWeather"]];
    _windPowerIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"windPower_main"]];
    
    [_upTmpLabel setText:[NSString stringWithFormat:@"%d℃",self.dataItem.upTemperature]];
    [_downTmpLabel setText:[NSString stringWithFormat:@"%d℃",self.dataItem.downTemperature]];
    [_humidityLabel setText:[NSString stringWithFormat:@"%d%%",self.dataItem.humidity]];
    [_windLabel setText:[NSString stringWithFormat:@"%dkm/h",self.dataItem.wind]];
    
}


@end


/*******************************   watherForecastView   **************************/
@interface weatherForecastView ()
{
    UILabel*        _titleLbel;
    UIView*         _line;
    UIImageView*    _weatherImgView;
    
    UIImageView*    _upTmpIcon;
    UIImageView*    _downTmpIcon;
    UILabel*        _upTmpLabel;
    UILabel*        _downTmpLabel;
    
    UIImageView*    _dashedLine;
    
    BOOL            _isios7Later;
    
}
@end
@implementation weatherForecastView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.layer.cornerRadius = self.frame.size.width/4.f;
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.65];
        
        _weather = -1;
        _isios7Later = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO;
        
        [self createAllSubviews];
    }
    
    return self;
}
- (id)initWithFrame:(CGRect)frame Title:(NSString *)title weather:(weatherType)weather upTemperature:(NSInteger)upTmp downTemperature:(NSInteger)downTmp
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.layer.cornerRadius = self.frame.size.width/4.f;
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.65];
        
        _weather = -1;
        _isios7Later = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO;
        
        [self createAllSubviews];

        self.title = title;
        self.weather = weather;
        self.upTemperature = upTmp;
        self.downTemperature = downTmp;
        
    }
    
    return self;
}
- (void)createAllSubviews
{
    _titleLbel = [[UILabel alloc] init];
    [_titleLbel setText:_title];
    [_titleLbel setTextColor:[UIColor whiteColor]];
    //    [labelTitle setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20]];
    _titleLbel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLbel];
    
    _line =  [[UIView alloc]init];
    _line.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
    [self addSubview:_line];
    
    _weatherImgView = [[UIImageView alloc]init];
    //_weatherImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sunny_small"]];
    
    [self addSubview:_weatherImgView];
    
    _upTmpIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"upWeather_big"]];
    [self addSubview:_upTmpIcon];
    _downTmpIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"downWeather_big"]];
    [self addSubview:_downTmpIcon];
    
    _upTmpLabel = [[UILabel alloc] init];
    [_upTmpLabel setText:[NSString stringWithFormat:@"%i℃",_upTemperature]];
    [_upTmpLabel setTextColor:[UIColor whiteColor]];
    //    [_upTmpLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30]];
    _upTmpLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_upTmpLabel];
    
    _downTmpLabel = [[UILabel alloc] init];
    [_downTmpLabel setText:[NSString stringWithFormat:@"%i℃",_downTemperature]];
    [_downTmpLabel setTextColor:[UIColor whiteColor]];
    //    [_downTmpLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30]];
    _downTmpLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_downTmpLabel];
    
    _dashedLine = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line"]];
    [self addSubview:_dashedLine];
    
}
- (void)setTitle:(NSString *)newtitle
{
    if ([_title isEqualToString:newtitle]) {
        return;
    }
    _title = newtitle;
    [_titleLbel setText:_title];
}

- (void)setWeather:(weatherType)newweather
{
    if (_weather == newweather) {
        return;
    }
    _weather = newweather;
    switch (_weather) {
        case Sunny:
            [_weatherImgView setImage:[UIImage imageNamed:@"sunny_small"]];
            break;
        case Rainy:
            [_weatherImgView setImage:[UIImage imageNamed:@"rainy_small"]];
            break;
        case Cloudy:
            [_weatherImgView setImage:[UIImage imageNamed:@"cloudy_small"]];
            break;
        case Snowy:
            [_weatherImgView setImage:[UIImage imageNamed:@"snowy_small"]];
            break;
        case Foggy:
            [_weatherImgView setImage:[UIImage imageNamed:@"foggy_small"]];
            
            break;
        default:
            break;
    }
}
- (void)setUpTemperature:(NSInteger)tmp
{
    if (_upTemperature == tmp) {
        return;
    }
    _upTemperature = tmp;
    [_upTmpLabel setText:[NSString stringWithFormat:@"%i℃",_upTemperature]];
}

- (void)setDownTemperature:(NSInteger)tmp
{
    if (_downTemperature == tmp) {
        return;
    }
    _downTemperature = tmp;
    [_downTmpLabel setText:[NSString stringWithFormat:@"%i℃",_downTemperature]];
}

-(void)layoutSubviews
{
    CGRect rc = self.bounds;
    CGRect rcTitle,rcLine,rcWeatherIV,rcDashLine;
    CGRect rcUpIcon,rcDownIcon,rcUpL,rcDownL;
    
    // CGSize titleSZ = _isios7Later ? [_titleLbel.text sizeWithAttributes:@{NSFontAttributeName:_titleLbel.font}] : [_titleLbel.text sizeWithFont:_titleLbel.font];
    
    rcTitle = CGRectMake((rc.size.width - 80)/2, 0, 80, 40);
    rcLine = CGRectMake(10, 40, self.frame.size.width - 20, 1);
    rcWeatherIV = CGRectMake(18, 70, 80, 70);
    rcDashLine = CGRectMake(95, 106, 74, 1);
    
    rcUpIcon = CGRectMake(100, 80, 11, 16);
    rcDownIcon = CGRectMake(100, 118, 11, 16);
    rcUpL = CGRectMake(120, 68, 40, 40);
    rcDownL = CGRectMake(120, 108, 40, 40);
    
    _titleLbel.frame = rcTitle;
    _line.frame = rcLine;
    _weatherImgView.frame = rcWeatherIV;
    _upTmpIcon.frame = rcUpIcon;
    _downTmpIcon.frame = rcDownIcon;
    _upTmpLabel.frame = rcUpL;
    _downTmpLabel.frame = rcDownL;
    _dashedLine.frame = rcDashLine;
    
}

@end


@interface weatherHeaderView()
{
    UIImageView *       _cityIcon;
    UILabel *           _cityLabel;
    UIImageView *       _tempIcon;
    UILabel *           _tempLabel;
    FBShimmeringView *  _shimmeringViewUp;
    UILabel *           _labelC;
    UIImageView *       _weatherIcon;
    UILabel *           _weatherLabel;
}
@end

@implementation weatherHeaderView
- (instancetype) initWithFrame:(CGRect)frame city:(NSString *)city temperature:(NSInteger)temperature weather:(weatherType)weather
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.layer.cornerRadius = self.frame.size.height/4.f;
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.65];
       
        _cityIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"city"]];
        
        _cityLabel = [[UILabel alloc] init];
        _cityLabel.text = city;
        _cityLabel.textColor = [UIColor whiteColor];
        _cityLabel.font = [UIFont systemFontOfSize:22.0f];
        _cityLabel.textAlignment = NSTextAlignmentCenter;
        _cityLabel.adjustsFontSizeToFitWidth = YES;
        
        _tempIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"t_icon"]];
        
        _tempLabel = [[UILabel alloc] init];
        _tempLabel.text = [NSString stringWithFormat:@"%i",temperature];
        _tempLabel.textColor = [UIColor whiteColor];
        _tempLabel.font = [UIFont boldSystemFontOfSize:24];
        _tempLabel.textAlignment = NSTextAlignmentCenter;
        _tempLabel.adjustsFontSizeToFitWidth = YES;
        _shimmeringViewUp = [[FBShimmeringView alloc] init];
        _shimmeringViewUp.contentView = _tempLabel;
        _shimmeringViewUp.shimmeringSpeed = 70;
        _shimmeringViewUp.shimmering = YES;
        
        _labelC = [[UILabel alloc] init];
        _labelC.text = @"℃";
        _labelC.textColor = [UIColor whiteColor];
        _labelC.font = [UIFont systemFontOfSize:15.0];
        _labelC.textAlignment = NSTextAlignmentCenter;
        _labelC.adjustsFontSizeToFitWidth = YES;
        
        _weatherLabel = [[UILabel alloc] init];
        _weatherLabel.textColor = [UIColor whiteColor];
        _weatherLabel.font = [UIFont systemFontOfSize:22.0];
        _weatherLabel.textAlignment = NSTextAlignmentCenter;
        _weatherLabel.adjustsFontSizeToFitWidth = YES;

        switch (weather) {
            case Sunny:
                _weatherIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sunny_icon"]];
                _weatherLabel.text = @"晴天";
                break;
            case Rainy:
                _weatherIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rainy_icon"]];
                _weatherLabel.text = @"下雨";
                break;
            case Cloudy:
                _weatherIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cloudy_icon"]];
                _weatherLabel.text = @"阴天";
                break;
            case Snowy:
                _weatherIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"snowy_icon"]];
                _weatherLabel.text = @"下雪";
                break;
            case Foggy:
                _weatherIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"foggy_icon"]];
                _weatherLabel.text = @"雾霾";
                break;
            default:
                break;
        }
        
        
        [self addSubview:_cityIcon];
        [self addSubview:_cityLabel];
        [self addSubview:_tempIcon];
        [self addSubview:_shimmeringViewUp];
        [self addSubview:_labelC];
        [self addSubview:_weatherIcon];
        [self addSubview:_weatherLabel];


    }
    
    return self;
}
- (void)layoutSubviews
{
    CGRect rc  = self.frame;
    CGRect rcCityIcon,rcCityL,rcteIcon,rcteLabel,rccLabel,rcwIcon,rcwL;
    
    rcCityIcon = CGRectMake(13, (rc.size.height - 24)/2, 20, 24);
    
    CGSize sz = [_cityLabel.text sizeWithFont:_cityLabel.font];
    rcCityL = CGRectMake(rcCityIcon.origin.x + rcCityIcon.size.width + 6, (rc.size.height - sz.height)/2, sz.width , sz.height);
    rcteIcon = CGRectMake(rcCityL.origin.x + rcCityL.size.width + 26.0f,(rc.size.height - 24)/2 , 20, 24);
    CGSize szt = [_tempLabel.text sizeWithFont:_tempLabel.font];
    rcteLabel = CGRectMake(rcteIcon.origin.x + rcteIcon.size.width + 5.0f,(rc.size.height - szt.height)/2, szt.width, szt.height);
    sz = [_labelC.text sizeWithFont:_labelC.font];
    rccLabel = CGRectMake(rcteLabel.origin.x + rcteLabel.size.width + 3, rcteLabel.origin.y + 3, sz.width, sz.height);
    rcwIcon = CGRectMake(rccLabel.origin.x + rccLabel.size.width + 22, (rc.size.height - 24)/2, 28., 24.);
    sz = [_weatherLabel.text sizeWithFont:_weatherLabel.font];
    rcwL = CGRectMake(rcwIcon.origin.x + rcwIcon.size.width + 5, (rc.size.height - sz.height)/2, sz.width, sz.height);

    _cityIcon.frame = rcCityIcon;
    _cityLabel.frame = rcCityL;
    _tempIcon.frame = rcteIcon;
    _tempLabel.frame = rcteLabel;
    _shimmeringViewUp.frame = rcteLabel;
    _labelC.frame = rccLabel;
    _weatherIcon.frame = rcwIcon;
    _weatherLabel.frame = rcwL;
    
}

@end

@interface aboutUSView()
{
    UIView *        _lineView;
    UIImageView *   _wholeAbout;
}

@end
@implementation aboutUSView

- (instancetype) initWithFrame:(CGRect)frame title:(NSString *)title text:(NSString *)text
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.layer.cornerRadius = self.frame.size.width/4.f;
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.65];
        
        if(title==nil || title.length==0)
        {
            PSLog(@"drawRect title == nil");
        }
        else
        {
            _lineView = [[UIView alloc]initWithFrame:CGRectMake(18, 54, self.frame.size.width - 36, 1)];
            _lineView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
        }
        [self addSubview:_lineView];
        
        _wholeAbout = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"aboutus"]];
        _wholeAbout.frame = CGRectMake(30, 15, 279, 308);
        
        [self addSubview:_wholeAbout];
    }
    return self;
}

@end
