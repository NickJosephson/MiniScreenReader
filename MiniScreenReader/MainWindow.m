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

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    NSDictionary *options = @{
        (__bridge NSString*)kAXTrustedCheckOptionPrompt : @YES,
    };
    BOOL isProcessTrusted = AXIsProcessTrustedWithOptions((CFDictionaryRef)options);
    
    NSLog(@"Processed is trusted: %d", isProcessTrusted);
    
    
    AXUIElementRef systemWide = AXUIElementCreateSystemWide();
    
    
    CFShow(systemWide);
    

//    CFStringRef keys[3];
//    CFTypeRef values[3];
//    CFDictionaryRef options;
//    keys[0] = kAXTrustedCheckOptionPrompt;
//    values[0] = kCFBooleanTrue;
//
//    options = CFDictionaryCreate(NULL, (void **)keys, (void **)values, 1, &kCFCopyStringDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
//
//    CFShow(options);
//
//    BOOL isProcessTrusted = AXIsProcessTrustedWithOptions(options);
//      NSLog(@"Processed is trusted: %d", isProcessTrusted);
//
//    CFRelease(options);
}

@end
