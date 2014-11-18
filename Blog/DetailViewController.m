//
//  DetailViewController.m
//  Blog
//
//  Created by Lingchuan Hu on 11/13/14.
//  Copyright (c) 2014 Lingchuan Hu. All rights reserved.
//

#import "DetailViewController.h"
#import "CommentViewCelll.h"
#import "BlogViewCell.h"

@interface DetailViewController ()

@property (strong, nonatomic) NSDictionary *blog;
@property (strong, nonatomic) NSMutableArray *comments;

@end

@implementation DetailViewController

@synthesize commentsDetail;

- (void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        [self setData];
    }
}

- (void)setData {
    if (self.detailItem) {
        self.blog = self.detailItem;
        self.comments = self.blog[@"comments"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    [self showComments];
}

- (void)showComments {
    self.commentsDetail.dataSource = self;
    self.commentsDetail.delegate = self;
    [self.commentsDetail reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}

- (CGFloat)tableView:(UITableView  *)tableView  heightForRowAtIndexPath:(NSIndexPath  *)indexPath {
    if (indexPath.row == 0){
        return 200;
    }
    return [self getTextHeight:self.comments[indexPath.row][@"content"]] + 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0){
        return [self displayBlog:tableView];
    }
    
    CommentViewCell *cell = (CommentViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    if(cell == nil){
        cell = [[CommentViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommentCell"];
    }
    
    NSDictionary *comment = self.comments[indexPath.row];
    NSDictionary *author  = comment[@"author"];
    NSString *date = [self calculateDate:comment[@"time_created"]];
    NSMutableAttributedString *lastCommenterText = [[NSMutableAttributedString alloc]
                                                    initWithString:[author[@"first_name"]
                                                                    stringByAppendingString:date]];
    [lastCommenterText addAttribute:NSForegroundColorAttributeName
                              value:[UIColor blueColor]
                              range:NSMakeRange(0,lastCommenterText.length - date.length)];
    cell.commenter.attributedText = lastCommenterText;
    cell.content.text             = comment[@"content"];
    NSString *avatarLink = author[@"profile_image"];
    if ((NSNull *)avatarLink != [NSNull null]) {
        NSURL *avatarUrl = [NSURL URLWithString:avatarLink];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:avatarUrl]];
        cell.avatar.image = image;
    }
    cell.avatar.layer.masksToBounds =YES;
    cell.avatar.layer.cornerRadius =13;
    cell.like.layer.masksToBounds = YES;
    cell.like.layer.cornerRadius = 3;
    cell.reply.layer.masksToBounds = YES;
    cell.reply.layer.cornerRadius = 3;
    cell.like.backgroundColor = [UIColor colorWithRed:200 / 255.0
                                                green:220 / 255.0
                                                 blue:200 / 255.0
                                                alpha:0.2];
    cell.reply.backgroundColor = [UIColor colorWithRed:200 / 255.0
                                                 green:220 / 255.0
                                                  blue:200 / 255.0
                                                 alpha:0.2];
    CGFloat height = [self getTextHeight:comment[@"content"]];
    [self rePostionButton:cell.like textHeight:height];
    [self rePostionButton:cell.reply textHeight:height];
    [self rePositionLabel:cell.report textHeight:height];
    return cell;
}

- (UITableViewCell *) displayBlog:(UITableView*) tableView {
    BlogViewCell *cell = (BlogViewCell *)[tableView dequeueReusableCellWithIdentifier:@"BlogCell"];
    if(cell == nil){
        cell = [[BlogViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BlogCell"];
    }
    
    NSDictionary *author  = self.blog[@"author"];
    NSString *commentsCount = [NSString stringWithFormat:@"%lu", (unsigned long)self.comments.count];
    NSString *viewCount = [NSString stringWithFormat:@"%@", self.blog[@"views"]];
    cell.commentAndView.text = [[[commentsCount stringByAppendingString:@" comments ∙ "]
                                 stringByAppendingString:viewCount] stringByAppendingString:@" views"];
    cell.tagName.text  = self.blog[@"tag"];
    cell.content.text  = self.blog[@"content"];
    NSString *date = [self calculateDate:self.blog[@"time_created"]];
    NSMutableAttributedString *authorAndDate = [[NSMutableAttributedString alloc]
                                         initWithString:[author[@"first_name"]
                                                         stringByAppendingString:date]];
    [authorAndDate addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor]
                              range:NSMakeRange(0,authorAndDate.length - date.length)];
    cell.authorAndDate.attributedText = authorAndDate;
    
    cell.like.layer.masksToBounds = YES;
    cell.like.layer.cornerRadius = 6;
    cell.share.layer.masksToBounds = YES;
    cell.share.layer.cornerRadius = 6;
    cell.like.backgroundColor = [UIColor colorWithRed:200 / 255.0
                                                 green:220 / 255.0
                                                  blue:200 / 255.0
                                                 alpha:0.2];
    cell.share.backgroundColor = [UIColor colorWithRed:200 / 255.0
                                                 green:220 / 255.0
                                                  blue:200 / 255.0
                                                 alpha:0.2];
    return cell;
}

- (NSString *)calculateDate:(NSString *)date {
    NSDate *createdTime = [[NSDate alloc] initWithTimeIntervalSince1970:
                      [date doubleValue] / 1.0];
    NSTimeInterval interval = [createdTime timeIntervalSinceNow];
    NSInteger days = (NSInteger) interval / 3600 / 24;
    NSInteger hours = (NSInteger) (interval - days * 3600 * 24) / 3600;
    days = 0 - days;
    hours = 0 - hours;
    NSString *intervalStr = [NSString stringWithFormat:@" ∙ %ld days, %ld hours ago",
                             (long)days, (long)hours];
    return intervalStr;
}

- (CGFloat)getTextHeight:(NSString *)text {
    CGSize constSize = CGSizeMake(300.f, 500.f);
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont systemFontOfSize:14], NSFontAttributeName,
                                          paragraph, NSParagraphStyleAttributeName,
                                          nil];
    CGSize fixedSize = [text boundingRectWithSize:constSize
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:attributesDictionary context:nil].size;
    return fixedSize.height;
}

- (void)rePostionButton:(UIButton *)btn textHeight:(CGFloat)height {
    [btn setTranslatesAutoresizingMaskIntoConstraints:YES];
    CGRect newFrame = btn.frame;
    newFrame.origin.y = height + 40;
    btn.frame = newFrame;
}

- (void) rePositionLabel:(UILabel *)label textHeight:(CGFloat)height {
    [label setTranslatesAutoresizingMaskIntoConstraints:YES];
    CGRect newFrame = label.frame;
    newFrame.origin.y = height + 40;
    label.frame = newFrame;
}

@end
