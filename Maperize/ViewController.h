//
//  ViewController.h
//  Maperize
//
//  Created by EMERSON DE SOUZA BARROS on 26/03/14.
//  Copyright (c) 2014 EMERSON DE SOUZA BARROS. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "STTwitter.h"
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController <MKMapViewDelegate, UITextFieldDelegate, UISearchBarDelegate> {
    //API do twiiter
    STTwitterAPI *twitter;
}
- (IBAction)bu:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *altbu;

//View do menu
@property (weak, nonatomic) IBOutlet UIView *menuView;

//Tipo do mapa
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipoMapa;
- (IBAction)escolhaTipoDoMapa:(id)sender;

//Mapa e pesquisa
@property (weak, nonatomic) IBOutlet MKMapView *mapaBacana;
@property (weak, nonatomic) IBOutlet UILabel *lblbackground;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

//Rota

@property (weak, nonatomic) IBOutlet UITextField *txtPartida;
@property (weak, nonatomic) IBOutlet UITextField *txtDestino;
@property (weak, nonatomic) IBOutlet UILabel *lblRota;
@property (weak, nonatomic) IBOutlet UIButton *outSearchRota;
- (IBAction)searchRota:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *outAddRota;
- (IBAction)addRota:(id)sender;

//Pinos de ínicio e destino para rota
@property (strong, nonatomic) MKMapItem *inicio;
@property (strong, nonatomic) MKMapItem *destino;

//Linha que ligará os pontos de rota
@property (strong, nonatomic) MKPolylineRenderer *linha;

//Recebe o resultados do twitter
@property (nonatomic, strong) NSArray *results;

@end
