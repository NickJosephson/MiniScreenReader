//
//  MSRUIElement.h
//  MiniScreenReader
//
//  Created by Nicholas Josephson on 2020-04-26.
//  Copyright © 2020 Nicholas Josephson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ApplicationServices/ApplicationServices.h>

NS_ASSUME_NONNULL_BEGIN

@interface MSRUIElement : NSObject

@property (nonatomic) AXUIElementRef reference;

- (instancetype)initWithReference:(AXUIElementRef)reference;
- (NSString *)getTitle;
- (NSArray<MSRUIElement *> *)getChildren;
- (MSRUIElement * _Nullable)getParent;

@end

NS_ASSUME_NONNULL_END
