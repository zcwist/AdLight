//
//  Connection.m
//  AdLight
//
//  Created by kiwi on 10/23/13.
//  Copyright (c) 2013 kiwi. All rights reserved.
//

#import "Connection.h"
#import <CFNetwork/CFSocketStream.h>

@implementation Connection

@synthesize delegate, userInfo;
@synthesize inputStream, outputStream;

-(id)initWithNativeSocketHandle:(CFSocketNativeHandle)nativeSocketHandle{
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocket(kCFAllocatorDefault, nativeSocketHandle, &readStream, &writeStream);
    
    self.inputStream = (__bridge NSInputStream*) readStream;
    self.outputStream = (__bridge NSOutputStream*) writeStream;
    return self;
}

-(id)initWithInputStream:(NSInputStream *)istr outputStream:(NSOutputStream *)ost{
    
}

@end
