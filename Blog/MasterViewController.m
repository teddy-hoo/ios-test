//
//  MasterViewController.m
//  Blog
//
//  Created by Lingchuan Hu on 11/13/14.
//  Copyright (c) 2014 Lingchuan Hu. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "Blogs.h"
#import "MainViewCell.h"

@interface MasterViewController ()

@property NSMutableArray *objects;
@property (strong, nonatomic)NSMutableArray *blogs;
@property (strong, nonatomic)NSMutableDictionary *styles;

@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (NSMutableArray *)blogs {
    if (!_blogs) {
        _blogs = [[NSMutableArray alloc] init];
    }
    return _blogs;
}

- (NSMutableDictionary *)styles {
    if (!_styles) {
        _styles = [[NSMutableDictionary alloc] init];
        [_styles setObject:@"1" forKey:@"Sex & Relationships"];
        [_styles setObject:@"2" forKey:@"Glow Support"];
    }
    return _styles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Blogs *b = [[Blogs alloc] init];
    self.blogs = b.getNextTenBlogs;
    
    [self insertBlogs];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertBlogs {
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    for (id item in self.blogs) {
        NSDictionary *blog = item;
        [self.objects insertObject: blog atIndex:0];
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *object = self.objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MainViewCell *cell = (MainViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MainCell"];
    if(cell == nil){
        cell = [[MainViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainCell"];
    }
 
    NSDictionary *blog      = self.objects[indexPath.row];
    NSString *tagN = blog[@"tag"];
    if (self.styles[tagN] != nil) {
        NSString *i = self.styles[tagN];
        if ([i isEqual: @"1"]) {
            cell.tagName.textColor = [UIColor greenColor];
        }
        else {
            cell.tagName.textColor = [UIColor purpleColor];
        }
    }
    cell.tagName.text       = blog[@"tag"];
    NSMutableAttributedString *lastCommenterText = [[NSMutableAttributedString alloc]
                                                    initWithString:[blog[@"latestCommenter"]
                                                                    stringByAppendingString:@" responded:"]];
    [lastCommenterText addAttribute:NSForegroundColorAttributeName
                              value:[UIColor blueColor]
                              range:NSMakeRange(lastCommenterText.length - 10,10)];
    cell.lastCommenter.attributedText = lastCommenterText;
    cell.title.text         = blog[@"title"];
    cell.content.text       = blog[@"content"];
    cell.commentCount.text  = [blog[@"commentCount"] stringByAppendingString:@" responses..."];
    
    NSString *avatarLink = blog[@"avatarOfCommenter"];
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

- (void)fixWidth:(UILabel*)label {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:label.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize fixedSize = [label.text boundingRectWithSize:CGSizeMake(1000, 50)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:attributes context:nil].size;
    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y,
                             fixedSize.width, fixedSize.height);
}

@end
