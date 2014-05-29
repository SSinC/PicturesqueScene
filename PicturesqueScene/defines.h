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

#define  PSLastLongitude    @"PSLastLongitude"
#define  PSLastLatitude     @"PSLastLatitude"
#define  PSLastCity         @"PSLastCity"
#define  PSLastAddress      @"PSLastAddress"
#define  PSLastCityNumber   @"PSLastCityNumber"
#define  PSLastMainWeather  @"PSLastMainWeather"
#define  PSLastCurrentTemp  @"PSLastCurrentTemp"

#define ENABLE_LOGGING_DEBUG 1

#if ENABLE_LOGGING_DEBUG
#define PSLog NSLog
#else
#define PSLog(...)
#endif

#endif
