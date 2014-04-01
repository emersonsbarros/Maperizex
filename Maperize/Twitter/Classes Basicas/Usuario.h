//
//  Usuario.h
//  TwitterSDK
//
//  Created by VINICIUS RESENDE FIALHO on 26/03/14.
//  Copyright (c) 2014 VINICIUS RESENDE FIALHO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Rota.h"


@interface Usuario : NSObject {
    NSString *nome;
    
}


@property NSMutableArray *listaRotas;

-(NSMutableArray*)SerializarRotasDoSistema;

+(Usuario*)sharedManager;



@end
