//
//  Helpers.h
//  Blog
//
//  Created by Lingchuan Hu on 11/19/14.
//  Copyright (c) 2014 Lingchuan Hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Helpers : NSObject

+ (void)rePostionButton:(UIButton *)btn textHeight:(CGFloat)height;
+ (void) rePositionLabel:(UILabel *)label textHeight:(CGFloat)height;
+ (void) setAvatar:(UIImageView *)avatar avatarLink:(NSString *)avatarLink;
+ (CGFloat)getTextHeight:(NSString *)text fontSize:(CGFloat)size;
+ (NSString *)calculateDate:(NSString *)date;

@end