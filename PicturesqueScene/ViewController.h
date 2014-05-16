//
//  ViewController.h
//  PicturesqueScene
//
//  Created by stan on 3/25/14.
//  Copyright (c) 2014 stan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STANSideBar.h"
#import "networkWeather.h"
#import "ALMoviePlayerController.h"
@interface ViewController : UIViewController
<STANSideBarDelegate,UIScrollViewDelegate,weatherDelegate>

@property (nonatomic, strong) ALMoviePlayerController *moviePlayer;

@end
