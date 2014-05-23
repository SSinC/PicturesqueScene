//
//  LocationManager.h
//  PicturesqueScene
//
//  Created by stan on 5/12/14.
//  Copyright (c) 2014 stan. All rights reserved.
//

#import "LocationManager.h"
#import "TSMessage.h"

@interface LocationManager ()

@property (nonatomic, strong) LocationBlock locationBlock;
@property (nonatomic, strong) NSStringBlock cityBlock;
@property (nonatomic, strong) NSStringBlock addressBlock;
@property (nonatomic, strong) LocationErrorBlock errorBlock;

@end

@implementation LocationManager

+ (LocationManager *)shareLocation;
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] _init];
    });
    return _sharedObject;
}

- (instancetype)_init
{
    self = [super init];
    if (self) {
        NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
        
        float longitude = [standard floatForKey:PSLastLongitude];
        float latitude = [standard floatForKey:PSLastLatitude];
        self.longitude = longitude;
        self.latitude = latitude;
        self.lastCoordinate = CLLocationCoordinate2DMake(longitude,latitude);
        self.lastCity = [standard objectForKey:PSLastCity];
        PSLog(@"lastcity:%@",self.lastCity);
        self.lastAddress=[standard objectForKey:PSLastAddress];
    }
    return self;

}

- (instancetype)init
{
    [NSException raise:NSStringFromClass([self class]) format:@"Use sharedInstance instead of New And Init."];
    return nil;
}

+ (instancetype)new
{
    [NSException raise:NSStringFromClass([self class]) format:@"Use sharedInstance instead of New And Init."];
    return nil;
}

//- (id)init
//{
//    self = [super init];
//    if (self) {
//        NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
//        
//        float longitude = [standard floatForKey:MMLastLongitude];
//        float latitude = [standard floatForKey:MMLastLatitude];
//        self.longitude = longitude;
//        self.latitude = latitude;
//        self.lastCoordinate = CLLocationCoordinate2DMake(longitude,latitude);
//        self.lastCity = [standard objectForKey:MMLastCity];
//        self.lastAddress=[standard objectForKey:MMLastAddress];
//    }
//    return self;
//}

- (void) getLocationCoordinate:(LocationBlock) locaiontBlock
{
    self.locationBlock = [locaiontBlock copy];
    [self startLocation];
}

- (void) getLocationCoordinate:(LocationBlock) locaiontBlock  withAddress:(NSStringBlock) addressBlock
{
    self.locationBlock = [locaiontBlock copy];
    self.addressBlock = [addressBlock copy];
    [self startLocation];
}

- (void) getAddress:(NSStringBlock)addressBlock
{
    self.addressBlock = [addressBlock copy];
    [self startLocation];
}

- (void) getCity:(NSStringBlock)cityBlock
{   PSLog(@"getCity");
    self.cityBlock = [cityBlock copy];
    [self startLocation];
}

- (void) getCity:(NSStringBlock)cityBlock error:(LocationErrorBlock) errorBlock
{
    self.cityBlock = [cityBlock copy];
    self.errorBlock = [errorBlock copy];
    [self startLocation];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    PSLog(@"in 1");
    CLLocation * newLocation = userLocation.location;
    self.lastCoordinate=mapView.userLocation.location.coordinate;
    
    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
    
    [standard setObject:@(self.lastCoordinate.longitude) forKey:PSLastLongitude];
    [standard setObject:@(self.lastCoordinate.latitude) forKey:PSLastLatitude];
    
    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    CLGeocodeCompletionHandler handle = ^(NSArray *placemarks,NSError *error)
    {
        PSLog(@"in 2");
        for (CLPlacemark * placeMark in placemarks)
        {
            NSDictionary *addressDic=placeMark.addressDictionary;
            
            NSString *state=[addressDic objectForKey:@"State"];
            NSString *city=[addressDic objectForKey:@"City"];
            NSString *subLocality=[addressDic objectForKey:@"SubLocality"];
            NSString *street=[addressDic objectForKey:@"Street"];
            
            self.lastCity = city;
            self.lastAddress=[NSString stringWithFormat:@"%@%@%@%@",state,city,subLocality,street];
            
            [standard setObject:self.lastCity forKey:PSLastCity];
            [standard setObject:self.lastAddress forKey:PSLastAddress];
            
            [self stopLocation];
        }
        
        if (_cityBlock) {
            _cityBlock(_lastCity);
            _cityBlock = nil;
        }
        
        if (_locationBlock) {
            _locationBlock(_lastCoordinate);
            _locationBlock = nil;
        }
        
        if (_addressBlock) {
            _addressBlock(_lastAddress);
            _addressBlock = nil;
        }
    };
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [clGeoCoder reverseGeocodeLocation:newLocation completionHandler:handle];
}


-(void)startLocation
{
    PSLog(@"startLocation");
    if (_mapView) {
        _mapView = nil;
    }
    
//mapView 必须在主线程种创建
    __weak id wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        LocationManager *strongSelf = wself;
        _mapView = [[MKMapView alloc] init];
        _mapView.delegate = strongSelf;
        _mapView.showsUserLocation = YES;
    });
    
//    _mapView = [[MKMapView alloc] init];
//    _mapView.delegate = self;
//    _mapView.showsUserLocation = YES;
}

-(void)stopLocation
{
    _mapView.showsUserLocation = NO;
    _mapView = nil;
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    PSLog(@"didFailToLocateUserWithError");
    [TSMessage showNotificationWithTitle:@"Warning" subtitle:@"There is a problem getting your location automatically.Please choose your city if you want" type:TSMessageNotificationTypeWarning];
    [self stopLocation];
}

@end
