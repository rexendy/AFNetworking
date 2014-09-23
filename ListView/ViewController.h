//
//  ViewController.h
//  ListView
//
//  Created by Rexen Dy on 9/23/14.
//  Copyright (c) 2014 Rexen Dy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AFNetworking/UIImageView+AFNetworking.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    //table view
    UITableView *tblList;
    
    // store json data
    NSDictionary *data;
    
    CGRect fullScreen ;
}

- (void)getDataFromAPI;
@end
