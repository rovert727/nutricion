//
//  newViewController.m
//  Nutricion
//
//  Created by Robert Rodriguez on 12/04/13.
//  Copyright (c) 2013 Robert Rodriguez. All rights reserved.
//

#import "newViewController.h"
#import "ViewController.h"

@interface newViewController ()

@end

@implementation newViewController

@synthesize name,lastname,password,username,age,weight,height;

NSMutableData *webData;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
	// Do any additional setup after loading the view.
    webData = [NSMutableData new];
    }

#pragma mark - HTTP Request

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [webData setLength:0];
    NSLog(@"didReceiveResponse");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [webData appendData:data];
    //NSLog(@"%@",data);
    NSLog(@"didReceiveData");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSError *error;
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:webData
                                                             options:kNilOptions
                                                               error:&error];
    NSLog(@"Response: %@", response);
}


- (IBAction)back:(id)sender {
    //Instantiate blue controller
    ViewController *blue = [self.storyboard instantiateViewControllerWithIdentifier:@"homeController"];
    //perform transition
    [self presentViewController:blue animated:YES completion:nil];
}

- (IBAction)done:(id)sender {
    NSString *url = @"http://166.78.30.215/nutricion2/users/add.json";
    //NSString *url = @"http://166.78.30.215/app/users/add.json";
    
    
    NSMutableDictionary *user = [NSMutableDictionary new];
    NSMutableDictionary *userParameters = [NSMutableDictionary new];
    
    if(![name.text isEqualToString:@""] || ![lastname.text isEqualToString:@""]|| ![username.text isEqualToString:@""]|| ![lastname.text isEqualToString:@""]){
        //Setting the parameters of the user
        [userParameters setObject:name.text                 forKey:@"name"];
        [userParameters setObject:lastname.text             forKey:@"lastname"];
        //[userParameters setObject:age.text                  forKey:@"age"];
        [userParameters setObject:username.text             forKey:@"username"];
        [userParameters setObject:password.text             forKey:@"password"];
        //[userParameters setObject:weight.text               forKey:@"weight"];
        //[userParameters setObject:height.text               forKey:@"heigth"];
    }
    
    [user setObject:userParameters forKey:@"User"];
    
    //Making NSData from NSMutableDictionary
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:user
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
    
    //Changing from NSData to NSString;
    NSString *stringToSend = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    
    //Creating the NSMutableRequest
    NSString *params = [[NSString alloc] initWithFormat:@"data=%@",stringToSend];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    //Creating the NSURLConnection
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request
                                                                  delegate:self];
    
    if(!connection){
        NSLog(@"Hubo un error");
    }

    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.password resignFirstResponder];
        [self.username resignFirstResponder];
        [self.lastname resignFirstResponder];
        [self.weight resignFirstResponder];
        [self.height resignFirstResponder];
        [self.age resignFirstResponder];
        [self.name resignFirstResponder];
    }
}

 
@end