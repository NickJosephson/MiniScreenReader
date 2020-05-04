//
//  MSRUIApp.h
//  MiniScreenReader
//
//  Created by Nicholas Josephson on 2020-04-26.
//  Copyright © 2020 Nicholas Josephson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSRUIElement.h"
#import "MSRUIWindow.h"

NS_ASSUME_NONNULL_BEGIN

@interface MSRUIApp : MSRUIElement

- (MSRUIWindow * _Nullable)getFocusedWindow;

@end

NS_ASSUME_NONNULL_END
