//
//  ViewController.m
//  ListView
//
//  Created by Rexen Dy on 9/23/14.
//  Copyright (c) 2014 Rexen Dy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

#define NAV_HEIGHT 44.0f
static NSString * const baseURL = @"http://guarded-basin-2383.herokuapp.com/facts.json";
@implementation ViewController

/* loadView method initializes the view and other controls to be used, since i did not use story board or xib, when the app will run, it will go to this method first */
- (void)loadView
{
    
    fullScreen = [[UIScreen mainScreen] applicationFrame];
    
    self.view = [[UIView alloc] initWithFrame:fullScreen];
    [self.view setBackgroundColor:[UIColor yellowColor]];
    
    [self.navigationItem setTitle:@"Fact"];
    
    //CGRect frame = CGRectMake(0, 0, fullScreen.size.width, fullScreen.size.height);
    tblList = [[UITableView alloc] initWithFrame:fullScreen];
    [tblList setDelegate:self];
    [tblList setDataSource:self];
    [self.view addSubview:tblList];
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    UIInterfaceOrientation currentOrientation = self.interfaceOrientation;
    
    if (currentOrientation == UIInterfaceOrientationLandscapeLeft || currentOrientation == UIInterfaceOrientationLandscapeRight) {
        
        [tblList setFrame:CGRectMake(fullScreen.origin.x, fullScreen.origin.y, fullScreen.size.height + NAV_HEIGHT, fullScreen.size.width)];
    }
    else
    {
        [tblList setFrame:CGRectMake(fullScreen.origin.x, fullScreen.origin.y, fullScreen.size.width, fullScreen.size.height)];
    }
}

#pragma mark - TABLEVIEW

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[data objectForKey:@"rows"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //cell identifier (i include the path row to be unique)
    NSString *CELLIDENTIFIER = [NSString stringWithFormat:@"cellidentifier%d",(int)indexPath.row];
    
    // i use dequeueReusableCell so that it will not load all data but only those data who fits in the screen
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIER];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CELLIDENTIFIER];
    }
    
    // store the data in a specific row
    NSDictionary *getDataEachRow = [[data objectForKey:@"rows"] objectAtIndex:indexPath.row];
    
    
    if ((NSNull *)[getDataEachRow objectForKey:@"imageHref"] != [NSNull null]) {
        
        // use the setImageWithURL from AFNetWorking library for lazy loading of image
        [cell.imageView setImageWithURL:[NSURL URLWithString:[getDataEachRow objectForKey:@"imageHref"]] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    }    
    else
    {
        [cell.imageView setImage:[UIImage imageNamed:@"placeholder.jpg"]];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[getDataEachRow objectForKey:@"title"]];
    
    if ((NSNull *)[getDataEachRow objectForKey:@"description"] != [NSNull null]) {
        
        cell.detailTextLabel.text = [getDataEachRow objectForKey:@"description"];
    }

    
    return cell;
}

#pragma mark - API

- (void)getDataFromAPI
{
    NSURL *url = [NSURL URLWithString:baseURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        data = (NSDictionary *)responseObject;
        
        [tblList reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Data"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    [operation start];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getDataFromAPI];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
