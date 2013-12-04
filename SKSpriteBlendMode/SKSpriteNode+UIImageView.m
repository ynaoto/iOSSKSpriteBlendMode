//
//  SKSpriteNode+UIImageView.m
//  IQTestPractice
//
//  Created by Naoto Yoshioka on 2013/12/03.
//  Copyright (c) 2013年 Naoto Yoshioka. All rights reserved.
//

#import "SKSpriteNode+UIImageView.h"

@implementation SKSpriteNode (UIImageView)

+ (SKSpriteNode*)spriteWithImageView:(UIImageView*)imageView
{
    SKTexture *texture = [SKTexture textureWithImage:imageView.image];
    SKSpriteNode *spriteNode = [SKSpriteNode spriteNodeWithTexture:texture size:texture.size];

    CGSize size = imageView.frame.size;
    CGSize textureSize = texture.size;
    CGFloat rw = size.width / textureSize.width;
    CGFloat rh = size.height / textureSize.height;
    if (rw < rh) {
        spriteNode.xScale = rw;
        spriteNode.yScale = rw;
    } else {
        spriteNode.xScale = rh;
        spriteNode.yScale = rh;
    }

    return spriteNode;
}

@end
