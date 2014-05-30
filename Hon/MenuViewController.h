//
//  MenuViewController.h
//  Hon
//
//  Created by Zhang Xingjia on 20/02/2014.
//  Copyright (c) 2014 Zhang Xingjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController <UITableViewDataSource, UITabBarDelegate>

- (IBAction)unwindToMenuViewController:(UIStoryboardSegue *)segue;

@end
