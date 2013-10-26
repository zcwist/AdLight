//
//  AdViewController.h
//  AdLight
//
//  Created by kiwi on 10/22/13.
//  Copyright (c) 2013 kiwi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
@class AdDeviceConnection ;

@interface AdViewController : UIViewController<GKPeerPickerControllerDelegate,GKSessionDelegate>{
    Boolean isServer;
    Boolean isBusy;
}

@property (retain, nonatomic) NSMutableArray *devices;
@property (weak, nonatomic) IBOutlet UILabel *LogInfo;
- (IBAction)LightOn:(id)sender;
- (IBAction)PickPeer:(id)sender;
- (IBAction)beServer;
- (IBAction)beClient;
- (IBAction)main:(UIStoryboardSegue *)segue;

- (void) addDevices;

@end
