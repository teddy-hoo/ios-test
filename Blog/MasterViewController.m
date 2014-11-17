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
@property (strong, nonatomic)NSMutableArray *colors;
@property (nonatomic)  NSUInteger indexOfColors;
@property (strong, nonatomic)NSMutableArray *backgrouds;

@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (NSUInteger)indexOfColors{
    if (!_indexOfColors || _indexOfColors >= _colors.count) {
        _indexOfColors = 0;
    }
    return _indexOfColors;
}

- (NSMutableArray *)blogs {
    if (!_blogs) {
        _blogs = [[NSMutableArray alloc] init];
    }
    return _blogs;
}

- (NSMutableArray *)backgrouds {
    if (!_backgrouds) {
        _backgrouds = [[NSMutableArray alloc] init];
        [_backgrouds setObject:[UIColor colorWithRed:45 / 255.0
                                           green:100 / 255.0
                                            blue:180 / 255.0
                                           alpha:0.1]
        atIndexedSubscript:0];
        [_backgrouds setObject:[UIColor colorWithRed:250 / 255.0
                                           green:200 / 255.0
                                            blue:30 / 255.0
                                           alpha:0.1]
        atIndexedSubscript:1];
        [_backgrouds setObject:[UIColor colorWithRed:10 / 255.0
                                           green:180 / 255.0
                                            blue:220 / 255.0
                                           alpha:0.1]
        atIndexedSubscript:2];
        
    }
    return _backgrouds;
}

- (NSMutableArray *)colors {
    if (!_colors) {
        _colors = [[NSMutableArray alloc] init];
        [_colors setObject:[UIColor colorWithRed:45 / 255.0
                                           green:100 / 255.0
                                            blue:180 / 255.0
                                           alpha:1.0]
        atIndexedSubscript:0];
        [_colors setObject:[UIColor colorWithRed:250 / 255.0
                                           green:200 / 255.0
                                            blue:30 / 255.0
                                           alpha:1.0]
        atIndexedSubscript:1];
        [_colors setObject:[UIColor colorWithRed:10 / 255.0
                                           green:180 / 255.0
                                            blue:220 / 255.0
                                           alpha:1.0]
        atIndexedSubscript:2];
        
    }
    return _colors;
}

- (NSMutableDictionary *)styles {
    if (!_styles) {
        _styles = [[NSMutableDictionary alloc] init];
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
    [self setCellContent:cell blogDictionary:blog];
    
    return cell;
}

- (void)setCellContent:(MainViewCell *)cell blogDictionary:(NSDictionary *)blog{
    NSString *tagN = blog[@"tag"];
    UIColor *color;
    UIColor *backgroud;
    if (self.styles[tagN] != nil) {
        NSInteger i = [self.styles[tagN] integerValue];
        color = self.colors[i];
        backgroud = self.backgrouds[i];
    }
    else {
        [self.styles setObject:[NSString stringWithFormat:@"%lu",(unsigned long)self.indexOfColors] forKey:tagN];
        color = self.colors[self.indexOfColors];
        backgroud = self.backgrouds[self.indexOfColors];
        self.indexOfColors += 1;
    }
    cell.tagName.textColor = color;
    cell.tagName.backgroundColor = backgroud;
    cell.tagName.text       = [blog[@"tag"] stringByAppendingString:@" > "];
    NSMutableAttributedString *lastCommenterText = [[NSMutableAttributedString alloc]
                                                    initWithString:[blog[@"latestCommenter"]
                                                                    stringByAppendingString:@" responded:"]];
    [lastCommenterText addAttribute:NSForegroundColorAttributeName
                              value:[UIColor grayColor]
                              range:NSMakeRange(lastCommenterText.length - 10,10)];
    cell.lastCommenter.attributedText = lastCommenterText;
    cell.title.text         = blog[@"title"];
    cell.content.text       = blog[@"content"];
    cell.commentCount.text  = [blog[@"commentCount"] stringByAppendingString:@" responses"];
    
    NSString *avatarLink = blog[@"avatarOfCommenter"];
    if ((NSNull *)avatarLink != [NSNull null]) {
        NSURL *avatarUrl = [NSURL URLWithString:avatarLink];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:avatarUrl]];
        cell.avatar.image = image;
    }
    cell.avatar.layer.masksToBounds = YES;
    cell.avatar.layer.cornerRadius = 13;

}

@end
