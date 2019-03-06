//
//  Themes.m
//  Tinkoff_chat
//
//  Created by Denis Nefedov on 06/03/2019.
//  Copyright © 2019 X. All rights reserved.
//

#import "Themes.h"

@implementation Themes

- (instancetype)initColor1:(UIColor *)color1 color2:(UIColor *)color2 color3:(UIColor *)color3 {
    if (self = [super init]) {
        _theme1 = color1;
        _theme2 = color2;
        _theme3 = color3;
    }
    return self;
}

- (UIColor*) theme1 {
    return _theme1;
}

- (UIColor*) theme2 {
    return _theme2;
}

-(UIColor*) theme3 {
    return _theme3;
}

/// "private" destructor
- (void)dealloc {
    [_theme1 release];
    [_theme2 release];
    [_theme3 release];
    [super dealloc];
}
@end
