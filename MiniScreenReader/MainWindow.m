//
//  MainWindow.m
//  MiniScreenReader
//
//  Created by Nicholas Josephson on 2020-02-05.
//  Copyright © 2020 Nicholas Josephson. All rights reserved.
//

#import "MainWindow.h"
#import "AppDelegate.h"

#import <ApplicationServices/ApplicationServices.h>


void callbackFunc(AXObserverRef observer, AXUIElementRef element, CFStringRef notification, CFDictionaryRef info, void *refcon) {
    MainWindow* controller = (__bridge MainWindow*)refcon;
    
    NSLog(@"Notification received: %@", notification);
    [controller logCurrentWindow];
    [controller stopNotifications];
    [controller startNotifications];
}

@interface MainWindow ()

@end

@implementation MainWindow {
    AXObserverRef _observer;
    AXUIElementRef _currentApp;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    NSDictionary *options = @{(__bridge NSString*)kAXTrustedCheckOptionPrompt : @YES};
    BOOL isProcessTrusted = AXIsProcessTrustedWithOptions((CFDictionaryRef)options);
    NSLog(@"Processed is trusted: %d", isProcessTrusted);
   
    [self listenForKey];
}

- (IBAction)start:(NSButton *)sender {
    [self startNotifications];
    [self logCurrentWindow];
    
//    AXUIElementRef systemWide = AXUIElementCreateSystemWide();
//
//    CFTypeRef value;
//    AXError error;
//
//    error = AXUIElementCopyAttributeValue(systemWide, kAXFocusedApplicationAttribute, &value);
//    NSLog(@"Error: %d", (int)error);
//
//    AXUIElementRef currentApp = value;
//
//    error = AXUIElementCopyAttributeValue(currentApp, kAXMainWindowAttribute, &value);
//    NSLog(@"Error: %d", (int)error);
//
//    AXUIElementRef mainWindow = value;
//
//    error = AXUIElementCopyAttributeValue(mainWindow, kAXChildrenAttribute, &value);
//    NSLog(@"Error: %d", (int)error);
//
//    CFArrayRef children = value;
//
//    for (int i = 0; i < CFArrayGetCount(children); i++) {
//        AXUIElementRef child = CFArrayGetValueAtIndex(children, i);
//
//        error = AXUIElementCopyAttributeValue(child, kAXRoleAttribute, &value);
//        //NSLog(@"Error: %d", (int)error);
//
//        CFShow(value);
//    }
    
//    AXError currError = 0;
//    while(currError == 0) {
//
//    }
}

- (void)startNotifications {
    AXUIElementRef systemWide = AXUIElementCreateSystemWide();
    CFTypeRef value;
    AXError error;

    error = AXUIElementCopyAttributeValue(systemWide, kAXFocusedApplicationAttribute, &value);
    if (error) {
        NSLog(@"Error getting focused application: %d", (int)error);
        return;
    }
    self->_currentApp = value;
    
    pid_t currentAppPID;
    AXUIElementGetPid(self->_currentApp, &currentAppPID);
    if (error) {
        NSLog(@"Error getting PID for UIElement: %d", (int)error);
        return;
    }
    
    AXObserverCallbackWithInfo observerFunc = &callbackFunc;
    error = AXObserverCreateWithInfoCallback(currentAppPID, observerFunc, &self->_observer);
    if (error) {
        NSLog(@"Error creating observer: %d", (int)error);
        return;
    }

    CFRunLoopAddSource(CFRunLoopGetCurrent(), AXObserverGetRunLoopSource(self->_observer), kCFRunLoopDefaultMode);

    error = AXObserverAddNotification(self->_observer, self->_currentApp, kAXApplicationDeactivatedNotification, (__bridge void * _Nullable)(self));
    if (error) {
        NSLog(@"Error adding \"%@\" notification to observer: %d", kAXApplicationDeactivatedNotification, (int)error);
        return;
    }
    
    error = AXObserverAddNotification(self->_observer, self->_currentApp, kAXFocusedWindowChangedNotification, (__bridge void * _Nullable)(self));
    if (error) {
        NSLog(@"Error adding \"%@\" notification to observer: %d", kAXFocusedWindowChangedNotification, (int)error);
        return;
    }
}

- (void)stopNotifications {
    AXError error;
    
    error = AXObserverRemoveNotification(self->_observer, self->_currentApp, kAXApplicationDeactivatedNotification);
    if (error) {
        NSLog(@"Error removing \"%@\" notification from observer: %d", kAXApplicationDeactivatedNotification, (int)error);
        return;
    }
    
    error = AXObserverRemoveNotification(self->_observer, self->_currentApp, kAXFocusedWindowChangedNotification);
    if (error) {
        NSLog(@"Error removing \"%@\" notification from observer: %d", kAXFocusedWindowChangedNotification, (int)error);
        return;
    }
}

- (void)logCurrentWindow {
    AXUIElementRef systemWide = AXUIElementCreateSystemWide();
    CFTypeRef value;
    AXError error;

    error = AXUIElementCopyAttributeValue(systemWide, kAXFocusedApplicationAttribute, &value);
    if (error) {
        NSLog(@"Error getting focused application: %d", (int)error);
        return;
    }
    AXUIElementRef currentApp = value;

    error = AXUIElementCopyAttributeValue(currentApp, kAXTitleAttribute, &value);
    if (error) {
        NSLog(@"Error getting window title: %d", (int)error);
        return;
    }
    CFStringRef appTitle = value;
    
    error = AXUIElementCopyAttributeValue(currentApp, kAXFocusedWindowAttribute, &value);
    if (error) {
        NSLog(@"Error getting focused window: %d", (int)error);
        return;
    }
    AXUIElementRef focusedWindow = value;

    error = AXUIElementCopyAttributeValue(focusedWindow, kAXTitleAttribute, &value);
    if (error) {
        NSLog(@"Error getting window title: %d", (int)error);
        return;
    }
    CFStringRef windowTitle = value;
    
    NSLog(@"App Title: %@, Window Title: %@", appTitle, windowTitle);
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

