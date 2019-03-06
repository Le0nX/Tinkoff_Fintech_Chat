//
//  ThemesViewControllerDelegate.h
//  Tinkoff_chat
//
//  Created by Denis Nefedov on 06/03/2019.
//  Copyright © 2019 X. All rights reserved.
//

#import <UIKit/UIKit.h>
///forward declaration для того, чтобы код собрался.
@class ThemesViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol ThemesViewControllerDelegate <NSObject>

- (void)themesViewController: (ThemesViewController *)controller didSelect:(UIColor *)selectedTheme;

@end

NS_ASSUME_NONNULL_END
