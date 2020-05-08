//
//  MSRScreenReader.h
//  MiniScreenReader
//
//  Created by Nicholas Josephson on 2020-02-25.
//  Copyright © 2020 Nicholas Josephson. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface MSRScreenReader : NSObject

@property (readonly) BOOL isRunning;

- (void)start;
- (void)stop;
- (void)startNotifications;
- (void)stopNotifications;
- (void)speakCurrentWindow;
- (void)walkTree;

@end

NS_ASSUME_NONNULL_END
