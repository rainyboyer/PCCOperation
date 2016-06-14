//
//  PPCViewController.m
//  PPCOperation
//
//  Created by pen on 05/30/2016.
//  Copyright (c) 2016 pen. All rights reserved.
//

#import "PPCViewController.h"

#define CellIdentifier @"CellIdentifier"
@interface PPCViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *titles;
@end

@implementation PPCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
    self.titles = @[@[@"读取网页", @"PPCLoadWebVC"]];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate && DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell.textLabel setText:[[_titles objectAtIndex:indexPath.row] objectAtIndex:0]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *className = [[_titles objectAtIndex:indexPath.row] objectAtIndex:1];
    Class VC = NSClassFromString(className);
    [self.navigationController pushViewController:[[VC alloc]init] animated:YES];
}
@end
