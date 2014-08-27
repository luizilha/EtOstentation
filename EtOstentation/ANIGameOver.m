//
//  ANIGameOver.m
//  EtOstentation
//
//  Created by willie santos on 27/08/14.
//  Copyright (c) 2014 ani. All rights reserved.
//

#import "ANIGameOver.h"
#import "ANIMyScene.h"

@implementation ANIGameOver

-(id) initWithSize:(CGSize)size score:(int)score {
    if(self = [super initWithSize:size]){
        
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"sky"];
        bg.position = CGPointMake(self.size.width/2, self.size.height/2);
        
        SKSpriteNode *planeta = [SKSpriteNode spriteNodeWithImageNamed:@"lua"];
        [planeta setScale:0.73]; // diminuir a escala do planeta
        planeta.position = CGPointMake(0, self.size.height/2 + self.size.height - self.size.height * 0.78);
        [bg addChild:planeta];
        
        
        NSString *pts = [NSString stringWithFormat:@"Score : %d",score];
        
        SKLabelNode *msg = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        SKLabelNode *pontuacao = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        msg.position = CGPointMake(self.size.width/2, self.size.height-200);
        pontuacao.text = pts;
        pontuacao.fontColor = [SKColor redColor];
        pontuacao.fontSize = 25;
        pontuacao.position = CGPointMake(self.size.width/2, self.size.height-250);
        
        msg.text = @"Você perdeu :(";
        msg.fontSize = 35;
        msg.color = [SKColor redColor];
        
        [self addChild:bg];
        [self addChild:msg];
        [self addChild:pontuacao];
        
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
