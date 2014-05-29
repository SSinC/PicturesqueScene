//
//  CityChooseViewController.m
//  PicturesqueScene
//
//  Created by Sara on 5/29/14.
//  Copyright (c) 2014 Stan. All rights reserved.
//

#import "CityChooseViewController.h"


@interface PopularCityCollectionCell()
{
    UILabel *  _cityLabel;
}
@end
@implementation PopularCityCollectionCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _cityLabel = [[UILabel alloc]initWithFrame:frame];
        _cityLabel.backgroundColor = [UIColor clearColor];
        _cityLabel.font = [UIFont systemFontOfSize:18.0];
        _cityLabel.textColor = [UIColor whiteColor];
        _cityLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return self;
}

- (void)setCityname:(NSString *)city
{
    _cityname = city;
    _cityLabel.text = _cityname;
}

@end


#define POPOVER_WIDTH 500
#define POPOVER_HEIGHT 800

@interface SuggestionsTableController()
{
    NSArray *                   _stringsArray;
    NSArray *                   _matchedStrings;
    UIPopoverController *       _popOver;
    UITextField *               _activeTextField;
}
@end

@implementation SuggestionsTableController

- (id)initWithArray:(NSArray*)array
{
    self = [super init];
    if (self) {
        
        _stringsArray = array;
        _matchedStrings = [NSArray array];
        
        _popOver = [[UIPopoverController alloc] initWithContentViewController:self];
        _popOver.popoverContentSize = CGSizeMake(POPOVER_WIDTH, POPOVER_HEIGHT);
    }
    return self;
}
#pragma mark Main Suggestions Methods
-(void)matchString:(NSString *)letters {
    _matchedStrings = nil;
    
    if (_stringsArray == nil) {
        @throw [NSException exceptionWithName:@"Please set an array to stringsArray" reason:@"No array specified" userInfo:nil];
    }
    
    _matchedStrings = [_stringsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self beginswith[cd] %@",letters]];
    [self.tableView reloadData];
}
-(void)showPopOverListFor:(UITextField*)textField{
    UIPopoverArrowDirection arrowDirection = UIPopoverArrowDirectionUp;
    if ([_matchedStrings count] == 0) {
        [_popOver dismissPopoverAnimated:YES];
    }
    else if(!_popOver.isPopoverVisible){
        [_popOver presentPopoverFromRect:textField.frame inView:textField.superview permittedArrowDirections:arrowDirection animated:YES];
        
    }
}
-(void)showSuggestionsFor:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSMutableString *rightText;
    
    if (textField.text) {
        rightText = [NSMutableString stringWithString:textField.text];
        [rightText replaceCharactersInRange:range withString:string];
    }
    else {
        rightText = [NSMutableString stringWithString:string];
    }
    
    [self matchString:rightText];
    [self showPopOverListFor:textField];
    _activeTextField = textField;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_matchedStrings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [_matchedStrings objectAtIndex:indexPath.row];
    
    return cell;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_activeTextField setText:[_matchedStrings objectAtIndex:indexPath.row]];
    [_popOver dismissPopoverAnimated:YES];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}



@end




/******************  cityChooseView  ******************/




@interface CityChooseViewController ()
{
    UITextField *   _typeField;
    NSArray *       _popularList;
    UIButton *      _backButton;
}
@end

@implementation CityChooseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
           }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.frame = CGRectMake(0,0,343,343);;
    self.view.layer.cornerRadius = 343/4.f;
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.65];
    
    _cityList = [NSArray arrayWithObjects:@"安徽",@"北京",@"南京",@"杭州",@"合肥",@"常州",@"香港",@"上海",@"西安",@"连云港",@"沈阳",@"吉林",@"辽宁",@"广州",@"厦门",@"山东",@"河北",@"湖南",@"河北", nil];
    _popularList = [NSArray arrayWithObjects:@"北京",@"南京",@"杭州",@"合肥",@"常州",@"香港",@"上海",@"西安",@"连云港",@"沈阳",@"吉林",@"厦门", nil];
    _suggestList = [[SuggestionsTableController alloc]initWithArray:_cityList];
    
    _typeField = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, 200, 50)];
    _typeField.backgroundColor = [UIColor greenColor];
    _typeField.delegate = self;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(76,24); //  76是4个18号字体的汉字的宽度
    _popularCityView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 80 , 343 - 20, 200) collectionViewLayout:flowLayout];
    [_popularCityView registerClass:[PopularCityCollectionCell class] forCellWithReuseIdentifier:@"collectionCell"];
    _popularCityView.dataSource = self;
    _popularCityView.delegate = self;
    _popularCityView.backgroundColor = [UIColor clearColor];
    
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame = CGRectMake(100, _popularCityView.frame.origin.y + _popularCityView.frame.size.height + 10, 100, 50);
    [_backButton setImage:[UIImage imageNamed:@"button2.png"] forState:UIControlStateNormal] ;
    [_backButton setTitle:@"add" forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(_onBack:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_typeField];
    [self.view addSubview:_popularCityView];
    [self.view addSubview:_backButton];
    
}

- (void)_onBack:(id)sender
{
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - collection view datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    
    return [_popularList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    PopularCityCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    //cell.contentView.backgroundColor = [UIColor redColor];
    cell.cityname = [_popularList objectAtIndex:indexPath.item];
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;//cell的最小行间距
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return  5;//cell的最小列间距
}

#pragma mark -- UITextField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    [_suggestList showSuggestionsFor:textField shouldChangeCharactersInRange:range replacementString:string];
    
    return YES;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
