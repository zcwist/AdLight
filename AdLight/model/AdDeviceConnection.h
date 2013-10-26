//
//  AdDeviesConnection.h
//  AdLight
//
//  Created by kiwi on 10/23/13.
//  Copyright (c) 2013 kiwi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface AdDeviceConnection : NSObject

@property (retain, nonatomic) NSString *gkPeerID;
@property (retain, nonatomic) GKSession *gkSession;

@end
