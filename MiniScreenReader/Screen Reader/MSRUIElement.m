//
//  MSRUIElement.m
//  MiniScreenReader
//
//  Created by Nicholas Josephson on 2020-04-26.
//  Copyright © 2020 Nicholas Josephson. All rights reserved.
//

#import "MSRUIElement.h"

@implementation MSRUIElement

- (instancetype)initWithReference:(AXUIElementRef)reference {
    if (self = [super init]) {
        _reference = CFRetain(reference);
    }
    return self;
}

- (void)setReference:(AXUIElementRef)reference {
    if (!_reference) {
        _reference = CFRetain(reference);
    } else if (!CFEqual(_reference, reference)) {
        CFRelease(_reference);
        _reference = CFRetain(reference);
    }
}

- (NSString *)getLabel {
    CFTypeRef value;

    AXError error = AXUIElementCopyAttributeValue(self.reference, kAXTitleAttribute, &value);
    if (error) {
        NSLog(@"Error getting title attribute: %d", (int)error);
        return @"";
    }
    
    CFStringRef appTitle = value;
    return CFBridgingRelease(appTitle);
}

- (NSArray<MSRUIElement *> *)getChildren {
    return @[];
}

- (MSRUIElement *)getParent {
    return NULL;
}

- (void)dealloc {
    if (_reference) {
        CFRelease(_reference);
    }
}

@end
