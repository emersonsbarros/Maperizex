//
//  ViewController.m
//  Maperize
//
//  Created by EMERSON DE SOUZA BARROS on 26/03/14.
//  Copyright (c) 2014 EMERSON DE SOUZA BARROS. All rights reserved.
//

#import "Tweet.h"
#import "TweetCet.h"
#import "TweetCorpo.h"
#import "Coordenada.h"
#import "CoordenadaCet.h"
#import "CoordenadaCorpo.h"
#import "DataBaseCoordenada.h"
#import "DataBaseCoordenadaRadares.h"
#import "CoordenadaCetSite.h"


#import "ViewController.h"

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);


@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    //Configura a localização atual como a localização do usuário e adiciona os delegates do mapa e pesquisa
    self.mapaBacana.showsUserLocation = YES;
    [self.mapaBacana setDelegate: self];
    [self.searchBar setDelegate: self];
    [self.txtPartida setDelegate: self];
    [self.txtDestino setDelegate: self];
    
    //Adiciona as views do mapa, botão, caixa de texto ... etc
    [self.view addSubview: self.mapaBacana];
    [self.view addSubview: self.lblbackground];
    [self.view addSubview: self.outAddRota];
    [self.view addSubview: self.tipoMapa];
    [self.view addSubview: self.searchBar];
    

     [self.view addSubview: self.altbu];
    
    //Adiciona a view de rotas seus componentes
    [self.menuView addSubview: self.lblRota];
    [self.menuView addSubview: self.txtPartida];
    [self.menuView addSubview: self.txtDestino];
    
    
    //Configura sombra e cor da view de rotas
    self.menuView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.menuView.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.menuView.layer.shadowRadius = 3.0f;
    self.menuView.layer.shadowOpacity = 1.0f;
    [self.menuView setBackgroundColor: [UIColor whiteColor]];
    
    [self.view addSubview: self.menuView];
    
    
    
    /// ATRIBUTOS DO TWITER
    twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:@"FxaToB2yxC9iX3fJ4tzgw"
                                              consumerSecret:@"f0IVL6hjhaoC4OncXLVp8mxq3Aq5x0BFjnvMBZjUXzQ"];
    
//    [[DataBaseCoordenadaRadares sharedManager] SerializarCoordenadasRadarDoSistema];
//    
//    [self refreshTwitterCET];
//    [self refreshTwitterProject];
//    [self refreshTwitterCorpo];
    [self serializaDadosSiteCET];
    
//    [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(refreshTwitterProject) userInfo:nil repeats:YES];
//    [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(refreshTwitterCET) userInfo:nil repeats:YES];
//    [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(refreshTwitterCorpo) userInfo:nil repeats:YES];
//    
    
    
    
    //     Marca os radares na tela
    //     [[self mapaBacana] addAnnotations:[[DataBaseCoordenadaRadares sharedManager]marcarPosicaoNoMaparPoliciaRodoviaria] ];
    //     [[self mapaBacana] addAnnotations:[[DataBaseCoordenadaRadares sharedManager]marcarPosicaoNoMapaRadarFixo] ];
    //     [[self mapaBacana] addAnnotations:[[DataBaseCoordenadaRadares sharedManager]marcarPosicaoNoMapaRadarMovel] ];
    //     [[self mapaBacana] addAnnotations:[[DataBaseCoordenadaRadares sharedManager]marcarPosicaoNoMaparLomapada] ];
    //     [[self mapaBacana] addAnnotations:[[DataBaseCoordenadaRadares sharedManager]marcarPosicaoNoMaparPedagio] ];
    //     [[self mapaBacana] addAnnotations:[[DataBaseCoordenadaRadares sharedManager]marcarPosicaoNoMapaSemafaroComCamera] ];
    //     [[self mapaBacana] addAnnotations:[[DataBaseCoordenadaRadares sharedManager]marcarPosicaoNoMapaSemafaroComRadar] ];
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self zoomToUserRegion];
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}



//================================== MÉTODOS PARA TWITTER ======================================


- (void) refreshTwitterProject {
    
    [twitter verifyCredentialsWithSuccessBlock:^(NSString *bearerToken) {
        [twitter getSearchTweetsWithQuery:@"ProjetoSdkIOS"
                                  geocode:nil
                                     lang:nil
                                   locale:nil
                               resultType:nil
                                    count:@"10"
                                    until:nil
                                  sinceID:nil
                                    maxID:nil
                          includeEntities:nil
                                 callback:nil
                             successBlock: ^(NSDictionary *searchMetaData, NSArray *statusesConrado){
                                 self.results = statusesConrado;
                                 //                                NSString *user;
                                 //                                NSString *img;
                                 
                                 NSString *comment;
                                 NSString *date;
                                 NSString *geolo;
                                 NSString *hash;
                                 NSString *hash2;
                                 
                                 
                                 for (NSDictionary *twit in self.results) {
                                     
                                     
                                     
                                     //                                   user = [twit valueForKeyPath:@"user.screen_name"];
                                     //                                   img = [twit valueForKeyPath:@"user.profile_image_url"];
                                     //                                     NSLog(@"User: %@ ",user);
                                     //                                     NSLog(@"ImgUserProfile: %@",img);
                                     
                                     comment = [twit valueForKey:@"text"];
                                     date = [twit valueForKey:@"created_at"];
                                     geolo = [[twit valueForKeyPath:@"entities.media.media_url"] objectAtIndex:0];
                                     hash = [[twit valueForKeyPath:@"entities.hashtags.text"] objectAtIndex:0];
                                     hash2 = [[twit valueForKeyPath:@"entities.hashtags.text"] objectAtIndex:1];
                                     
                                     
                                     
                                     Tweet *tw = [[Tweet alloc]init];
                                     
                                     NSArray *a = [comment componentsSeparatedByString:@","];
                                     tw.tweetCompleto = comment;
                                     tw.cep = [a objectAtIndex:1];
                                     tw.rua = [a objectAtIndex:2];
                                     tw.numero = [a objectAtIndex:3];
                                     
                                     
                                     NSArray *a2 = [[a objectAtIndex:4] componentsSeparatedByString:@"http"];
                                     tw.descricao = [a2 objectAtIndex:0];
                                     
                                     NSArray *a3 = [date componentsSeparatedByString:@" "];
                                     NSString *s = [NSString stringWithFormat:@"%@%@%@%@%@",[a3 objectAtIndex:2],@"/",[a3 objectAtIndex:1],@"/",[a3 objectAtIndex:5]];
                                     tw.data = s;
                                     tw.hora = [a3 objectAtIndex:3];
                                     
                                     tw.caminhoImagem = geolo;
                                     tw.nomeCategoria = hash;
                                     tw.bairro = hash2;
                                     tw.estado = true;
                                     
                                     
                                     BOOL estadoParaAdicionar = true;
                                     
                                     for(int i=0;i<[[[DataBaseCoordenada sharedManager]listaCoordenadas ]count];i++){
                                         Coordenada *coord = [[[DataBaseCoordenada sharedManager]listaCoordenadas ]objectAtIndex:i];
                                         if([coord isKindOfClass:[Coordenada class]]){
                                             Coordenada *coord = [[[DataBaseCoordenada sharedManager]listaCoordenadas ]objectAtIndex:i];
                                             if(([[coord tweetCompleto] isEqualToString:[tw tweetCompleto]])){
                                                 estadoParaAdicionar = false;
                                                 break;
                                             }
                                             
                                         }
                                         
                                     }
                                     
                                     if(estadoParaAdicionar){
                                         Coordenada *coord = [[Coordenada alloc]initCoordenada:tw];
                                         [[DataBaseCoordenada sharedManager]criaCoordenada:coord];
                                         
                                         [self marcarPosicaoNoMapaDiretoTwitterCadaProject:coord];
                                     }else{
                                         NSLog(@"ja add o projeto");
                                     }
                                     
                                     
                                     
                                     
                                 }
                                 
                                 //[self marcarPosicaoNoMapaDiretoTwitter];
                                 self.mapaBacana.showsUserLocation = YES;
                                 [self zoomToUserRegion];
                                 
                             } errorBlock:^(NSError *error) {
                                 NSLog(@"Error1");
                             }
         ];
        
    } errorBlock:^(NSError *error) {
        NSLog(@"Error2");
    }];
    
    
    
}

- (void) refreshTwitterCET {
    
    [twitter verifyCredentialsWithSuccessBlock:^(NSString *bearerToken) {
        [twitter getSearchTweetsWithQuery:@"CETSP_"
                                  geocode:nil
                                     lang:nil
                                   locale:nil
                               resultType:nil
                                    count:@"10"
                                    until:nil
                                  sinceID:nil
                                    maxID:nil
                          includeEntities:nil
                                 callback:nil
                             successBlock: ^(NSDictionary *searchMetaData, NSArray *statusesConrado){
                                 self.results = statusesConrado;
                                 
                                 NSString *comment;
                                 NSString *date;
                                 NSString *geolo;
                                 NSString *hash = @"";
                                 NSString *hash2 = @"";
                                 
                                 
                                 
                                 for (NSDictionary *twit in self.results) {
                                     comment = [twit valueForKey:@"text"];
                                     BOOL validartwitter = false;
                                     
                                     NSString *sentence = comment;
                                     NSString *word = @"@";
                                     
                                     if ([sentence rangeOfString:word].location == NSNotFound) {
                                         
                                         NSString *v= [comment substringToIndex:1];
                                         
                                         NSArray *a = [comment componentsSeparatedByString:@" "];
                                         
                                         NSString *auxpegaHash = [a objectAtIndex:1];
                                         
                                         NSString *pegahash = [auxpegaHash substringToIndex:1];
                                         
                                         if((([v intValue] == 0) || ([v intValue] == 1) || ([v intValue] == 2)) &&
                                            ([pegahash isEqualToString:@"#"])){
                                             validartwitter = true;
                                             
                                             
                                         }else{
                                             validartwitter = false;
                                         }
                                         
                                         
                                         if(validartwitter == true){
                                             
                                             comment = [twit valueForKey:@"text"];
                                             date = [twit valueForKey:@"created_at"];
                                             geolo = [[twit valueForKeyPath:@"entities.media.media_url"] objectAtIndex:0];
                                             hash = [[twit valueForKeyPath:@"entities.hashtags.text"] objectAtIndex:0];
                                             hash2 = [[twit valueForKeyPath:@"entities.hashtags.text"] objectAtIndex:1];
                                             
                                             
                                             
                                             TweetCet *tw = [[TweetCet alloc]init];
                                             tw.tweetCompleto = comment;
                                             
                                             
                                             NSArray *a = [comment componentsSeparatedByString:@" "];
                                             tw.tweetCompleto = comment;
                                             
                                             NSArray *a1 = [comment componentsSeparatedByString:@":"];
                                             tw.descricao = [a1 objectAtIndex:1];
                                             
                                             tw.bairro = hash;
                                             tw.nomeCategoria = [a objectAtIndex:2];
                                             
                                             NSArray *a5 = [date componentsSeparatedByString:@" "];
                                             NSString *s = [NSString stringWithFormat:@"%@%@%@%@%@",[a5 objectAtIndex:2],@"/",[a5 objectAtIndex:1],@"/",[a5 objectAtIndex:5]];
                                             tw.data = s;
                                             tw.hora = [a5 objectAtIndex:3];
                                             tw.caminhoImagem = geolo;
                                             tw.estado = true;
                                             
                                             NSArray *a2 = [comment componentsSeparatedByString:@":"];
                                             NSArray *a3 = [[a2 objectAtIndex:1] componentsSeparatedByString:@","];
                                             tw.rua = [a3 objectAtIndex:0];
                                             tw.zona = hash2;
                                             
                                             NSString *sentence = comment;
                                             NSString *R = @"Marginal";
                                             NSString *Rua = @"Rua";
                                             NSString *Av = @"Av";
                                             
                                             
                                             if([sentence rangeOfString:R].location != NSNotFound){
                                                 NSArray *arR = [comment componentsSeparatedByString:R];
                                                 NSString *ars = [arR objectAtIndex:1];
                                                 NSString *s = [NSString stringWithFormat:@"%@%@",R,ars];
                                                 NSArray *arR2 = [s componentsSeparatedByString:@","];
                                                 NSString *rua = [arR2 objectAtIndex:0];
                                                 //NSString *numero = [arR2 objectAtIndex:1];
                                                 
                                                 if ([rua rangeOfString:@"#"].location != NSNotFound) {
                                                     NSArray *arRua = [rua componentsSeparatedByString:@"#"];
                                                     NSString *arse = [arRua objectAtIndex:0];
                                                     tw.rua = arse;
                                                 }else{
                                                     tw.rua = rua;
                                                 }
                                                 
                                                 
                                             }
                                             
                                             if([sentence rangeOfString:Rua].location !=  NSNotFound){
                                                 NSArray *arRua = [comment componentsSeparatedByString:Rua];
                                                 NSString *arse = [arRua objectAtIndex:1];
                                                 NSString *s = [NSString stringWithFormat:@"%@%@",Rua,arse];
                                                 NSArray *arR2 = [s componentsSeparatedByString:@","];
                                                 NSString *rua = [arR2 objectAtIndex:0];
                                                 //NSString *numero = [arR2 objectAtIndex:1];
                                                 
                                                 if ([rua rangeOfString:@"#"].location != NSNotFound) {
                                                     NSArray *arRua = [rua componentsSeparatedByString:@"#"];
                                                     NSString *arse = [arRua objectAtIndex:0];
                                                     tw.rua = arse;
                                                 }else{
                                                     tw.rua = rua;
                                                 }
                                                 
                                                 
                                             }
                                             
                                             if([sentence rangeOfString:Av].location !=  NSNotFound){
                                                 NSArray *arAv = [comment componentsSeparatedByString:Av];
                                                 NSString *arsd = [arAv objectAtIndex:1];
                                                 NSString *s = [NSString stringWithFormat:@"%@%@",@"Avenida",arsd];
                                                 NSArray *arR2 = [s componentsSeparatedByString:@","];
                                                 NSString *ruas = [arR2 objectAtIndex:0];
                                                 NSString *rua = [ruas stringByReplacingOccurrencesOfString:@"." withString:@""];
                                                 //NSString *numero = [arR2 objectAtIndex:1];
                                                 
                                                 if ([rua rangeOfString:@"#"].location != NSNotFound) {
                                                     NSArray *arRua = [rua componentsSeparatedByString:@"#"];
                                                     NSString *arse = [arRua objectAtIndex:0];
                                                     tw.rua = arse;
                                                 }else{
                                                     tw.rua = rua;
                                                 }
                                                 
                                             }
                                             
                                             
                                             
                                             BOOL estadoParaAdicionar = true;
                                             
                                             for(int i=0;i<[[[DataBaseCoordenada sharedManager]listaCoordenadas ]count];i++){
                                                 CoordenadaCet *coord = [[[DataBaseCoordenada sharedManager]listaCoordenadas ]objectAtIndex:i];
                                                 if([coord isKindOfClass:[CoordenadaCet class]]){
                                                     if(([[coord tweetCompleto] isEqualToString:[tw tweetCompleto]])){
                                                         estadoParaAdicionar = false;
                                                         break;
                                                     }
                                                     
                                                 }
                                             }
                                             
                                             if(estadoParaAdicionar){
                                                 CoordenadaCet *coord = [[CoordenadaCet alloc]initCoordenada:tw];
                                                 [[DataBaseCoordenada sharedManager]criaCoordenadaCET:coord];
                                                 
                                                 [self marcarPosicaoNoMapaDiretoTwitterCadaUmCET:coord];
                                             }else{
                                                 NSLog(@"ja add cet");
                                             }
                                             
                                             
                                         }
                                         
                                         
                                         
                                     }
                                     
                                 }
                                 
                                 
                                 
                             } errorBlock:^(NSError *error) {
                                 NSLog(@"Error1");
                             }
         ];
        
    } errorBlock:^(NSError *error) {
        NSLog(@"Error2");
    }];
}

- (void) refreshTwitterCorpo {
    
    
    [twitter verifyCredentialsWithSuccessBlock:^(NSString *bearerToken) {
        [twitter getSearchTweetsWithQuery:@"BombeirosPMESP"
                                  geocode:nil
                                     lang:nil
                                   locale:nil
                               resultType:nil
                                    count:@"10"
                                    until:nil
                                  sinceID:nil
                                    maxID:nil
                          includeEntities:nil
                                 callback:nil
                             successBlock: ^(NSDictionary *searchMetaData, NSArray *statusesConrado){
                                 self.results = statusesConrado;
                                 
                                 NSString *comment;
                                 NSString *date;
                                 NSString *geolo;
                                 
                                 
                                 
                                 for (NSDictionary *twit in self.results) {
                                     
                                     comment = [twit valueForKey:@"text"];
                                     BOOL validartwitter = false;
                                     
                                     
                                     NSString *sentence = comment;
                                     NSString *word = @"@";
                                     
                                     if ([sentence rangeOfString:word].location == NSNotFound) {
                                         NSString *v= [comment substringToIndex:1];
                                         
                                         
                                         NSString *est1 = @"Atropelamento";
                                         NSString *est2 = @"Sobre";
                                         NSString *est3 = @"Acidente";
                                         NSString *est4 = @"Incendio";
                                         NSString *est5 = @"Incêndio";
                                         NSString *est6 = @"Colisão";
                                         
                                         
                                         if( ( ([v intValue] == 0) || ([v intValue] == 1) || ([v intValue] == 2)) &&
                                            (([sentence rangeOfString:est2].location == NSNotFound)) &&
                                            ( ([sentence rangeOfString:est1].location != NSNotFound) ||
                                             ([sentence rangeOfString:est3].location != NSNotFound) ||
                                             ([sentence rangeOfString:est4].location != NSNotFound) ||
                                             ([sentence rangeOfString:est6].location != NSNotFound) ||
                                             ([sentence rangeOfString:est5].location != NSNotFound)) )  {
                                                
                                                validartwitter = true;
                                                
                                                
                                            }else{
                                                validartwitter = false;
                                            }
                                         
                                         
                                         if(validartwitter == true){
                                             
                                             comment = [twit valueForKey:@"text"];
                                             date = [twit valueForKey:@"created_at"];
                                             geolo = [[twit valueForKeyPath:@"entities.media.media_url"] objectAtIndex:0];
                                             
                                             
                                             TweetCorpo *tw = [[TweetCorpo alloc]init];
                                             tw.tweetCompleto = comment;
                                             
                                             
                                             NSArray *a = [comment componentsSeparatedByString:@" "];
                                             tw.hora = [a objectAtIndex:0];
                                             
                                             NSArray *a2 = [comment componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@".,"]];
                                             NSString *aux2 = [a2 objectAtIndex:0];
                                             NSArray *a12 = [aux2 componentsSeparatedByString:@" "];
                                             
                                             tw.nomeCategoria = [a12 objectAtIndex:1];
                                             
                                             
                                             tw.descricao = comment;
                                             
                                             NSArray *a5 = [date componentsSeparatedByString:@" "];
                                             NSString *s = [NSString stringWithFormat:@"%@%@%@%@%@",[a5 objectAtIndex:2],@"/",[a5 objectAtIndex:1],@"/",[a5 objectAtIndex:5]];
                                             tw.data = s;
                                             //tw.hora = [a5 objectAtIndex:3];
                                             tw.caminhoImagem = geolo;
                                             tw.estado = true;
                                             
                                             
                                             
                                             NSString *sentence = comment;
                                             NSString *R = @"R ";
                                             NSString *Rua = @"Rua";
                                             NSString *Av = @"Av";
                                             
                                             
                                             
                                             if([sentence rangeOfString:R].location != NSNotFound){
                                                 NSArray *arR = [comment componentsSeparatedByString:R];
                                                 NSString *ars = [arR objectAtIndex:1];
                                                 NSString *s = [NSString stringWithFormat:@"%@%@",Rua,ars];
                                                 NSArray *arR2 = [s componentsSeparatedByString:@","];
                                                 NSString *rua = [arR2 objectAtIndex:0];
                                                 //NSString *numero = [arR2 objectAtIndex:1];
                                                 tw.rua = rua;
                                                 
                                                 
                                             }
                                             
                                             if([sentence rangeOfString:Rua].location !=  NSNotFound){
                                                 NSArray *arRua = [comment componentsSeparatedByString:Rua];
                                                 NSString *arse = [arRua objectAtIndex:1];
                                                 NSString *s = [NSString stringWithFormat:@"%@%@",Rua,arse];
                                                 NSArray *arR2 = [s componentsSeparatedByString:@","];
                                                 NSString *rua = [arR2 objectAtIndex:0];
                                                 //NSString *numero = [arR2 objectAtIndex:1];
                                                 tw.rua = rua;
                                                 
                                                 
                                             }
                                             
                                             if([sentence rangeOfString:Av].location !=  NSNotFound){
                                                 NSArray *arAv = [comment componentsSeparatedByString:Av];
                                                 NSString *arsd = [arAv objectAtIndex:1];
                                                 NSString *s = [NSString stringWithFormat:@"%@%@",@"Avenida",arsd];
                                                 NSArray *arR2 = [s componentsSeparatedByString:@","];
                                                 NSString *rua = [arR2 objectAtIndex:0];
                                                 //NSString *numero = [arR2 objectAtIndex:1];
                                                 tw.rua = rua;
                                                 
                                             }
                                             
                                             BOOL estadoParaAdicionar = true;
                                             
                                             for(int i=0;i<[[[DataBaseCoordenada sharedManager]listaCoordenadas ]count];i++){
                                                 CoordenadaCorpo *coord = [[[DataBaseCoordenada sharedManager]listaCoordenadas ]objectAtIndex:i];
                                                 if([coord isKindOfClass:[CoordenadaCorpo class]]){
                                                     if(([[coord tweetCompleto] isEqualToString:[tw tweetCompleto]])){
                                                         estadoParaAdicionar = false;
                                                         break;
                                                     }
                                                     
                                                 }
                                             }
                                             
                                             if(estadoParaAdicionar){
                                                 CoordenadaCorpo *coord = [[CoordenadaCorpo alloc]initCoordenada:tw];
                                                 [[DataBaseCoordenada sharedManager]criaCoordenadaCorpo:coord];
                                                 
                                                 [self marcarPosicaoNoMapaDiretoTwitterCadaUmCorpo:coord];
                                             }else{
                                                 NSLog(@"ja add bomb");
                                             }
                                             
                                             
                                             
                                         }
                                         
                                         
                                         
                                     }
                                     
                                 }
                                 
                                 
                                 
                             } errorBlock:^(NSError *error) {
                                 NSLog(@"Error1");
                             }
         ];
        
    } errorBlock:^(NSError *error) {
        NSLog(@"Error2");
    }];
}


-(void)marcarPosicaoNoMapaDiretoTwitterCadaProject:(Coordenada*)Coord{
    
    [[self mapaBacana] addAnnotation: [[DataBaseCoordenada sharedManager]marcarPosicaoNoMapaDiretoTwitterCadaProject:Coord]];
    
}

-(void)marcarPosicaoNoMapaDiretoTwitterCadaUmCET:(CoordenadaCet*)CoordCet{
    
    [[self mapaBacana] addAnnotation: [[DataBaseCoordenada sharedManager]marcarPosicaoNoMapaDiretoTwitterCadaUmCET:CoordCet]];
    
}

-(void)marcarPosicaoNoMapaDiretoTwitterCadaUmCorpo:(CoordenadaCorpo*)CoordCet{
    
    [[self mapaBacana] addAnnotation: [[DataBaseCoordenada sharedManager]marcarPosicaoNoMapaDiretoTwitterCadaUmCorpo:CoordCet]];
    
}

-(void)marcarPosicaoNoMapaDiretoSiteCet:(CoordenadaCetSite*)CoordCet{
    
    [[self mapaBacana] addAnnotation: [[DataBaseCoordenada sharedManager]marcarPosicaoNoMapaDiretoSiteCet:CoordCet]];
    
}


-(void)serializaDadosSiteCET{
    
    NSString *problema = @"Ocorrências não disponíveis no momento";
    NSString* url = @"http://cetsp1.cetsp.com.br/monitransmapa/IMG1/ocorrenciasH.asp?ordem=H";
    NSURL* query = [NSURL URLWithString:url];
    NSString* result = [NSString stringWithContentsOfURL:query encoding:NSWindowsCP1254StringEncoding error:nil];
    // NSString *s = [NSString stringWithFormat:@"%@%@",@"Avenida",arsd];
    
    int contando =0;
    while([result rangeOfString:problema].location != NSNotFound){
        contando += 1;
        
        NSString *s = [NSString stringWithFormat:@"%@%d%@",@"http://cetsp1.cetsp.com.br/monitransmapa/IMG",contando,@"/ocorrenciasH.asp?ordem=H"];
        NSURL* query = [NSURL URLWithString:s];
        result = [NSString stringWithContentsOfURL:query encoding:NSWindowsCP1254StringEncoding error:nil];
        
        NSLog(@"site =%@",s);
        
    }
    
    NSString *string=result;
    NSRange searchFromRange = [string rangeOfString:@"<table>"];
    NSRange searchToRange = [string rangeOfString:@"</body>"];
    NSString *substring = [string substringWithRange:NSMakeRange(searchFromRange.location+searchFromRange.length, searchToRange.location-searchFromRange.location-searchFromRange.length)];
    
    NSString *stringFinal = substring;
    
    //NSLog(@"v = %@",stringFinal );
    
    //Controla o laco de repeticao
    NSRange continua =[stringFinal rangeOfString:@"<tr class"];
    
    
    
    //Faz enquanto encontrar o ultimo #EXTINF:-1,
    while(continua.location != NSNotFound){
        
        CoordenadaCetSite *t = [[CoordenadaCetSite alloc]init];
        
        stringFinal = [stringFinal substringFromIndex:continua.location];
        stringFinal = [stringFinal substringFromIndex:[stringFinal rangeOfString:@"title="].location+7];
        t.titulo = [stringFinal substringToIndex:[stringFinal rangeOfString:@"<td>"].location-9];
        
        stringFinal = [stringFinal substringFromIndex:[stringFinal rangeOfString:@"<td>"].location+4];
        t.codigo = [stringFinal substringToIndex:[stringFinal rangeOfString:@"</td>"].location-6];
        
        stringFinal = [stringFinal substringFromIndex:[stringFinal rangeOfString:@"<td>"].location+4];
        NSString *rua = [stringFinal substringToIndex:[stringFinal rangeOfString:@"</td>"].location];
        NSString *barra = @"/";
        
        if ([rua rangeOfString:barra].location != NSNotFound){
            NSArray *arR = [rua componentsSeparatedByString:@"/"];
            t.local = [arR objectAtIndex:0];
        }else{
            t.local = rua;
        }
        
        
        
        stringFinal = [stringFinal substringFromIndex:[stringFinal rangeOfString:@"<td>"].location+4];
        t.sentido = [stringFinal substringToIndex:[stringFinal rangeOfString:@"</td>"].location-6];
        
        
        stringFinal = [stringFinal substringFromIndex:[stringFinal rangeOfString:@"<td>"].location+4];
        NSString *time = [stringFinal substringToIndex:[stringFinal rangeOfString:@"</td>"].location-6];
        NSArray *arR2 = [time componentsSeparatedByString:@"-"];
        t.data = [arR2 objectAtIndex:0];
        t.hora = [arR2 objectAtIndex:1];
        
        
        //        BOOL estadoParaAdicionar = true;
        //
        //        for(int i=0;i<[[[DataBaseCoordenada sharedManager]listaCoordenadas ]count];i++){
        //            CoordenadaCetSite *coord = [[[DataBaseCoordenada sharedManager]listaCoordenadas ]objectAtIndex:i];
        //            if([coord isKindOfClass:[CoordenadaCetSite class]]){
        //                if(([[coord hora] isEqualToString:[t hora]]) && ([[coord data] isEqualToString:[t data]])){
        //                    estadoParaAdicionar = false;
        //                    break;
        //                }
        //
        //            }
        //        }
        //
        //        if(estadoParaAdicionar){
        //            CoordenadaCorpo *coord = [[CoordenadaCorpo alloc]initCoordenada:tw];
        //            [[DataBaseCoordenada sharedManager]criaCoordenadaCorpo:coord];
        //
        //            [self marcarPosicaoNoMapaDiretoTwitterCadaUmCorpo:coord];
        //        }else{
        //            NSLog(@"ja add bomb");
        //        }
        
        [[DataBaseCoordenada sharedManager]criaCoordenadaSiteCET:t];
        [self marcarPosicaoNoMapaDiretoSiteCet:t];
        
        
        continua = [stringFinal rangeOfString:@"<tr class"];
        
        
        NSLog(@"\n");
        
    }
    
    
    
    
    
    
    //NSLog(@"t = %@",t.codigo);
    
    //pega o proximo #EXTINF:-1, até sair do While
    continua = [stringFinal rangeOfString:@"<tr class"];
    
    //    @property NSString *codigo;
    //    @property NSString *local;
    //    @property NSString *sentido;
    //    @property NSString *data;
    //    @property NSString *hora;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *annotationIdentifier = @"annotationIdentifier";
    MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
    
    if([pinView.annotation.title isEqualToString:@"Project"]) {
        [pinView setImage:[UIImage imageNamed:@"Lompada.png"]];
        //pinView.pinColor = MKPinAnnotationColorPurple;
    }
    
    if([pinView.annotation.title isEqualToString:@"CET"]) {
        [pinView setImage:[UIImage imageNamed:@"Pedagio.png"]];
        //pinView.pinColor = MKPinAnnotationColorGreen;
    }
    
    if (pinView.annotation == mapView.userLocation) {
        return nil;
        
    }
    
    if([pinView.annotation.title isEqualToString:@"Corpo"]){
        [pinView setImage:[UIImage imageNamed:@"Pedagio.png"]];
        //pinView.pinColor = MKPinAnnotationColorRed;
    }
    
    
    pinView.canShowCallout = YES;
    pinView.animatesDrop = YES;
    pinView.selected = YES;
    
    return pinView;
}

//================================== FIM DOS METODOS TWITTER =====================================





//Ao clicar na tela com o teclado evidente o mesmo é recolhido
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UIView *view in self.view.subviews) {
        [view resignFirstResponder];
    }
}


//Define o estilo do mapa
- (IBAction)escolhaTipoDoMapa:(id)sender {
    
    if (self.tipoMapa.selectedSegmentIndex == 0)
        [[self mapaBacana] setMapType: MKMapTypeStandard];
    else if (self.tipoMapa.selectedSegmentIndex == 1)
        [[self mapaBacana] setMapType: MKMapTypeSatellite];
    else
        [[self mapaBacana] setMapType: MKMapTypeHybrid];
}


//Configura a localização atual
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    [[self mapaBacana] setCenterCoordinate: userLocation.location.coordinate];
}


//Aplica zoom ao mapa na região em que o usuário se encontra
-(void)zoomToUserRegion {
    MKCoordinateRegion region;
    region.center.latitude = self.mapaBacana.userLocation.coordinate.latitude;
    region.center.longitude = self.mapaBacana.userLocation.coordinate.longitude;
    region.span.latitudeDelta = 0.1;
    region.span.longitudeDelta = 0.1;
    [self.mapaBacana setRegion:region];
}


//============================ MÉTODOS PARA PINAGEM DO LOCAL PROCURADO ==================================


//Ao clicar no botão search do teclado procura pela localização
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self marcarPosicaoNoMapa];
}

//Ao procurar por um local, caso existente este irá pinar o mapa
-(void)marcarPosicaoNoMapa{
    
    //Devolve a latitude e longitude apartir de um enedereço
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    //Ponto onde será adicionado a marcação
    [geocoder geocodeAddressString:self.searchBar.text completionHandler:^(NSArray* placemarks, NSError* error){
        for (CLPlacemark  *aPlacemark in placemarks) {

            
            CLLocationCoordinate2D localizacao;
            MKPointAnnotation *ponto = [[MKPointAnnotation alloc] init];
            
            //Guarda a latitude e longitude para marcação no mapa
            NSString *latitude = [NSString stringWithFormat:@"%f", aPlacemark.location.coordinate.latitude];
            NSString *longitude = [NSString stringWithFormat:@"%f", aPlacemark.location.coordinate.longitude];
            localizacao.latitude = [latitude doubleValue];
            localizacao.longitude = [longitude doubleValue];
            
            
            NSLog(@"Localização %@", [aPlacemark.location description]);
            NSLog(@"Latitude %f", aPlacemark.location.coordinate.latitude);
            NSLog(@"Longitude %f", aPlacemark.location.coordinate.longitude);
            
            
            
            //Zoom no ponto
            MKCoordinateRegion regiao;
            regiao.center = localizacao;
            ponto.coordinate = localizacao;
            
            //Título da marcação
            NSLog(@"Texto da caixa de pesquisa:  %@", self.searchBar.text);
            ponto.title = self.searchBar.text;
            
            //Adicionada a marcação
            [[self mapaBacana] setRegion: regiao];
            [[self mapaBacana] addAnnotation: ponto];
            
            [self.searchBar setText:@""];
            
        }
    }];
}




//================================ MÉTODOS PARA ROTA ========================================

//Cálculo da rota
-(void)calcularRota{
    
    if ([self inicio] == nil) {
        
        //Ponto onde será adicionado a marcação
        CLGeocoder *geocoderDestino = [[CLGeocoder alloc] init];
        CLGeocoder *geocoderPartida = [[CLGeocoder alloc] init];
        MKPlacemark __block *pinInicio = [[MKPlacemark alloc] initWithCoordinate: [[[self mapaBacana] userLocation] coordinate] addressDictionary:nil];
        MKPlacemark __block *pinDestino;
        
        
        //Se o usuário  digitou um outro ponto de partida solicitamos que o geocoder encontre-o também
        if (self.txtPartida.text != [NSString stringWithFormat:@""]) {

            [geocoderPartida geocodeAddressString:self.txtPartida.text completionHandler:^(NSArray* placemarks, NSError* error){
                if(error){
                    NSLog(@"Erro ao buscar destino - %@", error.description)
                }
                else{
                    CLPlacemark  *aPlacemark = [placemarks firstObject];
                    CLLocationCoordinate2D localizacaoPartida;
                    
                    //Guarda a latitude e longitude para marcação no mapa
                    NSString *latitude = [NSString stringWithFormat:@"%f", aPlacemark.location.coordinate.latitude];
                    NSString *longitude = [NSString stringWithFormat:@"%f", aPlacemark.location.coordinate.longitude];
                    localizacaoPartida.latitude = [latitude doubleValue];
                    localizacaoPartida.longitude = [longitude doubleValue];
                    
                    
                    pinInicio = [[MKPlacemark alloc] initWithCoordinate: localizacaoPartida addressDictionary:nil];
                }
                
            }];
        }
        
        
        
        
        
        [geocoderDestino geocodeAddressString:self.txtDestino.text completionHandler:^(NSArray* placemarks, NSError* error){
            if(error){
                NSLog(@"Erro ao buscar destino - %@", error.description)
            }
            else{
                CLPlacemark  *aPlacemark = [placemarks firstObject];
                CLLocationCoordinate2D localizacaoDestino;
                
                //Guarda a latitude e longitude para marcação no mapa
                NSString *latitude = [NSString stringWithFormat:@"%f", aPlacemark.location.coordinate.latitude];
                NSString *longitude = [NSString stringWithFormat:@"%f", aPlacemark.location.coordinate.longitude];
                localizacaoDestino.latitude = [latitude doubleValue];
                localizacaoDestino.longitude = [longitude doubleValue];
                
                pinDestino = [[MKPlacemark alloc] initWithCoordinate: localizacaoDestino addressDictionary:nil];
                
                self.inicio = [[MKMapItem alloc] initWithPlacemark: pinInicio];
                self.destino = [[MKMapItem alloc] initWithPlacemark: pinDestino];
                [self obterDirecoes];
                
            }
            
        }];
        
            
    }else if ([self inicio] != nil && [self destino]){
        
        self.inicio = nil;
        self.destino = nil;
        [self.mapaBacana removeOverlays: self.mapaBacana.overlays];
        
    }
}


//Guarda as direções, passo-a-passo da rota solicitada
-(void)obterDirecoes{
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    
    request.source = [self inicio];
    request.destination = [self destino];
    request.requestsAlternateRoutes = YES;

    
    MKDirections *direcoes = [[MKDirections alloc] initWithRequest: request];
    
    [direcoes calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error){
        if (error){
            NSLog(@"Erro ao criar rota");
        }else{
            [self mostraRotaPassoAPasso: response];
        }
        
    }];
    
    
}

//Mostra as direções da rota passo-a-passo
-(void)mostraRotaPassoAPasso:(MKDirectionsResponse*)response{
    
    
    //Tolerância para sabwe se passa no ponto de obstáculo
    double tolerancia = 0.000020;
    
    for (MKRoute *rota in response.routes) {
        
        CoodenadaLatitudeLongitude *coordenadaDeObstaculo;
        CLLocationCoordinate2D coordenadaDeRota;

        
        //Percorre a lista de todos os obstáculos (coordenadas) exibidos np mapa
        for (coordenadaDeObstaculo in [[DataBaseCoordenada sharedManager] listaCoordenadasLatLong]) {
            
            //Percorre a lista de pontos que esta rota passa
            for (int i = 0; i < rota.polyline.pointCount; i++) {
                
                coordenadaDeRota = MKCoordinateForMapPoint(rota.polyline.points[i]);
                coordenadaDeRota.latitude = coordenadaDeRota.latitude;
                coordenadaDeRota.longitude = coordenadaDeRota.longitude;
                
                NSLog(@"\nROTA LATITUDE: %f / LONGITUDE: %f",  coordenadaDeRota.latitude,  coordenadaDeRota.longitude);
                NSLog(@"OBST LATITUDE: %f / LONGITUDE: %f",  coordenadaDeObstaculo.latitude,  coordenadaDeObstaculo.longitude);
                
                
                //Comparação entre a coordenada do obstáculo e coordenada do ponto que a rota está passando
                //---PS: Colocamos uma tolerância de 0.000020, porém ainda não está 100% preciso
                if ((      ((coordenadaDeObstaculo.latitude <= (coordenadaDeRota.latitude) + tolerancia)) && (coordenadaDeObstaculo.latitude >= (coordenadaDeRota.latitude) - tolerancia))    &&                                     ((coordenadaDeObstaculo.longitude <= (coordenadaDeRota.longitude) + tolerancia)) && (coordenadaDeObstaculo.longitude >= (coordenadaDeRota.longitude) - tolerancia)) {
                    NSLog(@"Está rota passa por um pino!");
                }
                
                
            }
        }
        
        
        
        
        [self.mapaBacana addOverlay: rota.polyline level: MKOverlayLevelAboveRoads];
        
        
        
        NSLog(@"\nCOMEÇO ROTA\n");
        int auxiliar = 1;
        for (MKRouteStep *step in rota.steps) {
            NSLog(@"ETAPA %i - %@ by %.0f meters", auxiliar, step.instructions, (double)step.distance);
            auxiliar++;
        }
        NSLog(@"\nFIM ROTA\n");
        
    }
}

//Função que renderiza a rota
-(MKOverlayRenderer*)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    self.linha = [[MKPolylineRenderer alloc] initWithOverlay: overlay];
    
    NSInteger aRedValue = arc4random()%255;
    NSInteger aGreenValue = arc4random()%255;
    NSInteger aBlueValue = arc4random()%255;
    
    UIColor *randColor = [UIColor colorWithRed:aRedValue/255.0f green:aGreenValue/255.0f blue:aBlueValue/255.0f alpha:1.0f];
    
    
    
    self.linha.strokeColor = randColor;
    self.linha.lineWidth = 5.0;
    
    return self.linha;
}


- (IBAction)addRota:(id)sender {
    
    if (self.menuView.hidden == YES)
        self.menuView.hidden = NO;
    else{
        self.menuView.hidden = YES;
        self.txtPartida.text = @"";
        self.txtDestino.text = @"";
        [self.txtDestino resignFirstResponder];
    }
}




-(BOOL)textFieldShouldReturn:(UITextField*)textField{
    
    if (textField.returnKeyType == UIReturnKeySearch)
        [self calcularRota];
    else
        [[self txtDestino] becomeFirstResponder];
    
    return YES;
}


- (IBAction)bu:(id)sender {
}

@end
