//
//  ViewController.m
//  PicturesqueScene
//
//  Created by stan on 3/25/14.
//  Copyright (c) 2014 stan. All rights reserved.
//

#import "ViewController.h"
#import "FRDLivelyButton.h"
//#import "ALMoviePlayerController.h"
#import "StanGlassScrollView.h"
#import "FBShimmeringView.h"
#import "CheckNetwork.h"
#import "JSONKit.h"
#import "FXBlurView.h"
#import "defines.h"
#import "UITestViewController.h"
#import "weatherViewContainer.h"
#import "RQShineLabel.h"

#import <objc/runtime.h>
//#import <AVFoundation/AVFoundation.h>

#define SIMPLE_SAMPLE NO

/*****************************
    Test for learning
 *****************************/
//@interface InspectionLayer : CALayer
//@end
//
//@implementation InspectionLayer
//- (void)addAnimation:(CAAnimation *)anim forKey:(NSString *)key
//{
//    PSLog(@"adding animation: %@", [anim debugDescription]);
//    [super addAnimation:anim forKey:key];
//}
//@end
//
//
//@interface InspectionView : UIView
//@end
//
//@implementation InspectionView
//+ (Class)layerClass
//{
//    return [InspectionLayer class];
//}
//@end
//
//@interface UIView (DR_CustomBlockAnimations )
//
//@end
//
//
//@implementation UIView (DR_CustomBlockAnimations)
//
//+ (void)load
//{
//    SEL originalSelector = @selector(actionForLayer:forKey:);
//    SEL extendedSelector = @selector(DR_actionForLayer:forKey:);
//    
//    Method originalMethod = class_getInstanceMethod(self, originalSelector);
//    Method extendedMethod = class_getInstanceMethod(self, extendedSelector);
//    
//    NSAssert(originalMethod, @"original method should exist");
//    NSAssert(extendedMethod, @"exchanged method should exist");
//    
//    if(class_addMethod(self, originalSelector, method_getImplementation(extendedMethod), method_getTypeEncoding(extendedMethod))) {
//        class_replaceMethod(self, extendedSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
//    } else {
//        method_exchangeImplementations(originalMethod, extendedMethod);
//    }
//}
//
//static void *DR_currentAnimationContext = NULL;
//static void *DR_popAnimationContext     = &DR_popAnimationContext;
//
//- (id<CAAction>)DR_actionForLayer:(CALayer *)layer forKey:(NSString *)event
//{
//    if (DR_currentAnimationContext == DR_popAnimationContext) {
//        // 这里写我们自定义的代码...
//    }
//    
//    // 调用原始方法
////    return [self DR_actionForLayer:layer forKey:event];
//}
//@end

//stan
//- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
//    UIGraphicsBeginImageContext(size);
//    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
//    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return scaledImage;
//}

typedef enum {
    sunny,
    rainy,
    snowy,
    foggy,
    cloudy
} weather;

typedef void (^blk) (void);

@interface ViewController () <ALMoviePlayerControllerDelegate>
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property (nonatomic, strong) UIView* contentView;
@property (nonatomic, strong) FRDLivelyButton *button;
@property (nonatomic) CGRect defaultFrame;

//@property AVPlayer *newPlayer;

@end

@implementation ViewController
{
    BOOL _sideBarShowed;
    BOOL _sideBarAnimating;
    STANSideBar         *_callout;
    
    BOOL _moviePlaying;
    RQShineLabel *_labelPainter;
    RQShineLabel *_labelPainterDetails;
    
    UIScrollView        *_viewScroller;
    StanGlassScrollView *_glassScrollView1;
    StanGlassScrollView *_glassScrollView2;
    StanGlassScrollView *_glassScrollView3;
    StanGlassScrollView *_glassScrollView4;
    StanGlassScrollView *_glassScrollView5;
    NSMutableArray      *_scrollViewArray;
    
    NSMutableArray      *_viewContainerArray;
    
    int                  _page;
    CityCollectionViewController *cv;
    aboutUSView *   aboutUS1 ;
    UITestViewController *testController;
    
    __weak id           _wself;
    NSUserDefaults      *_userDefault;
}

//-(void)loadView
//{
//    
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    PSLog(@"[UIScreen mainScreen] applicationFrame].width:%f,height:%f",[[UIScreen mainScreen] applicationFrame].size.width,[[UIScreen mainScreen] applicationFrame].size.height);
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight){
        self.view.frame = CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width);
    }
    _wself = self;
    _userDefault = [NSUserDefaults standardUserDefaults];
    /*************************************
     Netwokr weather instance
     *************************************/
//    networkWeather *weatherInstance = [networkWeather sharedInstance];
//    weatherInstance.delegate = self;
//    [weatherInstance obtainWeaterInfoLocationBased];
    
    // 初始化的menu选择效果
    //    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:1];
    
    /*************************************
     mian content view
     *************************************/
    _contentView = [[UIView alloc]initWithFrame:self.view.frame];
//    _contentView.backgroundColor = [UIColor colorWithRed:0.35 green:0.35 blue:1 alpha:0.25];
    _contentView.backgroundColor = [UIColor blackColor];
    self.view.backgroundColor  = [UIColor blackColor];
    [self.view addSubview:_contentView];
    
    
    
    /*************************************
     menu button
     *************************************/
    _button = [[FRDLivelyButton alloc] initWithFrame:CGRectMake(6,self.view.bounds.size.height - 50, 40, 40)];
    [_button setOptions:@{ kFRDLivelyButtonLineWidth: @(2.0f),
                           kFRDLivelyButtonHighlightedColor: [UIColor colorWithRed:0.5 green:0.8 blue:1.0 alpha:1.0],
                           kFRDLivelyButtonColor: [UIColor whiteColor]
                           }];
    [_button setStyle:kFRDLivelyButtonStyleHamburger animated:NO];
    [_button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    _button.tag = 0;
    [self.view addSubview:_button];
    
    /*************************************
     painter view
     *************************************/
    CGFloat originX = 16 + _button.frame.size.width + 10;
    CGFloat originY = self.view.frame.size.height - 50;
    CGFloat width = self.view.frame.size.width - originX;
    UIView *painterView = [self createPainterViewWithFrame:CGRectMake(originX, originY ,width, 50) painter:@"文森特.威廉.梵高(Vincent Willem van Gogh, 1853 - 1890)" details:@"荷兰后印象派画家，他是表现主义的先驱，并深深影响了二十\n世纪艺术，尤其是野兽派与表现主义"];
    
    [self.view insertSubview:painterView belowSubview:_contentView];
    
    [_labelPainter fadeOut];
    [_labelPainterDetails fadeOut];
    /*************************************
     Movie Player
     *************************************/
    //create a player
    self.moviePlayer = [[ALMoviePlayerController alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.moviePlayer.view.alpha = 0.f;
    self.moviePlayer.delegate = self; //IMPORTANT!
    //create the controls
    ALMoviePlayerControls *movieControls = [[ALMoviePlayerControls alloc] initWithMoviePlayer:self.moviePlayer style:ALMoviePlayerControlsStyleDefault];
    //    [movieControls setBarColor:[UIColor colorWithRed:195/255.0 green:29/255.0 blue:29/255.0 alpha:0.5]];
    //    [movieControls setTimeRemainingDecrements:YES];
    //[movieControls setFadeDelay:2.0];
    //[movieControls setBarHeight:100.f];
    //[movieControls setSeekRate:2.f];
    
    //assign controls
    [self.moviePlayer setControls:movieControls];
//    [self.moviePlayer setScalingMode: MPMovieScalingModeNone];
    [self playLocalFile:@"sunny"];
    
    //     [_contentView addSubview:self.moviePlayer.view];
    
    
    /*************************************
     _viewScroller
     *************************************/
    CGFloat blackSideBarWidth = 2;
    _viewScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width + 2*blackSideBarWidth, self.view.frame.size.height)];
    [_viewScroller setPagingEnabled:YES];
    [_viewScroller setDelegate:self];
    [_viewScroller setShowsHorizontalScrollIndicator:NO];
    [_contentView addSubview:_viewScroller];
    
    _scrollViewArray    = [[NSMutableArray alloc] init];
    _viewContainerArray = [[NSMutableArray alloc] init];
    
    NSMutableArray* cityarray = [[NSMutableArray alloc]initWithArray:@[@"杭州",@"北京",@"上海",@"深圳",@"武汉",@"智利"]];
    NSArray *mainWeather = @[@(sunny),@(rainy),@(foggy),@(snowy)];
    NSArray *downWeahter = @[@(10.),@(11),@(12),@(13)];
    NSArray *upWeahter   = @[@(20),@(21),@(22),@(23)];
//    UIView *foregroundView = [self createForegroundView];
//    UIView *popOverView = [self popOverView];
//    UIView *headerView = [self headerView];
//    UIView *citySwitchView = [self createCitySwitchViewWithFrame:CGRectMake(341,198,343,343) title:@"城市管理" cityArray:cityarray];
//    UIView *infoView = [self createInfoViewWithFrame:CGRectMake(341,198,343,343) title:@"关于我们" text:@"画境是... ..."];
    
//    __block UIView *popOverView1;
//    __weak id wself = self;
//    PSLog(@"out self.view,width :%f,height:%f",self.view.frame.size.width,self.view.frame.size.height);
//    dispatch_group_t dispatchGroup = dispatch_group_create();
////    dispatch_group_async(dispatchGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//    dispatch_group_async(dispatchGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//        ViewController *strongSelf = wself;
//        popOverView1 = [strongSelf createPopOverViewWithFrame:CGRectZero city:@"杭州" image:@"sunny_big" mainTemp:23 upTemp:25 downTemp:19 humidity:10 wind:14 ];
//    });
//    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^{
//        ViewController *strongSelf = wself;
//        if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight){
//            CGRect r = strongSelf.view.frame;
//            CGFloat width = r.size.width;
//            r.size.width = r.size.height;
//            r.size.height = width;
//            strongSelf.view.frame = r;
//        }
//        PSLog(@"in self.view,oringin.x:%f,oringin.y:%f,width:%f,height:%f",strongSelf.view.frame.origin.x,strongSelf.view.frame.origin.y,strongSelf.view.frame.size.width,strongSelf.view.frame.size.height);
//        
//         _glassScrollView1 = [[StanGlassScrollView alloc] initWithFrame:strongSelf.view.frame BackgroundImage:[UIImage imageNamed:@"sunny_background"] BackgroundView:nil blurredImage:[UIImage imageNamed:@"sunny_background"] viewDistanceFromBottom:120 foregroundView:[strongSelf createForegroundView] popOverView:popOverView1  headerView:[strongSelf headerView] citySwitchView:[strongSelf createCitySwitchViewWithFrame:CGRectMake(341,198,343,343) title:@"城市管理" cityArray:cityarray] infoView:[strongSelf createInfoViewWithFrame:CGRectMake(341,198,343,343) title:@"关于我们" text:@"画境是... ..."]];
//         PSLog(@"in _contentView,oringin.x:%f,oringin.y:%f,width:%f,height:%f",_contentView.frame.origin.x,_contentView.frame.origin.y,_contentView.frame.size.width,_contentView.frame.size.height);
//        CGRect r = _contentView.frame;
////        r.origin.x -= 256;
//        _contentView.frame = r;
//        [_viewScroller addSubview:_glassScrollView1];
//        [_glassScrollView1 showMovieView:strongSelf.moviePlayer.view];
//
//
//    });
    
    cv = [[CityCollectionViewController alloc] init];
    cv.view.frame = CGRectMake(341,198,343,343);
    aboutUS1 = [[aboutUSView alloc]initWithFrame:CGRectMake(341,198,343,343) title:@"关于我们"  text:@"画境是... ..."];

    NSInteger mainTemp = ((NSString *)[_userDefault objectForKey:PSLastCurrentTemp]).integerValue;
    NSInteger upTemp   = ((NSString *)[_userDefault objectForKey:PSLastMaxTemp]).integerValue;
    NSInteger downTemp = ((NSString *)[_userDefault objectForKey:PSLastMinTemp]).integerValue;
    NSInteger humidity = ((NSString *)[_userDefault objectForKey:PSLastHumidity]).integerValue;
    NSInteger wind     = ((NSString *)[_userDefault objectForKey:PSLastWindPower]).integerValue;
    weatherType weatherType = ((NSNumber *)[_userDefault objectForKey:PSLastWindPower]).integerValue;

    weatherDataItem *data1 = [[weatherDataItem alloc] initWithCity:@"杭州" weather:weatherType mainTemp:mainTemp upTemp:upTemp downTemp:downTemp humidity:humidity wind:wind];
    weatherInfoDetailView* pop1 = [[weatherInfoDetailView alloc]initWithFrame:CGRectMake(0, 0, 360, 360) withDataItem:data1];
    weatherHeaderView* headerView1 = [[weatherHeaderView alloc]initWithFrame:CGRectMake(725, 16, 291, 39) city:@"杭州" temperature:23 weather:Sunny];
    
    weatherViewContainer *container1 = [[weatherViewContainer alloc] init];
    container1.weatherDataItem       = data1;
    container1.weatherInfoDetailView = pop1;
    [_viewContainerArray addObject:container1];
    
    _glassScrollView1 = [[StanGlassScrollView alloc] initWithFrame:self.view.frame BackgroundImage:[UIImage imageNamed:@"sunny_background"] BackgroundView:nil blurredImage:[UIImage imageNamed:@"sunny_background"] viewDistanceFromBottom:120 foregroundView:[self createForegroundViewWithMainWeather:mainWeather upWeather:upWeahter downWeather:downWeahter] popOverView:pop1  headerView:headerView1 citySwitchView:[self createCitySwitchViewWithFrame:CGRectMake(341,198,343,343) title:@"城市管理" cityArray:cityarray] infoView:[self createInfoViewWithFrame:CGRectMake(341,198,343,343) title:@"关于我们" text:@"画境是... ..."] testViewController:nil];
    
    weatherDataItem* data2 = [[weatherDataItem alloc]initWithCity:@"武汉" weather:Cloudy mainTemp:18 upTemp:22 downTemp:16 humidity:10 wind:14];
    weatherInfoDetailView* pop2 = [[weatherInfoDetailView alloc]initWithFrame:CGRectMake(0, 0, 360, 360) withDataItem:data2];
    weatherHeaderView* headerView2 = [[weatherHeaderView alloc]initWithFrame:CGRectMake(725, 16, 291, 39) city:@"武汉" temperature:18 weather:Cloudy];
    
    _glassScrollView2 = [[StanGlassScrollView alloc] initWithFrame:self.view.frame BackgroundImage:[UIImage imageNamed:@"cloudy_background"] BackgroundView:nil blurredImage:[UIImage imageNamed:@"cloudy_background"] viewDistanceFromBottom:120 foregroundView:[self createForegroundViewWithMainWeather:mainWeather upWeather:upWeahter downWeather:downWeahter] popOverView:pop2  headerView:headerView2 citySwitchView:[self createCitySwitchViewWithFrame:CGRectMake(341,198,343,343) title:@"城市管理" cityArray:cityarray] infoView:[self createInfoViewWithFrame:CGRectMake(341,198,343,343) title:@"关于我们" text:@"画境是... ..."] testViewController:nil];
    
    
    weatherDataItem* data3 = [[weatherDataItem alloc]initWithCity:@"悉尼" weather:Snowy mainTemp:-8 upTemp:-5 downTemp:-9 humidity:10 wind:14];
    
    weatherInfoDetailView* pop3 = [[weatherInfoDetailView alloc]initWithFrame:CGRectMake(0, 0, 360, 360) withDataItem:data3];
    weatherHeaderView* headerView3 = [[weatherHeaderView alloc]initWithFrame:CGRectMake(725, 16, 291, 39) city:@"悉尼" temperature:-8 weather:Snowy];
    
    _glassScrollView3 = [[StanGlassScrollView alloc] initWithFrame:self.view.frame BackgroundImage:[UIImage imageNamed:@"snowy_background"] BackgroundView:nil blurredImage:[UIImage imageNamed:@"snowy_background"] viewDistanceFromBottom:120 foregroundView:[self createForegroundViewWithMainWeather:mainWeather upWeather:upWeahter downWeather:downWeahter] popOverView:pop3  headerView:headerView3 citySwitchView:[self createCitySwitchViewWithFrame:CGRectMake(341,198,343,343) title:@"城市管理" cityArray:cityarray] infoView:[self createInfoViewWithFrame:CGRectMake(341,198,343,343) title:@"关于我们" text:@"画境是... ..."] testViewController:nil];

    weatherDataItem* data4 = [[weatherDataItem alloc]initWithCity:@"深圳" weather:Rainy mainTemp:14 upTemp:16 downTemp:12 humidity:10 wind:14];
    weatherInfoDetailView* pop4 = [[weatherInfoDetailView alloc]initWithFrame:CGRectMake(0, 0, 360, 360) withDataItem:data4];
    weatherHeaderView* headerView4 = [[weatherHeaderView alloc]initWithFrame:CGRectMake(725, 16, 291, 39) city:@"深圳" temperature:14 weather:Rainy];
    
    _glassScrollView4 = [[StanGlassScrollView alloc] initWithFrame:self.view.frame BackgroundImage:[UIImage imageNamed:@"rainy_background"] BackgroundView:nil blurredImage:[UIImage imageNamed:@"rainy_background"] viewDistanceFromBottom:120 foregroundView:[self createForegroundViewWithMainWeather:mainWeather upWeather:upWeahter downWeather:downWeahter] popOverView:pop4  headerView:headerView4 citySwitchView:[self createCitySwitchViewWithFrame:CGRectMake(341,198,343,343) title:@"城市管理" cityArray:cityarray] infoView:[self createInfoViewWithFrame:CGRectMake(341,198,343,343) title:@"关于我们" text:@"画境是... ..."] testViewController:nil];

    weatherDataItem* data5 = [[weatherDataItem alloc]initWithCity:@"北京" weather:Foggy mainTemp:12 upTemp:14 downTemp:10 humidity:10 wind:14];
    weatherInfoDetailView* pop5 = [[weatherInfoDetailView alloc]initWithFrame:CGRectMake(0, 0, 360, 360) withDataItem:data5];
    weatherHeaderView* headerView5 = [[weatherHeaderView alloc]initWithFrame:CGRectMake(725, 16, 291, 39) city:@"深圳" temperature:12 weather:Foggy];
    

    _glassScrollView5 = [[StanGlassScrollView alloc] initWithFrame:self.view.frame BackgroundImage:[UIImage imageNamed:@"foggy_background"] BackgroundView:nil blurredImage:[UIImage imageNamed:@"foggy_background"] viewDistanceFromBottom:120 foregroundView:[self createForegroundViewWithMainWeather:mainWeather upWeather:upWeahter downWeather:downWeahter] popOverView:pop5  headerView:headerView5 citySwitchView:[self createCitySwitchViewWithFrame:CGRectMake(341,198,343,343) title:@"城市管理" cityArray:cityarray] infoView:[self createInfoViewWithFrame:CGRectMake(341,198,343,343) title:@"关于我们" text:@"画境是... ..."] testViewController:nil];

//    _glassScrollView1 = [[StanGlassScrollView alloc] initWithFrame:self.view.frame BackgroundImage:[UIImage imageNamed:@"sunny_background"] BackgroundView:nil blurredImage:[UIImage imageNamed:@"sunny_background"] viewDistanceFromBottom:120 foregroundView:[self createForegroundViewWithMainWeather:mainWeather upWeather:upWeahter downWeather:downWeahter] popOverView:[self createPopOverViewWithFrame:CGRectZero city:@"杭州" image:@"sunny_big" mainTemp:23 upTemp:26 downTemp:10 humidity:10 wind:14 ]  headerView:[self headerViewWithCityName:@"杭州" temp:23 mainweather:sunny] citySwitchView:[self createCitySwitchViewWithFrame:CGRectMake(341,198,343,343) title:@"城市管理" cityArray:cityarray] infoView:[self createInfoViewWithFrame:CGRectMake(341,198,343,343) title:@"关于我们" text:@"画境是... ..."]];

   // _glassScrollView2 = [[StanGlassScrollView alloc] initWithFrame:self.view.frame BackgroundImage:[UIImage imageNamed:@"cloudy_background"] BackgroundView:nil blurredImage:[UIImage imageNamed:@"cloudy_background"] viewDistanceFromBottom:120 foregroundView:[self createForegroundViewWithMainWeather:mainWeather upWeather:upWeahter downWeather:downWeahter] popOverView:pop2 headerView:headerView2 citySwitchView:[self createCitySwitchViewWithFrame:CGRectMake(341,198,343,343) title:@"城市管理" cityArray:cityarray] infoView:[self createInfoViewWithFrame:CGRectMake(341,198,343,343) title:@"关于我们" text:@"画境是... ..."] testViewController:nil];

   //  _glassScrollView3 = [[StanGlassScrollView alloc] initWithFrame:self.view.frame BackgroundImage:[UIImage imageNamed:@"snowy_background"] BackgroundView:nil blurredImage:[UIImage imageNamed:@"snowy_background"] viewDistanceFromBottom:120 foregroundView:[self createForegroundViewWithMainWeather:mainWeather upWeather:upWeahter downWeather:downWeahter] popOverView:[self createPopOverViewWithFrame:CGRectZero city:@"悉尼" image:@"snowy_big" mainTemp:-8 upTemp:-5 downTemp:-9 humidity:10 wind:14 ] headerView:[self headerViewWithCityName:@"悉尼" temp:-8 mainweather:snowy] citySwitchView:[self createCitySwitchViewWithFrame:CGRectMake(341,198,343,343) title:@"城市管理" cityArray:cityarray] infoView:[self createInfoViewWithFrame:CGRectMake(341,198,343,343) title:@"关于我们" text:@"画境是... ..."] testViewController:nil];
    
  //  _glassScrollView4 = [[StanGlassScrollView alloc] initWithFrame:self.view.frame BackgroundImage:[UIImage imageNamed:@"rainy_background"] BackgroundView:nil blurredImage:[UIImage imageNamed:@"rainy_background"] viewDistanceFromBottom:120 foregroundView:[self createForegroundViewWithMainWeather:mainWeather upWeather:upWeahter downWeather:downWeahter] popOverView:[self createPopOverViewWithFrame:CGRectZero city:@"深圳" image:@"rainy_big" mainTemp:14 upTemp:16 downTemp:12 humidity:10 wind:14 ] headerView:[self headerViewWithCityName:@"深圳" temp:14 mainweather:rainy] citySwitchView:[self createCitySwitchViewWithFrame:CGRectMake(341,198,343,343) title:@"城市管理" cityArray:cityarray] infoView:[self createInfoViewWithFrame:CGRectMake(341,198,343,343) title:@"关于我们" text:@"画境是... ..."] testViewController:nil];
    
 //   _glassScrollView5 = [[StanGlassScrollView alloc] initWithFrame:self.view.frame BackgroundImage:[UIImage imageNamed:@"foggy_background"] BackgroundView:nil blurredImage:[UIImage imageNamed:@"foggy_background"] viewDistanceFromBottom:120 foregroundView:[self createForegroundViewWithMainWeather:mainWeather upWeather:upWeahter downWeather:downWeahter] popOverView:[self createPopOverViewWithFrame:CGRectZero city:@"北京" image:@"foggy_big" mainTemp:12 upTemp:14 downTemp:10 humidity:10 wind:14 ] headerView:[self headerViewWithCityName:@"北京" temp:12 mainweather:foggy] citySwitchView:[self createCitySwitchViewWithFrame:CGRectMake(341,198,343,343) title:@"城市管理" cityArray:cityarray] infoView:[self createInfoViewWithFrame:CGRectMake(341,198,343,343) title:@"关于我们" text:@"画境是... ..."] testViewController:nil];

//    PSLog(@"add sceollView1");
    [_viewScroller addSubview:_glassScrollView1];
    [_glassScrollView1 showMovieView:self.moviePlayer.view];

    [_viewScroller addSubview:_glassScrollView2];
    [_viewScroller addSubview:_glassScrollView3];
    [_viewScroller addSubview:_glassScrollView4];
    [_viewScroller addSubview:_glassScrollView5];
    
    [_scrollViewArray addObject:_glassScrollView1];
    [_scrollViewArray addObject:_glassScrollView2];
    [_scrollViewArray addObject:_glassScrollView3];
    [_scrollViewArray addObject:_glassScrollView4];
    [_scrollViewArray addObject:_glassScrollView5];
    
    _sideBarShowed     = NO;
    _sideBarAnimating  = NO;
    _moviePlaying      = NO;
    _page              = 0;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationFinishedLaunching) name:@"ApplicationFinishedLaunching" object:nil];

    double delayInSeconds = 1.0;
    __weak id wself = self;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        ViewController *strongSelf = wself;
        [strongSelf onApplicationFinishedLaunching];
    });

//    InspectionView *testView = [[InspectionView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
//    
//    [UIView animateWithDuration:0.5 delay:0.1 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        PSLog(@"testView : %@",testView);
////        [testView setFrame:CGRectMake(0,0,200,200 )];
//        testView.alpha = 0.0;
////        PSLog(@"inside animation block: %@",
////              [testView actionForLayer:_contentView.layer forKey:@"position"] );
//    } completion:^(BOOL finished) {
//    }];
    
    
   //    [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollViewTo0" object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPlayerDisplayChanged:) name:MPMoviePlayerReadyForDisplayDidChangeNotification object:nil];
    
    
    //    UIImageView *testView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background2"]];
    //    FXBlurView *blur = [[FXBlurView alloc] initWithFrame:self.view.frame];
    //    blur.underlyingView = testView;
    //    blur.tintColor = [UIColor clearColor];
    //    blur.blurEnabled = YES;
    //    blur.dynamic  = YES;
    //    blur.blurRadius = 42;
    //    [self.view addSubview:blur];
    
    // Set vertical effect
//    UIInterpolatingMotionEffect *verticalMotionEffect =
//    [[UIInterpolatingMotionEffect alloc]
//     initWithKeyPath:@"center.y"
//     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
//    verticalMotionEffect.minimumRelativeValue = @(-10);
//    verticalMotionEffect.maximumRelativeValue = @(10);
//    
//    // Set horizontal effect
//    UIInterpolatingMotionEffect *horizontalMotionEffect =
//    [[UIInterpolatingMotionEffect alloc]
//     initWithKeyPath:@"center.x"
//     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
//    horizontalMotionEffect.minimumRelativeValue = @(-10);
//    horizontalMotionEffect.maximumRelativeValue = @(10);
//    
//    // Create group to combine both
//    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
//    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
//    
//    // Add both effects to your view
//    [_contentView addMotionEffect:group];
    
//    NSArray *testArray = @[@"1",@"2",@"3",@"2",@"5"];
//    NSIndexSet *areaIndexes = [testArray indexesOfObjectsWithOptions:NSEnumerationConcurrent
//                                                             passingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
//                                                                 if ([(NSString *)obj isEqualToString:@"2"]) {
//                                                                     return YES;
//                                                                 }
//                                                                 return NO;
//                                                             }];
//    PSLog(@"areaIndexed :%@",areaIndexes);
    
//    __block int val = 10;
//     blk strongPointerBlock = ^{NSLog(@"val = %d", ++val);};
//    NSLog(@"strongPointerBlock: %@", strongPointerBlock); //1
//    
//    __weak blk weakPointerBlock = ^{NSLog(@"val = %d", ++val);};
//    NSLog(@"weakPointerBlock: %@", weakPointerBlock); //2
//    
//    NSLog(@"mallocBlock: %@", [weakPointerBlock copy]); //3
//    
//    NSLog(@"test %@", ^{NSLog(@"val = %d", ++val);}); //4
    
//    static int base = 100;
//    __block NSArray * array = [[NSArray alloc] init];
//    void (^sum)(NSArray *) = ^ (NSArray * a) {
//        array = [a copy];
//        NSLog(@"array:%@",array);
//    };
//     NSLog(@"block is %@", sum);
//    base = 0;
//    NSArray *a = @[@0,@1];
//    sum(a);
//    NSLog(@"array:%@",array);
//    

//    [self testGlobalObj];
//     printf("global address: %p\n", &__globalString);
}

NSString *__globalString = nil;

- (void)testGlobalObj
{
    __globalString = @"1";
    void (^TestBlock)(void) = ^{
        printf("global address: %p\n", &__globalString);
        NSLog(@"string is :%@", __globalString);
    };
    
    __globalString = @"2";
    
    TestBlock();
}

- (void)testLocalObj
{//local 变量会被copy到block里，非引用。指针不一样
    __block NSString *__localString = nil;
    __localString = @"1";
    
    printf("local address: %p\n", &__localString);
    
    void (^TestBlock)(void) = ^{
        
        printf("local address: %p\n", &__localString);
        
        NSLog(@"string is : %@", __localString); //string is : 1
    };
    
    __localString = @"2";
    
    TestBlock();
}
#pragma mark - Lazy Loading
- (void)onApplicationFinishedLaunching
{
    PSLog(@"onApplicationFinishedLaunching");
    /*************************************
     Netwokr weather instance
     *************************************/
    networkWeather *weatherInstance = [networkWeather sharedInstance];
    weatherInstance.delegate = self;
    [weatherInstance obtainWeaterInfoLocationBased];
    
    [self addScrollView];
}

#pragma mark - weatherDelegate - NOT on main-thread
- (BOOL)gotWeatherInfo:(NSDictionary *)weather
{
    weatherViewContainer *viewContainer =(weatherViewContainer *)_viewContainerArray[0];
    
//    viewContainer.weatherDataItem.mainTemperature = ((NSString *)weather[0]).intValue;
//    viewContainer.weatherDataItem.humidity        = ((NSString *)weather[1]).intValue;
//    viewContainer.weatherDataItem.wind            = ((NSString *)weather[2]).intValue;
//    viewContainer.weatherDataItem.cityNumber      = (NSString *)weather[3];
    
    if(weather[@"currentTemp"]){
        viewContainer.weatherDataItem.mainTemperature = ((NSString *)weather[@"currentTemp"]).intValue;
        viewContainer.weatherDataItem.humidity        = ((NSString *)weather[@"humidity"]).intValue;
        viewContainer.weatherDataItem.wind            = ((NSString *)weather[@"windPower"]).intValue;
        viewContainer.weatherDataItem.cityNumber      = (NSString *)(weather[@"cityID"]);
    }else{
        viewContainer.weatherDataItem.upTemperature   = ((NSString *)weather[@"maxTemp"]).intValue;
        viewContainer.weatherDataItem.downTemperature = ((NSString *)weather[@"minTemp"]).intValue;
        
        NSString *mainWeather = (NSString *)weather[@"mainWeather"];
        viewContainer.weatherDataItem.weather = ((NSNumber *)weather[@"mainWeatherType"]).integerValue;

//        if([mainWeather rangeOfString:@"晴"].length>0){
//            viewContainer.weatherDataItem.weather = Sunny;
//        }else if([mainWeather rangeOfString:@"雪"].length>0){
//            viewContainer.weatherDataItem.weather = Snowy;
//        }else if([mainWeather rangeOfString:@"雨"].length>0){
//            viewContainer.weatherDataItem.weather = Rainy;
//        }else if([mainWeather rangeOfString:@"阴"].length>0){
//            viewContainer.weatherDataItem.weather = Cloudy;
//        }else{
//            viewContainer.weatherDataItem.weather = Foggy;
//        }
        
        PSLog(@"mainWeather: %@", mainWeather);
    }

    
//    PSLog(@"viewContainer.weatherInfoDetailView.dataItem:%@",viewContainer.weatherInfoDetailView.dataItem);
//    PSLog(@"viewContainer.weatherDataItem:%@",viewContainer.weatherDataItem);

//    PSLog(@"cityNumber: %@", viewContainer.weatherDataItem.cityNumber);
    
    dispatch_async(dispatch_get_main_queue(), ^{
//        viewContainer.weatherInfoDetailView.dataItem  = viewContainer.weatherDataItem;
        [viewContainer.weatherInfoDetailView updateUIbyData:viewContainer.weatherDataItem];
    });
    
    return YES;
}


#pragma mark - ScrollView delegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGPoint point = *targetContentOffset;
    CGFloat page = point.x / _viewScroller.frame.size.width;
    
    if(_page != page){
        _page = page;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"viewScrolled" object:nil];
        
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            ViewController *strongSelf = _wself;
            
            [strongSelf playMovieNumber:_page];
            [_scrollViewArray[_page] showMovieView:_moviePlayer.view];
//            switch ((int)page) {
//                case 0:{
//                    [strongSelf playMovieNumber:0];
//                    //                [_glassScrollView2 dismissMovieView];
//                    [_glassScrollView1 showMovieView:self.moviePlayer.view];
//                    break;
//                }
//                case 1:{
//                    [strongSelf playMovieNumber:1];
//                    //                [_glassScrollView1 dismissMovieView];
//                    [_glassScrollView2 showMovieView:self.moviePlayer.view];
//                    break;
//                }
//                case 2:{
//                    [strongSelf playMovieNumber:2];
//                    //                [_glassScrollView1 dismissMovieView];
//                    [_glassScrollView3 showMovieView:self.moviePlayer.view];
//                    break;
//                }
//                case 3:{
//                    [strongSelf playMovieNumber:3];
//                    [_glassScrollView4 showMovieView:self.moviePlayer.view];
//                    break;
//                }
//                case 4:{
//                    [strongSelf playMovieNumber:4];
//                    [_glassScrollView5 showMovieView:self.moviePlayer.view];
//                    break;
//                }
//                default:
//                    break;
//            }
        });

    }
//    PSLog(@"point.x :%f",page);
    //    [self playMovieNumber:(int)ratio];
}

#pragma mark - viewWillAppear
- (void)viewWillAppear:(BOOL)animated
{
    [self adjustScrollView];
}

#pragma mark - adjustScrollView
- (void)adjustScrollView
{
    //    PSLog(@"before width is: %f, height is:%f",self.view.frame.size.width,self.view.frame.size.height);
    //     PSLog(@"bounds width is: %f, height is:%f",self.view.bounds.size.width,self.view.bounds.size.height);
    //    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    //    if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight){
    
    if( self.view.bounds.size.width < 1024){
        self.view.bounds = CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width);
    }
    //        PSLog(@"after width is: %f, height is:%f",self.view.frame.size.width,self.view.frame.size.height);
    
    int page = _page; // resize scrollview can cause setContentOffset off for no reason and screw things up
    
    CGFloat blackSideBarWidth = 2;
    [_viewScroller setFrame:CGRectMake(0, 0, self.view.bounds.size.width + 2*blackSideBarWidth, self.view.bounds.size.height)];
    //        PSLog(@"_viewScroll width:%f",_viewScroller.frame.size.width);
    [_viewScroller setContentSize:CGSizeMake(_scrollViewArray.count * _viewScroller.frame.size.width, self.view.bounds.size.height)];
    //
    //        [_glassScrollView1 setFrame:self.view.frame];
    //        [_glassScrollView2 setFrame:self.view.frame];
    //        [_glassScrollView3 setFrame:self.view.frame];
    //        [_glassScrollView4 setFrame:self.view.frame];
    //        [_glassScrollView5 setFrame:self.view.frame];
    //
    //        [_glassScrollView2 setFrame:CGRectOffset(_glassScrollView2.bounds, _viewScroller.frame.size.width, 0)];
    //        [_glassScrollView3 setFrame:CGRectOffset(_glassScrollView3.bounds, 2*_viewScroller.frame.size.width, 0)];
    //        [_glassScrollView4 setFrame:CGRectOffset(_glassScrollView4.bounds, 3*_viewScroller.frame.size.width, 0)];
    //        [_glassScrollView5 setFrame:CGRectOffset(_glassScrollView5.bounds, 4*_viewScroller.frame.size.width, 0)];
    
    [_scrollViewArray enumerateObjectsUsingBlock:^(StanGlassScrollView *subScrollView, NSUInteger idx, BOOL *stop) {
        [subScrollView setFrame:self.view.bounds];
    }];
    
    [_scrollViewArray enumerateObjectsUsingBlock:^(StanGlassScrollView *subScrollView, NSUInteger idx, BOOL *stop) {
        if(idx != 0){
            [subScrollView setFrame:CGRectOffset(subScrollView.bounds, idx * _viewScroller.frame.size.width, 0)];
        }
    }];
    
    
    [_viewScroller setContentOffset:CGPointMake(page * _viewScroller.frame.size.width, _viewScroller.contentOffset.y)];
    _page = page;
    
}

#pragma mark - add scrollView
- (void)addScrollView
{
    NSMutableArray* cityarray = [[NSMutableArray alloc]initWithArray:@[@"杭州",@"北京",@"上海",@"深圳",@"武汉",@"智利"]];
    NSArray *mainWeather = @[@(sunny),@(rainy),@(foggy),@(snowy)];
    NSArray *downWeahter = @[@(10.),@(11),@(12),@(13)];
    NSArray *upWeahter   = @[@(20),@(21),@(22),@(23)];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //    if( self.view.frame.size.width < 1024){
        //        self.view.frame = CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width);
        //    }
        //
        //        PSLog(@"out width is: %f, height is:%f",self.view.bounds.size.width,self.view.bounds.size.height);
        //        PSLog(@"out width is: %f, height is:%f",self.view.frame.size.width,self.view.frame.size.height);
        
        StanGlassScrollView  *addingScrollView = [[StanGlassScrollView alloc] initWithFrame:self.view.bounds BackgroundImage:[UIImage imageNamed:@"snowy_background"] BackgroundView:nil blurredImage:[UIImage imageNamed:@"snowy_background"] viewDistanceFromBottom:120 foregroundView:[self createForegroundViewWithMainWeather:mainWeather upWeather:upWeahter downWeather:downWeahter] popOverView:[self createPopOverViewWithFrame:CGRectZero city:@"天堂" image:@"snowy_big" mainTemp:12 upTemp:14 downTemp:10 humidity:10 wind:14 ] headerView:[self headerViewWithCityName:@"天堂" temp:12 mainweather:foggy] citySwitchView:[self createCitySwitchViewWithFrame:CGRectMake(341,198,343,343) title:@"城市管理" cityArray:cityarray] infoView:[self createInfoViewWithFrame:CGRectMake(341,198,343,343) title:@"关于我们" text:@"画境是... ..."] testViewController:nil];
        
        [_scrollViewArray addObject:addingScrollView];
        
        [_viewScroller addSubview:addingScrollView];
        
        [self adjustScrollView];
        
    });
    
}

-(void)onPlayerDisplayChanged:(NSNotification *)noti
{
    if(noti.object == self.moviePlayer){
        if(self.moviePlayer.readyForDisplay == YES){
            PSLog(@"readyForDisplay YES");
        }
    }
}

#pragma mark - menu click
- (void)onClick:(FRDLivelyButton *)sender
{
    if(_sideBarAnimating) return;
//    if (sender.buttonStyle == kFRDLivelyButtonStyleHamburger) {
    
    if(!_sideBarShowed){
        
//        _sideBarShowed    = YES;
        _sideBarAnimating = YES;
        
        NSArray *images = @[
                            [UIImage imageNamed:@"city_icon1"],
                            [UIImage imageNamed:@"info_icon1"],
                            ];
        NSArray *colors = @[
                            [UIColor colorWithWhite:0.7 alpha:1],
                            [UIColor colorWithWhite:0.7 alpha:1],
                            ];
        
        _callout = [[STANSideBar alloc] initWithImages:images selectedIndices:self.optionIndices borderColors:colors];
        _callout.delegate = self;
        _callout.isSingleSelect = YES;
        [_callout show];
        
    } else {
//        _sideBarShowed    = NO;
        _sideBarAnimating = YES;
        [_callout dismiss];
    }
}


#pragma mark - play movie
//these files are in the public domain and no longer have property rights
- (void)playLocalFile:(NSString *)name
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH , 0), ^{
            [_moviePlayer stop];
            _moviePlayer.movieSourceType = MPMovieSourceTypeFile;
            [_moviePlayer setRepeatMode:MPMovieRepeatModeOne];
//     self.moviePlayer.initialPlaybackTime = -0.1;
            [_moviePlayer prepareToPlay];
        
            dispatch_async(dispatch_get_main_queue(), ^{
            [_moviePlayer setContentURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:name ofType:@"mp4"]]];
             [_moviePlayer play];
            [UIView animateWithDuration:0.4 delay:0.0 options:0 animations:^{
                _moviePlayer.view.alpha = 1.f;
            } completion:^(BOOL finished) {
                _moviePlaying = YES;
           }];
        });
    });
}

#pragma mark - ALMoviePlayerControllerDelegate

//IMPORTANT!
- (void)moviePlayerWillMoveFromWindow
{
    //movie player must be readded to this view upon exiting fullscreen mode.
    if (![_contentView.subviews containsObject:self.moviePlayer.view])
        [_contentView addSubview:self.moviePlayer.view];
    
    //you MUST use [ALMoviePlayerController setFrame:] to adjust frame, NOT [ALMoviePlayerController.view setFrame:]
    [self.moviePlayer setFrame:self.defaultFrame];
}

- (void)movieTimedOut
{
    //    [self playLocalFile];
    PSLog(@"movieTimedOut");
}

- (void)playMovieNumber:(int)index
{
    if(index == 0 ){
        [self playLocalFile:@"sunny"];
    }else if(index == 1){
        [self playLocalFile:@"cloudy"];
    }else if(index == 2){
        [self playLocalFile:@"snowy"];
    }else if(index == 3){
        [self playLocalFile:@"rainy"];
    }else if(index == 4){
        [self playLocalFile:@"foggy"];
    }else{
        [self playLocalFile:@"snowy"];
    }
}


#pragma mark - STANSideBarDelegate

- (void)sidebar:(STANSideBar *)sidebar didTapItemAtIndex:(NSUInteger)index
{
    StanGlassScrollView *sendObject = _scrollViewArray[_page];
    
    if (index == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cityButtonClick1" object:sendObject];
    }
    if (index == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"infoButtonClick1" object:sendObject];
    }
}

- (void)sidebar:(STANSideBar *)sidebar didEnable:(BOOL)itemEnabled itemAtIndex:(NSUInteger)index
{
    if (itemEnabled) {
        [self.optionIndices addIndex:index];
    }else {
        [self.optionIndices removeIndex:index];
    }
}

- (void)sidebar:(STANSideBar *)sidebar willShowOnScreenAnimated:(BOOL)animatedYesOrNo
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sideBarShowed" object:self];

//    PSLog(@"sidebar show");
    [UIView animateWithDuration:0.75
                          delay:0
         usingSpringWithDamping:0.3
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
//                         PSLog(@"show before x:%f, y:%f",_contentView.center.x , _contentView.center.y);
                         _contentView.center = CGPointMake(_contentView.center.x + 50, _contentView.center.y - 50);
                     }
                     completion:^(BOOL finished) {
                         [_button setStyle:kFRDLivelyButtonStylePlus animated:YES];
//                         PSLog(@"show after x:%f, y:%f",_contentView.center.x , _contentView.center.y);
                         _callout.sideBarShowsOnParentView = YES;
                         _sideBarAnimating = NO;
                         _sideBarShowed    = YES;
                         [_labelPainter shine];
                         [_labelPainterDetails shine];
                     }];
    
}

- (void)sidebar:(STANSideBar *)sidebar willDismissFromScreenAnimated:(BOOL)animatedYesOrNo
{
/******************************
When sideBar shows,it will call [rn_frostedMenu dismissAnimated:NO completion:nil] which
calls delegate: sidebar:(STANSideBar *)sidebar willDismissFromScreenAnimated:
So we must NOT execute dismiss before showing the bar.
 ******************************/
    
    if(_sideBarShowed){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"sideBarDismiss" object:self];
//        PSLog(@"sidebar dismiss");
        [_labelPainter fadeOut];
        [_labelPainterDetails fadeOut];
        
        [UIView animateWithDuration:0.55
                              delay:0.25
             usingSpringWithDamping:0.9
              initialSpringVelocity:0.5
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
//                                PSLog(@"dismiss before x:%f, y:%f",_contentView.center.x , _contentView.center.y);
                             _contentView.center = CGPointMake(_contentView.center.x - 50, _contentView.center.y + 50);
                         }
                         completion:^(BOOL finished) {
                             [_button setStyle:kFRDLivelyButtonStyleHamburger animated:YES];
                             _sideBarAnimating = NO;
                             _sideBarShowed    = NO;
//                             [_labelPainter fadeOut];
//                             [_labelPainterDetails fadeOut];
                         }];
    }
}

#pragma mark - raotate
- (void)configureViewForOrientation:(UIInterfaceOrientation)orientation
{
    CGFloat videoWidth = 0;
    CGFloat videoHeight = 0;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        videoWidth = 700.f;
        videoHeight = 535.f;
    } else {
        videoWidth = self.view.frame.size.width;
        videoHeight = 220.f;
    }
    
    //    //calulate the frame on every rotation, so when we're returning from fullscreen mode we'll know where to position the movie plauyer
    //    self.defaultFrame = CGRectMake(self.view.frame.size.width/2 - videoWidth/2, self.view.frame.size.height/2 - videoHeight/2, videoWidth, videoHeight);
    //
    //    //only manage the movie player frame when it's not in fullscreen. when in fullscreen, the frame is automatically managed
    //    if (self.moviePlayer.isFullscreen)
    //        return;
    //
    //    //you MUST use [ALMoviePlayerController setFrame:] to adjust frame, NOT [ALMoviePlayerController.view setFrame:]
    //    [self.moviePlayer setFrame:self.defaultFrame];
    
    //     PSLog(@"player before x:%f, y:%f",self.moviePlayer.view.center.x , self.moviePlayer.view.center.y);
    //
    CGPoint p;
    if(self.view.bounds.size.width>self.view.bounds.size.height)
    {
        _contentView.frame  = [self LandscapeBounds];
        
        _button.frame = CGRectMake(25,self.view.bounds.size.height - 45, 30, 30);
        p = CGPointMake(self.view.center.y + 80, self.view.center.x -50);
    }
    else{
        CGRect bounds = [UIScreen mainScreen].bounds;
        _contentView.frame  = bounds;
        _button.frame = CGRectMake(25,self.view.bounds.size.height - 45, 30, 30);
        p = CGPointMake(self.view.center.x + 80, self.view.center.y -50);
    }
    
    self.defaultFrame = _contentView.frame;
    
    if(_sideBarShowed){
        [UIView animateWithDuration:0.75
                              delay:0
             usingSpringWithDamping:0.3
              initialSpringVelocity:0.5
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             //                             PSLog(@"self.view.center.x:%f, self.view.center.y:%f",self.view.center.x , self.view.center.y);
                             _contentView.center = p;
                         }
                         completion:^(BOOL finished) {
                         }];
    }
    
    
    //calulate the frame on every rotation, so when we're returning from fullscreen mode we'll know where to position the movie plauyer
    //    self.defaultFrame = _contentView.frame;
    
    //only manage the movie player frame when it's not in fullscreen. when in fullscreen, the frame is automatically managed
    if (self.moviePlayer.isFullscreen)
        return;
    
    //you MUST use [ALMoviePlayerController setFrame:] to adjust frame, NOT [ALMoviePlayerController.view setFrame:]
    //    [self.moviePlayer setFrame:self.defaultFrame];
    
    
}

- (CGRect)LandscapeBounds
{
	CGRect bounds = [UIScreen mainScreen].bounds;
    CGFloat width = bounds.size.width; bounds.size.width = bounds.size.height; bounds.size.height = width;
    
	return bounds;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    //    return (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft);
    return YES;
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self configureViewForOrientation:toInterfaceOrientation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - All kinds of view

- (UIView *)createForegroundViewWithMainWeather:(NSArray *)mainWeather upWeather:(NSArray *)upWeather downWeather:(NSArray *)downWeather
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 705)];
    
    CGRect r1 = CGRectMake(105, 250, 185, 185);
    CGRect r2 = CGRectMake(315, 250, 185, 185);
    CGRect r3 = CGRectMake(525, 250, 185, 185);
    CGRect r4 = CGRectMake(735, 250, 185, 185);
//    weather sunny = sunny;
//    weather rainy = rainy;
//    weather snowy = snowy;
//    weather cloudy = cloudy;
    int random1 = arc4random_uniform(4);
    int random2 = arc4random_uniform(4);
    int random3 = arc4random_uniform(4);
    int random4 = arc4random_uniform(4);
    
    weatherForecastView *fview1 = [[weatherForecastView alloc] initWithFrame:r1 Title:@"明天" weather:random1 upTemperature:((NSNumber *)upWeather[0]).intValue downTemperature:((NSNumber *)downWeather[0]).intValue];
    weatherForecastView *fview2 = [[weatherForecastView alloc] initWithFrame:r2 Title:@"后天" weather:random1 upTemperature:((NSNumber *)upWeather[1]).intValue downTemperature:((NSNumber *)downWeather[1]).intValue];
    weatherForecastView *fview3 = [[weatherForecastView alloc] initWithFrame:r3 Title:@"12月10号" weather:random1 upTemperature:((NSNumber *)upWeather[2]).intValue downTemperature:((NSNumber *)downWeather[2]).intValue];
    weatherForecastView *fview4 = [[weatherForecastView alloc] initWithFrame:r4 Title:@"12月11号" weather:random1 upTemperature:((NSNumber *)upWeather[3]).intValue downTemperature:((NSNumber *)downWeather[3]).intValue];
    UIView *view1 = [self createSmallWeatherViewWithFrame:r1 Title:@"明天" mainWeather:random1 upperWeather:((NSNumber *)upWeather[0]).intValue downWeather:((NSNumber *)downWeather[0]).intValue];
    UIView *view2 = [self createSmallWeatherViewWithFrame:r2 Title:@"后天" mainWeather:random2 upperWeather:((NSNumber *)upWeather[1]).intValue downWeather:((NSNumber *)downWeather[1]).intValue];
    UIView *view3 = [self createSmallWeatherViewWithFrame:r3 Title:@"12月10号" mainWeather:random3 upperWeather:((NSNumber *)upWeather[2]).intValue downWeather:((NSNumber *)downWeather[2]).intValue];
    UIView *view4 = [self createSmallWeatherViewWithFrame:r4 Title:@"12月11号" mainWeather:random4 upperWeather:((NSNumber *)upWeather[3]).intValue downWeather:((NSNumber *)downWeather[3]).intValue];
//    UIView *view2 = [self createSmallWeatherViewWithFrame:r2 Title:@"后天" mainWeather:weather[1] upperWeather:25 downWeather:14];
//    UIView *view3 = [self createSmallWeatherViewWithFrame:r3 Title:@"12月10号" mainWeather:weather[2] upperWeather:10 downWeather:10];
//    UIView *view4 = [self createSmallWeatherViewWithFrame:r4 Title:@"12月11号" mainWeather:weather[3] upperWeather:21 downWeather:14];
    
    [view addSubview:fview1];
    [view addSubview:fview2];
    [view addSubview:fview3];
    [view addSubview:fview4];
    
    return view;
}

- (UIView *)createPopOverViewWithFrame:(CGRect)frame city:(NSString *)cityName image:(NSString *)imageName mainTemp:(NSInteger)temp upTemp:(NSInteger)upTemp downTemp:(NSInteger)downTemp humidity:(NSInteger)humidity wind:(NSInteger)wind
//- (UIView *)popOverView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 360, 360)];
    view.layer.cornerRadius = view.frame.size.width/4.f;
    view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.65];
    
    //city
    UILabel *labelCity = [[UILabel alloc] initWithFrame:CGRectMake(150, 20, 60, 40)];
    [labelCity setText:cityName];
    [labelCity setTextColor:[UIColor whiteColor]];
    labelCity.font = [UIFont boldSystemFontOfSize:20];
    //    [labelCity setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:25]];
    labelCity.textAlignment = NSTextAlignmentCenter;
    [view addSubview:labelCity];
    
    //main weather image
    UIImageView *mainWeather = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    mainWeather.frame = CGRectMake(100, 68, 160, 148);
    [view addSubview:mainWeather];
    
    //main weather index
    UILabel *labelIndex = [[UILabel alloc] initWithFrame:CGRectMake(40, 228, 90, 90)];
    [labelIndex setText:[NSString stringWithFormat:@"%i",temp]];
    [labelIndex setTextColor:[UIColor whiteColor]];
    //    [labelIndex setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:70]];
    labelIndex.font = [UIFont boldSystemFontOfSize:70];
    
    labelIndex.textAlignment = NSTextAlignmentCenter;
    labelIndex.adjustsFontSizeToFitWidth = YES;
    //    [view addSubview:labelIndex];
    
    FBShimmeringView *shimmeringVieWeather = [[FBShimmeringView alloc] initWithFrame:CGRectMake(40, 228, 90, 90)];
    shimmeringVieWeather.contentView = labelIndex;
    [view addSubview:shimmeringVieWeather];
    // Start shimmering.℃
    
    //    shimmeringViewCity.shimmeringSpeed = 0.5;
    //    shimmeringViewCity.shimmeringOpacity = 1.0;
    
    
    //main weather index
    UILabel *labelC = [[UILabel alloc] initWithFrame:CGRectMake(120, 246, 35, 30)];
    [labelC setText:@"℃"];
    [labelC setTextColor:[UIColor whiteColor]];
    //    [labelC setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30]];
    labelC.font = [UIFont boldSystemFontOfSize:30];
    
    labelC.textAlignment = NSTextAlignmentCenter;
    labelC.adjustsFontSizeToFitWidth = YES;
    //    [view addSubview:labelIndex];
    
    FBShimmeringView *shimmeringViewC = [[FBShimmeringView alloc] initWithFrame:CGRectMake(124, 248, 35, 30)];
    shimmeringViewC.contentView = labelC;
    [view addSubview:shimmeringViewC];
    
    UIImageView *upWeatherIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"upWeather"]];
    upWeatherIcon.frame = CGRectMake(175, 254, 10, 12);
    [view addSubview:upWeatherIcon];
    UIImageView *downWeatherIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"downWeather"]];
    downWeatherIcon.frame = CGRectMake(175, 284, 10, 12);
    [view addSubview:downWeatherIcon];
    
    //labelWeatherUp
    UILabel *labelWeatherUp = [[UILabel alloc] initWithFrame:CGRectMake(190, 244, 30, 30)];
    [labelWeatherUp setText:[NSString stringWithFormat:@"%i℃",upTemp]];
    [labelWeatherUp setTextColor:[UIColor whiteColor]];
    //    [labelWeatherUp setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30]];
    labelWeatherUp.textAlignment = NSTextAlignmentCenter;
    labelWeatherUp.adjustsFontSizeToFitWidth = YES;
    [view addSubview:labelWeatherUp];
    
    //labelWeatherDown
    UILabel *labelWeatherDown = [[UILabel alloc] initWithFrame:CGRectMake(190, 274, 30, 30)];
    [labelWeatherDown setText:[NSString stringWithFormat:@"%i℃",downTemp]];
    [labelWeatherDown setTextColor:[UIColor whiteColor]];
    //    [labelWeatherDown setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30]];
    labelWeatherDown.textAlignment = NSTextAlignmentCenter;
    labelWeatherDown.adjustsFontSizeToFitWidth = YES;
    [view addSubview:labelWeatherDown];
    
    UIImageView *line1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line1"]];
    line1.frame = CGRectMake(231, 246, 1, 58);
    line1.alpha = 0.5;
    [view addSubview:line1];
    
    UIImageView *perecitationIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"precipitation_main"]];
    perecitationIcon.frame = CGRectMake(240, 250, 20, 20);
    [view addSubview:perecitationIcon];
    UIImageView *windPowerIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"windPower_main"]];
    windPowerIcon.frame = CGRectMake(240, 280, 20, 20);
    [view addSubview:windPowerIcon];
    
    
    //labelHumidity
    UILabel *labelHumidity = [[UILabel alloc] initWithFrame:CGRectMake(255, 230, 60, 60)];
    [labelHumidity setText:@"56%"];
//    [labelHumidity setText:[NSString stringWithFormat:@"%i%%",humidity]];
    [labelHumidity setTextColor:[UIColor whiteColor]];
    //    [labelHumidity setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:40]];
    labelHumidity.textAlignment = NSTextAlignmentCenter;
    labelHumidity.adjustsFontSizeToFitWidth = YES;
    labelHumidity.font = [UIFont boldSystemFontOfSize:18.0f];
    CGSize sz = [labelHumidity.text sizeWithAttributes:@{NSFontAttributeName:labelHumidity.font}];
    CGRect rcHumL = CGRectMake(255, 230, sz.width , sz.height);
    [labelHumidity setFrame:rcHumL];
//    [view addSubview: labelHumidity];
    
    //labelWindSpeed
    UILabel *labelWindSpeed = [[UILabel alloc] initWithFrame:CGRectMake(263, 270, 60, 40)];
    [labelWindSpeed setText:@"12km/h"];
//    [labelWindSpeed setText:[NSString stringWithFormat:@"%ikm/h",wind]];
    [labelWindSpeed setTextColor:[UIColor whiteColor]];
    //    [labelWindSpeed setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:40]];
    labelWindSpeed.textAlignment = NSTextAlignmentCenter;
    labelWindSpeed.adjustsFontSizeToFitWidth = YES;
    labelHumidity.font = [UIFont boldSystemFontOfSize:18.0f];
    sz = [labelHumidity.text sizeWithAttributes:@{NSFontAttributeName:labelHumidity.font}];
    CGRect rWindL = CGRectMake(263, 270, sz.width , sz.height);
    [labelHumidity setFrame:rWindL];
//    [view addSubview:labelWindSpeed];
    
    FBShimmeringView *shimmeringViewHumidity = [[FBShimmeringView alloc] initWithFrame:CGRectMake(255, 230, 60, 60)];
    shimmeringViewHumidity.contentView = labelHumidity;
    [view addSubview:shimmeringViewHumidity];
    FBShimmeringView *shimmeringViewWindSpeed = [[FBShimmeringView alloc] initWithFrame:CGRectMake(263, 270, 60, 40)];
    shimmeringViewWindSpeed.contentView = labelWindSpeed;
    [view addSubview:shimmeringViewWindSpeed];
    
    // Start shimmering
    shimmeringViewC.shimmeringSpeed = 150;
    shimmeringVieWeather.shimmeringSpeed = 75;
    //    shimmeringVieWeather.shimmeringHighlightWidth = 1;
    shimmeringViewHumidity.shimmeringSpeed = 150;
    shimmeringViewWindSpeed.shimmeringSpeed = 150;
    shimmeringVieWeather.shimmering = YES;
    //    shimmeringViewC.shimmering = YES;
    //    shimmeringViewHumidity.shimmering = YES;
    //    shimmeringViewWindSpeed.shimmering = YES;
    return view;
}


- (UIView *)createSmallWeatherViewWithFrame:(CGRect)frame Title:(NSString *)title mainWeather:(weather)mainWeather upperWeather:(int)upperWeather downWeather:(int)downWeather
{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.layer.cornerRadius = view.frame.size.width/4.f;
    view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.65];
    //city
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, 80, 40)];
    [labelTitle setText:title];
    [labelTitle setTextColor:[UIColor whiteColor]];
    //    [labelTitle setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20]];
    labelTitle.textAlignment = NSTextAlignmentCenter;
    [view addSubview:labelTitle];
    
    //line under title
    UIView *lineView = nil;
    if(title==nil || title.length==0)
    {
        PSLog(@"drawRect title == nil");
    }
    else
    {
        //        CGContextRef ctx = UIGraphicsGetCurrentContext();
        //        CGContextSaveGState(ctx);
        //
        //        CGContextSetLineCap(ctx, kCGLineCapRound);
        //        CGContextSetLineWidth(ctx, 4.0);
        //        CGContextSetAllowsAntialiasing(ctx, YES);
        //        CGContextSetRGBStrokeColor(ctx, 0.0, 0.0, 0.0, 1.0);
        //        CGContextBeginPath(ctx);
        //
        //        CGContextMoveToPoint(ctx, 10, 40);
        //        CGContextAddLineToPoint(ctx, view.bounds.size.width - 10, 40);
        //
        //        CGContextStrokePath(ctx);
        lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 40, view.frame.size.width - 20, 1)];
        lineView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
    }
    
    [view addSubview:lineView];
    
    //main weather image
    UIImageView *mainWeatherView = nil;
    
    switch (mainWeather) {
        case sunny:
            mainWeatherView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sunny_small"]];
            break;
        case rainy:
            mainWeatherView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rainy_small"]];
            break;
        case cloudy:
            mainWeatherView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cloudy_small"]];
            break;
        case snowy:
            mainWeatherView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"snowy_small"]];
            break;
        case foggy:
            mainWeatherView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"foggy_small"]];
            break;
        default:
            break;
    }
    mainWeatherView.frame = CGRectMake(18, 70, 80, 70);
    [view addSubview:mainWeatherView];
    
    UIImageView *upWeatherIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"upWeather_big"]];
    upWeatherIcon.frame = CGRectMake(100, 80, 11, 16);
    [view addSubview:upWeatherIcon];
    UIImageView *downWeatherIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"downWeather_big"]];
    downWeatherIcon.frame = CGRectMake(100, 118, 11, 16);
    [view addSubview:downWeatherIcon];
    
    //labelWeatherUp
    UILabel *labelWeatherUp = [[UILabel alloc] initWithFrame:CGRectMake(120, 68, 40, 40)];
    [labelWeatherUp setText:[NSString stringWithFormat:@"%i℃",downWeather]];
    [labelWeatherUp setTextColor:[UIColor whiteColor]];
    //    [labelWeatherUp setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30]];
    labelWeatherUp.adjustsFontSizeToFitWidth = YES;
    [view addSubview:labelWeatherUp];
    
    //labelWeatherDown
    UILabel *labelWeatherDown = [[UILabel alloc] initWithFrame:CGRectMake(120, 108, 40, 40)];
    [labelWeatherDown setText:[NSString stringWithFormat:@"%i℃",upperWeather]];
    [labelWeatherDown setTextColor:[UIColor whiteColor]];
    //    [labelWeatherDown setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30]];
    labelWeatherDown.adjustsFontSizeToFitWidth = YES;
    [view addSubview:labelWeatherDown];
    
    UIImageView *line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line"]];
    line.frame = CGRectMake(95, 106, 74, 1);
    [view addSubview:line];
    
    FBShimmeringView *shimmeringViewUp = [[FBShimmeringView alloc] initWithFrame:CGRectMake(120, 68, 40, 40)];
    shimmeringViewUp.contentView = labelWeatherUp;
    [view addSubview:shimmeringViewUp];
    FBShimmeringView *shimmeringViewDown = [[FBShimmeringView alloc] initWithFrame:CGRectMake(120, 108, 40, 40)];
    shimmeringViewDown.contentView = labelWeatherDown;
    [view addSubview:shimmeringViewDown];
    
    shimmeringViewUp.shimmeringSpeed = arc4random_uniform(100);
    shimmeringViewDown.shimmeringSpeed = arc4random_uniform(100);
    //    shimmeringViewUp.shimmering = YES;
    //    shimmeringViewDown.shimmering = YES;
    
    return view;
}

- (UIView *)headerViewWithCityName:(NSString *)cityName temp:(int)temp mainweather:(weather)mainWeather
{
    return [self createHeaderViewWithFrame:CGRectMake(725, 16, 291, 39) city:cityName temperature:temp weather:mainWeather];
}

- (UIView *)createHeaderViewWithFrame:(CGRect)frame city:(NSString *)city temperature:(int)temperature weather:(weather)weather
{
    
    CGRect rc  = frame;
    CGRect rcCityIcon,rcCityL,rcteIcon,rcteLabel,rccLabel,rcwIcon,rcwL;
    rcCityIcon = CGRectMake(13, (rc.size.height - 24)/2, 20, 24);
    
    
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.layer.cornerRadius = view.frame.size.height/4.f;
    view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.65];
    
    UIImageView *cityIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"city"]];
    cityIcon.frame = CGRectMake(10, 10, 20, 24);
    cityIcon.frame = rcCityIcon;
    [view addSubview:cityIcon];
    
    //city
    UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 4, 30, 31)];
    [cityLabel setText:city];
    [cityLabel setTextColor:[UIColor whiteColor]];
    cityLabel.font = [UIFont systemFontOfSize:22.0f];
    CGSize sz = [cityLabel.text sizeWithAttributes:@{NSFontAttributeName:cityLabel.font}];
    rcCityL = CGRectMake(rcCityIcon.origin.x + rcCityIcon.size.width + 6, (rc.size.height - sz.height)/2, sz.width , sz.height);
    [cityLabel setFrame:rcCityL];
    //    [cityLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:22]];
    cityLabel.textAlignment = NSTextAlignmentCenter;
    cityLabel.adjustsFontSizeToFitWidth = YES;
    [view addSubview:cityLabel];
    
    UIImageView *tIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"t_icon"]];
    // tIcon.frame = CGRectMake(92, 10, 20, 24);
    rcteIcon = CGRectMake(rcCityL.origin.x + rcCityL.size.width + 26.0f,(rc.size.height - 24)/2 , 20, 24);
    tIcon.frame = rcteIcon;
    [view addSubview:tIcon];
    
    //temperature
    UILabel *tLabel = [[UILabel alloc] initWithFrame:CGRectMake(117, 10, 30, 26)];
    [tLabel setText:[NSString stringWithFormat:@"%i",temperature]];
    [tLabel setTextColor:[UIColor whiteColor]];
    tLabel.font = [UIFont boldSystemFontOfSize:24];
    //    [tLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:22]];
    tLabel.textAlignment = NSTextAlignmentCenter;
    tLabel.adjustsFontSizeToFitWidth = YES;
    CGSize szt = [tLabel.text sizeWithAttributes:@{NSFontAttributeName:tLabel.font}];
    rcteLabel = CGRectMake(rcteIcon.origin.x + rcteIcon.size.width + 5.0f,(rc.size.height - szt.height)/2, szt.width, szt.height);
    [tLabel setFrame:rcteLabel];
    [view addSubview:tLabel];
    
    FBShimmeringView *shimmeringViewUp = [[FBShimmeringView alloc] initWithFrame:CGRectMake(120, 10, 30, 26)];
    shimmeringViewUp.contentView = tLabel;
    shimmeringViewUp.frame = rcteLabel;
    [view addSubview:shimmeringViewUp];
    //
    UILabel *labelC = [[UILabel alloc] init];
    [labelC setText:@"℃"];
    [labelC setTextColor:[UIColor whiteColor]];
    labelC.font = [UIFont systemFontOfSize:15.0];
    
    //[labelC setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:10]];
    sz = [labelC.text sizeWithAttributes:@{NSFontAttributeName:labelC.font}];
    rccLabel = CGRectMake(rcteLabel.origin.x + rcteLabel.size.width + 3, rcteLabel.origin.y + 3, sz.width, sz.height);
    [labelC setFrame:rccLabel];
    labelC.textAlignment = NSTextAlignmentCenter;
    labelC.adjustsFontSizeToFitWidth = YES;
    [view addSubview:labelC];
    
    UIImageView *weatherIcon = nil;
    NSString *weatherString = nil;
    switch (weather) {
        case sunny:
            weatherIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sunny_icon"]];
            weatherString = @"晴天";
            break;
        case rainy:
            weatherIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rainy_icon"]];
            weatherString = @"下雨";
            break;
        case cloudy:
            weatherIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cloudy_icon"]];
            weatherString = @"阴天";
            break;
        case snowy:
            weatherIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"snowy_icon"]];
            weatherString = @"下雪";
            break;
        case foggy:
            weatherIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"foggy_icon"]];
            weatherString = @"雾霾";
            break;
        default:
            break;
    }
    weatherIcon.frame = CGRectMake(157, 10, 28, 24);
    rcwIcon = CGRectMake(rccLabel.origin.x + rccLabel.size.width + 22, (rc.size.height - 24)/2, 28., 24.);
    [weatherIcon setFrame:rcwIcon];
    [view addSubview:weatherIcon];
    
    //weatherString
    UILabel *wLabel = [[UILabel alloc] initWithFrame:CGRectMake(202, 10, 30, 24)];
    [wLabel setText:weatherString];
    [wLabel setTextColor:[UIColor whiteColor]];
    wLabel.font = [UIFont systemFontOfSize:22.0];
    //    [tLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:22]];
    wLabel.textAlignment = NSTextAlignmentCenter;
    wLabel.adjustsFontSizeToFitWidth = YES;
    sz = [wLabel.text sizeWithAttributes:@{NSFontAttributeName:wLabel.font}];
    rcwL = CGRectMake(rcwIcon.origin.x + rcwIcon.size.width + 5, (rc.size.height - sz.height)/2, sz.width, sz.height);
    [wLabel setFrame:rcwL];
    [view addSubview:wLabel];
    
    
    shimmeringViewUp.shimmeringSpeed = 70;
    shimmeringViewUp.shimmering = YES;
    return view;
}

- (UIView *)createInfoViewWithFrame:(CGRect)frame title:(NSString *)title text:(NSString *)text
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.layer.cornerRadius = view.frame.size.width/4.f;
    view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.65];
    
//    UIImageView* infoIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"info_icon.png"]];
//    infoIcon.frame = CGRectMake(112.0f, 24.0f, 22.0f, 22.0f);
//    [view addSubview:infoIcon];
//    
//    //info title
//    UILabel *labelTitle = [[UILabel alloc] init];
//    labelTitle.font = [UIFont boldSystemFontOfSize:22.0];
//    [labelTitle setText:@"关于我们"];
//    CGSize sz = [labelTitle.text sizeWithAttributes:@{NSFontAttributeName:labelTitle.font}];
//    labelTitle.frame = CGRectMake(infoIcon.frame.origin.x + infoIcon.frame.size.width + 5.0, 24, sz.width,sz.height );
//    [labelTitle setTextColor:[UIColor whiteColor]];
//    //    [labelTitle setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20]];
//    labelTitle.textAlignment = NSTextAlignmentCenter;
//    [view addSubview:labelTitle];
//    
    //line under title
    UIView *lineView = nil;
    if(title==nil || title.length==0)
    {
        PSLog(@"drawRect title == nil");
    }
    else
    {
        lineView = [[UIView alloc]initWithFrame:CGRectMake(18, 54, view.frame.size.width - 36, 1)];
        lineView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
    }
    [view addSubview:lineView];
    
//    //text
//    UILabel *labelContent = [[UILabel alloc] init];
//    labelContent.font = [UIFont boldSystemFontOfSize:18.0];
//    labelContent.numberOfLines =3;
//    [labelContent setText:@"画境 是通过将名画动态情景化，来表达\n天气的变化莫测，希望能让人们在生活\n中感受到艺术的魅力。"];
//    CGSize contentSize = [labelContent.text sizeWithAttributes:@{NSFontAttributeName:labelContent.font}];
//    labelContent.frame = CGRectMake(lineView.frame.origin.x , lineView.frame.origin.y + 10, contentSize.width,contentSize.height );
//    [labelContent setTextColor:[UIColor whiteColor]];
//    //    [labelTitle setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20]];
//    labelContent.textAlignment = NSTextAlignmentLeft;
//    [view addSubview:labelContent];
//    
//    UILabel *labelAuthor = [[UILabel alloc] init];
//    labelAuthor.font = [UIFont boldSystemFontOfSize:19.0];
////    labelAuthor.numberOfLines =3;
//    [labelAuthor setText:@"设计:靖绪楠 陈超 张玉玲   程序:王康"];
//   contentSize = [labelAuthor.text sizeWithAttributes:@{NSFontAttributeName:labelAuthor.font}];
//    labelAuthor.frame = CGRectMake(lineView.frame.origin.x , labelContent.frame.origin.y + labelContent.frame.size.height+ 10, contentSize.width,contentSize.height );
//    [labelAuthor setTextColor:[UIColor whiteColor]];
//    //    [labelTitle setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20]];
//    labelAuthor.textAlignment = NSTextAlignmentLeft;
//    [view addSubview:labelAuthor];
//
//    UILabel *labelAuthor1 = [[UILabel alloc] init];
//    labelAuthor1.font = [UIFont boldSystemFontOfSize:19.0];
//    [labelAuthor1 setText:@"艺术顾问：孙炜"];
//    contentSize = [labelAuthor1.text sizeWithAttributes:@{NSFontAttributeName:labelAuthor1.font}];
//    labelAuthor1.frame = CGRectMake(lineView.frame.origin.x , labelAuthor.frame.origin.y + labelAuthor.frame.size.height+ 10, contentSize.width,contentSize.height );
//    [labelAuthor1 setTextColor:[UIColor whiteColor]];
//    //    [labelTitle setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20]];
//    labelAuthor1.textAlignment = NSTextAlignmentLeft;
//    [view addSubview:labelAuthor1];
//    
//    UILabel *labelAuthor2 = [[UILabel alloc] init];
//    labelAuthor2.font = [UIFont boldSystemFontOfSize:19.0];
//    [labelAuthor2 setText:@"指导老师：童元园"];
//    contentSize = [labelAuthor2.text sizeWithAttributes:@{NSFontAttributeName:labelAuthor2.font}];
//    labelAuthor2.frame = CGRectMake(lineView.frame.origin.x , labelAuthor1.frame.origin.y + labelAuthor1.frame.size.height+ 10, contentSize.width,contentSize.height );
//    [labelAuthor2 setTextColor:[UIColor whiteColor]];
//    //    [labelTitle setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20]];
//    labelAuthor2.textAlignment = NSTextAlignmentLeft;
//    [view addSubview:labelAuthor2];
//    
//    UIImageView* logo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CAA_Logo.png"]];
//    logo.frame = CGRectMake(51.5f, labelAuthor2.frame.origin.y+ labelAuthor2.frame.size.height + 20, 240.0f, 46.0f);
//    
//    [view addSubview:logo];
    UIImageView* wholeAbout = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"aboutus"]];
    wholeAbout.frame = CGRectMake(30, 15, 279, 308);

    [view addSubview:wholeAbout];

    
    return view;
}

- (UIView *)createCitySwitchViewWithFrame:(CGRect)frame title:(NSString *)title cityArray:(NSMutableArray *)cityarray
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.layer.cornerRadius = view.frame.size.width/4.f;
    view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.65];
    
    UIImageView* cityIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"city_icon.png"]];
    cityIcon.frame = CGRectMake(122.0f, 24.0f, 22.0f, 22.0f);
    
    //info title
    UILabel *labelTitle = [[UILabel alloc] init];
    labelTitle.font = [UIFont systemFontOfSize:18.0];
    [labelTitle setText:title];
    CGSize sz = [labelTitle.text sizeWithAttributes:@{NSFontAttributeName:labelTitle.font}];
    labelTitle.frame = CGRectMake(cityIcon.frame.origin.x + cityIcon.frame.size.width + 5.0, 24, sz.width,sz.height );
    [labelTitle setTextColor:[UIColor whiteColor]];
    //    [labelTitle setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20]];
    labelTitle.textAlignment = NSTextAlignmentCenter;
    
    //line under title
    UIView *lineView = nil;
    if(title==nil || title.length==0)
    {
        PSLog(@"drawRect title == nil");
    }
    else
    {
        lineView = [[UIView alloc]initWithFrame:CGRectMake(18, 68, view.frame.size.width - 36, 1)];
        lineView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
    }
    
    
    //city6
    UIImage* icon = [UIImage imageNamed:@"delete.png"];
    
    CGRect icon1,icon2,icon3,icon4,icon5,icon6;
    CGRect city1,city2,city3,city4,city5,city6;
    
    
    
    UILabel* cityLabel1 = [[UILabel alloc]init];
    UILabel* cityLabel2 = [[UILabel alloc]init];
    UILabel* cityLabel3 = [[UILabel alloc]init];
    UILabel* cityLabel4 = [[UILabel alloc]init];
    UILabel* cityLabel5 = [[UILabel alloc]init];
    UILabel* cityLabel6 = [[UILabel alloc]init];
    
    cityLabel1.text = [NSString stringWithString:[cityarray objectAtIndex:0]];
    cityLabel2.text = [NSString stringWithString:[cityarray objectAtIndex:1]];
    cityLabel3.text = [NSString stringWithString:[cityarray objectAtIndex:2]];
    cityLabel4.text = [NSString stringWithString:[cityarray objectAtIndex:3]];
    cityLabel5.text = [NSString stringWithString:[cityarray objectAtIndex:4]];
    cityLabel6.text = [NSString stringWithString:[cityarray objectAtIndex:5]];
    
    cityLabel1.font = [UIFont systemFontOfSize:18.0f];
    cityLabel1.textColor = [UIColor whiteColor];
    
    cityLabel2.font = [UIFont systemFontOfSize:18.0f];
    cityLabel2.textColor = [UIColor whiteColor];
    
    cityLabel3.font = [UIFont systemFontOfSize:18.0f];
    cityLabel3.textColor = [UIColor whiteColor];
    
    cityLabel4.font = [UIFont systemFontOfSize:18.0f];
    cityLabel4.textColor = [UIColor whiteColor];
    
    cityLabel5.font = [UIFont systemFontOfSize:18.0f];
    cityLabel5.textColor = [UIColor whiteColor];
    
    cityLabel6.font = [UIFont systemFontOfSize:18.0f];
    cityLabel6.textColor = [UIColor whiteColor];
    
    
    CGSize textsz = [cityLabel1.text sizeWithAttributes:@{NSFontAttributeName:cityLabel1.font}];
    
    icon1 = CGRectMake(10, lineView.frame.origin.y + lineView.frame.size.height + 65, 24, 24);
    city1 = CGRectMake(icon1.origin.x + icon1.size.width + 10, lineView.frame.origin.y + lineView.frame.size.height +65, textsz.width, textsz.height);
    
    icon2 = CGRectMake(city1.origin.x + city1.size.width + 58, icon1.origin.y, icon.size.width, icon.size.width);
    city2 = CGRectMake(icon2.origin.x + icon2.size.width + 10, city1.origin.y, textsz.width, textsz.height);
    
    icon3 = CGRectMake(city2.origin.x + city2.size.width + 58, icon1.origin.y, icon.size.width, icon.size.width);
    city3 = CGRectMake(icon3.origin.x + icon3.size.width + 10, city1.origin.y, textsz.width, textsz.height);
    
    icon4 = CGRectMake(icon1.origin.x , icon1.origin.y + icon1.size.height + 58, icon.size.width, icon.size.width);
    city4 = CGRectMake(icon4.origin.x + icon4.size.width + 10, city1.origin.y + city1.size.height + 62, textsz.width, textsz.height);
    
    icon5 = CGRectMake(city4.origin.x + city4.size.width + 58, icon4.origin.y, icon.size.width, icon.size.width);
    city5 = CGRectMake(icon5.origin.x + icon5.size.width + 10, city4.origin.y , textsz.width, textsz.height);
    
    icon6 = CGRectMake(city5.origin.x + city5.size.width + 58, icon5.origin.y, icon.size.width, icon.size.width);
    city6 = CGRectMake(icon6.origin.x + icon6.size.width + 10, city4.origin.y, textsz.width, textsz.height);
    
    
    UIImageView* iconImageView1 = [[UIImageView alloc]initWithImage:icon];
    iconImageView1.frame = icon1;
    
    UIImageView* iconImageView2 = [[UIImageView alloc]initWithImage:icon];
    iconImageView2.frame = icon2;
    
    UIImageView* iconImageView3 = [[UIImageView alloc]initWithImage:icon];
    iconImageView3.frame = icon3;
    
    UIImageView* iconImageView4 = [[UIImageView alloc]initWithImage:icon];
    iconImageView4.frame = icon4;
    
    UIImageView* iconImageView5 = [[UIImageView alloc]initWithImage:icon];
    iconImageView5.frame = icon5;
    
    UIImageView* iconImageView6 = [[UIImageView alloc]initWithImage:icon];
    iconImageView6.frame = icon6;
    
//    UITapGestureRecognizer *myTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickAddCityButton:)];
//    iconImageView1.userInteractionEnabled = YES;
//    [iconImageView1 addGestureRecognizer:myTapGesture];
//    iconImageView2.userInteractionEnabled = YES;
//    [iconImageView2 addGestureRecognizer:myTapGesture];
//    iconImageView3.userInteractionEnabled = YES;
//    [iconImageView3 addGestureRecognizer:myTapGesture];
//    iconImageView4.userInteractionEnabled = YES;
//    [iconImageView4 addGestureRecognizer:myTapGesture];
//    iconImageView5.userInteractionEnabled = YES;
//    [iconImageView5 addGestureRecognizer:myTapGesture];
//    iconImageView6.userInteractionEnabled = YES;
//    [iconImageView6 addGestureRecognizer:myTapGesture];
    
    cityLabel1.frame = city1;
    cityLabel2.frame = city2;
    cityLabel3.frame = city3;
    cityLabel4.frame = city4;
    cityLabel5.frame = city5;
    cityLabel6.frame = city6;
    
    CGRect rcIcon = icon1,rcCity = city1;
    
    //    for (NSInteger i = 0; i < 6 ; i++) {
    //        UIImageView* iconImageView = [[UIImageView alloc]initWithImage:icon];
    //        if (i < 3) {
    //            rcIcon = CGRectMake(rcCity.origin.x + rcCity.size.width + 58, rcIcon.origin.y, icon.size.width, icon.size.height);
    //            rcCity = CGRectMake(rcIcon.origin.x + rcIcon.size.width + 10, rcCity.origin.y, textsz.width, textsz.height);
    //        }
    //    }
    [view addSubview:cityIcon];
    [view addSubview:labelTitle];
    [view addSubview:lineView];
    [view addSubview:iconImageView1];
    [view addSubview:cityLabel1];
    [view addSubview:iconImageView2];
    [view addSubview:cityLabel2];
    [view addSubview:iconImageView3];
    [view addSubview:cityLabel3];
    [view addSubview:iconImageView4];
    [view addSubview:cityLabel4];
    [view addSubview:iconImageView5];
    [view addSubview:cityLabel5];
    [view addSubview:iconImageView6];
    [view addSubview:cityLabel6];
    
    return view;
}

- (void)onClickAddCityButton:(UIImageView *)sender
{
    if(sender.image == [UIImage imageNamed:@"删除1.png"]){
        sender.image = [UIImage imageNamed:@"添加1.png"];
    }else{
        sender.image = [UIImage imageNamed:@"删除1.png"];
    }
}

- (UIView *)createPainterViewWithFrame:(CGRect)frame painter:(NSString *)painter details:(NSString *)details
{
    UIView *painterInfo = [[UIView alloc] initWithFrame:frame];
    //    painterInfo.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    
    _labelPainter = [[RQShineLabel alloc] init];
    _labelPainter.font = [UIFont boldSystemFontOfSize:18.0];
    [_labelPainter setText:painter];
    CGSize sz = [_labelPainter.text sizeWithAttributes:@{NSFontAttributeName:_labelPainter.font}];
    _labelPainter.frame = CGRectMake(15 , 10 ,sz.width, sz.height  );
    [_labelPainter setTextColor:[UIColor whiteColor]];
    //    [labelTitle setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20]];
    _labelPainter.textAlignment = NSTextAlignmentCenter;
    
    [painterInfo addSubview:_labelPainter];
    
    
    _labelPainterDetails = [[RQShineLabel alloc] init];
    _labelPainterDetails.font = [UIFont boldSystemFontOfSize:16.0];
    _labelPainterDetails.numberOfLines =2;
    [_labelPainterDetails setText:details];
    CGSize sz1 = [_labelPainterDetails.text sizeWithAttributes:@{NSFontAttributeName:_labelPainterDetails.font}];
    _labelPainterDetails.frame = CGRectMake(20 + _labelPainter.frame.origin.x + _labelPainter.frame.size.width , 5 ,sz1.width, sz1.height  );
    [_labelPainterDetails setTextColor:[UIColor whiteColor]];
    //    [labelTitle setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20]];
    _labelPainterDetails.textAlignment = NSTextAlignmentLeft;
    [painterInfo addSubview:_labelPainterDetails];
    
    _labelPainter.fadeoutDuration = 0.1;
    _labelPainterDetails.fadeoutDuration = 0.1;
    
    [_labelPainter fadeOut];
    [_labelPainterDetails fadeOut];
    return  painterInfo;
}

@end
