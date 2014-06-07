//
//  FeedListCell.h
//  Boar
//
//  Created by George Matau on 19/03/2014.
//  Copyright (c) 2014 Visible Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *ivPhoto;
@property (weak, nonatomic) IBOutlet UIImageView *ivCategory;
@property (weak, nonatomic) IBOutlet UILabel *lblCategory;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblAuthor;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;

@end
