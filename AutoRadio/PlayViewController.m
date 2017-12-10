//
//  PlayViewController.m
//  AutoRadio
//
//  Created by POLA on 14/02/15.
//  Copyright (c) 2015 POLA. All rights reserved.
//

#import "PlayViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ViewController.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "GAI.h"

@interface PlayViewController ()<UIAlertViewDelegate>
{
    AVPlayer *_audioPlayer;
    BOOL    buttonToggled;
    BOOL    isFPorIns;
}
@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];    
    
    
    NSError *setCategoryError = nil;
    
    BOOL success = [audioSession setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
    
    if (!success) { [self displayError:setCategoryError]; }
    
    
    
    NSError *activationError = nil;
    
    success = [audioSession setActive:YES error:&activationError];
    
    if (!success) { [self displayError:activationError]; }
    
    [self loadRadio];
}


-(void)displayError:(NSError *)error {
    NSString *reason = [error.localizedDescription isEqualToString:@"The operation could not be completed"]
            ? @"An unknown error occurred"
            : error.localizedDescription;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:reason delegate:self cancelButtonTitle:@"Try again" otherButtonTitles:nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self loadRadio];
}

-(void)loadRadio {
    
    NSURL *url = [NSURL URLWithString:@"http://nl1.streamingpulse.com:2199/tunein/autoradi.pls"];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    NSArray *keys = @[@"playable", @"tracks"/*, @"duration"*/ ];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    self.playAndStopButton.alpha = .3;
    self.playAndStopButton.enabled = false;
    
    [UIView animateWithDuration:1 delay:0.5 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
        self.playAndStopButton.alpha = 1;
    } completion:nil];
    
    [asset loadValuesAsynchronouslyForKeys:keys completionHandler:^()
     {
         // make sure everything downloaded properly
         for (NSString *thisKey in keys) {
             NSError *error = nil;
             AVKeyValueStatus keyStatus = [asset statusOfValueForKey:thisKey error:&error];
             if (keyStatus == AVKeyValueStatusFailed) {
                 dispatch_async(dispatch_get_main_queue(), ^ {
                     [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                     [self displayError:error];
                 });
                 return;
             }
         }
         
         AVPlayerItem *item = [[AVPlayerItem alloc] initWithAsset:asset];
         
         dispatch_async(dispatch_get_main_queue(), ^ {
             _audioPlayer = [AVPlayer playerWithPlayerItem:item];
             _audioPlayer.volume = 0.5;
             [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
             [self.playAndStopButton.layer removeAllAnimations];
             self.playAndStopButton.alpha = 1;
             self.playAndStopButton.enabled = true;
         });
     }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Main Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playSoundTapped:(id)sender
{
    if (!_audioPlayer)
        return;
    
    UIButton *btn = (UIButton *)sender;
    
    if (!buttonToggled) {
        //[sender setTitle:@"Pause" forState:UIControlStateNormal];
        //[sender setImage:@"stop.png" forSearchBarIcon:UI state:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"btn_stop.png"] forState:UIControlStateNormal];
        buttonToggled = YES;
        
        // When button is tapped, play sound
        [_audioPlayer play];
    }
    else {
        [btn setImage:[UIImage imageNamed:@"btn_play.png"] forState:UIControlStateNormal];
        buttonToggled = NO;
        if (_audioPlayer.rate == 0)
        {
            [self loadRadio];
        }
        [_audioPlayer pause];
    }
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (result == MessageComposeResultCancelled)
        NSLog(@"Message cancelled");
    else if (result == MessageComposeResultSent)
        NSLog(@"Message sent");
    else
        NSLog(@"Message failed");
}

-(void)sendSMS:(NSString *)bodyOfMessage recipientLis:(NSArray *)recipients
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if ([MFMessageComposeViewController canSendText]) {
        controller.body = bodyOfMessage;
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

-(IBAction)buttonPressed:(UIButton *)button
{
    [self sendSMS:@"Auto " recipientLis:[NSArray arrayWithObjects:@"3579", nil]];
}

-(IBAction)callPhone:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:+97143759111"]];
}

/*
#pragma mark - Navigation*/

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ViewController *vw = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"gotoFacebook"]) {
        vw.url = @"http://facebook.com/autoradiouae";
        vw.isFPorIns = YES;
    }
    else if ([segue.identifier isEqualToString:@"gotoInstagram"])
    {
        vw.url = @"https://www.instagram.com/autoradiouae/";
        vw.isFPorIns = NO;
    }
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSURL *url = nil;
    if ([identifier isEqualToString:@"gotoFacebook"]) {
        url = [NSURL URLWithString:@"fb://profile/545063842296428"];
    }
    else if ([identifier isEqualToString:@"gotoInstagram"])
    {
        url = [NSURL URLWithString:@"instagram://user?username=autoradio.ae"];
    }
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
        return false;
    }
    return true;
}

-(IBAction)volumnSlider:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    _audioPlayer.volume = slider.value;
}

@end
