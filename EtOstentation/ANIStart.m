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
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"sky"];
        bg.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:bg];
        
        SKSpriteNode *planeta = [SKSpriteNode spriteNodeWithImageNamed:@"lua"];
        [planeta setScale:1.3]; // diminuir a escala do planeta
        planeta.position = CGPointMake(0, self.size.height/2 + self.size.height - self.size.height * 0.5);
        [bg addChild:planeta];
        
        SKSpriteNode *start = [SKSpriteNode spriteNodeWithImageNamed:@"play"];
        start.name = @"play";
        [start setScale:1];
        start.position = CGPointMake(160, 220);
        [self addChild:start];
        
        SKLabelNode *nomeApp = [SKLabelNode labelNodeWithFontNamed:@"MarkerFelt-Wide"];
        nomeApp.position = CGPointMake(self.size.width/2, self.size.height-200);
        nomeApp.text = @"Et Ostentation";
        nomeApp.fontSize = 35;
        nomeApp.color = [SKColor whiteColor];
        [self addChild:nomeApp];
        
        SKLabelNode *msg = [SKLabelNode labelNodeWithFontNamed:@"MarkerFelt-Wide"];
        msg.position = CGPointMake(self.size.width/2, self.size.height-250);
        msg.text = @"Bem Vindos !!";
        msg.fontSize = 25;
        msg.color = [SKColor whiteColor];
        [self addChild:msg];
        
        SKLabelNode *msg2 = [SKLabelNode labelNodeWithFontNamed:@"MarkerFelt-Wide"];
        msg2.position = CGPointMake(self.size.width/2, self.size.height-465);
        msg2.text = @"Conquiste diamantes no imenso UNIVERSO";
        msg2.fontSize = 16;
        msg2.color = [SKColor whiteColor];
        [self addChild:msg2];
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
