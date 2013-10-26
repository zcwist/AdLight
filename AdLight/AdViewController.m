//
//  AdViewController.m
//  AdLight
//
//  Created by kiwi on 10/22/13.
//  Copyright (c) 2013 kiwi. All rights reserved.
//

#import "AdViewController.h"
#import "AdShowViewController.h"
#import "AdDeviceConnection.h"
#import "AdLightModel.h"

@interface AdViewController ()

@end

@implementation AdViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.devices = [@[] mutableCopy];//初始化设备列表
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"添加设备？" message:@"添加配对设备？"
                                                   delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert setTag:0];
    [alert show];
    
    

}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView tag] == 0){
        switch (buttonIndex) { //alertView about add device
            case 0:
                NSLog(@"Cancel Button Pressed");
                if ([self.devices count]>1) isServer = true;
                else isServer = false;
                break;
            case 1:
                NSLog(@"继续添加设备");
                [self addDevices];
                break;
                
            default:
                break;
        }
    }
    else{ //alertView of ad
        switch (buttonIndex)
        {
            case 0:
                break;
                
            default:{
                [self performSegueWithIdentifier:@"AdPage" sender:self];
                
                break;

                
            }
        }
    }

    
}

- (IBAction)LightOn:(id)sender {
    [self lightRequest];
}


- (void) lightRequest{
    if (!isBusy){ //灯空闲
        if (isServer) { //是Server就直接发送指令
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self turnOnLight];
                NSLog(@"Finish light flow");
            });
        }
        else{ //if client
            [self sendAString:@"turn on"];
            
            
        }  
    }
    
    else{
        //goto ad pages

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"工厂已经在运转啦" message:@"先看看商家优惠活动！"
                                                       delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"OK", nil];
        [alert setTag:1];
        [alert show];
    }
}

- (void) sendAString:(NSString*) str{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    for (AdDeviceConnection *device in self.devices){
        [device.gkSession sendDataToAllPeers:data withDataMode:GKSendDataReliable error:nil];
    }    
}

- (void) turnOnLight{
    AdLightModel *adLight = [[AdLightModel alloc]init];
    
    //tell others light is busy
    [self sendAString:@"busy"];
    
    isBusy = true;
    self.LogInfo.text = @"is busy";
    NSLog(@"I'm busy");
    
    [adLight startLight];
    
    isBusy = false;
    self.LogInfo.text = @"is free";
    [self sendAString:@"free"];
    
    
}


- (IBAction)PickPeer:(id)sender {
    self.devices = [@[] mutableCopy];//初始化设备列表
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"添加设备？" message:@"添加配对设备？"
                                                   delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert setTag:0];
    [alert show];
    
}

- (IBAction)beServer {
    isServer = true;
    self.LogInfo.text = @"I'm server!";
}

- (IBAction)beClient {
    isServer = false;
    self.LogInfo.text = @"I'm client!";
}


- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context
{
    //unpackage NSData to NSString and set incoming text as label's text
    NSString *receivedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    self.LogInfo.text = receivedString;
    
    if (isServer){
        [self lightRequest];
    }else{ //isClient
        if ([receivedString isEqualToString: @"busy"]){
            isBusy = true;
            self.LogInfo.text = @"Server is busy";
            
        } else if ([receivedString isEqualToString: @"free"]){
            isBusy = false;
            self.LogInfo.text = @"Server is free";
            
        }
        
    }
    

}
- (void)addDevices{
    GKPeerPickerController *picker;
    picker = [[GKPeerPickerController alloc] init];
    picker.delegate = self;
    [picker show];
    
}

- (void) peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session{
    AdDeviceConnection *newDevice =[[AdDeviceConnection alloc] init];
    newDevice.gkPeerID = peerID;
    newDevice.gkSession = session;
    [newDevice.gkSession setDataReceiveHandler:self withContext:NULL];
    [picker dismiss];
    picker.delegate = nil;
    
    [self.devices addObject:newDevice];
    NSLog(@"DeviceNum:%d",[self.devices count]);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"添加设备？" message:@"继续添加配对设备？"
                                                   delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert setTag:0];
    [alert show];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)main:(UIStoryboardSegue *)segue
{
    [self dismissViewControllerAnimated:NO completion:NULL];
}


@end
