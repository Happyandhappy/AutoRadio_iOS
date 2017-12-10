//
//  PlayViewController.h
//  AutoRadio
//
//  Created by POLA on 14/02/15.
//  Copyright (c) 2015 POLA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface PlayViewController : UIViewController <MFMessageComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *playAndStopButton;

@end
