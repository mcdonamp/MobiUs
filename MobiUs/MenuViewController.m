/*
 * Copyright (c) 2014 FirstBuild
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

//
//  MenuViewController.m
//  RevealControllerStoryboardExample
//
//  Created by Nick Hodapp on 1/9/13.
//  Copyright (c) 2013 CoDeveloper. All rights reserved.
//

#import "MenuViewController.h"
#import "ChillHubViewController.h"
#import "FSTProduct.h"
#import "FSTChillHub.h"
#import "FBTuser.h"
#import <Firebase/Firebase.h>

@implementation SWUITableViewCell
@end

@implementation MenuViewController


- (void) viewDidLoad
{
    self.products = [[NSMutableArray alloc] init];
    self.productsTableView.delegate = self;
}

- (void) viewDidAppear:(BOOL)animated
{
    [self loadProducts];
}

- (void) loadProducts
{
    Firebase *baseRef = [[Firebase alloc] initWithUrl:FirebaseUrl];
    FBTUser *user = [FBTUser sharedInstance];
    
    [self.products removeAllObjects];
    Firebase *devicesRef = [[baseRef childByAppendingPath:user.rootContainer] childByAppendingPath:@"devices"];
    [devicesRef observeSingleEventOfType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        if ([snapshot.key isEqualToString:@"chillhubs"])
        {
            for (FDataSnapshot* device in snapshot.children) {
                FSTChillHub* chillhub = [FSTChillHub new];
                chillhub.identifier = device.key;
                chillhub.friendlyName = @"My ChillHub";
                [self.products addObject:chillhub];
            }
        }
        [self.tableView reloadData];
        
    }];
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
}


#pragma mark - Table view data source



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.products.count;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSTProduct * product = self.products[indexPath.row];
    NSLog(@"selected %@", product.identifier);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSTProduct * product = self.products[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"reusableIdentifier"];
    cell.textLabel.text = product.friendlyName;
    return cell;
}

#pragma mark state preservation / restoration
- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // TODO save what you need here
    
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // TODO restore what you need here
    
    [super decodeRestorableStateWithCoder:coder];
}

- (void)applicationFinishedRestoringState {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // TODO call whatever function you need to visually restore
}

@end
