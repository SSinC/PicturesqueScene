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
    BOOL            _sendWeatherInfoCompleted;
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
            
            //            NSString *targetName = [addressString substringToIndex:(addressString.length-1)];
            NSString *targetName = addressString;
            NSLog(@"city name :%@",targetName);
            
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
                    NSLog(@"open database error %@",[err localizedDescription]);
                }
            }
            
            FMDatabase *db=[FMDatabase databaseWithPath:sqlPath];
            
            if (![db open]) {
                NSLog(@"Init DB failed");
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
                        NSLog(@"DB search case a");
                    }
                }else{
                    NSString *cityName = [nameArray objectAtIndex:1];
                    if ([cityName isEqualToString:targetName ]) {
                        cityNumber = tempNumber;
                        NSLog(@"DB search case b");
                    }
                }
            }
            [db close];
            
            if (cityNumber == nil) {
                NSLog(@"city Number is Nil,uses PSLastCityNumber");
//                cityNumber = @"101210101";
                cityNumber = [_userDefaults objectForKey:PSLastCityNumber];
            }else{
                NSLog(@"cityNumber:%@",cityNumber);
                [_userDefaults setObject:cityNumber forKey:PSLastCityNumber];
            }
            
            NSString *string1 = @"http://www.weather.com.cn/data/cityinfo/";
            NSString *string3 = @".html";
            NSString *weatherURLString = @"";
            weatherURLString = [weatherURLString stringByAppendingFormat:@"%@%@%@",string1,cityNumber,string3];
            
            NSLog(@"URL is :%@",weatherURLString);
            
            [self getWeather:weatherURLString];
            
        });//end of dispatch_async
        
    }];//end of getCity
}

// upper and down temperature HZ http://www.weather.com.cn/data/cityinfo/101210101.html
// {"weatherinfo":{"city":"杭州","cityid":"101210101","temp1":"22℃","temp2":"17℃","weather":"阵雨转阴","img1":"d3.gif","img2":"n2.gif","ptime":"11:00"}}
// details of weather HZ        http://www.weather.com.cn/data/sk/101210101.html
// {"weatherinfo":{"city":"杭州","cityid":"101210101","temp":"20","WD":"东南风","WS":"1级","SD":"68%","WSE":"1","time":"13:25","isRadar":"1","Radar":"JC_RADAR_AZ9571_JB"}}

- (NSString *)getWeather:(NSString *)URLString
{
    if(![CheckNetwork isExistenceNetwork]) return nil;
    
    //    NSURL *url1 =  [NSURL URLWithString:@"http://www.weather.com.cn/data/cityinfo/101210101.html"];
    NSURL *url1 = [NSURL URLWithString:URLString];
    NSURLRequest *request1 = [[NSURLRequest alloc]initWithURL:url1 cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    //    NSData *received1 = [NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    __block NSString *text0,*text1,*text2,*text3,*text4,*text5,*text6,*text7,*text8,*text9;
    
    //        NSString *text8 = [json1 objectForKey:[keyArray1 objectAtIndex:8]];
    //        NSString *text9 = [json1 objectForKey:[keyArray1 objectAtIndex:9]];
    
    [NSURLConnection sendAsynchronousRequest:request1 queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError){
        
        NSDictionary *json;
        if(data){
           json = [NSJSONSerialization
                              JSONObjectWithData:data
                              options:kNilOptions
                              error:&connectionError];
        }else{
            json = nil;
        }
        
        if(nil == json){
            NSLog(@"json is nil");
            NSString *lastMainWeather = [_userDefaults objectForKey:PSLastMainWeather];
            if ([self.delegate respondsToSelector:@selector(gotWeatherInfo:)]) {
                [self.delegate gotWeatherInfo:lastMainWeather];
            }
            return ;
        }
        
        // print all the info obtained
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
        NSLog(@"jsonData %@",[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
        
        NSDictionary *json1 = [json objectForKey:[[json allKeys]objectAtIndex:0]];
        NSArray *keyArray1 = [json1 allKeys];
        text0 = [json1 objectForKey:[keyArray1 objectAtIndex:0]];
        text1 = [json1 objectForKey:[keyArray1 objectAtIndex:1]];
        text2 = [json1 objectForKey:[keyArray1 objectAtIndex:2]];
        text3 = [json1 objectForKey:[keyArray1 objectAtIndex:3]];
        text4 = [json1 objectForKey:[keyArray1 objectAtIndex:4]];
        text5 = [json1 objectForKey:[keyArray1 objectAtIndex:5]];
        text6 = [json1 objectForKey:[keyArray1 objectAtIndex:6]];
        text7 = [json1 objectForKey:[keyArray1 objectAtIndex:7]];
        //        text8 = [json1 objectForKey:[keyArray1 objectAtIndex:8]];
        //        text9 = [json1 objectForKey:[keyArray1 objectAtIndex:9]];
        
        //         NSLog(@"weather info: %@, %@ ,%@ ,%@ ,%@ ,%@ ,%@ ,%@ ,%@ ,%@",text0,text1,text2,text3,text4,text5,text6,text7,text8,text9);
        //         NSLog(@"weather info: %@, %@ ,%@ ,%@ ,%@ ,%@ ,%@ ,%@ ",text0,text1,text2,text3,text4,text5,text6,text7);
        
        [_userDefaults setObject:text4 forKey:PSLastMainWeather];
        if ([self.delegate respondsToSelector:@selector(gotWeatherInfo:)]) {
            _sendWeatherInfoCompleted = [self.delegate gotWeatherInfo:text4];
        }
    }];
    
    
    //     NSError* error;
    //    NSDictionary* json = [NSJSONSerialization
    //                          JSONObjectWithData:received1 //1
    //                          options:kNilOptions
    //                          error:&error];
    //    if(nil == json){
    //        NSLog(@"json is nil");
    //    }
    //
    //    NSDictionary *json1 = [json valueForKey:[[json allKeys]objectAtIndex:0]];
    //    NSArray * keyArray1 = [json1 allKeys];
    //    NSLog(@"length: %i",keyArray1.count);
    //    NSString *text0 = [json1 objectForKey:[keyArray1 objectAtIndex:0]];
    //    NSString *text1 = [json1 objectForKey:[keyArray1 objectAtIndex:1]];
    //    NSString *text2 = [json1 objectForKey:[keyArray1 objectAtIndex:2]];
    //    NSString *text3 = [json1 objectForKey:[keyArray1 objectAtIndex:3]];
    //    NSString *text4 = [json1 objectForKey:[keyArray1 objectAtIndex:4]];
    //    NSString *text5 = [json1 objectForKey:[keyArray1 objectAtIndex:5]];
    //    NSString *text6 = [json1 objectForKey:[keyArray1 objectAtIndex:6]];
    //    NSString *text7 = [json1 objectForKey:[keyArray1 objectAtIndex:7]];
    //    NSString *text8 = [json1 objectForKey:[keyArray1 objectAtIndex:8]];
    //    NSString *text9 = [json1 objectForKey:[keyArray1 objectAtIndex:9]];
    //
    ////    JSONDecoder * jd = [[JSONDecoder alloc]init];
    ////    NSDictionary * result = [jd objectWithData:received1];
    ////    NSDictionary * a = [result valueForKey:[[result allKeys]objectAtIndex:0]];
    ////    NSArray * keyArray = [a allKeys];
    ////    NSString *text1 = [a objectForKey:[keyArray objectAtIndex:6]];
    ////
    ////    NSString *text2 = [a objectForKey:[keyArray objectAtIndex:0]];
    //
    //    NSLog(@"weather info: %@, %@ ,%@ ,%@ ,%@ ,%@ ,%@ ,%@ ,%@ ,%@",text0,text1,text2,text3,text4,text5,text6,text7,text8,text9);
    
    return text4;
}



-(void)showCityNameResponse:(NSString *)cityName
{
    [[AFWeather sharedClient]fetchForecastOfLocationWithName:cityName andCompletionBlock:^(NSDictionary *response, NSError *error) {
        if (!error) {
            NSData *data = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:nil];
            NSLog(@"jsonData %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            
            NSDictionary *jsonData = [response objectForKey:@"data"];
            NSArray *jsonCurrentCondition = [jsonData valueForKey:@"current_condition"];
            NSDictionary *currentDetails = [jsonCurrentCondition objectAtIndex:0];
            //                NSArray *keyArray1 = [json3 allKeys];
            
            NSString *text0,*text1;
            text0 = [currentDetails objectForKey:@"temp_C"];
            NSLog(@"temp_C: %@",text0);
            
            text1 = [[[currentDetails objectForKey:@"weatherDesc"] objectAtIndex:0] valueForKey:@"value"];
            NSLog(@"weatherDesc: %@",text1);
        }
    }];
}

@end
