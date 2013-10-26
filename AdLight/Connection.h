//
//  Connection.h
//  AdLight
//
//  Created by kiwi on 10/23/13.
//  Copyright (c) 2013 kiwi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Connection;

@protocol ConnectionDelegate
- (void) connctionClosed:(Connection *)connection;

@end

@interface Connection : NSObject {
    NSInputStream *inputStream;
    NSMutableArray *incomingDataBuffer;
    int nextMessageSize;
    BOOL outputSteamWasOpened;
    NSOutputStream *outputStream;
    NSMutableArray *outgoingDataBuffer;
    id<ConnectionDelegate> delegate;
    id userInfo;
}
@property (nonatomic, retain) NSInputStream *inputStream;
@property (nonatomic, retain) NSOutputStream *outputStream;
@property (nonatomic, retain) id<ConnectionDelegate> delegate;
@property (nonatomic, retain) id userInfo;

- (id)initWithNativeSocketHandle:(CFSocketNativeHandle) nativeSocketHandle;
- (id)initWithInputStream:(NSInputStream*) istr outputStream:(NSOutputStream*) ostr;

-(BOOL) connect;
-(void) close;

@end
