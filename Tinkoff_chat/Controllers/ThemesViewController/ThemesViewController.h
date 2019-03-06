//
//  ThemesViewController.h
//  Tinkoff_chat
//
//  Created by Denis Nefedov on 06/03/2019.
//  Copyright © 2019 X. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

///forward declaration для того, чтобы код собрался.
@protocol ThemesViewControllerDelegate;
@class Themes;

@interface ThemesViewController : UIViewController {

    id<ThemesViewControllerDelegate> _delegate;
    Themes* _model;

}
@end

NS_ASSUME_NONNULL_END
