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
        self.imagesCache = [NSMutableDictionary new];
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

#pragma mark - Application methods
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
        return [self colorFromHexString:COLOR_GAMES];
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

- (NSURL*)getURLForSection:(NSString *)section andPage:(int)page {
    if([section isEqualToString:@"News"]) {
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@?json=1&page=%d&count=%d",LINK_NEWS, page, NUMBER_ARTICLES]];
    } else if([section isEqualToString:@"Comment"]) {
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@?json=1&page=%d&count=%d",LINK_COMMENT, page, NUMBER_ARTICLES]];
    } else if([section isEqualToString:@"Features"]) {
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@?json=1&page=%d&count=%d",LINK_FEATURES, page, NUMBER_ARTICLES]];
    } else if([section isEqualToString:@"Lifestyle"]) {
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@?json=1&page=%d&count=%d",LINK_LIFESTYLE, page, NUMBER_ARTICLES]];
    } else if([section isEqualToString:@"Money"]) {
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@?json=1&page=%d&count=%d",LINK_MONEY, page, NUMBER_ARTICLES]];
    } else if([section isEqualToString:@"Arts"]) {
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@?json=1&page=%d&count=%d",LINK_ARTS, page, NUMBER_ARTICLES]];
    } else if([section isEqualToString:@"Books"]) {
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@?json=1&page=%d&count=%d",LINK_BOOKS, page, NUMBER_ARTICLES]];
    } else if([section isEqualToString:@"Film"]) {
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@?json=1&page=%d&count=%d",LINK_FILM, page, NUMBER_ARTICLES]];
    } else if([section isEqualToString:@"Games"]) {
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@?json=1&page=%d&count=%d",LINK_GAMES, page, NUMBER_ARTICLES]];
    } else if([section isEqualToString:@"Music"]) {
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@?json=1&page=%d&count=%d",LINK_MUSIC, page, NUMBER_ARTICLES]];
    } else if([section isEqualToString:@"Science & Tech"]) {
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@?json=1&page=%d&count=%d",LINK_SCIENCE_TECH, page, NUMBER_ARTICLES]];
    } else if([section isEqualToString:@"Travel"]) {
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@?json=1&page=%d&count=%d",LINK_TRAVEL, page, NUMBER_ARTICLES]];
    } else if([section isEqualToString:@"TV"]) {
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@?json=1&page=%d&count=%d",LINK_TV, page, NUMBER_ARTICLES]];
    } else if([section isEqualToString:@"Sport"]) {
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@?json=1&page=%d&count=%d",LINK_SPORT, page, NUMBER_ARTICLES]];
    } else if([section isEqualToString:@"Photography"]) {
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@?json=1&page=%d&count=%d",LINK_PHOTOGRAPHY, page, NUMBER_ARTICLES]];
    } else {
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@?json=1&page=%d&count=%d",LINK_HOME, page, NUMBER_ARTICLES]];
    }
}

- (NSURL*)getURLForSearchTerm:(NSString*)searchTerm andPage:(int)page {
    searchTerm = [searchTerm stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@?json=1&s=%@&page=%d&count=%d",LINK_HOME, searchTerm, page, NUMBER_ARTICLES]];
}

- (NSURL*)getURLForTag:(NSString*)tag andPage:(int)page {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/tag/%@/?json=1&page=%d&count=%d",LINK_HOME, tag, page, NUMBER_ARTICLES]];
}

- (NSURL*)getWebsiteForSection:(NSString *)section {
    if([section isEqualToString:@"News"]) {
        return [NSURL URLWithString:WEBPAGE_NEWS];
    } else if([section isEqualToString:@"Comment"]) {
        return [NSURL URLWithString:WEBPAGE_COMMENT];
    } else if([section isEqualToString:@"Features"]) {
        return [NSURL URLWithString:WEBPAGE_FEATURES];
    } else if([section isEqualToString:@"Lifestyle"]) {
        return [NSURL URLWithString:WEBPAGE_LIFESTYLE];
    } else if([section isEqualToString:@"Money"]) {
        return [NSURL URLWithString:WEBPAGE_MONEY];
    } else if([section isEqualToString:@"Arts"]) {
        return [NSURL URLWithString:WEBPAGE_ARTS];
    } else if([section isEqualToString:@"Books"]) {
        return [NSURL URLWithString:WEBPAGE_BOOKS];
    } else if([section isEqualToString:@"Film"]) {
        return [NSURL URLWithString:WEBPAGE_FILM];
    } else if([section isEqualToString:@"Games"]) {
        return [NSURL URLWithString:WEBPAGE_GAMES];
    } else if([section isEqualToString:@"Music"]) {
        return [NSURL URLWithString:WEBPAGE_MUSIC];
    } else if([section isEqualToString:@"Science & Tech"]) {
        return [NSURL URLWithString:WEBPAGE_SCIENCE_TECH];
    } else if([section isEqualToString:@"Travel"]) {
        return [NSURL URLWithString:WEBPAGE_TRAVEL];
    } else if([section isEqualToString:@"TV"]) {
        return [NSURL URLWithString:WEBPAGE_TV];
    } else if([section isEqualToString:@"Sport"]) {
        return [NSURL URLWithString:WEBPAGE_SPORT];
    } else if([section isEqualToString:@"Photography"]) {
        return [NSURL URLWithString:WEBPAGE_PHOTOGRAPHY];
    } else {
        return [NSURL URLWithString:WEBPAGE_HOME];
    }
}

- (NSString*)changeSpecialCharacters: (NSString*) foo {
    foo = [foo stringByReplacingOccurrencesOfString:@"&#038;" withString:@"&"];
    foo = [foo stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    foo = [foo stringByReplacingOccurrencesOfString:@"&#8211;" withString:@":"];
    foo = [foo stringByReplacingOccurrencesOfString:@"&#8217;" withString:@"'"];
    foo = [foo stringByReplacingOccurrencesOfString:@"&#8216;" withString:@"'"];
    foo = [foo stringByReplacingOccurrencesOfString:@"&#8218;" withString:@","];
    foo = [foo stringByReplacingOccurrencesOfString:@"&#8220;" withString:@"\""];
    foo = [foo stringByReplacingOccurrencesOfString:@"&#8221;" withString:@"\""];
    foo = [foo stringByReplacingOccurrencesOfString:@"&#8222;" withString:@",,"];
    foo = [foo stringByReplacingOccurrencesOfString:@"&#8230;" withString:@"..."];
    return foo;
}

- (NSString*) getModel {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString* systemModel = [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
    
    if([systemModel containsString:@"iPhone4"]) return @"iPhone 4S";
    else if([systemModel containsString:@"iPhone5,1"] || [systemModel containsString:@"iPhone5,2"]) return @"iPhone 5";
    else if([systemModel containsString:@"iPhone5,3"] || [systemModel containsString:@"iPhone5,4"]) return @"iPhone 5C";
    else if([systemModel containsString:@"iPhone6"]) return @"iPhone 5S";
    else if([systemModel containsString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    else if([systemModel containsString:@"iPhone7,2"]) return @"iPhone 6";
    else if([systemModel containsString:@"iPhone8,1"]) return @"iPhone 6S";
    else if([systemModel containsString:@"iPhone8,2"]) return @"iPhone 6S Plus";
    else return @"iPhone";
}

- (NSString*) getIOSVersion {
    return [UIDevice currentDevice].systemVersion;
}

- (float) getScaleFromWidth:(int)pWidth andHeight:(int)pHeight forContainer:(UIImageView*)ivPhoto {
    if(pHeight <= 0) {
        pHeight = pWidth/2;
    }
    float pRatio = pWidth/pHeight;
    float pScale = 1;
    if(pRatio > (ivPhoto.frame.size.width/ivPhoto.frame.size.height)) {
        // Scale by height
        if(ivPhoto.frame.size.height < pHeight) {
            pScale = pHeight/ivPhoto.frame.size.height;
        }
    } else {
        // Scale by width
        if(ivPhoto.frame.size.width < pWidth) {
            pScale = pWidth/ivPhoto.frame.size.width;
        }
    }
    
//    NSLog(@"Scale: %f from Picture: %d x %d to Container: %f x %f", pScale, pWidth, pHeight, ivPhoto.frame.size.width, ivPhoto.frame.size.height);
    
    return pScale;
}

- (void)cleanDictionary:(NSMutableDictionary *)dictionary {
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (obj == [NSNull null]) {
            [dictionary setObject:@"" forKey:key];
        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            [self cleanDictionary:obj];
        }
    }];
}

- (NSString*)getCategoryFromList:(NSArray*)arCategories {
    NSArray* allCategories = [NSArray arrayWithObjects:@"Home", @"Money", @"Arts", @"Comment", @"Features", @"Sport", @"Games", @"Science & Tech", @"Books", @"Travel", @"TV", @"Lifestyle", @"Music", @"News", @"Film", nil];
    NSString* strCategory = [[arCategories objectAtIndex:0] valueForKey:@"title"];
    int parent = [[[arCategories objectAtIndex:0] valueForKey:@"parent"] intValue];
    if([allCategories containsObject:strCategory] && parent == 0) {
        return strCategory;
    } else {
        for(NSDictionary* dicCategory in arCategories) {
            strCategory = [dicCategory valueForKey:@"title"];
            parent = [[dicCategory valueForKey:@"parent"] intValue];
            if([allCategories containsObject:strCategory] && parent == 0) {
                return strCategory;
            }
        }
        return [[arCategories objectAtIndex:0] valueForKey:@"title"];
    }
}

#pragma mark - Photos
- (void) saveImage:(UIImage*)image withDetails:(NSDictionary*)details {
    // Get image size
    NSData *imgData = UIImageJPEGRepresentation(image, 1);
    int imageSize = [imgData length];
    // Save image
    self.assetLibrary = [[ALAssetsLibrary alloc] init];
    ALAssetsLibrary *lib = self.assetLibrary;
    [self.assetLibrary addAssetsGroupAlbumWithName:@"The Boar" resultBlock:^(ALAssetsGroup *group) {
        // Album already exists
        if(group == nil){
            //enumerate albums
            [lib enumerateGroupsWithTypes:ALAssetsGroupAlbum
                               usingBlock:^(ALAssetsGroup *g, BOOL *stop) {
                                   
                 //if the album is equal to our album
                 if ([[g valueForProperty:ALAssetsGroupPropertyName] isEqualToString:@"The Boar"]) {
                     
                     //save image
                     [lib writeImageDataToSavedPhotosAlbum:UIImagePNGRepresentation(image) metadata:nil
                                           completionBlock:^(NSURL *assetURL, NSError *error) {
                                               
                                               //then get the image asseturl
                                               [lib assetForURL:assetURL
                                                    resultBlock:^(ALAsset *asset) {
                                                        //put it into our album
                                                        [g addAsset:asset];
                                                        NSMutableDictionary* dicAssets = [[BModel sharedBModel] getStoredImageAssets];
                                                        NSMutableDictionary* dicAsset = [NSMutableDictionary new];
                                                        [dicAsset setObject:assetURL forKey:@"id"];
                                                        [dicAsset setValue:[NSNumber numberWithInt:imageSize] forKey:@"size"];
                                                        [dicAsset setObject:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] forKey:@"date"];
                                                        [dicAssets setObject:dicAsset forKey:[details objectForKey:@"id"]];
                                                        [[BModel sharedBModel] saveImageAssetsToStorage:dicAssets];
                                                    } failureBlock:^(NSError *error) {
                                                    }];
                                           }];
                 }
             }failureBlock:^(NSError *error){
             }];
        }else{
            // Save image directly to library
            [lib writeImageDataToSavedPhotosAlbum:UIImagePNGRepresentation(image) metadata:nil
                                  completionBlock:^(NSURL *assetURL, NSError *error) {
                                      
                                      [lib assetForURL:assetURL
                                           resultBlock:^(ALAsset *asset) {
                                               // Save to album
                                               [group addAsset:asset];
                                               NSMutableDictionary* dicAssets = [[BModel sharedBModel] getStoredImageAssets];
                                               NSMutableDictionary* dicAsset = [NSMutableDictionary new];
                                               [dicAsset setObject:assetURL forKey:@"id"];
                                               [dicAsset setValue:[NSNumber numberWithInt:imageSize] forKey:@"size"];
                                               [dicAsset setObject:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] forKey:@"date"];
                                               [dicAssets setObject:dicAsset forKey:[details objectForKey:@"id"]];
                                               [[BModel sharedBModel] saveImageAssetsToStorage:dicAssets];
                                           } failureBlock:^(NSError *error) {
                                           }];
                                  }];
        }
    } failureBlock:^(NSError *error) {
    }];
}

- (int)getSizeImagesStored {
    NSDictionary* dicAssets = [self getStoredImageAssets];
    int totalSize = 0;
    for(NSString* key in dicAssets) {
        totalSize = totalSize + [[[dicAssets objectForKey:key] valueForKey:@"size"] intValue];
    }
    NSLog(@"Total assets size: %d", totalSize);
    
    return totalSize;
}

- (BOOL)shouldSaveImage {
    if([[BModel sharedBModel] getSaveImagesFromStorage] && [[BModel sharedBModel] isOnline] && [[BModel sharedBModel] getSizeImagesStored] < [[BModel sharedBModel] getCacheMaxSize]) {
        return YES;
    } else {
        return NO;
    }
}

- (NSURL*)getOldestImageSaved {
    NSDictionary* dicAssets = [self getStoredImageAssets];
    NSURL* oldestAsset;
    NSNumber* oldestDate = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    for(NSString* key in dicAssets) {
        if([[dicAssets objectForKey:key] objectForKey:@"date"] < oldestDate) {
            oldestDate = [[dicAssets objectForKey:key] objectForKey:@"date"];
            oldestAsset = [[dicAssets objectForKey:key] objectForKey:@"id"];
        }
    }
    
    return oldestAsset;
}

- (BOOL) clearAllAssets {
    // Iterate through all stored assets
    NSDictionary* dicAssets = [self getStoredImageAssets];
    NSMutableArray* arAssets = [NSMutableArray new];
    for(NSString* key in dicAssets) {
        NSURL* assetUrl = [[dicAssets objectForKey:key] objectForKey:@"id"];
        [arAssets addObject:assetUrl];
    }
    [self deleteAssetsWithUrls:arAssets];
    // Return
    if([dicAssets count] > 0) {
        return YES;
    } else {
        return NO;
    }
    // Not working -> will check on this later when have responses on StackOverflow
//    ALAssetsLibrary *lib = [ALAssetsLibrary new];
//    [lib enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
//        //if the album is equal to our album
//        NSLog(@"Going through album %@", [group valueForProperty:ALAssetsGroupPropertyName]);
//        if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:@"The Boar"]) {
//            // delete all assets
//            [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop) {
//                NSLog(@"asset url: %@", asset.defaultRepresentation.url);
//                if(asset.isEditable) {
//                    [asset setImageData:nil metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
//                        NSLog(@"Asset url %@ should be deleted. (Error %@)", assetURL, error);
//                    }];
//                }
//            }];
//            // remove from local
//            [[BModel sharedBModel]saveImageAssetsToStorage:[NSMutableDictionary new]];
//        }
//    } failureBlock:^(NSError *error) {
//        
//    }];
}

-(void)deleteAssetsWithUrls:(NSArray*)arALAssetURLs {
    // Create array of PHAssets
    PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:arALAssetURLs options:nil];
    NSMutableArray* arPHAssetURLs = [NSMutableArray new];
    for(PHAsset* asset in result) {
        [arPHAssetURLs addObject:asset];
    }
    // Remove assets
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^ {
        [PHAssetChangeRequest deleteAssets:arPHAssetURLs];
    } completionHandler:^(BOOL success, NSError *error) {
        if ((!success) && (error != nil)) {
            NSLog(@"Error deleting assets: %@", [error description]);
        } else {
            NSLog(@"Success removed assets: %@", arPHAssetURLs);
            // Remove from local
            [[BModel sharedBModel]saveImageAssetsToStorage:[NSMutableDictionary new]];
        }
    }];
}

-(void)deleteAssetWithURL:(NSURL*)assetURL {
    // Check if asset exists first
    if (assetURL == nil) {
        return;
    }
    // Get PHAsset and delete
    PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[assetURL] options:nil];
    if (result.count > 0) {
        PHAsset *phAsset = result.firstObject;
        if ((phAsset != nil) && ([phAsset canPerformEditOperation:PHAssetEditOperationDelete])) {
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^ {
                 [PHAssetChangeRequest deleteAssets:@[phAsset]];
            } completionHandler:^(BOOL success, NSError *error) {
                if ((!success) && (error != nil)) {
                    NSLog(@"Error deleting asset: %@", [error description]);
                } else {
                    NSLog(@"Success removed asset: %@", assetURL);
                }
             }];
        }
    }
}

- (UIImage *)imageFromAssetUrl:(NSURL*)assetURL {
//    NSURL* assetURL = [NSURL URLWithString:assetStringUrl];
    NSLog(@"asset url: %@", assetURL);
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    __block UIImage* image = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [assetsLibrary assetForURL:assetURL resultBlock: ^(ALAsset *asset) {
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        CGImageRef imageRef = [representation fullResolutionImage];
        if (imageRef) {
            image = [UIImage imageWithCGImage:imageRef scale:representation.scale orientation:(UIImageOrientation)representation.orientation];
        }
        dispatch_semaphore_signal(semaphore);
//        NSLog(@"success found image: %@", image);
    } failureBlock:^(NSError *error) {
        NSLog(@"failure-----");
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//    NSLog(@"returning image: %@", image);
    return image;
}

#pragma mark - local storage methods
- (void)getDataFromStorage {
    NSData *encodedData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"boarData"] mutableCopy];
    self.fullData = [NSKeyedUnarchiver unarchiveObjectWithData:encodedData];
    NSLog(@"got from storage");
}

- (void)saveDataToStorage {
    [self cleanDictionary:self.fullData];
    NSData *encodedData = [NSKeyedArchiver archivedDataWithRootObject:self.fullData];
    [[NSUserDefaults standardUserDefaults]setValue:encodedData forKey:@"boarData"];
    NSLog(@"saved to storage");
}

- (NSMutableArray*)getFavoritesFromStorage {
    NSMutableArray* arFavorites = [self.fullData objectForKey:@"Favorites"];
    if(arFavorites == nil) {
        return [NSMutableArray new];
    } else {
        return [arFavorites mutableCopy];
    }
}

- (void)saveFavoritesToStorage:(NSArray*)arFavorites {
    [self.fullData setObject:arFavorites forKey:@"Favorites"];
    [self saveDataToStorage];
}

- (NSString*)getDefaultCategoryFromStorage {
    NSString* strCategory = [self.fullData objectForKey:@"DefaultCategory"];
    if(strCategory == nil) {
        return @"Home";
    } else {
        return strCategory;
    }
}

- (void)saveDefaultCategoryToStorage:(NSString*)strCategory {
    [self.fullData setObject:strCategory forKey:@"DefaultCategory"];
    [self saveDataToStorage];
}

- (BOOL)getFullscreenFromStorage {
    NSString* strFullscreen = [self.fullData objectForKey:@"Fullscreen"];
    if(strFullscreen == nil || [strFullscreen isEqualToString:@"false"]) {
        return NO;
    } else {
        return YES;
    }
}

- (void)saveFullscreenToStorage:(NSString*)strFullscreen {
    [self.fullData setObject:strFullscreen forKey:@"Fullscreen"];
    [self saveDataToStorage];
}

- (BOOL)getSaveImagesFromStorage {
    NSString* strSaveImages = [self.fullData objectForKey:@"SaveImages"];
    if(strSaveImages == nil || [strSaveImages isEqualToString:@"false"]) {
        return NO;
    } else {
        return YES;
    }
}

- (void)saveSaveImagesToStorage:(NSString*)strSaveImages {
    [self.fullData setObject:strSaveImages forKey:@"SaveImages"];
    [self saveDataToStorage];
}

- (NSMutableDictionary*)getStoredImageAssets {
    NSMutableDictionary* dicAssets = [self.fullData objectForKey:@"Assets"];
    if(dicAssets == nil) {
        return [NSMutableDictionary new];
    } else {
        return [dicAssets mutableCopy];
    }
}

- (void)saveImageAssetsToStorage:(NSDictionary*)dicAssets {
    [self.fullData setObject:dicAssets forKey:@"Assets"];
    [self saveDataToStorage];
//    NSLog(@"Saved assets data: %@", dicAssets);
}

- (int)getCacheMaxSize {
    NSNumber* maxSize = [self.fullData objectForKey:@"CacheMaxSize"];
    if(maxSize == nil) {
        return 10000000;
    } else {
        return [maxSize intValue];
    }
}

- (void)saveCacheMaxSize:(int)maxSize {
    [self.fullData setObject:[NSNumber numberWithInt:maxSize] forKey:@"CacheMaxSize"];
    [self saveDataToStorage];
}


@end
