//
//  networkWeater.m
//  PicturesqueScene
//
//  Created by Stan on 14-4-16.
//  Copyright (c) 2014年 Stan. All rights reserved.
//

#import "networkWeather.h"
#import "CheckNetwork.h"
#import "AFWeather.h"

#import "FMDatabase.h"
#import "FMResultSet.h"
#import "FMDatabaseAdditions.h"
#import "LocationManager.h"
#import "defines.h"

@implementation networkWeather
{
    NSUserDefaults *_userDefaults;
    BOOL           _sendWeatherInfoCompleted;
    __weak id      _wself ;
}

+ (instancetype)sharedInstance
{
    static networkWeather *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] _init];
    });
    
    return sharedInstance;
}

- (instancetype)_init
{
    if (self = [super init]) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
        _wself        = self;
        
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

+ (void)withGroup:(dispatch_group_t)group sendAsynchronousRequest:(NSURLRequest *)request queue:(NSOperationQueue *)queue completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler
{
    if (group == NULL) {
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:queue
                               completionHandler:handler];
    } else {
        dispatch_group_enter(group);
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:queue
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                                   handler(response, data, error);
                                   dispatch_group_leave(group);
                               }];
    }
}

#pragma mark - Obtain weather info
/****************************
 Location based ,obtain weather info automaticlly.
 ****************************/
- (void)obtainWeaterInfoLocationBased
{
    //异步回调
    [[LocationManager shareLocation] getCity:^(NSString *addressString) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            networkWeather *strongSelf = _wself;
            NSString *targetName = addressString;
            
            if([[addressString substringFromIndex:addressString.length - 1] isEqualToString:@"市"]){
                 targetName = [addressString substringToIndex:(addressString.length-1)];
            }
            PSLog(@"city name :%@",targetName);
                        //寻找路径
            NSString *doc_path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
            //数据库路径
            NSString *sqlPath=[doc_path stringByAppendingPathComponent:@"cityname.sqlite"];
            
            //原始路径
            NSString *orignFilePath = [[NSBundle mainBundle] pathForResource:@"cityname" ofType:@"sqlite"];
            
            NSFileManager *fm = [NSFileManager defaultManager];
            
            if([fm fileExistsAtPath:sqlPath] == NO){
                NSError *err = nil;
                
                if([fm copyItemAtPath:orignFilePath toPath:sqlPath error:&err] == NO){
                    PSLog(@"open database error %@",[err localizedDescription]);
                }
            }
            
            FMDatabase *db=[FMDatabase databaseWithPath:sqlPath];
            if (![db open]) {
                PSLog(@"Init DB failed");
            }
            
            FMResultSet *resultSet=[db executeQuery:@"select * from citys"];
            NSString *tempName;
            NSString *tempNumber;
            NSString *cityNumber;
            
            while ([resultSet next]) {
                tempName = [resultSet stringForColumn:@"Name"];
                tempNumber = [resultSet stringForColumn:@"city_num"];
                NSArray *nameArray = [tempName componentsSeparatedByString:@"."];
                
                if (tempName.length<5) {
                    if ([tempName isEqualToString:targetName ]) {
                        cityNumber = tempNumber;
                        PSLog(@"DB search case a");
                    }
                }else{
                    NSString *cityName = [nameArray objectAtIndex:1];
                    if ([cityName isEqualToString:targetName ]) {
                        cityNumber = tempNumber;
                        PSLog(@"DB search case b");
                    }
                }
            }
            [db close];
            
            if (cityNumber == nil) {
                PSLog(@"city Number is Nil,uses PSLastCityNumber");
//                cityNumber = @"101210101";
                cityNumber = [_userDefaults objectForKey:PSLastCityNumber];
            }else{
                PSLog(@"cityNumber:%@",cityNumber);
                [_userDefaults setObject:cityNumber forKey:PSLastCityNumber];
            }
            
            NSString *string1 = @"http://www.weather.com.cn/data/sk/";
            NSString *string3 = @".html";
            NSString *weatherURLString = @"";
            weatherURLString = [weatherURLString stringByAppendingFormat:@"%@%@%@",string1,cityNumber,string3];
            PSLog(@"URL is :%@",weatherURLString);
            
            [strongSelf getWeather:weatherURLString];
            
            
            NSString *string4 = @"http://www.weather.com.cn/data/cityinfo/";
            NSString *weatherURLString1 = [NSString stringWithFormat:@"%@%@%@",string4,cityNumber,string3];
            PSLog(@"URL is :%@",weatherURLString1);
            
            [strongSelf getWeather:weatherURLString1];
        });//end of dispatch_async
        
    }];//end of getCity
}

/* upper and down temperature HZ http://www.weather.com.cn/data/cityinfo/101210101.html
jsonData {
    "weatherinfo" : {
        "img2" : "n2.gif",
        "city" : "杭州",
        "cityid" : "101210101",
        "temp1" : "32℃",
        "weather" : "多云转阴",
        "img1" : "d1.gif",
        "ptime" : "11:00",
        "temp2" : "22℃"
    }
}
 
 details of weather HZ        http://www.weather.com.cn/data/sk/101210101.html
 jsonData {
     "weatherinfo" : {
     "city" : "杭州",
     "cityid" : "101210101",
     "SD" : "50%",
     "WS" : "3级",
     "WSE" : "3",
     "time" : "12:45",
     "WD" : "南风",
     "isRadar" : "1",
     "Radar" : "JC_RADAR_AZ9571_JB",
     "temp" : "30"
     }
 }
*/
- (BOOL)getWeather:(NSString *)URLString
{
    if(![CheckNetwork isExistenceNetwork]) return NO;
    
    networkWeather *strongSelf = _wself;
    
    //    NSURL *url1 =  [NSURL URLWithString:@"http://www.weather.com.cn/data/cityinfo/101210101.html"];
    NSURL *url1 = [NSURL URLWithString:URLString];
    NSURLRequest *request1 = [[NSURLRequest alloc]initWithURL:url1 cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    //    NSData *received1 = [NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    __block NSDictionary *json;
    
    [NSURLConnection sendAsynchronousRequest:request1 queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError){
        
        if(data){
           json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&connectionError];
        }else{
            json = nil;
        }
        
        if(nil == json){
            PSLog(@"json is nil");
            NSString *lastMainWeather = [_userDefaults objectForKey:PSLastMainWeather];
            NSArray  *array       = @[lastMainWeather];
            if ([strongSelf.delegate respondsToSelector:@selector(gotWeatherInfo:)]) {
                [strongSelf.delegate gotWeatherInfo:array];
            }
            return ;
        }
        
        // print all the info obtained
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
        PSLog(@"jsonData %@",[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
        
        NSDictionary *json1 = [json objectForKey:[[json allKeys] objectAtIndex:0]];
        
        NSDictionary *sendDick;
        NSArray      *sendArray;
        NSString *currentTemp = [json1 objectForKey:@"temp"];
        [_userDefaults setObject:currentTemp forKey:PSLastCurrentTemp];
        
        if(currentTemp){
            NSString *humidity    = [json1 objectForKey:@"SD"];
            NSString *cityID      = [json1 objectForKey:@"cityid"];
            NSString *windPower   = [json1 objectForKey:@"WS"];
            [_userDefaults setObject:humidity forKey:PSLastHumidity];
            [_userDefaults setObject:windPower forKey:PSLastWindPower];
            
            sendArray = @[currentTemp,humidity,windPower,cityID];
            sendDick  = @{@"currentTemp":currentTemp,@"humidity":humidity,@"windPower":windPower,@"cityID":cityID};
        }else{
            NSString *maxTemp     = [json1 objectForKey:@"temp1"];
            NSString *minTemp     = [json1 objectForKey:@"temp2"];
            NSString *updatedTime = [json1 objectForKey:@"ptime"];
            NSString *weather     = [json1 objectForKey:@"weather"];
            [_userDefaults setObject:weather forKey:PSLastMainWeather];
            [_userDefaults setObject:maxTemp forKey:PSLastMaxTemp];
            [_userDefaults setObject:minTemp forKey:PSLastMinTemp];
            [_userDefaults setObject:updatedTime forKey:PSLastUpdatedTime];
            
            sendArray = @[weather,maxTemp,minTemp,updatedTime];
            sendDick  = @{@"mainWeather":weather,@"maxTemp":maxTemp,@"minTemp":minTemp,@"updatedTime":updatedTime};
        }
        
        if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(gotWeatherInfo:)]) {
            _sendWeatherInfoCompleted = [strongSelf.delegate gotWeatherInfo:sendDick];
        }
        
    }];
    
    if(json){
        return YES;
    }else {
        return NO;
    }
    
}



-(void)showCityNameResponse:(NSString *)cityName
{
    [[AFWeather sharedClient] fetchForecastOfLocationWithName:cityName andCompletionBlock:^(NSDictionary *response, NSError *error) {
        if (!error) {
            NSData *data = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:nil];
            PSLog(@"jsonData %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            
            NSDictionary *jsonData = [response objectForKey:@"data"];
            NSArray *jsonCurrentCondition = [jsonData valueForKey:@"current_condition"];
            NSDictionary *currentDetails = [jsonCurrentCondition objectAtIndex:0];
            //                NSArray *keyArray1 = [json3 allKeys];
            
            NSString *text0,*text1;
            text0 = [currentDetails objectForKey:@"temp_C"];
            PSLog(@"temp_C: %@",text0);
            
            text1 = [[[currentDetails objectForKey:@"weatherDesc"] objectAtIndex:0] valueForKey:@"value"];
            PSLog(@"weatherDesc: %@",text1);
        }
    }];
}

@end
