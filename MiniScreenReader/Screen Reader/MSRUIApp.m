//
//  MSRUIApp.m
//  MiniScreenReader
//
//  Created by Nicholas Josephson on 2020-04-26.
//  Copyright © 2020 Nicholas Josephson. All rights reserved.
//

#import "MSRUIApp.h"

@implementation MSRUIApp

- (MSRUIWindow * _Nullable)getFocusedWindow {
    CFTypeRef value;
    AXError error;

    error = AXUIElementCopyAttributeValue(self.reference, kAXFocusedWindowAttribute, &value);
    if (error) {
        NSLog(@"Error getting focused window: %d", (int)error);
        return NULL;
    }
    AXUIElementRef focusedAXWindow = value;
    
    MSRUIWindow *focusedWindow = [[MSRUIWindow alloc] initWithReference:focusedAXWindow];
    
    CFRelease(focusedAXWindow);
    return focusedWindow;
}

@end
