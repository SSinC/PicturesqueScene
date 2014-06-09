//
//  defines.h
//  PicturesqueScene
//
//  Created by Stan on 14-5-16.
//  Copyright (c) 2014年 Stan. All rights reserved.
//

#ifndef PicturesqueScene_defines_h
#define PicturesqueScene_defines_h

#define __IPHONE_OS_VERSION_SOFT_MAX_REQUIRED __IPHONE_7_0

//Location Info
#define  PSLastLongitude    @"PSLastLongitude"
#define  PSLastLatitude     @"PSLastLatitude"
#define  PSLastCity         @"PSLastCity"
#define  PSLastAddress      @"PSLastAddress"
#define  PSLastCityNumber   @"PSLastCityNumber"

//Weather Info
#define  PSLastMainWeather      @"PSLastMainWeather"
#define  PSLastMainWeatherType  @"PSLastMainWeatherType"
#define  PSLastCurrentTemp      @"PSLastCurrentTemp"
#define  PSLastHumidity         @"PSLastHumidity"
#define  PSLastWindPower        @"PSLastWindPower"
#define  PSLastMaxTemp          @"PSLastMaxTemp"
#define  PSLastMinTemp          @"PSLastMinTemp"
#define  PSLastUpdatedTime      @"PSLastUpdatedTime"

#define ENABLE_LOGGING_DEBUG 1

#if ENABLE_LOGGING_DEBUG
#define PSLog NSLog
#else
#define PSLog(...)
#endif

#endif
