//
//  PlayViewController.m
//  AutoRadio
//
//  Created by POLA on 14/02/15.
//  Copyright (c) 2015 POLA. All rights reserved.
//

#import "PlayViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface PlayViewController ()
{
    AVAudioPlayer *_audioPlayer;
}
@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Construct URL to sound file
    NSString *path = [NSString stringWithFormat:@"AUTORADIOAAC.pls", [[NSBundle mainBundle] resourcePath]];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    
    // Create audio player object and initialize with URL to sound
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playSoundTapped:(id)sender
{
    // When button is tapped, play sound
    [_audioPlayer play];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
