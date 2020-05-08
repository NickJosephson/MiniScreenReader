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

- (NSString *)getTitle {
    CFTypeRef value;

    AXError error = AXUIElementCopyAttributeValue(self.reference, kAXTitleAttribute, &value);
    if (error) {
        //NSLog(@"Error getting title attribute: %d", (int)error);
        return @"No Title";
    }
    
    CFStringRef appTitle = value;
    return CFBridgingRelease(appTitle);
}

- (NSArray<MSRUIElement *> *)getChildren {
    CFTypeRef value;

    AXError error = AXUIElementCopyAttributeValue(self.reference, kAXChildrenAttribute, &value);
    if (error) {
        //NSLog(@"Error getting children attribute: %d", (int)error);
        return @[];
    }
    CFArrayRef childrenAX = (CFArrayRef)value;

    NSMutableArray<MSRUIElement *> *children = [[NSMutableArray alloc] init];
    
    CFIndex length = CFArrayGetCount(childrenAX);
    for (CFIndex i = 0; i < length; i++) {
        AXUIElementRef currentAXRef = CFArrayGetValueAtIndex(childrenAX, i);

        MSRUIElement *currentChild = [[MSRUIElement alloc] initWithReference:currentAXRef];
        [children addObject:currentChild];
    }

    CFRelease(childrenAX);
    return children;
}

- (MSRUIElement *)getParent {
    CFTypeRef value;

    AXError error = AXUIElementCopyAttributeValue(self.reference, kAXParentAttribute, &value);
    if (error) {
        NSLog(@"Error getting parent attribute: %d", (int)error);
        return NULL;
    }
    AXUIElementRef parentAX = value;

    MSRUIElement *parent = [[MSRUIElement alloc] initWithReference:parentAX];
    
    CFRelease(parentAX);
    return parent;
}

- (void)dealloc {
    if (_reference) {
        CFRelease(_reference);
    }
}

@end
