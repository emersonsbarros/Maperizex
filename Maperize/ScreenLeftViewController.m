//
//  ScreenLeftViewController.m
//  Maperize
//
//  Created by Vinicius Resende Fialho on 04/04/14.
//  Copyright (c) 2014 EMERSON DE SOUZA BARROS. All rights reserved.
//

#import "ScreenLeftViewController.h"
#import "AssetsLibrary/AssetsLibrary.h"
#import "Base64.h"

@interface ScreenLeftViewController ()

@end

@implementation ScreenLeftViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)buttonTwetar:(id)sender {
    if ([TWTweetComposeViewController canSendTweet])
    {
        TWTweetComposeViewController *tweetSheet = [[TWTweetComposeViewController alloc] init];
        //[tweetSheet setInitialText:@"Coloque a descricao do problema e escolha"];
        
        if (self.imageString)
        {
            
            [tweetSheet addImage:[UIImage imageNamed:self.imageString]];
            //[tweetSheet addImage:self.imageView.image];
            
        }
        
        if (self.nomeTwitter)
        {
            [tweetSheet addURL:[NSURL URLWithString:self.nomeTwitter]];
        }
        
        
	    [self presentModalViewController:tweetSheet animated:YES];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Desculpe"
                                                            message:@"Voce nao pode logar se nao estiver com o twitter instalado e logado!"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    
}

- (IBAction)buttonProject:(id)sender {

      self.nomeTwitter = @"@ProjetoSdkIOS";

}

- (IBAction)buttonCET:(id)sender {
    self.nomeTwitter = @"@CETSP_";
}

- (IBAction)buttonBomb:(id)sender {
    
}

- (IBAction)takePhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

@end
