//
//  FeedListCell.m
//  Boar
//
//  Created by George Matau on 19/03/2014.
//  Copyright (c) 2014 Visible Tech. All rights reserved.
//

#import "FeedListCell.h"

@implementation FeedListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) displayItem:(NSDictionary*) item {
    // Title, category
    self.lblTitle.text = [[BModel sharedBModel] changeSpecialCharacters:[item valueForKey:@"title"]];
    NSString* strCategory = [[BModel sharedBModel] getCategoryFromList:[item objectForKey:@"categories"]];
    self.lblCategory.text = [[[BModel sharedBModel] changeSpecialCharacters:strCategory] uppercaseString];
    [self.lblCategory setTextColor:[[BModel sharedBModel] getColorForSection:[[BModel sharedBModel] changeSpecialCharacters:strCategory]]];
    self.ivCategory.backgroundColor = [[BModel sharedBModel] getColorForSection:[[BModel sharedBModel] changeSpecialCharacters:strCategory]];
    // Date
    NSString *str = [item valueForKey:@"date"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:str];
    [formatter setDateFormat:@"dd MMMM yyyy"];
    self.lblDate.text = [formatter stringFromDate:date];
    // Images
    self.ivPhoto.clipsToBounds = YES;
    [self.ivPhoto setImage:nil];
    UIImage *photo = [[BModel sharedBModel].imagesCache objectForKey:[item valueForKey:@"id"]];
    if(photo == nil) {
        // Not in cache
        if([[BModel sharedBModel] isOnline]) {
            // Download and scale
            if([[item objectForKey:@"thumbnail_images"] isKindOfClass:[NSDictionary class]]) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    // Get and resize image
                    int pWidth = [[[[item objectForKey:@"thumbnail_images"] objectForKey:@"large"] valueForKey:@"width"]intValue];
                    int pHeight = [[[[item objectForKey:@"thumbnail_images"] objectForKey:@"large"] valueForKey:@"height"]intValue];
                    float pScale = [[BModel sharedBModel] getScaleFromWidth:pWidth andHeight:pHeight forContainer:self.ivPhoto];
                    
                    UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[[item objectForKey:@"thumbnail_images"] objectForKey:@"large"] valueForKey:@"url"]]]scale:pScale];
                    //                NSLog(@"Size of image: %f x %f", img.size.width, img.size.height);
                    
                    // Display image
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[BModel sharedBModel].imagesCache setValue:img forKey:[item valueForKey:@"id"]];
                        [self.ivPhoto setImage:img];
                    });
                });
            }
        } else {
            // Check if asset is stored
            NSDictionary* imageAssets = [[BModel sharedBModel] getStoredImageAssets];
            if([imageAssets objectForKey:[item valueForKey:@"id"]] != nil) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    // Get image from assets
                    NSURL* assetUrl = [[imageAssets objectForKey:[item valueForKey:@"id"]] objectForKey:@"id"];
                    UIImage *img = [[BModel sharedBModel] imageFromAssetUrl:assetUrl];
                    // Display image
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[BModel sharedBModel].imagesCache setValue:img forKey:[item valueForKey:@"id"]];
                        [self.ivPhoto setImage:img];
                    });
                });
            }
        }
    } else {
        // Take from cache
        [self.ivPhoto setImage:photo];
    }
}

@end
