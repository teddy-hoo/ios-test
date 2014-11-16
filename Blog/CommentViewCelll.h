//
//  CommentViewCellTableViewCell.h
//  Blog
//
//  Created by Lingchuan Hu on 11/15/14.
//  Copyright (c) 2014 Lingchuan Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *commenter;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UIButton *like;
@property (weak, nonatomic) IBOutlet UIButton *reply;

@end
