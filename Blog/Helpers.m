//
//  Helpers.m
//  Blog
//
//  Created by Lingchuan Hu on 11/19/14.
//  Copyright (c) 2014 Lingchuan Hu. All rights reserved.
//

#import "Helpers.h"

@interface Helpers()

@end

@implementation Helpers

+ (void)rePostionButton:(UIButton *)btn textHeight:(CGFloat)height {
    
    [btn setTranslatesAutoresizingMaskIntoConstraints:YES];
    CGRect newFrame = btn.frame;
    newFrame.origin.y = height + 60;
    btn.frame = newFrame;
    
}

+ (void)rePositionLabel:(UILabel *)label textHeight:(CGFloat)height {
    
    [label setTranslatesAutoresizingMaskIntoConstraints:YES];
    CGRect newFrame = label.frame;
    newFrame.origin.y = height + 60;
    label.frame = newFrame;

}

+ (void)setAvatar:(UIImageView *)avatar avatarLink:(NSString *)avatarLink {
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:avatar, @"avatar",
                            avatarLink, @"avatarLink", nil];
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadImage:) object:params];
    if ((NSNull *)avatarLink != [NSNull null]) {
        UIImage *image = [UIImage animatedImageNamed:@"loading" duration:0.5f];
        avatar.image = image;
        [operationQueue addOperation:op];
    }
    avatar.layer.masksToBounds = YES;
    avatar.layer.cornerRadius = avatar.frame.size.height / 2;
}

- (void)loadImage:(NSDictionary *)params {
    NSURL *avatarUrl = [NSURL URLWithString:params[@"avatarLink"]];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:avatarUrl]];
    UIImageView *avatar = params[@"avatar"];
    avatar.image = image;
}

+ (CGFloat)getTextHeight:(NSString *)text fontSize:(CGFloat)size {
    CGSize constSize = CGSizeMake(300.f, 500.f);
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont systemFontOfSize:size], NSFontAttributeName,
                                          paragraph, NSParagraphStyleAttributeName,
                                          nil];
    CGSize fixedSize = [text boundingRectWithSize:constSize
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:attributesDictionary context:nil].size;
    return fixedSize.height;
}

+ (NSString *)calculateDate:(NSString *)date {
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

@end