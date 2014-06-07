//
//  BModel.h
//  Boar
//
//  Created by George Matau on 17/03/2014.
//  Copyright (c) 2014 Visible Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"
#import "XMLReader.h"
#import "Reachability.h"

@interface BModel : NSObject

+ (BModel *)sharedBModel;
- (void)initReachability;
- (BOOL)isOnline;
- (UIColor*)getColorForSection:(NSString *)section;
- (UIColor *)colorFromHexString:(NSString *)hexString;
- (void)saveDataToStorage;
- (void)getDataFromStorage;
- (NSURL*)getURLForSection:(NSString *)section;


@property (nonatomic, getter = isNetworkAvailable) BOOL networkAvailable;
@property (nonatomic) BOOL isShowingLandscapeView;
@property (nonatomic, strong) NSMutableDictionary* fullData;

@end
