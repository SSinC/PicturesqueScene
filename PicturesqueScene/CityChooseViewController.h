//
//  CityChooseViewController.h
//  PicturesqueScene
//
//  Created by Sara on 5/29/14.
//  Copyright (c) 2014 Stan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopularCityCollectionCell : UICollectionViewCell
@property(nonatomic) NSString *     cityname;
@end

/******************  CityChooseViewController  ******************/

@interface SuggestionsTableController : UITableViewController

-(id)initWithArray:(NSArray*)array;
-(void)showSuggestionsFor:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string;


@end



/******************  CityChooseViewController  ******************/

@interface CityChooseViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>

@property(nonatomic) SuggestionsTableController * suggestList;
@property(nonatomic) NSArray * cityList;
@property(nonatomic) UICollectionView * popularCityView;

@end


