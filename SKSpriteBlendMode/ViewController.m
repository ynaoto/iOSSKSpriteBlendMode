//
//  ViewController.m
//  Sprites
//
//  Created by Naoto Yoshioka on 2013/12/02.
//  Copyright (c) 2013年 Naoto Yoshioka. All rights reserved.
//

#import "ViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "SKSpriteNode+UIImageView.h"

@interface MyScene : SKScene

@end

@implementation MyScene

- (SKNode*)setupColorBarWithColors:(NSArray*)colors size:(CGSize)size
{
    SKNode *node = [SKNode node];

    CGFloat width = size.width;
    CGFloat height = size.height;
    NSUInteger n = colors.count;
    CGFloat h = height / n;
    for (NSUInteger i = 0; i < n; i++) {
        SKSpriteNode *skSpriteNode = [SKSpriteNode spriteNodeWithColor:colors[i] size:CGSizeMake(width, h)];
        skSpriteNode.position = CGPointMake(0, i * h - height / 2);
        [node addChild:skSpriteNode];
    }
    [self addChild:node];

    return node;
}

/*
- (SKSpriteNode*)setupTextureSpriteWithImageNamed:(NSString*)imageName size:(CGSize)size
{
    SKTexture *skTexture = [SKTexture textureWithImageNamed:imageName];
    SKSpriteNode *skSpriteNode = [SKSpriteNode spriteNodeWithTexture:skTexture size:size];
    [self addChild:skSpriteNode];
    return skSpriteNode;
}
*/

- (SKSpriteNode*)setupTextureSpriteWithImageView:(UIImageView*)imageView
{
    SKSpriteNode *skSpriteNode = [SKSpriteNode spriteWithImageView:imageView];
    [self addChild:skSpriteNode];
    return skSpriteNode;
}

@end

@interface ViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet SKView *skView;
@property (weak, nonatomic) IBOutlet UIView *colorBar;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *alphaSprites;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *addSprites;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *subSprites;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *mulSprites;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *mul2Sprites;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *scrSprites;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *replSprites;

@property (nonatomic) NSArray *colors;

@end

@implementation ViewController
{
    SKBlendMode blendMode;
    UIColor *color;
}

- (NSArray *)colors
{
    if (_colors == nil) {
        _colors = @[
                   [UIColor blackColor],
                   [UIColor darkGrayColor],
                   [UIColor lightGrayColor],
                   [UIColor whiteColor],
                   [UIColor grayColor],
                   [UIColor redColor],
                   [UIColor greenColor],
                   [UIColor blueColor],
                   [UIColor cyanColor],
                   [UIColor yellowColor],
                   [UIColor magentaColor],
                   [UIColor orangeColor],
                   [UIColor purpleColor],
                   [UIColor brownColor],
                   [UIColor clearColor],
                   ];
    }
    return _colors;
}

static SKBlendMode blendModes[] = {
    SKBlendModeAlpha,      // The source and destination colors are blended by multiplying the source alpha value.
    SKBlendModeAdd,        // The source and destination colors are added together.
    SKBlendModeSubtract,   // The source color is subtracted from the destination color.
    SKBlendModeMultiply,   // The source color is multiplied by the destination color.
    SKBlendModeMultiplyX2, // The source color is multiplied by the destination color and then doubled.
    SKBlendModeScreen,     // The source color is added to the destination color times the inverted source color.
    SKBlendModeReplace,    // The source color replaces the destination color.
};

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return component == 0 ? sizeof(blendModes)/sizeof(blendModes[0]) : self.colors.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *items;
    
    if (component == 0) {
        items = @[
                  @"Alpha",
                  @"Add",
                  @"Subtract",
                  @"Multiply",
                  @"MultiplyX2",
                  @"Screen",
                  @"Replace",
                  ];
    } else if (component == 1) {
        items = @[
                  @"black",
                  @"darkGray",
                  @"lightGray",
                  @"white",
                  @"gray",
                  @"red",
                  @"green",
                  @"blue",
                  @"cyan",
                  @"yellow",
                  @"magenta",
                  @"orange",
                  @"purple",
                  @"brown",
                  @"clear",
                  ];
        
    } else {
        NSLog(@"can't happen");
        abort();
    }
    return items[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        blendMode = blendModes[row];
    } else if (component == 1) {
        color = self.colors[row];
    } else {
        NSLog(@"can't happen");
        abort();
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    SKScene *skScene = self.skView.scene;
    SKSpriteNode *skSpriteNode = [SKSpriteNode spriteNodeWithColor:color size:CGSizeMake(10, 10)];
    skSpriteNode.position = [[touches anyObject] locationInNode:skScene];
    skSpriteNode.blendMode = blendMode;
    skSpriteNode.name = @"inkSprite";
    [skScene addChild:skSpriteNode];
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    SKScene *skScene = self.skView.scene;
    [skScene enumerateChildNodesWithName:@"inkSprite"
                              usingBlock:^(SKNode *node, BOOL *stop) {
                                  [node removeFromParent];
                              }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    blendMode = blendModes[0];
    color = self.colors[0];

    self.colorBar.hidden = YES;
    
    SKView *skView = self.skView;
    skView.showsDrawCount = YES;
    skView.showsNodeCount = YES;
    skView.showsFPS = YES;
    
    MyScene *skScene = [MyScene sceneWithSize:skView.frame.size];
    skScene.backgroundColor = self.skView.backgroundColor;
 
    SKNode *skNode = [skScene setupColorBarWithColors:self.colors size:self.colorBar.frame.size];
    skNode.position = [skView convertPoint:self.colorBar.center toScene:skScene];

    for (UIImageView *view in self.alphaSprites) {
        view.hidden = YES;
        SKSpriteNode *skSpriteNode = [skScene setupTextureSpriteWithImageView:view];
        skSpriteNode.blendMode = SKBlendModeAlpha;
        skSpriteNode.position = [skView convertPoint:view.center toScene:skScene];
    }

    for (UIImageView *view in self.addSprites) {
        view.hidden = YES;
        SKSpriteNode *skSpriteNode = [skScene setupTextureSpriteWithImageView:view];
        skSpriteNode.blendMode = SKBlendModeAdd;
        skSpriteNode.position = [skView convertPoint:view.center toScene:skScene];
    }

    for (UIImageView *view in self.subSprites) {
        view.hidden = YES;
        SKSpriteNode *skSpriteNode = [skScene setupTextureSpriteWithImageView:view];
        skSpriteNode.blendMode = SKBlendModeSubtract;
        skSpriteNode.position = [skView convertPoint:view.center toScene:skScene];
    }
    
    for (UIImageView *view in self.mulSprites) {
        view.hidden = YES;
        SKSpriteNode *skSpriteNode = [skScene setupTextureSpriteWithImageView:view];
        skSpriteNode.blendMode = SKBlendModeMultiply;
        skSpriteNode.position = [skView convertPoint:view.center toScene:skScene];
    }

    for (UIImageView *view in self.mul2Sprites) {
        view.hidden = YES;
        SKSpriteNode *skSpriteNode = [skScene setupTextureSpriteWithImageView:view];
        skSpriteNode.blendMode = SKBlendModeMultiplyX2;
        skSpriteNode.position = [skView convertPoint:view.center toScene:skScene];
    }

    for (UIImageView *view in self.scrSprites) {
        view.hidden = YES;
        SKSpriteNode *skSpriteNode = [skScene setupTextureSpriteWithImageView:view];
        skSpriteNode.blendMode = SKBlendModeScreen;
        skSpriteNode.position = [skView convertPoint:view.center toScene:skScene];
    }

    for (UIImageView *view in self.replSprites) {
        view.hidden = YES;
        SKSpriteNode *skSpriteNode = [skScene setupTextureSpriteWithImageView:view];
        skSpriteNode.blendMode = SKBlendModeReplace;
        skSpriteNode.position = [skView convertPoint:view.center toScene:skScene];
    }

    [skView presentScene:skScene];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
