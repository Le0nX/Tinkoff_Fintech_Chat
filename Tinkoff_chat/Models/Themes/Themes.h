//
//  Themes.h
//  Tinkoff_chat
//
//  Created by Denis Nefedov on 06/03/2019.
//  Copyright © 2019 X. All rights reserved.
//

#import <UIKit/UIKit.h>

//#ifndef THEMES_H
//#define THEMES_H

@interface Themes : NSObject {
    UIColor* _theme1;
    UIColor* _theme2;
    UIColor* _theme3;
}

@property (readonly, nonatomic) UIColor* theme1;
@property (readonly, nonatomic) UIColor* theme2;
@property (readonly, nonatomic) UIColor* theme3;

- (instancetype)initColor1:(UIColor *)color1 color2:(UIColor *)color2 color3:(UIColor *)color3;

@end

//#endif /* THEMES_H */
