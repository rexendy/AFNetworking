//
//  AppDelegate.h
//  ListView
//
//  Created by Neil Dy on 9/23/14.
//  Copyright (c) 2014 Rexen Dy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UINavigationController *navController;
    ViewController *mainView;
}
@property (strong, nonatomic) UIWindow *window;

@end
