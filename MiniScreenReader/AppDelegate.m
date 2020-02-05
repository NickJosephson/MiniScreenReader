//
//  AppDelegate.m
//  MiniScreenReader
//
//  Created by Nicholas Josephson on 2020-02-05.
//  Copyright © 2020 Nicholas Josephson. All rights reserved.
//

#import "AppDelegate.h"
#import "MainWindow.h"

@interface AppDelegate ()

@property MainWindow* mainWindowController;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    MainWindow* newWindowController = [[MainWindow alloc] initWithWindowNibName:@"MainWindow"];
    [self setMainWindowController:newWindowController];
    [self.mainWindowController showWindow:self];
    
    
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
