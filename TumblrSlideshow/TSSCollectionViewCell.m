//
//  TSSCollectionViewCell.m
//  TumblrSlideshow
//
//  Created by Joe on 12/3/13.
//  Copyright (c) 2013 Joe Bramhall. All rights reserved.
//

#import "TSSCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation TSSCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.imageView setImage:nil];
}

- (void)layoutCellForPost:(id)post
{
    NSString *imageUrl = [self urlForFirstImage:[post valueForKey:@"photos"]];
    [self.imageView setImageWithURL:[NSURL URLWithString:imageUrl]];
    [self setNeedsLayout];
}

- (void)fadeToNextPost:(id)post
{
    NSString *imageUrl = [self urlForFirstImage:[post valueForKey:@"photos"]];
    NSURL *url = [NSURL URLWithString:imageUrl];
    __weak __typeof(self)weakSelf = self;
    [self.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:url] placeholderImage:self.imageView.image success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [UIView animateWithDuration:2.0 animations:^{
            weakSelf.imageView.alpha = 0.0;
        }completion:^(BOOL finished) {
            weakSelf.imageView.image = image;
            [UIView animateWithDuration:2.0 animations:^{
                weakSelf.imageView.alpha = 1.0;
            }];
        }];
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"There was a problem with the request %@", request);
        NSLog(@"response: %@", response);
        NSLog(@"error: %@", error);
    }];
}

- (NSString *)urlForFirstImage:(NSArray *)photos
{
    id photo = [photos objectAtIndex:0];
    NSArray *photoSizes = [photo valueForKey:@"alt_sizes"];
    for (id image in photoSizes) {
        NSNumber *width = [image valueForKey:@"width"];
        if ([[width stringValue] isEqualToString:@"400"]) {
            return [image valueForKey:@"url"];
        }
    }
    id image = [photoSizes objectAtIndex:0];
    return [image valueForKey:@"url"];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.imageView setFrame:self.bounds];
}

@end
