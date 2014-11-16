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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%ld", (long)indexPath.row);
    if(indexPath.row == 0){
        return [self displayBlog:tableView];
    }
    
    CommentViewCell *cell = (CommentViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    if(cell == nil){
        cell = [[CommentViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommentCell"];
    }
    
    NSDictionary *comment = self.comments[indexPath.row];
    NSDictionary *author  = comment[@"author"];
    NSMutableAttributedString *lastCommenterText = [[NSMutableAttributedString alloc]
                                                    initWithString:[author[@"first_name"]
                                                                    stringByAppendingString:@" responded:"]];
    [lastCommenterText addAttribute:NSForegroundColorAttributeName
                              value:[UIColor blueColor]
                              range:NSMakeRange(lastCommenterText.length - 10,10)];
    cell.commenter.attributedText = lastCommenterText;
    cell.content.text             = comment[@"content"];
    
    NSString *avatarLink = author[@"profile_image"];
    if ((NSNull *)avatarLink != [NSNull null]) {
        //        NSURL *avatarUrl = [NSURL URLWithString:avatarLink];
        //        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:avatarUrl]];
        //        cell.avatar.image = image;
        cell.avatar.frame = CGRectMake(60,100, 100, 100);
        cell.avatar.layer.masksToBounds =YES;
        cell.avatar.layer.cornerRadius =50;
    }
    
    return cell;
}

- (UITableViewCell *) displayBlog:(UITableView*) tableView {
    BlogViewCell *cell = (BlogViewCell *)[tableView dequeueReusableCellWithIdentifier:@"BlogCell"];
    if(cell == nil){
        cell = [[BlogViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BlogCell"];
    }
    
    NSDictionary *author  = self.blog[@"author"];
//    NSMutableAttributedString *lastCommenterText = [[NSMutableAttributedString alloc]
//                                                    initWithString:[author[@"first_name"]
//                                                                    stringByAppendingString:@" responded:"]];
//    [lastCommenterText addAttribute:NSForegroundColorAttributeName
//                              value:[UIColor blueColor]
//                              range:NSMakeRange(lastCommenterText.length - 10,10)];
//    cell.authorAndDate.attributedText = lastCommenterText;
    cell.content.text  = self.blog[@"content"];
    cell.authorAndDate = author[@"first_name"];
    
    return cell;
}

@end
