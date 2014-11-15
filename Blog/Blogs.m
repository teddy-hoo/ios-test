//
//  Model.m
//  Blog
//
//  Created by Lingchuan Hu on 11/14/14.
//  Copyright (c) 2014 Lingchuan Hu. All rights reserved.
//

#import "Blogs.h"

@interface Blogs()

@property (strong, nonatomic) NSMutableArray *blogs;

@end

@implementation Blogs

- (instancetype)init{
    
    self = [super init];
    @autoreleasepool {
        NSError *err       = nil;
        NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"community" ofType:@"json"];
        self.blogs         = [NSJSONSerialization
                              JSONObjectWithData:
                              [NSMutableData dataWithContentsOfFile:dataPath]
                              options:kNilOptions
                              error:&err];
    }
    return self;
}

- (NSMutableArray *)blogs
{
    if (!_blogs){
        _blogs = [[NSMutableArray alloc] init];
    }
    return _blogs;
}

- (NSMutableArray *) getNextTenBlogs
{
    [self calculate];
    return self.blogs;
}

- (void)calculate{
    NSMutableArray *newBlogs = [[NSMutableArray alloc] initWithCapacity:self.blogs.count];
    for (id item in self.blogs){
        NSMutableDictionary *blog = item;
        NSMutableDictionary *newBlog = [[NSMutableDictionary alloc] initWithDictionary:blog];
        
        NSInteger count;
        NSMutableString *commenter;
        NSString *url;
        NSInteger latest = 0;
        NSMutableArray *comments = blog[@"comments"];
        count = comments.count;
        NSMutableString *str;
        str = [NSMutableString stringWithFormat: @"%ld", (long)count];
        [newBlog setObject:str forKey:@"commentCount"];
        
        for(id item in comments){
            NSDictionary *comment = item;
            NSInteger cur = [comment[@"time_created"] intValue];
            if (cur > latest){
                latest = cur;
                NSDictionary *author = comment[@"author"];
                commenter = author[@"first_name"];
                url = author[@"profile_image"];
            }
        }
        [newBlog setObject:commenter forKey:@"latestCommenter"];
        [newBlog setObject:url forKey:@"avatarOfCommenter"];
        
        [newBlogs insertObject:newBlog atIndex:0];
    }
    self.blogs = newBlogs;
}

@end