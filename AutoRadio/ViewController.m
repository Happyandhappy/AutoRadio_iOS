//
//  ViewController.m
//  AutoRadio
//
//  Created by POLA on 13/02/15.
//  Copyright (c) 2015 POLA. All rights reserved.
//

#import "ViewController.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "GAI.h"

@interface ViewController ()

//{
//    int seconds;
//    NSTimer *
//}
@property (weak, nonatomic) IBOutlet UIWebView *WebView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBarHidden = NO;
    
    [self loadRequestFromString:self.url];
    
    if (self.isFPorIns == YES) {
        self.title = @"Facebook";
    }
    else
    {
        self.title = @"Instagram";
    }
}

//- (void)progress
//{
//    seconds ++;
//    self.slider.value = seconds;
//    if (seconds > ) {
//        
//    }
//}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:self.title];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadRequestFromString:(NSString*)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.WebView loadRequest:urlRequest];
}

@end


