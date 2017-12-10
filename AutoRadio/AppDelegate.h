//
//  AppDelegate.h
//  AutoRadio
//
//  Created by POLA on 13/02/15.
//  Copyright (c) 2015 POLA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <Pushbots/Pushbots.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    AVAudioPlayer *audioPlayer;
    AVAudioSession *audioSession;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Pushbots *PushbotsClient;

@end

