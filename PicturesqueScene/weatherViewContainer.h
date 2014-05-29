//
//  weatherViewContainer.h
//  PicturesqueScene
//
//  Created by Stan on 14-5-29.
//  Copyright (c) 2014年 Stan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherUI.h"

@interface weatherViewContainer : NSObject

@property weatherDataItem       *weatherDataItem;
@property weatherInfoDetailView *weatherInfoDetailView;
@property weatherForecastView   *weatherForecastView;
@property weatherHeaderView     *headerView;

@end
