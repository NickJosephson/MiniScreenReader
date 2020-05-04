//
//  MSRScreenReader.m
//  MiniScreenReader
//
//  Created by Nicholas Josephson on 2020-02-25.
//  Copyright © 2020 Nicholas Josephson. All rights reserved.
//

#import "MSRScreenReader.h"
#import <ApplicationServices/ApplicationServices.h>
#import "MSRUISystem.h"
#import "MSRUIApp.h"
#import "MSRUIWindow.h"

void callbackFunc(AXObserverRef observer, AXUIElementRef element, CFStringRef notification, CFDictionaryRef info, void *refcon) {
    MSRScreenReader* screenReader = (__bridge MSRScreenReader*)refcon;
    
    NSLog(@"Notification received: %@", notification);
    [screenReader speakCurrentWindow];
    [screenReader stopNotifications];
    [screenReader startNotifications];
}

@interface MSRScreenReader ()

@property NSSpeechSynthesizer* synth;

@end


@implementation MSRScreenReader {
    AXObserverRef _observer;
    AXUIElementRef _currentApp;
}

- (void)dealloc {
    [self stop];
    CFRelease(_observer);
    CFRelease(_currentApp);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isRunning = NO;
    }
    return self;
}


- (void)start {
    NSDictionary *options = @{(__bridge NSString*)kAXTrustedCheckOptionPrompt : @YES};
    BOOL isProcessTrusted = AXIsProcessTrustedWithOptions((CFDictionaryRef)options);
    NSLog(@"Processed is trusted: %d", isProcessTrusted);
    
    _isRunning = YES;
    self.synth = [[NSSpeechSynthesizer alloc] init];
    
    [self listenForKey];
    [self startNotifications];
    [self speakCurrentWindow];
}

- (void)stop {
    [self stopNotifications];
    [self.synth stopSpeaking];
    _isRunning = NO;
}

- (void)startNotifications {
    AXUIElementRef systemWide = AXUIElementCreateSystemWide();
    AXError error;

    CFTypeRef value;
    error = AXUIElementCopyAttributeValue(systemWide, kAXFocusedApplicationAttribute, &value);
    if (error) {
        NSLog(@"Error getting focused application: %d", (int)error);
        CFRelease(systemWide);
        return;
    }
    if (_currentApp) {
        CFRelease(_currentApp);
    }
    _currentApp = value;
    
    pid_t currentAppPID;
    AXUIElementGetPid(self->_currentApp, &currentAppPID);
    if (error) {
        NSLog(@"Error getting PID for UIElement: %d", (int)error);
        CFRelease(systemWide);
        return;
    }
    
    AXObserverCallbackWithInfo observerFunc = &callbackFunc;
    AXObserverRef observer;
    error = AXObserverCreateWithInfoCallback(currentAppPID, observerFunc, &observer);
    if (error) {
        NSLog(@"Error creating observer: %d", (int)error);
        CFRelease(systemWide);
        return;
    }
    if (_observer) {
        CFRelease(_observer);
    }
    _observer = observer;

    CFRunLoopAddSource(CFRunLoopGetCurrent(), AXObserverGetRunLoopSource(_observer), kCFRunLoopDefaultMode);

    error = AXObserverAddNotification(_observer, self->_currentApp, kAXApplicationDeactivatedNotification, (void * _Nullable)(self));
    if (error) {
        NSLog(@"Error adding \"%@\" notification to observer: %d", kAXApplicationDeactivatedNotification, (int)error);
        CFRelease(systemWide);
        return;
    }
    
    error = AXObserverAddNotification(_observer, self->_currentApp, kAXFocusedWindowChangedNotification, (void * _Nullable)(self));
    if (error) {
        NSLog(@"Error adding \"%@\" notification to observer: %d", kAXFocusedWindowChangedNotification, (int)error);
        CFRelease(systemWide);
        return;
    }
    
    CFRelease(systemWide);
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

- (void)speakCurrentWindow {
    MSRUISystem *system = [[MSRUISystem alloc] initSystemWide];
    MSRUIApp *focusedApp = [system getFocusedApp];
    MSRUIWindow *focusedWindow = [focusedApp getFocusedWindow];
    
    NSString *appTitle = [focusedApp getLabel];
    NSString *windowTitle = [focusedWindow getLabel];
    
    NSLog(@"App Title: %@, Window Title: %@", appTitle, windowTitle);
    
    NSString* spokenDescription = [[NSString alloc] initWithFormat:@"%@ %@", appTitle, windowTitle];
    
    [self.synth startSpeakingString:spokenDescription];
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
