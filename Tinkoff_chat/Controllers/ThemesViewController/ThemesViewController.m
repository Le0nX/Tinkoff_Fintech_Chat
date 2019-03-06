//
//  ThemesViewController.m
//  Tinkoff_chat
//
//  Created by Denis Nefedov on 06/03/2019.
//  Copyright © 2019 X. All rights reserved.
//

#import "ThemesViewController.h"
#import "Themes.h"
#import "ThemesViewControllerDelegate.h"


@implementation ThemesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _model = [[Themes alloc] initColor1:UIColor.redColor
                                 color2:UIColor.blueColor
                                 color3:UIColor.greenColor];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view setBackgroundColor:[[self.navigationController navigationBar] barTintColor]];
}

- (void) setDelegate:(id<ThemesViewControllerDelegate>)delegate{
    _delegate = delegate;
}

- (id<ThemesViewControllerDelegate>) delegate {
    return _delegate;
}

- (void)choosedThemeButton:(UIButton *)sender {
    if (sender == [self.themeButtons objectAtIndex:0]) {
        [_delegate themesViewController:self didSelect:[_model theme1]];
        [[self.navigationController navigationBar] setBarTintColor:[_model theme1]];
    } else if (sender == [self.themeButtons objectAtIndex:1]) {
        [_delegate themesViewController:self didSelect:[_model theme2]];
        [[self.navigationController navigationBar] setBarTintColor:[_model theme2]];
    } else {
        [_delegate themesViewController:self didSelect:[_model theme3]];
        [[self.navigationController navigationBar] setBarTintColor:[_model theme3]];
    }
}

- (void)dealloc {
    [_themeButtons release];
    [_model release];
    [super dealloc];
}



@end
