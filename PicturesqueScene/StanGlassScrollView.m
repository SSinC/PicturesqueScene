//
//  StanGlassScrollView.m
//  PicturesqueScene
//
//  Created by stan on 3/25/14.
//  Copyright (c) 2014 stan. All rights reserved.
//

#import "StanGlassScrollView.h"
#import "FXBlurView.h"

@implementation UIView (rn_Screenshot)

- (UIImage *)rn_screenshot {
    UIGraphicsBeginImageContext(self.bounds.size);
    if([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]){
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    }
    else{
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImageJPEGRepresentation(image, 0.75);
    image = [UIImage imageWithData:imageData];
    return image;
}

@end

@implementation StanGlassScrollView
{
    UIScrollView *_backgroundScrollView;
    UIView *_constraitView; // for autolayout
    UIImageView *_backgroundImageView;
    //    UIImageView *_blurredBackgroundImageView;
    UIView *_blurredBackgroundImageView;
    
    CALayer *_topShadowLayer;
    CALayer *_botShadowLayer;
    
    UIView *_foregroundContainerView; // for masking
    UIImageView *_topMaskImageView;
    
    //stan
    //    UIView *_backgroundView;
    //    UIView *_popOverView;
    //    UIView *_citySwitchView;
    //    UIView *_infoView;
    //    UIView *_headerView;
    CGPoint _headerViewOrgin;
    
    BOOL _popOverViewShowed;
    BOOL _scrollViewShowed;
    BOOL _headerViewShowed;
    BOOL _infoViewShowed;
    BOOL _cityViewShowed;
    
    BOOL _blurredBackgroundViewShowed;
    BOOL _isRetina;
}


- (id)initWithFrame:(CGRect)frame BackgroundImage:(UIImage *)backgroundImage blurredImage:(UIImage *)blurredImage viewDistanceFromBottom:(CGFloat)viewDistanceFromBottom foregroundView:(UIView *)foregroundView popOverView:(UIView *)popOverView
{
    self = [super initWithFrame:frame];
    if (self) {
        _isRetina = [self _detectScreenScale] == 2.0f;
        
        //initialize values
        _backgroundImage = backgroundImage;
//        if (blurredImage) {
        if(!_isRetina){
            _blurredBackgroundImage = blurredImage;
        }else{
            if ([_delegate respondsToSelector:@selector(glassScrollView:blurForImage:)]) {
                _blurredBackgroundImage = [_delegate glassScrollView:self blurForImage:_backgroundImage];
            } else {
                _blurredBackgroundImage = [backgroundImage applyBlurWithRadius:DEFAULT_BLUR_RADIUS tintColor:DEFAULT_BLUR_TINT_COLOR saturationDeltaFactor:DEFAULT_BLUR_DELTA_FACTOR maskImage:nil];
            }
        }
        _viewDistanceFromBottom = viewDistanceFromBottom;
        _foregroundView = foregroundView;
        _popOverView = popOverView;
        
        //autoresize
        [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        
        //create views
        [self createBackgroundView];
        [self createForegroundView];
        [self createTopShadow];
        [self createBottomShadow];
        [self createPopView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame BackgroundImage:(UIImage *)backgroundImage BackgroundView:(UIView *)backgroundView blurredImage:(UIImage *)blurredImage viewDistanceFromBottom:(CGFloat)viewDistanceFromBottom foregroundView:(UIView *)foregroundView popOverView:(UIView *)popOverView headerView:(UIView *)headerView citySwitchView:(UIView *)citySwitchView infoView:(UIView *)infoView
{
    self = [super initWithFrame:frame];
    if (self) {
        //initialize values
        //        _backgroundImage = backgroundImage;
        _isRetina = [self _detectScreenScale] == 2.0f;
        
//        if (blurredImage) {
        if(!_isRetina){
            _blurredBackgroundImage = blurredImage;
        }else{
            if ([_delegate respondsToSelector:@selector(glassScrollView:blurForImage:)]) {
                _blurredBackgroundImage = [_delegate glassScrollView:self blurForImage:_backgroundImage];
            } else {
                //                 UIImage *blurImage = [backgroundView rn_screenshot];
//                UIView *whiteView = [[UIView alloc] initWithFrame:backgroundView.frame];
//                whiteView.backgroundColor = [UIColor whiteColor];
//                UIImage *blurImage = [whiteView rn_screenshot];
//                _blurredBackgroundImage = [blurImage applyBlurWithRadius:DEFAULT_BLUR_RADIUS tintColor:DEFAULT_BLUR_TINT_COLOR saturationDeltaFactor:DEFAULT_BLUR_DELTA_FACTOR maskImage:nil];
                 _blurredBackgroundImage = [backgroundImage applyBlurWithRadius:25 tintColor:[UIColor clearColor] saturationDeltaFactor:1.4 maskImage:nil];
            }
        }
        _backgroundImage = backgroundImage;
        _backgroundView = backgroundView;
        
        _viewDistanceFromBottom = viewDistanceFromBottom;
        _foregroundView = foregroundView;
        _popOverView = popOverView;
        _headerView = headerView;
        _citySwitchView = citySwitchView;
        _infoView = infoView;
        
        //autoresize
        [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        
        //create views
        [self createBackgroundView];
        [self createForegroundView];
        [self createTopShadow];
        [self createBottomShadow];
        [self createPopView];
        [self createHeaderView];
        [self createCitySwitchView];
        [self createInfoView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleInfoButtonClick1) name:@"infoButtonClick1" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleCityButtonClick1) name:@"cityButtonClick1" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleViewScrolled) name:@"viewScrolled" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleSideBarDismiss) name:@"sideBarDismiss" object:nil];
        
    }
    return self;
}

- (CGFloat)_detectScreenScale
{
    CGFloat scale = 1.0;
    if([UIScreen instancesRespondToSelector:@selector(scale)])
    {
        scale = [[UIScreen mainScreen] scale];
        scale = MAX(scale, 1.0);
    }
    return scale;
}

- (void)handleViewScrolled
{
    [self dismissMovieView];
}

- (void)handleSideBarDismiss
{
    if(_infoViewShowed){
        [self infoViewDismissAnimate:YES];
    }
    else if(_cityViewShowed){
        [self cityViewDismissAnimate:YES];
    }
}

#pragma mark - Public Functions

- (void)scrollHorizontalRatio:(CGFloat)ratio
{
    // when the view scroll horizontally, this works the parallax magic
    [_backgroundScrollView setContentOffset:CGPointMake(DEFAULT_MAX_BACKGROUND_MOVEMENT_HORIZONTAL + ratio * DEFAULT_MAX_BACKGROUND_MOVEMENT_HORIZONTAL, _backgroundScrollView.contentOffset.y)];
}

- (void)scrollVerticallyToOffset:(CGFloat)offsetY
{
    [_foregroundScrollView setContentOffset:CGPointMake(_foregroundScrollView.contentOffset.x, offsetY)];
}

#pragma mark - Setters
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    //work background
    CGRect bounds = CGRectOffset(frame, -frame.origin.x, -frame.origin.y);
    
    //    [_backgroundScrollView setFrame:bounds];
    //    [_backgroundScrollView setContentSize:CGSizeMake(bounds.size.width + 2*DEFAULT_MAX_BACKGROUND_MOVEMENT_HORIZONTAL, self.bounds.size.height + DEFAULT_MAX_BACKGROUND_MOVEMENT_VERTICAL)];
    //    [_backgroundScrollView setContentOffset:CGPointMake(DEFAULT_MAX_BACKGROUND_MOVEMENT_HORIZONTAL, 0)];
    //
    //    [_constraitView setFrame:CGRectMake(0, 0, bounds.size.width + 2*DEFAULT_MAX_BACKGROUND_MOVEMENT_HORIZONTAL, bounds.size.height + DEFAULT_MAX_BACKGROUND_MOVEMENT_VERTICAL)];
    
    //foreground
    //    [_foregroundContainerView setFrame:bounds];
    //    [_foregroundScrollView setFrame:bounds];
    //    [_foregroundView setFrame:CGRectOffset(_foregroundView.bounds, (_foregroundScrollView.frame.size.width - _foregroundView.bounds.size.width)/2, _foregroundScrollView.frame.size.height - _foregroundScrollView.contentInset.top - _viewDistanceFromBottom)];
    //    [_foregroundScrollView setContentSize:CGSizeMake(bounds.size.width, _foregroundView.frame.origin.y + _foregroundView.bounds.size.height)];
    
    //shadows
    //[self createTopShadow];
    [_topShadowLayer setFrame:CGRectMake(0, 0, bounds.size.width, _foregroundScrollView.contentInset.top + DEFAULT_TOP_FADING_HEIGHT_HALF)];
    [_botShadowLayer setFrame:CGRectMake(0, bounds.size.height - _viewDistanceFromBottom, bounds.size.width, bounds.size.height)];//CGRectOffset(_botShadowLayer.bounds, 0, frame.size.height - _viewDistanceFromBottom)];
    
    if (_delegate && [_delegate respondsToSelector:@selector(glassScrollView:didChangedToFrame:)]) {
        [_delegate glassScrollView:self didChangedToFrame:frame];
    }
}

- (void)setTopLayoutGuideLength:(CGFloat)topLayoutGuideLength
{
    if (topLayoutGuideLength == 0) {
        return;
    }
    
    //set inset
    [_foregroundScrollView setContentInset:UIEdgeInsetsMake(topLayoutGuideLength, 0, 0, 0)];
    
    //reposition
    [_foregroundView setFrame:CGRectOffset(_foregroundView.bounds, (_foregroundScrollView.frame.size.width - _foregroundView.bounds.size.width)/2, _foregroundScrollView.frame.size.height - _foregroundScrollView.contentInset.top - _viewDistanceFromBottom)];
    
    //resize contentSize
    [_foregroundScrollView setContentSize:CGSizeMake(self.frame.size.width, _foregroundView.frame.origin.y + _foregroundView.frame.size.height)];
    
    //reset the offset
    if (_foregroundScrollView.contentOffset.y == 0) {
        [_foregroundScrollView setContentOffset:CGPointMake(0, -_foregroundScrollView.contentInset.top)];
    }
    
    //adding new mask
    _foregroundContainerView.layer.mask = [self createTopMaskWithSize:CGSizeMake(_foregroundContainerView.frame.size.width, _foregroundContainerView.frame.size.height) startFadeAt:_foregroundScrollView.contentInset.top - DEFAULT_TOP_FADING_HEIGHT_HALF endAt:_foregroundScrollView.contentInset.top + DEFAULT_TOP_FADING_HEIGHT_HALF topColor:[UIColor colorWithWhite:1.0 alpha:0.0] botColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
    
    //recreate shadow
    [self createTopShadow];
}


- (void)setViewDistanceFromBottom:(CGFloat)viewDistanceFromBottom
{
    _viewDistanceFromBottom = viewDistanceFromBottom;
    
    [_foregroundView setFrame:CGRectOffset(_foregroundView.bounds, (_foregroundScrollView.frame.size.width - _foregroundView.bounds.size.width)/2, _foregroundScrollView.frame.size.height - _foregroundScrollView.contentInset.top - _viewDistanceFromBottom)];
    [_foregroundScrollView setContentSize:CGSizeMake(self.frame.size.width, _foregroundView.frame.origin.y + _foregroundView.frame.size.height)];
    
    //shadows
    [_botShadowLayer setFrame:CGRectOffset(_botShadowLayer.bounds, 0, self.frame.size.height - _viewDistanceFromBottom)];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage overWriteBlur:(BOOL)overWriteBlur animated:(BOOL)animated duration:(NSTimeInterval)interval
{
    _backgroundImage = backgroundImage;
    if (overWriteBlur) {
        _blurredBackgroundImage = [backgroundImage applyBlurWithRadius:DEFAULT_BLUR_RADIUS tintColor:DEFAULT_BLUR_TINT_COLOR saturationDeltaFactor:DEFAULT_BLUR_DELTA_FACTOR maskImage:nil];
    }
    
    if (animated) {
        UIImageView *previousBackgroundImageView = _backgroundImageView;
        UIImageView *previousBlurredBackgroundImageView = _blurredBackgroundImageView;
        [self createBackgroundImageView];
        
        [_backgroundImageView setAlpha:0];
        [_blurredBackgroundImageView setAlpha:0];
        
        // blur needs to get animated first if the background is blurred
        if (previousBlurredBackgroundImageView.alpha == 1) {
            [UIView animateWithDuration:interval animations:^{
                [_blurredBackgroundImageView setAlpha:previousBlurredBackgroundImageView.alpha];
            } completion:^(BOOL finished) {
                [_backgroundImageView setAlpha:previousBackgroundImageView.alpha];
                [previousBackgroundImageView removeFromSuperview];
                [previousBlurredBackgroundImageView removeFromSuperview];
            }];
        } else {
            [UIView animateWithDuration:interval animations:^{
                [_backgroundImageView setAlpha:previousBackgroundImageView.alpha];
                [_blurredBackgroundImageView setAlpha:previousBlurredBackgroundImageView.alpha];
            } completion:^(BOOL finished) {
                [previousBackgroundImageView removeFromSuperview];
                [previousBlurredBackgroundImageView removeFromSuperview];
            }];
        }
        
        
    } else {
        [_backgroundImageView setImage:_backgroundImage];
        if ([_blurredBackgroundImageView isKindOfClass:[UIImageView class]]) {
            //            [_blurredBackgroundImageView setImage:_blurredBackgroundImage];
            
        }
    }
}


- (void)blurBackground:(BOOL)shouldBlur
{
    [_blurredBackgroundImageView setAlpha:shouldBlur?1:0];
}

#pragma mark - Views creation
#pragma mark ScrollViews

- (void)createBackgroundView
{
    //background
    _backgroundScrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    [_backgroundScrollView setUserInteractionEnabled:NO];
    [_backgroundScrollView setContentSize:CGSizeMake(self.frame.size.width + 2*DEFAULT_MAX_BACKGROUND_MOVEMENT_HORIZONTAL, self.frame.size.height + DEFAULT_MAX_BACKGROUND_MOVEMENT_VERTICAL)];
    [_backgroundScrollView setContentOffset:CGPointMake(DEFAULT_MAX_BACKGROUND_MOVEMENT_HORIZONTAL, 0)];
    [self addSubview:_backgroundScrollView];
    
    _constraitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width + 2*DEFAULT_MAX_BACKGROUND_MOVEMENT_HORIZONTAL, self.frame.size.height + DEFAULT_MAX_BACKGROUND_MOVEMENT_VERTICAL)];
    [_backgroundScrollView addSubview:_constraitView];
    
    //stan
    if (!_backgroundView) {
        [self createBackgroundImageView];
    }else{
        [self createBackgroundViewWithoutImage];
    }
    
}

//- (void)showMovieView:(UIView *)movieView afterDelay:(float)delay
- (void)showMovieView:(UIView *)movieView
{
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        _backgroundView = movieView;
        _backgroundView.alpha = 0.0;
        _backgroundView.frame = CGRectMake(0, 0, 1024 + 300, 785);
        //NSLog(@"123 width is: %f, height is:%f",self.frame.size.width,self.frame.size.height);
        [_backgroundView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_backgroundView setContentMode:UIViewContentModeScaleToFill];
        
        [_constraitView insertSubview:_backgroundView belowSubview:_backgroundImageView];
        
        [_constraitView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_backgroundView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_backgroundView)]];
        [_constraitView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_backgroundView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_backgroundView)]];
        
        if(!_blurredBackgroundImageView){
            if(!_isRetina){
                FXBlurView *blur = [[FXBlurView alloc] initWithFrame:_backgroundView.frame];
                blur.underlyingView = [[UIImageView alloc]initWithImage:_blurredBackgroundImage];
                [blur.underlyingView setContentMode:UIViewContentModeScaleAspectFill];
                
                //            if(_isRetina){
                //               [blur.underlyingView setFrame:CGRectMake(0,0,2030,1550)];
                //            }
//                NSLog(@"blur.underlyingView width is: %f, height is:%f",blur.underlyingView.frame.size.width,blur.underlyingView.frame.size.height);
                blur.tintColor = [UIColor clearColor];
                blur.blurEnabled = YES;
                blur.dynamic  = YES;
                blur.blurRadius = 40;
                _blurredBackgroundImageView = blur;
            }else{
                _blurredBackgroundImageView = [[UIImageView alloc] initWithImage:_blurredBackgroundImage];
            }
            
            [_blurredBackgroundImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
            [_blurredBackgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
            //        [_blurredBackgroundImageView setContentMode:UIViewContentModeScaleToFill];
            [_blurredBackgroundImageView setAlpha:0.0];
            [_constraitView addSubview:_blurredBackgroundImageView];
            
            [_constraitView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_blurredBackgroundImageView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_blurredBackgroundImageView)]];
            [_constraitView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_blurredBackgroundImageView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_blurredBackgroundImageView)]];
        }
        
        //    if(!_scrollViewShowed){
        //
        //    }
    
    float delay;
    if(!_isRetina){
        delay = 4.5;
    }else{
        delay = 5.0;
    }
        [_constraitView bringSubviewToFront:_blurredBackgroundImageView];
        [UIView animateWithDuration:delay animations:^{
            _backgroundImageView.alpha = 0.0;
            _backgroundView.alpha = 1.0;
        }];

//    });
}


- (void)dismissMovieView
{
//    [UIView animateWithDuration:0.0 animations:^{
        _backgroundView.alpha = 0.0;
        _backgroundImageView.alpha = 1.0;
//    }];
    [_backgroundView removeFromSuperview];
    _backgroundView = nil;
}

- (void)createBackgroundViewWithoutImage
{
    
    
    [_backgroundView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_backgroundView setContentMode:UIViewContentModeScaleAspectFill];
    [_constraitView addSubview:_backgroundView];
    
    _backgroundImageView = [[UIImageView alloc] initWithImage:_backgroundImage];
    [_backgroundImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_backgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
    _backgroundImageView.alpha = 1.0;
    [_constraitView addSubview:_backgroundImageView];
    
    //    _blurredBackgroundImageView = [[UIImageView alloc] initWithImage:_blurredBackgroundImage];
    
    FXBlurView *blur = [[FXBlurView alloc] initWithFrame:self.frame];
    blur.underlyingView = [[UIImageView alloc]initWithImage:_blurredBackgroundImage];
    blur.tintColor = [UIColor clearColor];
    blur.blurEnabled = YES;
    blur.dynamic  = YES;
    blur.blurRadius = 124;
    _blurredBackgroundImageView = blur;
    
    [_blurredBackgroundImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_blurredBackgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_blurredBackgroundImageView setAlpha:0];
    [_constraitView addSubview:_blurredBackgroundImageView];
    
    [_constraitView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_backgroundView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_backgroundView)]];
    [_constraitView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_backgroundView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_backgroundView)]];
    [_constraitView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_backgroundImageView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_backgroundImageView)]];
    [_constraitView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_backgroundImageView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_backgroundImageView)]];
    [_constraitView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_blurredBackgroundImageView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_blurredBackgroundImageView)]];
    [_constraitView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_blurredBackgroundImageView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_blurredBackgroundImageView)]];
    
}

- (void)createBackgroundImageView
{
    _backgroundImageView = [[UIImageView alloc] initWithImage:_backgroundImage];
    [_backgroundImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_backgroundImageView setContentMode:UIViewContentModeScaleAspectFit];
    [_constraitView addSubview:_backgroundImageView];
//    _blurredBackgroundImageView = [[UIImageView alloc] initWithImage:_blurredBackgroundImage];
//    [_blurredBackgroundImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [_blurredBackgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
//    [_blurredBackgroundImageView setAlpha:0];
//    [_constraitView addSubview:_blurredBackgroundImageView];
    
    [_constraitView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_backgroundImageView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_backgroundImageView)]];
    [_constraitView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_backgroundImageView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_backgroundImageView)]];
//    [_constraitView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_blurredBackgroundImageView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_blurredBackgroundImageView)]];
//    [_constraitView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_blurredBackgroundImageView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_blurredBackgroundImageView)]];
}


- (void)createForegroundView
{
    _foregroundContainerView = [[UIView alloc] initWithFrame:self.frame];
    [self addSubview:_foregroundContainerView];
    //    NSLog(@"123 width is: %f, height is:%f",self.frame.size.width,self.frame.size.height);
    _foregroundScrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    [_foregroundScrollView setDelegate:self];
    [_foregroundScrollView setShowsVerticalScrollIndicator:NO];
    [_foregroundScrollView setShowsHorizontalScrollIndicator:NO];
    [_foregroundContainerView addSubview:_foregroundScrollView];
    
    UITapGestureRecognizer *_tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(foregroundTapped:)];
    //stan
    [self addGestureRecognizer:_tapRecognizer];
    //    [_foregroundScrollView addGestureRecognizer:_tapRecognizer];
    
    //stan
    //    [_foregroundView setFrame:CGRectOffset(_foregroundView.bounds, (_foregroundScrollView.frame.size.width - _foregroundView.bounds.size.width)/2, _foregroundScrollView.frame.size.height - _viewDistanceFromBottom)];
    [_foregroundView setFrame:CGRectOffset(_foregroundView.bounds, 0, _foregroundScrollView.frame.size.height - _viewDistanceFromBottom)];
    [_foregroundScrollView addSubview:_foregroundView];
    
    [_foregroundScrollView setContentSize:CGSizeMake(self.frame.size.width, _foregroundView.frame.origin.y + _foregroundView.frame.size.height)];
    //     NSLog(@"_foregroundScrollView.contentOffset.y : %f",_foregroundScrollView.contentOffset.y);
}

//stan
- (void)createPopView{
    _popOverView.alpha = .0f;
    _popOverView.center = self.center;
    [self addSubview:_popOverView];
}

- (void)createHeaderView{
    _headerView.alpha = 0.0f;
    //    _popOverView.center = self.center;
    _headerViewOrgin = _headerView.frame.origin;
    _headerView.frame = CGRectMake(self.frame.size.width + 5, _headerViewOrgin.y,_headerView.frame.size.width,_headerView.frame.size.height);
    [self addSubview:_headerView];
    [self headerViewShowAfterDelay:1.0];
}

- (void)createCitySwitchView
{
    _citySwitchView.alpha = .0f;
    _citySwitchView.center = self.center;
    [self addSubview:_citySwitchView];
    
}

- (void)createInfoView
{
    _infoView.alpha = .0f;
    _infoView.center = self.center;
    [self addSubview:_infoView];
}

#pragma mark Shadow and Mask Layer
- (CALayer *)createTopMaskWithSize:(CGSize)size startFadeAt:(CGFloat)top endAt:(CGFloat)bottom topColor:(UIColor *)topColor botColor:(UIColor *)botColor;
{
    top = top/size.height;
    bottom = bottom/size.height;
    
    CAGradientLayer *maskLayer = [CAGradientLayer layer];
    maskLayer.anchorPoint = CGPointZero;
    maskLayer.startPoint = CGPointMake(0.5f, 0.0f);
    maskLayer.endPoint = CGPointMake(0.5f, 1.0f);
    
    //an array of colors that dictatates the gradient(s)
    maskLayer.colors = @[(id)topColor.CGColor, (id)topColor.CGColor, (id)botColor.CGColor, (id)botColor.CGColor];
    maskLayer.locations = @[@0.0, @(top), @(bottom), @1.0f];
    maskLayer.frame = CGRectMake(0, 0, size.width, size.height);
    
    return maskLayer;
}
- (void)createTopShadow
{
    //changing the top shadow
    [_topShadowLayer removeFromSuperlayer];
    _topShadowLayer = [self createTopMaskWithSize:CGSizeMake(_foregroundContainerView.frame.size.width, _foregroundScrollView.contentInset.top + DEFAULT_TOP_FADING_HEIGHT_HALF) startFadeAt:_foregroundScrollView.contentInset.top - DEFAULT_TOP_FADING_HEIGHT_HALF endAt:_foregroundScrollView.contentInset.top + DEFAULT_TOP_FADING_HEIGHT_HALF topColor:[UIColor colorWithWhite:0 alpha:.15] botColor:[UIColor colorWithWhite:0 alpha:0]];
    [self.layer insertSublayer:_topShadowLayer below:_foregroundContainerView.layer];
}
- (void)createBottomShadow
{
    [_botShadowLayer removeFromSuperlayer];
    _botShadowLayer = [self createTopMaskWithSize:CGSizeMake(self.frame.size.width,_viewDistanceFromBottom) startFadeAt:0 endAt:_viewDistanceFromBottom topColor:[UIColor colorWithWhite:0 alpha:0] botColor:[UIColor colorWithWhite:0 alpha:.8]];
    [_botShadowLayer setFrame:CGRectOffset(_botShadowLayer.bounds, 0, self.frame.size.height - _viewDistanceFromBottom)];
    [self.layer insertSublayer:_botShadowLayer below:_foregroundContainerView.layer];
}


#pragma mark - Button
- (void)foregroundTapped:(UITapGestureRecognizer *)tapRecognizer{
    CGPoint tappedPoint = [tapRecognizer locationInView:self];
    //    NSLog(@"x is: %f, y is:%f",tappedPoint.x,tappedPoint.y);
    
    if (! CGRectContainsPoint(_foregroundView.frame, tappedPoint)) {
        //         CGFloat ratio = _foregroundScrollView.contentOffset.y == -_foregroundScrollView.contentInset.top? 1:0;
        //         [_foregroundScrollView setContentOffset:CGPointMake(0, ratio * _foregroundView.frame.origin.y - _foregroundScrollView.contentInset.top) animated:YES];
        if(!_popOverViewShowed && !_scrollViewShowed){
            [self headerViewDismissAfterDelay:0.1];
            if(_infoViewShowed){
                [self infoViewDismissAnimate:NO];
            }
            if(_cityViewShowed){
                [self cityViewDismissAnimate:NO];
            }
            _popOverViewShowed = YES;
            [UIView animateWithDuration:0.8
                                  delay:.0
                 usingSpringWithDamping:0.5
                  initialSpringVelocity:0.5
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 _popOverView.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1);
                                 _popOverView.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1);
                                 _popOverView.alpha = 1.0;
                             } completion:^(BOOL finished) {
                             }];
            
        }else if (!_popOverViewShowed){
            [self scrollViewDismiss];
        } else {
            [self popOverViewDimsmissAnimate:YES];
            [self headerViewShowAfterDelay:0.1];
        }
        //    if (tappedPoint.y < _foregroundScrollView.frame.size.height) {
        //        CGFloat ratio = _foregroundScrollView.contentOffset.y == -_foregroundScrollView.contentInset.top? 1:0;
        //        [_foregroundScrollView setContentOffset:CGPointMake(0, ratio * _foregroundView.frame.origin.y - _foregroundScrollView.contentInset.top) animated:YES];
        //    }
    }
}

- (void)popOverViewDimsmissAnimate:(BOOL)animate{
    _popOverViewShowed = NO;
    if(animate){
        _popOverView.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1);
        
        [UIView animateWithDuration:1.2
                              delay:.0
             usingSpringWithDamping:0.5
              initialSpringVelocity:0.5
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             _popOverView.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1);
                             _popOverView.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
                             _popOverView.alpha = 0.0;
                         } completion:^(BOOL finished) {
                         }];
    }else{
        _popOverView.alpha = 0.0;
    }
}

- (void)scrollViewDismiss
{
    _scrollViewShowed = NO;
    [UIView animateWithDuration:1.2
                          delay:0.0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         //                                 NSLog(@"_foregroundScrollView.contentOffset.y : %f",_foregroundScrollView.contentOffset.y);
                         //                                 _foregroundView.center = CGPointMake(_foregroundView.center.x, _foregroundView.center.y + self.frame.size.height - _viewDistanceFromBottom );
                         [_foregroundScrollView setContentOffset:CGPointMake(0, 0)];
                         _blurredBackgroundImageView.alpha = 0.0;
                         //                                  NSLog(@"_foregroundScrollView.contentOffset.y : %f",_foregroundScrollView.contentOffset.y);
                     } completion:^(BOOL finished) {
                     }];
    
    
}

- (void)headerViewShowAfterDelay:(float)delay
{
    _headerViewShowed = YES;
    [UIView animateWithDuration:0.8
                          delay:delay
         usingSpringWithDamping:0.5
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _headerView.frame = CGRectMake(_headerViewOrgin.x, _headerViewOrgin.y,_headerView.frame.size.width,_headerView.frame.size.height);
                         _headerView.alpha = 1.0;
                     } completion:^(BOOL finished) {
                     }];
}

- (void)headerViewDismissAfterDelay:(float)delay
{
    _headerViewShowed = NO;
    [UIView animateWithDuration:0.8
                          delay:delay
         usingSpringWithDamping:0.5
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _headerView.frame = CGRectMake(self.frame.size.width + 5, _headerViewOrgin.y,_headerView.frame.size.width,_headerView.frame.size.height);
                         _headerView.alpha = 0.0;
                     } completion:^(BOOL finished) {
                     }];
}

- (void)handleInfoButtonClick1
{
    if(!_infoViewShowed){
        [self infoViewShowAnimate:YES];
    }else{
        [self infoViewDismissAnimate:YES];
    }
    
}

- (void)handleCityButtonClick1
{
    if(!_cityViewShowed){
        [self cityViewShowAnimate:YES];
    }else{
        [self cityViewDismissAnimate:YES];
    }
    
}

- (void)infoViewShowAnimate:(BOOL)animate
{
    _infoViewShowed = YES;
    if(_cityViewShowed){
        [self cityViewDismissAnimate:NO];
    }
    if(animate){
        [self popOverViewDimsmissAnimate:NO];
        [self scrollViewDismiss];
        if(!_headerViewShowed){
            [self headerViewShowAfterDelay:0.2];
        }
        //    [self headerViewDismissAfterDelay:0.1];
        [UIView animateWithDuration:0.8
                              delay:.0
             usingSpringWithDamping:0.5
              initialSpringVelocity:0.5
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             _infoView.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1);
                             _infoView.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1);
                             _infoView.alpha = 1.0;
                         } completion:^(BOOL finished) {
                         }];
    }else{
        _infoView.alpha = 1.0;
    }
    
}

- (void)infoViewDismissAnimate:(BOOL)animate
{
    _infoViewShowed = NO;
    if(animate){
        _infoView.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1);
        
        [UIView animateWithDuration:1.2
                              delay:.0
             usingSpringWithDamping:0.5
              initialSpringVelocity:0.5
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             _infoView.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1);
                             _infoView.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
                             _infoView.alpha = 0.0;
                         } completion:^(BOOL finished) {
                         }];
    }else{
        _infoView.alpha = 0.0;
    }
}

- (void)cityViewShowAnimate:(BOOL)animate
{
    _cityViewShowed = YES;
    if(_infoViewShowed){
        [self infoViewDismissAnimate:NO];
    }
    if(animate){
        [self popOverViewDimsmissAnimate:NO];
        [self scrollViewDismiss];
        if(!_headerViewShowed){
            [self headerViewShowAfterDelay:0.2];
        }
        //    [self headerViewDismissAfterDelay:0.1];
        [UIView animateWithDuration:0.8
                              delay:.0
             usingSpringWithDamping:0.5
              initialSpringVelocity:0.5
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             _citySwitchView.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1);
                             _citySwitchView.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1);
                             _citySwitchView.alpha = 1.0;
                         } completion:^(BOOL finished) {
                         }];
    }else{
        _citySwitchView.alpha = 1.0;
    }
    
}

- (void)cityViewDismissAnimate:(BOOL)animate
{
    _cityViewShowed = NO;
    if(animate){
        _citySwitchView.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1);
        
        [UIView animateWithDuration:1.2
                              delay:.0
             usingSpringWithDamping:0.5
              initialSpringVelocity:0.5
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             _citySwitchView.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1);
                             _citySwitchView.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
                             _citySwitchView.alpha = 0.0;
                         } completion:^(BOOL finished) {
                         }];
    }else{
        _citySwitchView.alpha = 0.0;
    }
}

#pragma mark - Delegate
#pragma mark UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //translate into ratio to height
    CGFloat ratio = (scrollView.contentOffset.y + _foregroundScrollView.contentInset.top)/(_foregroundScrollView.frame.size.height - _foregroundScrollView.contentInset.top - _viewDistanceFromBottom);
    //stan
    if(!_backgroundView){
        ratio = ratio<0?0:ratio;
        ratio = ratio>1?1:ratio;
    }else{
        //        ratio /= 2;
        //        ratio = ratio<0?0:ratio;
        //        ratio = ratio>1?0.5:ratio;
        ratio *= 0.8;
        ratio = ratio<0?0:ratio;
        ratio = ratio>0.8?0.8:ratio;
        
    }
    if(ratio ==0){
        _scrollViewShowed = NO;
    }else{
        if(_popOverViewShowed){
            [self popOverViewDimsmissAnimate:YES];
        }
        if(_infoViewShowed)
        {
            [self infoViewDismissAnimate:YES];
        }
        if(_cityViewShowed)
        {
            [self cityViewDismissAnimate:YES];
        }
        [self headerViewShowAfterDelay:0.5];
    }
    
    //set background scroll
    [_backgroundScrollView setContentOffset:CGPointMake(DEFAULT_MAX_BACKGROUND_MOVEMENT_HORIZONTAL, ratio * DEFAULT_MAX_BACKGROUND_MOVEMENT_VERTICAL)];
    
    //set alpha
    [_blurredBackgroundImageView setAlpha:ratio];
//    NSLog(@"ratio:%f",ratio);
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
    CGPoint point = *targetContentOffset;
    CGFloat ratio = (point.y + _foregroundScrollView.contentInset.top)/(_foregroundScrollView.frame.size.height - _foregroundScrollView.contentInset.top - _viewDistanceFromBottom);
    
    //it cannot be inbetween 0 to 1 so if it is >.5 it is one, otherwise 0
    if (ratio > 0 && ratio < 1) {
        if (velocity.y == 0) {
            ratio = ratio > .5?1:0;
        }else if(velocity.y > 0){
            ratio = ratio > .1?1:0;
        }else{
            ratio = ratio > .9?1:0;
        }
        if(ratio == 1){
            _scrollViewShowed = YES;
            if(_popOverViewShowed){
                [self popOverViewDimsmissAnimate:YES];
            }
        }
        //        else{
        //            _scrollViewShowed = NO;
        //        }
        targetContentOffset->y = ratio * _foregroundView.frame.origin.y - _foregroundScrollView.contentInset.top;
    }
    
}
@end

