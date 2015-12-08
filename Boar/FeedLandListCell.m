//
//  FeedLandListCell.m
//  Boar
//
//  Created by George Matau on 19/03/2014.
//  Copyright (c) 2014 Visible Tech. All rights reserved.
//

#import "FeedLandListCell.h"

@implementation FeedLandListCell

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

- (void) displayItem1:(NSDictionary*) item1 andItem2:(NSDictionary*) item2 onRow:(int)row {
    // Item 1
    // Label
    self.view1.tag = row * 2;
    self.lblTitle1.text = [[BModel sharedBModel] changeSpecialCharacters:[item1 valueForKey:@"title"]];
    NSString* strCategory1 = [[BModel sharedBModel] getCategoryFromList:[item1 objectForKey:@"categories"]];
    self.lblCategory1.text = [[[BModel sharedBModel] changeSpecialCharacters:strCategory1] uppercaseString];
    [self.lblCategory1 setTextColor:[[BModel sharedBModel] getColorForSection:[[BModel sharedBModel] changeSpecialCharacters:strCategory1]]];
    self.ivCategory1.backgroundColor = [[BModel sharedBModel] getColorForSection:[[BModel sharedBModel] changeSpecialCharacters:strCategory1]];
    // Date
    NSString *str1 = [item1 valueForKey:@"date"];
    NSString *str2 = [item2 valueForKey:@"date"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date1 = [formatter dateFromString:str1];
    NSDate *date2 = [formatter dateFromString:str2];
    [formatter setDateFormat:@"dd MMMM yyyy"];
    self.lblDate1.text = [formatter stringFromDate:date1];
    
    // Item 2
    if(item2 != nil) {
        [self.view2 setHidden:NO];
        // Label
        self.view2.tag = row * 2 + 1;
        self.lblTitle2.text = [[BModel sharedBModel] changeSpecialCharacters:[item2 valueForKey:@"title"]];
        NSString* strCategory2 = [[BModel sharedBModel] getCategoryFromList:[item2 objectForKey:@"categories"]];
        self.lblCategory2.text = [[[BModel sharedBModel] changeSpecialCharacters:strCategory2] uppercaseString];
        [self.lblCategory2 setTextColor:[[BModel sharedBModel] getColorForSection:[[BModel sharedBModel] changeSpecialCharacters:strCategory2]]];
        self.ivCategory2.backgroundColor = [[BModel sharedBModel] getColorForSection:[[BModel sharedBModel] changeSpecialCharacters:strCategory2]];
        // Date
        self.lblDate2.text = [formatter stringFromDate:date2];
    } else {
        [self.view2 setHidden:YES];
    }
    
    // Images
    for(int i=0; i<2; i++) {
        UIImageView* ivPhoto;
        NSDictionary* item;
        if(i==0) {
            ivPhoto = self.ivPhoto1;
            item = item1;
        } else {
            ivPhoto = self.ivPhoto2;
            item = item2;
        }
        ivPhoto.clipsToBounds = YES;
        [ivPhoto setImage:nil];
        if(item != nil) {
            UIImage *photo = [[BModel sharedBModel].imagesCache objectForKey:[item valueForKey:@"id"]];
            if(photo == nil) {
                // Not in cache
                if([[BModel sharedBModel] isOnline]) {
                    // Download and scale
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        // Get and resize image
                        int pWidth = [[[[item objectForKey:@"thumbnail_images"] objectForKey:@"large"] valueForKey:@"width"]intValue];
                        int pHeight = [[[[item objectForKey:@"thumbnail_images"] objectForKey:@"large"] valueForKey:@"height"]intValue];
                        float pScale = [[BModel sharedBModel] getScaleFromWidth:pWidth andHeight:pHeight forContainer:ivPhoto];
                        
                        UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[[item objectForKey:@"thumbnail_images"] objectForKey:@"large"] valueForKey:@"url"]]]scale:pScale];
                        
                        // Display image
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [ivPhoto setImage:img];
                            [[BModel sharedBModel].imagesCache setValue:img forKey:[item valueForKey:@"id"]];
                        });
                    });
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
                                [ivPhoto setImage:img];
                            });
                        });
                    }
                }
                
            } else {
                // Take from cache
                [ivPhoto setImage:photo];
            }
        }
    }  
}

- (IBAction)btn1Select:(id)sender {
    NSNumber* no = [NSNumber numberWithInteger:self.view1.tag];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:no, @"index", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ItemPressed"
                                                        object:nil
                                                      userInfo:userInfo];
}
- (IBAction)btn2Select:(id)sender {
    NSNumber* no = [NSNumber numberWithInteger:self.view2.tag];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:no, @"index", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ItemPressed"
                                                        object:nil
                                                      userInfo:userInfo];
}
@end
