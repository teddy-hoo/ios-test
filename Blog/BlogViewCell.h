//
//  BlogViewCell.h
//  Blog
//
//  Created by Lingchuan Hu on 11/16/14.
//  Copyright (c) 2014 Lingchuan Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlogViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tagName;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *commentAndView;
@property (weak, nonatomic) IBOutlet UILabel *authorAndDate;
@property (weak, nonatomic) IBOutlet UIButton *like;
@property (weak, nonatomic) IBOutlet UIButton *share;

@end
