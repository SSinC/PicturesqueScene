//
//  CityCollectionViewController.h
//  PicturesqueScene
//
//  Created by Sara on 5/20/14.
//  Copyright (c) 2014 Stan. All rights reserved.
//




#import <UIKit/UIKit.h>
#import "WeatherUI.h"
#import "CityChooseViewController.h"

@protocol CityIconClickDelegate <NSObject>

@required
- (void) ButtonClicked :(id)sender;
@end


@interface CityCollectionViewDataItem : NSObject
@property(nonatomic) BOOL enable;
@property(nonatomic) NSString*  city;

- (void)setWithCityName:(NSString *)city enable:(BOOL)enable;

@end

@interface CityCollectionViewCell : UICollectionViewCell

@property(nonatomic) BOOL enable;
@property(nonatomic) NSString* title;

@property(nonatomic,readwrite) NSInteger buttonTag;
@property(nonatomic) id <CityIconClickDelegate> delegate;

@end



@interface CityCollectionViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,CityIconClickDelegate>
@property(nonatomic)NSMutableArray *cityDataList;
@end

