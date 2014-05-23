//
//  UITestViewController.m
//  PicturesqueScene
//
//  Created by Stan on 14-5-22.
//  Copyright (c) 2014年 Stan. All rights reserved.
//

#import "UITestViewController.h"

@interface UITestViewController ()

@end

@implementation UITestViewController
{
    CATransform3D _initialTransformationFromLeft;
    CATransform3D _initialTransformationFromRight;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITableView *scrollView = [[UITableView alloc] initWithFrame:self.view.frame];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.delegate = self;
    scrollView.dataSource = self;

    [self.view addSubview:scrollView];
    
    CGPoint offsetPositioning = CGPointMake(-100, 0);
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, offsetPositioning.x, offsetPositioning.y, 0.0);
    _initialTransformationFromLeft = transform;
    
    offsetPositioning = CGPointMake(100, 0);
    CATransform3D transform1 = CATransform3DIdentity;
    transform1 = CATransform3DTranslate(transform1, offsetPositioning.x, offsetPositioning.y, 0.0);
    _initialTransformationFromRight = transform1;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"tableView numberOfRowsInSection");
    return 5;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"tableView cellForRowAtIndexPath");
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if( nil == cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor greenColor];
    }

    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (![self.shownIndexes containsObject:indexPath]) {
    //    [self.shownIndexes addObject:indexPath];
    NSInteger i = indexPath.row;
    UIView *card = cell.contentView;
    
    if( floor(i/2) == floor((i - 1)/2) ){
        card.layer.transform = _initialTransformationFromLeft;
    }else{
        card.layer.transform = _initialTransformationFromRight;
    }
    card.layer.opacity = 0.8;
    
    [UIView animateWithDuration:0.6 animations:^{
        card.layer.transform = CATransform3DIdentity;
        card.layer.opacity = 1;
    }];
    //    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
