/*
 Copyright (c) 2013, Hiromasa Suzuki.
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE. 
 */


#import "TMTestTableViewController.h"
#import "UITabBarController+hidable.h"

#import "TMPostDetailViewController.h"

@interface TMTestTableViewController ()

@end

@implementation TMTestTableViewController
{
    CGFloat startContentOffset;
    CGFloat lastContentOffset;
    BOOL hidden;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        //NavigationBarのタイトル指定
        self.title = NSLocalizedString(@"SOCIAL APP!", @"");
        hidden = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:hidden animated:YES];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tabBarController setTabBarHidden:hidden animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

//セクション数の指定
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

//セクション内のセルの数の指定
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"Awesome Post Number: %d", indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
    
    TMPostDetailViewController * pdvc = [[TMPostDetailViewController alloc] init];
    
    [self.navigationController pushViewController:pdvc animated:YES];
}

#pragma mark - The Magic!

//NavigationBarとTabBarを非表示にするためのメソッド
-(void)expand
{
    if(hidden)
        return;
    hidden = YES;
    
    //TabBarをアニメーション化して隠す
    [self.tabBarController setTabBarHidden:YES 
                                  animated:YES];
    
    //NavigationBarをアニメーション化して隠す
    [self.navigationController setNavigationBarHidden:YES 
                                             animated:YES];
}

//NavigationBarとTabBarの再表示のためのメソッド
-(void)contract
{
    if(!hidden)
        return;
    hidden = NO;
    
    //TabBarをアニメーション化して表示する
    [self.tabBarController setTabBarHidden:NO 
                                  animated:YES];
    
    //NavigationBarをアニメーション化して表示する
    [self.navigationController setNavigationBarHidden:NO 
                                             animated:YES];
}
 

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

//スクロール検知の開始
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    startContentOffset = lastContentOffset = scrollView.contentOffset.y;
    //NSLog(@"scrollViewWillBeginDragging: %f", scrollView.contentOffset.y);
}

//スクロール検知
- (void)scrollViewDidScroll:(UIScrollView *)scrollView 
{
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat differenceFromStart = startContentOffset - currentOffset;
    CGFloat differenceFromLast = lastContentOffset - currentOffset;
    lastContentOffset = currentOffset;
    
    
    //もし上スクロールなら
    if((differenceFromStart) < 0)
    {
        // scroll up
        if(scrollView.isTracking && (abs(differenceFromLast)>1))
            //NavigationBarとTabBarを隠すメソッドを呼び出す
            [self expand];
    }
    //もし下スクロールなら
    else {
        if(scrollView.isTracking && (abs(differenceFromLast)>1))
            //NavigationBarとTabBarを表示するメソッドを呼び出す
            [self contract];
    }
    
}

//スクロール終了
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
}


//最上部ならば
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    //NavigationBarとTabBarを表示するメソッドを呼び出す
    [self contract];
    return YES;
}


@end
