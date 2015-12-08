//
//  CommentView.m
//  Boar
//
//  Created by George Matau on 25/11/2015.
//  Copyright © 2015 Visible Tech. All rights reserved.
//

#import "CommentView.h"

@implementation CommentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (int)setupComment:(NSDictionary*)dicComment {
    // Name
    [self.lblName setText:[dicComment objectForKey:@"name"]];
    [self.lblName sizeToFit];
    // Comment
    NSString* htmlComment = [NSString stringWithFormat:@"<html><head><style type='text/css'>body { font: 10pt 'Gill Sans'; color: #555555; }</style></head><body>%@</body></html>", [dicComment objectForKey:@"content"]];
    [self.lblComment setAttributedText:[[NSAttributedString alloc]
                                            initWithData: [htmlComment dataUsingEncoding:NSUTF8StringEncoding]
                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                            documentAttributes: nil
                                            error: nil]];
    
    [self.lblComment sizeToFit];
    // Separator
    [self.ivSeparator setFrame:CGRectMake(20, self.lblComment.frame.origin.y + self.lblComment.frame.size.height + 9, self.ivSeparator.frame.size.width, 1)];
    
    NSLog(@"Separator y:%f", self.ivSeparator.frame.origin.y);
    
    return self.lblComment.frame.origin.y + self.lblComment.frame.size.height + 10;
}

@end
