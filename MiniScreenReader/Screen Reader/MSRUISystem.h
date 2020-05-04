//
//  MSRUISystem.h
//  MiniScreenReader
//
//  Created by Nicholas Josephson on 2020-04-26.
//  Copyright © 2020 Nicholas Josephson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSRUIElement.h"
#import "MSRUIApp.h"

NS_ASSUME_NONNULL_BEGIN

@interface MSRUISystem : MSRUIElement

- (instancetype)initSystemWide;
- (MSRUIApp * _Nullable)getFocusedApp;

@end

NS_ASSUME_NONNULL_END
