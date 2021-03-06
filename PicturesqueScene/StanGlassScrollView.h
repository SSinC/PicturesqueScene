//
//  StanGlassScrollView.h
//  PicturesqueScene
//
//  Created by stan on 3/25/14.
//  Copyright (c) 2014 stan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+ImageEffects.h"

//default blur settings
#define DEFAULT_BLUR_RADIUS 14
#define DEFAULT_BLUR_TINT_COLOR [UIColor colorWithWhite:0 alpha:.3]
#define DEFAULT_BLUR_DELTA_FACTOR 1.4

//how much the background moves when scroll
#define DEFAULT_MAX_BACKGROUND_MOVEMENT_VERTICAL 25
#define DEFAULT_MAX_BACKGROUND_MOVEMENT_HORIZONTAL 150


//the value of the fading space on the top between the view and navigation bar
#define DEFAULT_TOP_FADING_HEIGHT_HALF 10

@protocol StanGlassScrollViewDelegate;

@interface StanGlassScrollView : UIView <UIScrollViewDelegate>
//width = 640 + 2 * DEFAULT_MAX_BACKGROUND_MOVEMENT_VERTICAL
//height = 1136 + DEFAULT_MAX_BACKGROUND_MOVEMENT_VERTICAL
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) UIImage *blurredBackgroundImage;//default blurred is provided, thus nil is acceptable
@property (nonatomic, assign) CGFloat viewDistanceFromBottom;//how much view is showed up from the bottom
@property (nonatomic, strong) UIView *foregroundView;//the view that will contain all the info
@property (nonatomic, assign) CGFloat topLayoutGuideLength;//set this only when using navigation bar of sorts.
@property (nonatomic, strong, readonly) UIScrollView *foregroundScrollView;//readonly just to get the scroll offsets
@property (nonatomic, weak) id<StanGlassScrollViewDelegate> delegate;

//stan
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *popOverView;
@property (nonatomic, strong) UIView *citySwitchView;
@property (nonatomic, strong) UIView *infoView;
@property (nonatomic, strong) UIView *headerView;
//- (void)showMovieView:(UIView *)movieView afterDelay:(float)delay;
- (void)showMovieView:(UIView *)movieView;
- (void)dismissMovieView;
- (id)initWithFrame:(CGRect)frame BackgroundImage:(UIImage *)backgroundImage BackgroundView:(UIView *)backgroundView blurredImage:(UIImage *)blurredImage viewDistanceFromBottom:(CGFloat)viewDistanceFromBottom foregroundView:(UIView *)foregroundView popOverView:(UIView *)popOverView headerView:(UIView *)headerView citySwitchView:(UIView *)citySwitchView infoView:(UIView *)infoView testViewController:(UIViewController *)testViewController;


- (id)initWithFrame:(CGRect)frame BackgroundImage:(UIImage *)backgroundImage blurredImage:(UIImage *)blurredImage viewDistanceFromBottom:(CGFloat)viewDistanceFromBottom foregroundView:(UIView *)foregroundView popOverView:(UIView *)popOverView;

- (void)scrollHorizontalRatio:(CGFloat)ratio;//from -1 to 1
- (void)scrollVerticallyToOffset:(CGFloat)offsetY;
// change background image on the go
- (void)setBackgroundImage:(UIImage *)backgroundImage overWriteBlur:(BOOL)overWriteBlur animated:(BOOL)animated duration:(NSTimeInterval)interval;
- (void)blurBackground:(BOOL)shouldBlur;
@end


@protocol StanGlassScrollViewDelegate <NSObject>
@optional
//use this to configure your foregroundView when the frame of the whole view changed
- (void)glassScrollView:(StanGlassScrollView *)glassScrollView didChangedToFrame:(CGRect)frame;
//make custom blur without messing with default settings
- (UIImage*)glassScrollView:(StanGlassScrollView *)glassScrollView blurForImage:(UIImage *)image;

//- (void)
@end