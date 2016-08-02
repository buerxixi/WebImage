//
//  UIImageView+MYWebCache.m
//  MYWebImage
//
//  Created by 刘家强 on 16/8/1.
//  Copyright © 2016年 刘家强. All rights reserved.
//

#import "UIImageView+MYWebCache.h"
#import "MYWebImageManager.h"

@implementation UIImageView (MYWebCache)

- (void)my_getImageWithUrrlString:(NSString *)urlString {
    
    [[MYWebImageManager sharedWebImageManager] loadWebImageUrlString:urlString andReturnBlock:^(UIImage *image) {
        self.image = image;
    }];
    
}

@end
