//
//  ViewController.m
//  HaoUIAlertViewFianl
//
//  Created by Hao Zheng on 12/18/14.
//  Copyright (c) 2014 Hao Zheng. All rights reserved.
//

#import "ViewController.h"
#import "ADCAlertView.h"



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


- (IBAction)showAlertView:(id)sender {
    
    ADCAlertView *al = [[ADCAlertView alloc] initWithTitle:@"aaaaaccccccccccccccvvvvvva" message:@"asdfasdfwedqwdqwdqdqwdqwdczxdqwdqwdczxdqwdqwdczxwdczxcasdqwdqwdqweqweqwezzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz" cancelButtonTitle:@"OK"];
    [al show];
    
}

- (IBAction)traditional:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"aaaaaccccccccccccccvvvvvva" message:@"asdfasdfwedqwdqwdqdqwdqwdczxdqwdqwdczxdqwdqwdczxwdczxcasdqwdqwdqweqweqwezzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
    
    
}
@end
