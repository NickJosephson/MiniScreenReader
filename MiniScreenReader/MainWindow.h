//
//  MainWindow.h
//  MiniScreenReader
//
//  Created by Nicholas Josephson on 2020-02-05.
//  Copyright © 2020 Nicholas Josephson. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainWindow : NSWindowController

- (void)startNotifications;
- (void)stopNotifications;
- (void)logCurrentWindow;

@end

NS_ASSUME_NONNULL_END
