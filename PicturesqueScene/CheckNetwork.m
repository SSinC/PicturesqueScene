//
//  CheckNetwork.m
//  iphone.network1
//
//  Created by stan .
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CheckNetwork.h"
#import "Reachability.h"

#import "TSMessage.h"

@implementation CheckNetwork
+(BOOL)isExistenceNetwork
{
	BOOL isExistenceNetwork;
	Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
			isExistenceNetwork=FALSE;
            NSLog(@"无网络连接");
            break;
        case ReachableViaWWAN:
			isExistenceNetwork=TRUE;
            NSLog(@"3G网络");
            break;
        case ReachableViaWiFi:
			isExistenceNetwork=TRUE;
            NSLog(@"Wifi网络");
            break;
    }
	if (!isExistenceNetwork) {
        [TSMessage showNotificationWithTitle:@" Network Error" subtitle:@"There is a problem connecting to network." type:TSMessageNotificationTypeError];

//		UIAlertView *myalert = [[UIAlertView alloc] initWithTitle:@"网络连接" message:@"网络连接不存在" delegate:self cancelButtonTitle:@"OK，fuck it" otherButtonTitles:nil,nil];
//		[myalert show];
//		[myalert release];
	}
	return isExistenceNetwork;
}
@end
