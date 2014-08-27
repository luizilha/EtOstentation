//
//  ANIStart.m
//  EtOstentation
//
//  Created by willie santos on 27/08/14.
//  Copyright (c) 2014 ani. All rights reserved.
//

#import "ANIStart.h"
#import "ANIMyScene.h"

@implementation ANIStart
- (id)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]) {
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"lua"];
        [bg setScale:1.3];
        bg.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:bg];
        
        SKSpriteNode *start = [SKSpriteNode spriteNodeWithImageNamed:@"play"];
        start.name = @"play";
        [start setScale:1];
        start.position = CGPointMake(160, 200);
        [self addChild:start];
    }
    return  self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKSpriteNode * node = (SKSpriteNode *) [self nodeAtPoint:location];
    if ([node.name isEqualToString:@"play"]) {
        [self goTostartGame];
    }
}

-(void)goTostartGame{
    SKAction * block = [SKAction runBlock:^{
        SKScene * start = [[ANIMyScene alloc] initWithSize:self.size];
        SKTransition *reveal = [SKTransition fadeWithDuration:0.3];
        [self.view presentScene:start transition:reveal];
    }];
    [self runAction:block];
}
@end
