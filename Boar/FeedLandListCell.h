//
//  FeedLandListCell.h
//  Boar
//
//  Created by George Matau on 19/03/2014.
//  Copyright (c) 2014 Visible Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BModel.h"

@interface FeedLandListCell : UITableViewCell

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *ivPhoto1;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *ivCategory1;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblCategory1;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblTitle1;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblDate1;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *view1;

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *ivPhoto2;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *ivCategory2;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblCategory2;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblTitle2;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblDate2;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *view2;


- (IBAction)btn1Select:(id)sender;
- (IBAction)btn2Select:(id)sender;

- (void) displayItem1:(NSDictionary*) item1 andItem2:(NSDictionary*) item2 onRow:(int)row;

@end
