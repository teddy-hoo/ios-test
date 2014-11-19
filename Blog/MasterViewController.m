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
#import "Helpers.h"

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
                                           alpha:0.3]
        atIndexedSubscript:0];
        [_backgrouds setObject:[UIColor colorWithRed:250 / 255.0
                                           green:200 / 255.0
                                            blue:30 / 255.0
                                           alpha:0.3]
        atIndexedSubscript:1];
        [_backgrouds setObject:[UIColor colorWithRed:10 / 255.0
                                           green:180 / 255.0
                                            blue:220 / 255.0
                                           alpha:0.3]
        atIndexedSubscript:2];
        [_backgrouds setObject:[UIColor colorWithRed:150 / 255.0
                                           green:200 / 255.0
                                            blue:100 / 255.0
                                           alpha:0.3]
        atIndexedSubscript:3];
        
    }
    return _backgrouds;
}

- (NSMutableArray *)colors {
    if (!_colors) {
        _colors = [[NSMutableArray alloc] init];
        [_colors setObject:[UIColor colorWithRed:110 / 255.0
                                           green:110 / 255.0
                                            blue:220 / 255.0
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
        [_colors setObject:[UIColor colorWithRed:150 / 255.0
                                           green:200 / 255.0
                                            blue:100 / 255.0
                                           alpha:1.0]
        atIndexedSubscript:3];
        
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
        NSMutableDictionary *blog = item;
        [self.objects insertObject: blog atIndex:0];
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSMutableDictionary *object = self.objects[indexPath.row];
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

- (CGFloat)tableView:(UITableView  *)tableView  heightForRowAtIndexPath:(NSIndexPath  *)indexPath {
    return [self getTitleHeight:self.objects[indexPath.row][@"title"]] + 100;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(MainViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2) {
        [cell.contentView setBackgroundColor:[UIColor colorWithRed:0.5
                                                             green:0.5
                                                              blue:0.5
                                                             alpha:0.08]];
    }
    else {
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
    }
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
    NSString *tagStr        = blog[@"tag"];
    [self setTagName:cell.tagName tagString:tagStr];
    NSString *commenter     = blog[@"latestCommenter"];
    [self setLastCommnter:cell.lastCommenter commenter:commenter];
    cell.title.text         = blog[@"title"];
    CGFloat height = [Helpers getTextHeight:blog[@"title"] fontSize:18.0f];
    [self setContent:cell.content contentText:blog[@"content"] height:height];
    [self setCountOfResponses:cell.commentCount count:blog[@"commentCount"] height:height];
    [Helpers setAvatar:cell.avatar avatarLink:blog[@"avatarOfCommenter"]];
}

- (void) setCountOfResponses:(UILabel *)countOfRepsonses count:(NSString *) count height:(CGFloat) height {
    count  = [count stringByAppendingString:@" responses"];
    countOfRepsonses.text = count;
    [Helpers rePositionLabel:countOfRepsonses textHeight:height + 18];
}

- (void) setContent:(UILabel *)content contentText:(NSString *) contentText height:(CGFloat) height {
    content.text = contentText;
    [Helpers rePositionLabel:content textHeight:height];
}

- (void) setLastCommnter:(UILabel *)lastCommenter commenter:(NSString *)commenter {
    NSMutableAttributedString *lastCommenterText = [[NSMutableAttributedString alloc]
                                                    initWithString:[commenter
                                                                    stringByAppendingString:@" responded:"]];
    [lastCommenterText addAttribute:NSForegroundColorAttributeName
                              value:[UIColor blueColor]
                              range:NSMakeRange(0,commenter.length)];
    lastCommenter.attributedText = lastCommenterText;
}

- (void) setTagName:(UILabel *)tagName tagString:(NSString *)tagStr {
    UIColor *color;
    UIColor *backgroud;
    if (self.styles[tagStr] != nil) {
        NSInteger i = [self.styles[tagStr] integerValue];
        color = self.colors[i];
        backgroud = self.backgrouds[i];
    }
    else {
        [self.styles setObject:[NSString stringWithFormat:@"%lu",(unsigned long)self.indexOfColors] forKey:tagStr];
        color = self.colors[self.indexOfColors];
        backgroud = self.backgrouds[self.indexOfColors];
        self.indexOfColors += 1;
    }
    tagName.textColor           = color;
    tagName.backgroundColor     = backgroud;
    tagName.text                = [tagStr stringByAppendingString:@" >  "];
    tagName.layer.masksToBounds = YES;
    tagName.layer.cornerRadius  = 4;
}

@end
