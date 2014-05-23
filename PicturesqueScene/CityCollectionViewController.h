//
//  CityCollectionViewController.h
//  PicturesqueScene
//
//  Created by Sara on 5/20/14.
//  Copyright (c) 2014 Stan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CityIconClickDelegate <NSObject>

@required
- (void) ButtonClicked :(id)sender;
@end


@interface CityCollectionViewDataItem : NSObject
@property(nonatomic) BOOL enable;
@property(nonatomic) NSString*  city;
@end

@interface CityCollectionViewCell : UICollectionViewCell

@property(nonatomic) BOOL enable;
@property(nonatomic) NSString* title;
@property(nonatomic) id <CityIconClickDelegate> delegate;

@end



@interface CityCollectionViewController : UIViewController <CityIconClickDelegate>
//@property(nonatomic,strong)    UICollectionView*   collectionView;
//@property (nonatomic, strong) UIView* contentView;
@end


@interface cityCollectoinView : UICollectionView <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property(nonatomic)NSMutableArray *dataArray;
@end