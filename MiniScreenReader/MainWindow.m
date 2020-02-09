//
//  MainWindow.m
//  MiniScreenReader
//
//  Created by Nicholas Josephson on 2020-02-05.
//  Copyright © 2020 Nicholas Josephson. All rights reserved.
//

#import "MainWindow.h"

#import <ApplicationServices/ApplicationServices.h>

@interface MainWindow ()

@end

@implementation MainWindow

- (IBAction)start:(NSButton *)sender {

    AXUIElementRef systemWide = AXUIElementCreateSystemWide();

    CFTypeRef value;
    AXError error;

    error = AXUIElementCopyAttributeValue(systemWide, kAXFocusedApplicationAttribute, &value);
    NSLog(@"Error: %d", (int)error);

    AXUIElementRef currentApp = value;

    error = AXUIElementCopyAttributeValue(currentApp, kAXMainWindowAttribute, &value);
    NSLog(@"Error: %d", (int)error);

    AXUIElementRef mainWindow = value;

    error = AXUIElementCopyAttributeValue(mainWindow, kAXChildrenAttribute, &value);
    NSLog(@"Error: %d", (int)error);

    CFArrayRef children = value;
    
    for (int i = 0; i < CFArrayGetCount(children); i++) {
        AXUIElementRef child = CFArrayGetValueAtIndex(children, i);
        
        error = AXUIElementCopyAttributeValue(child, kAXRoleAttribute, &value);
        //NSLog(@"Error: %d", (int)error);

        CFShow(value);
    }
    
//    AXError currError = 0;
//    while(currError == 0) {
//
//    }
}


- (void)windowDidLoad {
    [super windowDidLoad];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    NSDictionary *options = @{(__bridge NSString*)kAXTrustedCheckOptionPrompt : @YES};
    BOOL isProcessTrusted = AXIsProcessTrustedWithOptions((CFDictionaryRef)options);
    NSLog(@"Processed is trusted: %d", isProcessTrusted);
   
    [self listenForKey];
}

- (void)listenForKey {
    [NSEvent addGlobalMonitorForEventsMatchingMask:NSEventMaskKeyDown handler:^(NSEvent *event) {
        const NSUInteger spaceKey = 49;
        const NSUInteger upKey = 126;
        const NSUInteger downKey = 125;
        const NSUInteger leftKey = 123;
        const NSUInteger rightKey = 124;
        const NSEventModifierFlags modifier = NSEventModifierFlagControl | NSEventModifierFlagOption;
        const NSEventModifierFlags modifierWithArrow = modifier | NSEventModifierFlagNumericPad | NSEventModifierFlagFunction;
        
        NSEventModifierFlags modifierFlags = [NSEvent modifierFlags];
        NSUInteger keyCode = [event keyCode];
        
        if (modifierFlags == modifier || modifierFlags == modifierWithArrow) {
            switch (keyCode) {
                case spaceKey:
                    NSLog(@"space");
                    break;
                case upKey:
                    NSLog(@"up");
                    break;
                case downKey:
                    NSLog(@"down");
                    break;
                case leftKey:
                    NSLog(@"left");
                    break;
                case rightKey:
                    NSLog(@"right");
                    break;
                default:
                    break;
            }
        }
    }];
}

@end
