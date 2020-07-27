//
//  MainWindow.m
//  MiniScreenReader
//
//  Created by Nicholas Josephson on 2020-02-05.
//  Copyright © 2020 Nicholas Josephson. All rights reserved.
//

#import "MainWindowController.h"
#import "MSRScreenReader.h"

@interface MainWindowController ()

@property MSRScreenReader* screenReader;
@property (weak) IBOutlet NSButton *startStopButton;

@end

@implementation MainWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    self.screenReader = [[MSRScreenReader alloc] init];
}

- (IBAction)start:(NSButton *)sender {
    if (self.screenReader.isRunning) {
        [self.screenReader stop];
        [self.startStopButton setTitle:@"Start"];
    } else {
        [self.screenReader start];
        [self.startStopButton setTitle:@"Stop"];
    }
}

- (IBAction)walk:(NSButton *)sender {
    [self.screenReader walkTree];
}

@end

