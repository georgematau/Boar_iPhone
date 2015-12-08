//
//  CommentView.h
//  Boar
//
//  Created by George Matau on 25/11/2015.
//  Copyright © 2015 Visible Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentView : UIView

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblComment;
@property (weak, nonatomic) IBOutlet UIImageView *ivSeparator;


- (int)setupComment:(NSDictionary*)dicComment;

@end
