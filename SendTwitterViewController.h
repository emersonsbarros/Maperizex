//
//  SendTwitterViewController.h
//  Maperize
//
//  Created by VINICIUS RESENDE FIALHO on 02/04/14.
//  Copyright (c) 2014 EMERSON DE SOUZA BARROS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>

@interface SendTwitterViewController : UIViewController
- (IBAction)buttonTwetar:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *campoTweet;

@end
