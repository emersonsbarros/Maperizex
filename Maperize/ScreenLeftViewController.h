//
//  ScreenLeftViewController.h
//  Maperize
//
//  Created by Vinicius Resende Fialho on 04/04/14.
//  Copyright (c) 2014 EMERSON DE SOUZA BARROS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface ScreenLeftViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property NSString *nomeTwitter;
@property  NSString *imageString;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)buttonTwetar:(id)sender;


- (IBAction)buttonProject:(id)sender;
- (IBAction)buttonCET:(id)sender;
- (IBAction)buttonBomb:(id)sender;



- (IBAction)takePhoto:  (UIButton *)sender;
- (IBAction)selectPhoto:(UIButton *)sender;

@end
