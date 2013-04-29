//
//  ViewController.m
//  Nutricion
//
//  Created by Robert Rodriguez on 12/04/13.
//  Copyright (c) 2013 Robert Rodriguez. All rights reserved.
//

#import "ViewController.h"
#import "newViewController.h"
#import "AppDelegate.h"

@interface ViewController ()
- (void)updateView;

@end

@implementation ViewController

@synthesize username, password, myUsers,mail, correos,fbb;
NSMutableData *webData;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    FBLoginView *loginView = [[FBLoginView alloc] init];
    // Align the button in the center horizontally
    //loginView.frame = CGRectOffset(loginView.frame,
      //                             (self.view.center.x - (loginView.frame.size.width / 2)),
        //                           5);
    [self.view addSubview:loginView];
    //[loginView sizeToFit];
    
    
	// Do any additional setup after loading the view, typically from a nib.
    webData = [NSMutableData data];
    myUsers = [NSMutableArray new];
    correos = [NSMutableArray new];
    [correos addObject:@"rovert727@hotmail.com"];
    
    //NSString *url = @"http://166.78.30.215/app/users.json";
    NSString *url = @"http://166.78.30.215/nutricion2/users.json";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(!connection){
        NSLog(@"Hubo un error");
    }
    
    //Execute Request
    
    [self updateView];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (!appDelegate.session.isOpen) {
        // create a fresh session object
        appDelegate.session = [[FBSession alloc] init];
        
        // if we don't have a cached token, a call to open here would cause UX for login to
        // occur; we don't want that to happen unless the user clicks the login button, and so
        // we check here to make sure we have a token before calling open
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
            // even though we had a cached token, we need to login to make the session usable
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                // we recurse here, in order to update buttons and labels
                [self updateView];
            }];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {

    int i;
    int flag=0;
    for (i=0; i<[myUsers count]; i++) {
        
    NSDictionary *user = [[myUsers objectAtIndex:i] valueForKey:@"User"];
    
    
    if ([username.text isEqualToString:[user valueForKey:@"username"]] &&
        [password.text isEqualToString:[user valueForKey:@"password"]]) {
        
        flag=1;
        //NSLog(@"flag=%i",flag);
        break;
    }
    
    }
    NSLog(@"flag=%i",flag);
    if (flag==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alto" message:@"No estas registrado, verifica tus datos" delegate:self cancelButtonTitle:@"Adios" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bienvenido"
                                                        message:[NSString stringWithFormat:@"Hola %@", username.text]
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
        
        //Set user defaults
        [[NSUserDefaults standardUserDefaults] setObject:username.text forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] setObject:password.text forKey:@"password"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"username: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"username"]);
        NSLog(@"password: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"password"]);
        
        [alert show];
        
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == username) {
        [password becomeFirstResponder];
    } else if (textField == password) {

    int i;
    int flag=0;
    for (i=0; i<[myUsers count]; i++) {
        
        NSDictionary *user = [[myUsers objectAtIndex:i] valueForKey:@"User"];
        
        
        if ([username.text isEqualToString:[user valueForKey:@"username"]] &&
            [password.text isEqualToString:[user valueForKey:@"password"]]) {
            
            flag=1;
            //NSLog(@"flag=%i",flag);
            break;
        }
        
    }
    NSLog(@"flag=%i",flag);
    if (flag==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alto" message:@"No estas registrado, verifica tus datos" delegate:self cancelButtonTitle:@"Adios" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bienvenido"
                                                        message:[NSString stringWithFormat:@"Hola %@", username.text]
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
        
        //Set user defaults
        [[NSUserDefaults standardUserDefaults] setObject:username.text forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] setObject:password.text forKey:@"password"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"username: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"username"]);
        NSLog(@"password: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"password"]);
        
        [alert show];
        
    }
    }
    return true;
}

- (IBAction)reg:(id)sender {
    
        //Instantiate blue controller
        newViewController *blue = [self.storyboard instantiateViewControllerWithIdentifier:@"newController"];
        //perform transition
        [self presentViewController:blue animated:YES completion:nil];

    
}

- (IBAction)forgot:(id)sender {
}

- (IBAction)send:(id)sender {
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
	mailController.mailComposeDelegate = self;
    NSString *tipo =@"hola";
	[mailController setSubject: @"Referente al pedido"];
    [mailController setMessageBody: tipo isHTML:YES];
    [mailController setToRecipients:correos];
    [self presentModalViewController:mailController animated:YES];
}

- (IBAction)reg1:(id)sender {
}


- (IBAction)backf:(id)sender {
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [webData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [webData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSError *error;
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:webData options:kNilOptions error:&error];
    myUsers = [response valueForKey:@"users"];
    NSLog(@"%@",response);
    
}

- (IBAction)dismissKeyboar:(id)sender{
    [username resignFirstResponder];
    [password resignFirstResponder];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    NSString *mensaje;
    switch (result)
    {
        case MFMailComposeResultCancelled: mensaje = @"Se ha cancelado.";
            break;
        case MFMailComposeResultSaved: mensaje = @"El correo electrónico ha sido guardado.";
            break;
        case MFMailComposeResultSent: mensaje = @"El correo electrónico ha sido enviado correctamente.";
            break;
        case MFMailComposeResultFailed: mensaje = @"Algo ha fallado.";
            break;
        default:
            break;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Untitled.es"
                                                    message:mensaje
                                                   delegate:self
                                          cancelButtonTitle:@"Aceptar"
                                          otherButtonTitles: nil];
    [alert show];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)updateView {
    // get the app delegate, so that we can reference the session property
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (appDelegate.session.isOpen) {
        // valid account UI is shown whenever the session is open
        [self.fbb setTitle:@"Log out" forState:UIControlStateNormal];
    } else {
        // login-needed account UI is shown whenever the session is closed
        [self.fbb setTitle:@"Log in" forState:UIControlStateNormal];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.password resignFirstResponder];
        [self.username resignFirstResponder];
        
    }
}
//coment

@end
