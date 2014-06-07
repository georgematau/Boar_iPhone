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
