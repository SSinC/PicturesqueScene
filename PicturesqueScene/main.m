//
//  main.m
//  PicturesqueScene
//
//  Created by Stan on 14-4-4.
//  Copyright (c) 2014年 Stan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

CFAbsoluteTime StartTime;

int main(int argc, char * argv[])
{
    NSLog(@"start:%f",CFAbsoluteTimeGetCurrent());
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
