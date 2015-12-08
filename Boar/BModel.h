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
#import <sys/utsname.h>
#import <AVFoundation/AVFoundation.h>
#import "AssetsLibrary/AssetsLibrary.h"
#import <Photos/Photos.h>

@interface BModel : NSObject

+ (BModel *)sharedBModel;
- (void)initReachability;
- (BOOL)isOnline;
- (UIColor*)getColorForSection:(NSString *)section;
- (UIColor *)colorFromHexString:(NSString *)hexString;
- (void)saveDataToStorage;
- (void)getDataFromStorage;
- (NSURL*)getURLForSection:(NSString *)section andPage:(int)page;
- (NSURL*)getURLForSearchTerm:(NSString*)searchTerm andPage:(int)page;
- (NSURL*)getURLForTag:(NSString*)tag andPage:(int)page;
- (NSString*) getModel;
- (NSString*) getIOSVersion;
- (NSString*)changeSpecialCharacters: (NSString*) foo;
- (float) getScaleFromWidth:(int)pWidth andHeight:(int)pHeight forContainer:(UIImageView*)ivPhoto;
- (void)cleanDictionary:(NSMutableDictionary *)dictionary;
- (NSURL*)getWebsiteForSection:(NSString *)section;
- (NSString*)getCategoryFromList:(NSArray*)arCategories;
- (NSMutableArray*)getFavoritesFromStorage;
- (void)saveFavoritesToStorage:(NSArray*)arFavorites;
- (NSString*)getDefaultCategoryFromStorage;
- (void)saveDefaultCategoryToStorage:(NSString*)strCategory;
- (BOOL)getFullscreenFromStorage;
- (void)saveFullscreenToStorage:(NSString*)strFullscreen;
- (BOOL)getSaveImagesFromStorage;
- (void)saveSaveImagesToStorage:(NSString*)strSaveImages;
- (NSMutableDictionary*)getStoredImageAssets;
- (void)saveImageAssetsToStorage:(NSDictionary*)arAssets;
- (void) saveImage:(UIImage*)image withDetails:(NSDictionary*)details;
- (int)getSizeImagesStored;
- (BOOL) clearAllAssets;
- (void)deleteAssetsWithUrls:(NSArray*)arALAssetURLs;
- (void)deleteAssetWithURL:(NSURL*)assetURL;
- (BOOL)shouldSaveImage;
- (int)getCacheMaxSize;
- (void)saveCacheMaxSize:(int)maxSize;
- (UIImage *)imageFromAssetUrl:(NSURL*)assetURL;

@property (nonatomic, getter = isNetworkAvailable) BOOL networkAvailable;
@property (nonatomic) BOOL isShowingLandscapeView;
@property (nonatomic, strong) NSMutableDictionary* fullData;
@property (nonatomic, strong) NSMutableDictionary *imagesCache;
@property (nonatomic, strong) ALAssetsLibrary* assetLibrary;

@end
