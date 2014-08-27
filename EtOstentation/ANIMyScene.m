//
//  ANIMyScene.m
//  EtOstentation
//
//  Created by Luiz Ilha Moschem on 8/21/14.
//  Copyright (c) 2014 ani. All rights reserved.
//
//kleiton alves rodrigues batista lindo
#import "ANIMyScene.h"
#import "ANIGameOver.h"

@implementation ANIMyScene{
    SKSpriteNode *_et;
    SKSpriteNode *_planeta;
    SKLabelNode *_scoreLabel;
    
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"sky"];
        bg.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:bg];
        
        _planeta = [SKSpriteNode spriteNodeWithImageNamed:@"lua2"];
        [_planeta setScale:1.5]; // diminuir a escala do planeta
        _planeta.position = CGPointMake(self.size.width/2, self.size.height);
        [self addChild:_planeta];
        
        
        _et = [SKSpriteNode spriteNodeWithImageNamed:@"et_main"];
        [_et setScale:0.15]; // diminuir a escala do et
        _et.zRotation = M_PI; // girar o et de cabeca pra baixo
        _et.position = CGPointMake(self.size.width/2, self.size.height - self.size.height/4);
        [self addChild:_et];
        
        //[self rotacaoPlaneta:-M_PI velocidade:1.0 duracao:5.0];
        [self criarCoracao];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    NSLog(@"tocou %@",NSStringFromCGPoint(touchLocation));
    [self moveEt:touchLocation.x];
    
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    NSLog(@"tocou %@",NSStringFromCGPoint(touchLocation));
    [self moveEt:touchLocation.x];
    
}

-(void)moveEt:(CGFloat)location{
    SKAction *move = [SKAction moveToX:location duration:1.0];
    [_et runAction:move];
}

-(void)rotacaoPlaneta:(CGFloat)direcao velocidade:(NSTimeInterval)velocidade duracao:(CGFloat)duracao{
    SKAction *girar = [SKAction rotateByAngle:direcao duration:velocidade];
    [_planeta runAction:[SKAction repeatAction:girar count:duracao]];
    // [sprite runAction:[SKAction repeatActionForever:action]]
}

-(void) addPedra{
    self.timePedraCogumelo ++;
    SKSpriteNode *pedra = [SKSpriteNode spriteNodeWithImageNamed:@"projectile"];
    pedra.name = @"pedra";
    int randX = (arc4random() % 160)+160;
    
    pedra.position = CGPointMake(randX, 0);
    [self addChild:pedra];
    
    int minDuration = 2; // para que nao seja muito rapido a velocidade de transicao da pedra, para que seja no minimo 2
    int randDuration = arc4random() % 4 + minDuration;// soma com o minimo para que caso o rand de 0 soma 2
    
    SKAction *move = [SKAction moveToY:1000 duration:randDuration];
    [pedra runAction:move];
    if (self.timePedraCogumelo == 20) {
        [self addCogumelo];
        self.timePedraCogumelo = 0;
    }
}


-(void)colidePedra:(SKSpriteNode *)pedra
{
    [pedra removeFromParent];
}

-(void) updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast{
    self.lastSpawnTimeInterval += timeSinceLast;
    if(self.lastSpawnTimeInterval > 1){
        self.lastSpawnTimeInterval = 0;
        [self addPedra];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    // Tempo de atendimento delta
    // se cair abaixo de 60fps, ainda queremos tudo para mover a mesma distância
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdadeTimeInterval;
    self.lastUpdadeTimeInterval = currentTime;
    if(timeSinceLast > 1){ // mais de um segundo desde a última atualização
        timeSinceLast = 1.0/60.0;
        self.lastUpdadeTimeInterval = currentTime;
    }
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
    [self checarColisao];
    [self initScroe];
    
}

-(void) checarColisao
{
    NSMutableArray * lista = [[NSMutableArray alloc]init];
    // Checando colisao com a pedra
    [self enumerateChildNodesWithName:@"pedra" usingBlock:^(SKNode * node,BOOL * stop){
        
        SKSpriteNode * pedra = (SKSpriteNode *)node;
        if (CGRectIntersectsRect(pedra.frame, _et.frame)) {
            NSLog(@"agora foi...");
            // Aqui vamos tirar uma vida
            // Aqui removemos a pedra da cena
            [pedra removeFromParent];
            [self removerUmCoracao:lista];
        }
    }];
    if (lista.count == 1) {
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        SKScene * gameOverScene = [[ANIGameOver alloc]initWithSize:self.size score:0];//[[ANIGameOver alloc] initWithSize:self.size won:YES];
        [self.view presentScene:gameOverScene transition: reveal];
    }
}

-(void)criarCoracao{
    SKSpriteNode *coracao1 = [SKSpriteNode spriteNodeWithImageNamed:@"coracao"];;
    coracao1.name = @"coracao";
    SKSpriteNode *coracao2 = [SKSpriteNode spriteNodeWithImageNamed:@"coracao"];;
    coracao2.name = @"coracao";
    SKSpriteNode *coracao3 = [SKSpriteNode spriteNodeWithImageNamed:@"coracao"];;
    coracao3.name = @"coracao";
    
    [coracao1 setScale:0.2];
    [coracao2 setScale:0.2];
    [coracao3 setScale:0.2];
    
    //coracao1.position = CGPointMake(200,555);
    coracao1.position = CGPointMake(50, 30);
    coracao2.position = CGPointMake(77, 30);
    coracao3.position = CGPointMake(104, 30);
    
    [self addChild: coracao3];
    [self addChild:coracao2];
    [self addChild:coracao1];
}

-(void)removerUmCoracao:(NSMutableArray *)lista{
    
    [self enumerateChildNodesWithName:@"coracao" usingBlock:^(SKNode * node,BOOL * stop){
        SKSpriteNode * coracao = (SKSpriteNode *)node;
        [lista addObject:coracao];
    }];
    
    SKSpriteNode * ultimoCoracao = (SKSpriteNode *)[lista lastObject];
    [ultimoCoracao removeFromParent];
}

- (void)initScroe{
    // MarkerFelt-Thin = é o nome da fonte do label.
    _scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    _scoreLabel.text = @"0000";
    //_scoreLabel.zPosition = 2;
    _scoreLabel.fontColor = [SKColor whiteColor];
    _scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    _scoreLabel.position = CGPointMake(200 , 20);
    [self addChild:_scoreLabel];
}
-(void) addCogumelo{
    SKSpriteNode *cogumelo = [SKSpriteNode spriteNodeWithImageNamed:@"cogumelo"];
    cogumelo.name = @"cogumelo";
    int randX = arc4random() % 320;
    cogumelo.position = CGPointMake(randX, 0);
    [cogumelo setScale:0.033];
    SKAction *move = [SKAction moveToY:1000 duration:2.0];
    
    [self addChild:cogumelo];
    [cogumelo runAction:move];
    
}

@end
