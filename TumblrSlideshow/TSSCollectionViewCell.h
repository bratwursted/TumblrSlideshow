//
//  TSSCollectionViewCell.h
//  TumblrSlideshow
//
//  Created by Joe on 12/3/13.
//  Copyright (c) 2013 Joe Bramhall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSSCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

- (void)layoutCellForPost:(id)post;
- (void)fadeToNextPost:(id)post; 

@end
