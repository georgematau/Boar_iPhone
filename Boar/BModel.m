//
//  BModel.m
//  Boar
//
//  Created by George Matau on 17/03/2014.
//  Copyright (c) 2014 Visible Tech. All rights reserved.
//

#import "BModel.h"

@implementation BModel

SYNTHESIZE_SINGLETON_ARC_FOR_CLASS(BModel);

- (id)init {
    self = [super init];
    if(self) {
        // init vars
        UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
        if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
            self.isShowingLandscapeView = true;
        } else {
            self.isShowingLandscapeView = false;
        }
        // init full data
        [self getDataFromStorage];
    }
    
	return self;
}

- (void)initReachability {
    // Check internet connection
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    if ([reachability currentReachabilityStatus] == NotReachable) {
        self.networkAvailable = NO;
    } else {
        self.networkAvailable = YES;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    NSLog(@"Reachability checked!");
}

- (BOOL)isOnline {
    // Check internet connection
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    if ([reachability currentReachabilityStatus] == NotReachable) {
        self.networkAvailable = NO;
        return NO;
    } else {
        self.networkAvailable = YES;
        return YES;
    }
}

- (UIColor*)getColorForSection:(NSString *)section {
    if([section isEqualToString:@"News"]) {
        return [self colorFromHexString:COLOR_NEWS];
    } else if([section isEqualToString:@"Comment"]) {
        return [self colorFromHexString:COLOR_COMMENT];
    } else if([section isEqualToString:@"Features"]) {
        return [self colorFromHexString:COLOR_FEATURES];
    } else if([section isEqualToString:@"Lifestyle"]) {
        return [self colorFromHexString:COLOR_LIFESTYLE];
    } else if([section isEqualToString:@"Money"]) {
        return [self colorFromHexString:COLOR_MONEY];
    } else if([section isEqualToString:@"Arts"]) {
        return [self colorFromHexString:COLOR_ARTS];
    } else if([section isEqualToString:@"Books"]) {
        return [self colorFromHexString:COLOR_BOOKS];
    } else if([section isEqualToString:@"Film"]) {
        return [self colorFromHexString:COLOR_FILM];
    } else if([section isEqualToString:@"Games"]) {
        return [self colorFromHexString:COLOR_COMMENT];
    } else if([section isEqualToString:@"Music"]) {
        return [self colorFromHexString:COLOR_MUSIC];
    } else if([section isEqualToString:@"Science & Tech"]) {
        return [self colorFromHexString:COLOR_SCIENCE_TECH];
    } else if([section isEqualToString:@"Travel"]) {
        return [self colorFromHexString:COLOR_TRAVEL];
    } else if([section isEqualToString:@"TV"]) {
        return [self colorFromHexString:COLOR_TV];
    } else if([section isEqualToString:@"Sport"]) {
        return [self colorFromHexString:COLOR_SPORT];
    } else if([section isEqualToString:@"Photography"]) {
        return [self colorFromHexString:COLOR_PHOTOGRAPHY];
    } else {
        return [UIColor grayColor];
    }
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

- (NSURL*)getURLForSection:(NSString *)section {
    if([section isEqualToString:@"News"]) {
        return [NSURL URLWithString:LINK_NEWS];
    } else if([section isEqualToString:@"Comment"]) {
        return [NSURL URLWithString:LINK_COMMENT];
    } else if([section isEqualToString:@"Features"]) {
        return [NSURL URLWithString:LINK_FEATURES];
    } else if([section isEqualToString:@"Lifestyle"]) {
        return [NSURL URLWithString:LINK_LIFESTYLE];
    } else if([section isEqualToString:@"Money"]) {
        return [NSURL URLWithString:LINK_MONEY];
    } else if([section isEqualToString:@"Arts"]) {
        return [NSURL URLWithString:LINK_ARTS];
    } else if([section isEqualToString:@"Books"]) {
        return [NSURL URLWithString:LINK_BOOKS];
    } else if([section isEqualToString:@"Film"]) {
        return [NSURL URLWithString:LINK_FILM];
    } else if([section isEqualToString:@"Games"]) {
        return [NSURL URLWithString:LINK_GAMES];
    } else if([section isEqualToString:@"Music"]) {
        return [NSURL URLWithString:LINK_MUSIC];
    } else if([section isEqualToString:@"Science & Tech"]) {
        return [NSURL URLWithString:LINK_SCIENCE_TECH];
    } else if([section isEqualToString:@"Travel"]) {
        return [NSURL URLWithString:LINK_TRAVEL];
    } else if([section isEqualToString:@"TV"]) {
        return [NSURL URLWithString:LINK_TV];
    } else if([section isEqualToString:@"Sport"]) {
        return [NSURL URLWithString:LINK_SPORT];
    } else if([section isEqualToString:@"Photography"]) {
        return [NSURL URLWithString:LINK_PHOTOGRAPHY];
    } else {
        return [NSURL URLWithString:LINK_HOME];
    }
}

- (void)getDataFromStorage {
    self.fullData =  [[NSUserDefaults standardUserDefaults] objectForKey:@"boarData"];
    NSLog(@"got from storage");
}

- (void)saveDataToStorage {
    [[NSUserDefaults standardUserDefaults]setValue:self.fullData forKey:@"boarData"];
    NSLog(@"saved to storage");
}

@end
