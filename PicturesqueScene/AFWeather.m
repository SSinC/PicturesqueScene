//
//  AFWeather.m
//  PicturesqueScene
//
//  Created by stan on 5/12/14.
//  Copyright (c) 2014 stan. All rights reserved.
//

#import "AFWeather.h"
#import "defines.h"

@interface AFWeather ()

@property (nonatomic) BOOL isConfigured;
@property (nonatomic, strong) NSString *baseURL;
@property (nonatomic, strong) NSMutableString *baseURL1;
@property (nonatomic) AFWeatherAPI apiProvider;
@property (nonatomic) AFWeatherLocationType locationType;

-(NSURLRequest *)requestForLocationName:(NSString *)name orLatitude:(NSString *)lat andLongitude:(NSString *)lon;

@end

@implementation AFWeather

+(instancetype)sharedClient {
    
    static AFWeather *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [self new];
    });
    
    return sharedClient;
}

-(void)configureClientWithService:(AFWeatherAPI)service withAPIKey:(NSString *)apiKey {
    
    if ((service && apiKey) || service == AFWeatherAPITest || service == STANWeatherTest) {
        
        _apiProvider = service;
        
        switch (service) {
            case AFWeatherAPIWorldWeatherOnline:
//                _baseURL = [NSString stringWithFormat:@"http://api.worldweatheronline.com/free/v1/tz.ashx?key=%@&format=json", apiKey];
                 _baseURL1 =[NSMutableString stringWithFormat: @"http://api.worldweatheronline.com/free/v1/weather.ashx?q=&format=json&num_of_days=4&key=%@", apiKey];
                _baseURL = _baseURL1;
                break;
                
            case AFWeatherAPIWeatherUnderground:
                _baseURL = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/conditions", apiKey];
                break;
                
            case AFWeatherAPIForecast:
                _baseURL = [NSString stringWithFormat:@"http://api.forecast.io/forecast/%@", apiKey];
                break;
                
            case AFWeatherAPIOpenWeatherMap:
                _baseURL = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?APPID=%@", apiKey];
                break;
                
            case AFWeatherAPIAccuWeather:
                _baseURL = [NSString stringWithFormat:@"http://api.accuweather.com/locations/v1/search?apikey=%@", apiKey];
                break;
                
            case AFWeatherAPITest:
                _baseURL = @"http://api.openweathermap.org/data/2.5/weather";
                break;
                
            case STANWeatherTest:
                _baseURL = @"http://www.weather.com.cn/data/cityinfo/101210101.html";
                break;

            default:
                break;
        }
        
    } else if (service) {
        NSLog(@"AFWeather message: You need to provide a valid service");
    } else if (apiKey) {
        NSLog(@"AFWeather message: You need to provide a valid API key/App ID for the chosen service");
    } else {
        NSLog(@"AFWeather message: You need to provide a valid service and a valid API key/App ID for that service");
    }
}

-(void)fetchForecastOfLocationWithName:(NSString *)locationName andCompletionBlock:(completionBlock)completion {
    
    if ( (_baseURL || _baseURL1) && _apiProvider) {
        
        _locationType = AFWeatherLocationTypeName;
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection sendAsynchronousRequest:[self requestForLocationName:locationName orLatitude:nil andLongitude:nil] queue:queue /*[NSOperationQueue mainQueue]*/ completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            if (!connectionError) {
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                completion(json, nil);
            } else {
                completion(nil, connectionError);
            }
        }];
    }
}

-(void)fetchForecastOfLocationWithLatitude:(NSString *)lat andLogitude:(NSString *)lon andCompletionBlock:(completionBlock)completion {
    
    if (_baseURL && _apiProvider) {
        
        _locationType = AFWeatherLocationTypeLatLon;
        
        [NSURLConnection sendAsynchronousRequest:[self requestForLocationName:nil orLatitude:lat andLongitude:lon] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            if (!connectionError) {
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                completion(json, nil);
            } else {
                completion(nil, connectionError);
            }
        }];
    }
}

-(NSURLRequest *)requestForLocationName:(NSString *)name orLatitude:(NSString *)lat andLongitude:(NSString *)lon {
    
    NSURLRequest *request = [NSURLRequest new];
    
    if (_locationType == AFWeatherLocationTypeName) {
        
        switch (_apiProvider) {
            case AFWeatherAPIWorldWeatherOnline:
            {
                @"http://api.worldweatheronline.com/free/v1/weather.ashx?q=London&format=json&num_of_days=4&key=mdd5ssqupbua9jagjvg3eanf";
                NSString *insertString = [name encodeForURLWithEncoding:NSUTF8StringEncoding];
                NSRange from = [_baseURL1 rangeOfString:@"q="];
                NSRange to   = [_baseURL1 rangeOfString:@"&format"];
                int insertIndex = from.length + from.location;
               [_baseURL1 deleteCharactersInRange:NSMakeRange(insertIndex, to.location - insertIndex)];
               [_baseURL1 insertString:insertString atIndex:insertIndex];
                NSLog(@"string is%@",_baseURL1);
               // request = [NSURLRequest requestWithURL:[NSURL URLWithString:_baseURL1]];
            request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:_baseURL1] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
                break;
            }
            case AFWeatherAPIOpenWeatherMap: case AFWeatherAPIAccuWeather:
                request = [NSURLRequest requestWithURL:[NSURL URLWithString:[_baseURL stringByAppendingString:[NSString stringWithFormat:@"&q=%@",[name encodeForURLWithEncoding:NSUTF8StringEncoding]]]]];
                break;
                
            case AFWeatherAPIWeatherUnderground:
                request = [NSURLRequest requestWithURL:[NSURL URLWithString:[_baseURL stringByAppendingString:[NSString stringWithFormat:@"/q/%@",[name encodeForURLWithEncoding:NSUTF8StringEncoding]]]]];
                break;
                
            case AFWeatherAPIForecast:
                NSLog(@"AFWeather message: forecast.io does not support city name location, you must use coordinates");
                
            case AFWeatherAPITest:
                request = [NSURLRequest requestWithURL:[NSURL URLWithString:[_baseURL stringByAppendingString:[NSString stringWithFormat:@"?q=%@",[name encodeForURLWithEncoding:NSUTF8StringEncoding]]]]];
                break;
                
            case STANWeatherTest:
//                request = [NSURLRequest requestWithURL:[NSURL URLWithString:_baseURL]];
                request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:_baseURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
                break;
                
            default:
                break;
        }
    } else {
        
        switch (_apiProvider) {
            case AFWeatherAPIWorldWeatherOnline:
                request = [NSURLRequest requestWithURL:[NSURL URLWithString:[_baseURL stringByAppendingString:[NSString stringWithFormat:@"&q=%@/%@",[[lat stringByReplacingOccurrencesOfString:@"," withString:@"."] encodeForURLWithEncoding:NSUTF8StringEncoding],[[lon stringByReplacingOccurrencesOfString:@"," withString:@"."] encodeForURLWithEncoding:NSUTF8StringEncoding]]]]];
                break;

            case AFWeatherAPIOpenWeatherMap:
                request = [NSURLRequest requestWithURL:[NSURL URLWithString:[_baseURL stringByAppendingString:[NSString stringWithFormat:@"&lat=%@&lon=%@",[[lat stringByReplacingOccurrencesOfString:@"," withString:@"."] encodeForURLWithEncoding:NSUTF8StringEncoding],[[lon stringByReplacingOccurrencesOfString:@"," withString:@"."] encodeForURLWithEncoding:NSUTF8StringEncoding]]]]];
                break;
                
            case AFWeatherAPIAccuWeather:
                NSLog(@"AFWeather message: Accu Weather does not support coordinates, you must provide a valid place name or a postal code");
                break;
                
            case AFWeatherAPIWeatherUnderground:
                NSLog(@"AFWeather message: Weather Underground does not support coordinates, you must provide a valid place name or a postal code");
                break;
                
            case AFWeatherAPIForecast:
                request = [NSURLRequest requestWithURL:[NSURL URLWithString:[_baseURL stringByAppendingString:[NSString stringWithFormat:@"/%@,%@",[[lat stringByReplacingOccurrencesOfString:@"," withString:@"."] encodeForURLWithEncoding:NSUTF8StringEncoding],[[lon stringByReplacingOccurrencesOfString:@"," withString:@"."] encodeForURLWithEncoding:NSUTF8StringEncoding]]]]];
                break;
                
            case AFWeatherAPITest:
                request = [NSURLRequest requestWithURL:[NSURL URLWithString:[_baseURL stringByAppendingString:[NSString stringWithFormat:@"?lat=%@&lon=%@",[[lat stringByReplacingOccurrencesOfString:@"," withString:@"."] encodeForURLWithEncoding:NSUTF8StringEncoding],[[lon stringByReplacingOccurrencesOfString:@"," withString:@"."] encodeForURLWithEncoding:NSUTF8StringEncoding]]]]];
                break;
                
            default:
                break;
        }
    }
    
    return request;
}

@end

@implementation NSString (AFURLEncoding)

-(NSString *)encodeForURLWithEncoding:(NSStringEncoding)encoding {
    
    NSString *fixedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ", CFStringConvertNSStringEncodingToEncoding(encoding)));
    
    return fixedString;
}

@end
