//
//  MSRUISystem.m
//  MiniScreenReader
//
//  Created by Nicholas Josephson on 2020-04-26.
//  Copyright © 2020 Nicholas Josephson. All rights reserved.
//

#import "MSRUISystem.h"
#import <ApplicationServices/ApplicationServices.h>

@implementation MSRUISystem

- (instancetype)initSystemWide {
    if (self = [super init]) {
        // Initialize self
        AXUIElementRef systemWide = AXUIElementCreateSystemWide();
        
        self.reference = systemWide;
        
        CFRelease(systemWide);
    }
    return self;
}

- (MSRUIApp * _Nullable)getFocusedApp{
    CFTypeRef value;
    AXError error;
    
    error = AXUIElementCopyAttributeValue(self.reference, kAXFocusedApplicationAttribute, &value);
    if (error) {
        NSLog(@"Error getting focused application: %d", (int)error);
        return NULL;
    }
    AXUIElementRef focusedAXApp = value;

    MSRUIApp *focusedApp = [[MSRUIApp alloc] initWithReference:focusedAXApp];
    
    CFRelease(focusedAXApp);
    return focusedApp;
}

@end
