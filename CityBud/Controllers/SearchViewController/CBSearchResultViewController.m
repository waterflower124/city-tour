//
//  CBSearchResultViewController.m
//  CityBud
//
//  Created by Mohit Garg on 02/02/17.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import "CBSearchResultViewController.h"
#import "CBSearchResultTableViewCell.h"
#import "CBHomeDetailsViewController.h"
#import "CBCreateEventViewController.h"
#import "CBSearchViewController.h"
#import "STMethod.h"


@interface CBSearchResultViewController (){

    NSDictionary *dictEventInfo, *dictEditEvent;
    long deleteIndex, editIndex;
    UIRefreshControl *refreshControl;
    BOOL isFeatured;
    
}

@end

@implementation CBSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //labelTitle.text = _isFromAccount ? @"Your Events" : @"Search Result";//search_query
    
    
    if (_SearchUsingDate == true)
    {
        NSString * tempDate = [STMethod dateStringFromString:[NSString stringWithFormat:@"%@",[_dictSearchParameter valueForKey:@"search_query"]] destinationFormat:@"dd/MM/yyyy"];
        
        labelTitle.text =  labelTitle.text = _isFromAccount ? @"Your Events" : tempDate;
    }
    else
    {
        labelTitle.text = _isFromAccount ? @"Your Events" : [_dictSearchParameter valueForKey:@"search_query"];
    }   
    
    if ([_dictSearchParameter[@"search_by"] isEqualToString:@"veneus"]){
        isFeatured = YES;
    }else{
        isFeatured = NO;
    }
    
    tableResultEvent.emptyDataSetSource = self;
    tableResultEvent.emptyDataSetDelegate = self;
    
    if([AFNetworkReachabilityManager sharedManager].reachable){
        SHOW_NETWORK_ERROR_ALERT();
        return;
    }else{
        if(_isFromAccount){
            [self callYourEventWebservice];
            refreshControl = [[UIRefreshControl alloc]init];
            [tableResultEvent addSubview:refreshControl];
            [refreshControl addTarget:self action:@selector(callYourEventWebservice) forControlEvents:UIControlEventValueChanged];
        }else{
            [self callSearchWebservice];
            refreshControl = [[UIRefreshControl alloc]init];
            [tableResultEvent addSubview:refreshControl];
            [refreshControl addTarget:self action:@selector(callSearchWebservice) forControlEvents:UIControlEventValueChanged];
        }
    }    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if(_isFromAccount){
        [self callYourEventWebservice];
    }else{
        [self callSearchWebservice];
    }
}

-(void) viewDidAppear:(BOOL)animated {
    self.menuContainerViewController.panMode = MFSideMenuPanModeNone;//MFSideMenuPanModeDefault
}
- (void)callYourEventWebservice{
    
    //User Event API
    NSString *userID = [USUserInfoModel sharedInstance].user_id;
    NSLog(@"userId issss %@ ",userID);
    
    
    if ([AFNetworkReachabilityManager sharedManager].isReachable){
        SHOW_NETWORK_ERROR_ALERT();
        return;
    }else{
        WebserviceInputParameter *inputParam = [[WebserviceInputParameter alloc] init];
        //inputParam.webserviceRelativePath = @"user_event.php";
        inputParam.webserviceRelativePath = @"getUserevent.php";
        inputParam.serviceMethodType = WEBSERVICE_METHOD_TYPE_POST;
        inputParam.shouldShowLoadingActivity = YES;
        inputParam.dictPostParameters = [@{ @"user_id" : userID } mutableCopy];
        
        [WDWebserviceHelper callWebserviceWithInputParameter:inputParam success:^(id response, NSError *error) {
            
            NSLog(@"Your Event Response==>%@",response);
            
            if ([[response[@"status"] valueForKeyPath:@"code"] isEqual:@"1"]){
                
                self.arrSearchResult = [NSMutableArray new];
                self.arrSearchResult = [[[[response valueForKey:@"body"] reverseObjectEnumerator] allObjects] mutableCopy];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    HIDE_LOADING();

                    [refreshControl endRefreshing];
                    
                    if ([_arrSearchResult count] >0){
                        
                    }else{
                    }
                    
                    [tableResultEvent reloadData];
                    
                });
            }
            
        } error:^(id response, NSError *error) {
            /*[UIAlertController showAlertWithTitle:appNAME message:@"Something went wrong.!!" onViewController:self];*/
            HIDE_LOADING();
            NSLog(@"%@",error.userInfo);
        }];
    }
}

- (void)callSearchWebservice{
    
    [self hideKeyboard];
    
    WebserviceInputParameter *inputParam = [[WebserviceInputParameter alloc] init];
    inputParam.webserviceRelativePath = @"Search.php";
    inputParam.serviceMethodType = WEBSERVICE_METHOD_TYPE_POST;
    inputParam.dictPostParameters = _dictSearchParameter;
    
    [WDWebserviceHelper callWebserviceWithInputParameter:inputParam success:^(id response, NSError *error) {
        
        NSLog(@"Search Response==>%@",response);
        
        if ([[response[@"status"] valueForKeyPath:@"code"] isEqual:@"1"]){
            self.arrSearchResult = [NSMutableArray new];
            self.arrSearchResult = [[response valueForKey:@"body"] mutableCopy];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                HIDE_LOADING();

                [refreshControl endRefreshing];
                if ([_arrSearchResult count] >0){
                    
                }else{
                    
                    HIDE_LOADING();
                }
                
                [tableResultEvent reloadData];
            });
            
        }
        
        
    } error:^(id response, NSError *error) {
        HIDE_LOADING();
        NSLog(@"%@",error.userInfo);
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionBackButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)hideKeyboard{
    [self.view endEditing:YES];
}

#pragma mark - DZNEmptyDataSet DataSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"NoResultFound"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"Sorry..!!!";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}


- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"Sorry no result found for your search.";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1.0];
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 20.0f;
}

#pragma mark - DZNEmptyDataSet Delegate Implementation

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    [refreshControl endRefreshing];
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    NSLog(@"you tap the empty data source");
}


#pragma mark - TableView Delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrSearchResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"CBSearchResultTableViewCell";
    CBSearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[CBSearchResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.buttonEdit.hidden = TRUE;
    cell.buttonDelete.hidden = TRUE;
    [cell.viewCenterContainer setHidden:YES];
    [cell.viewBottomContainer setHidden:YES];
    
    
    
    NSDictionary *dict = _arrSearchResult[indexPath.row];
    if (![_eventType isEqualToString:@"Events"]){
        _isEvent = NO;
        
        if(isFeatured == YES && [dict[@"verificationcode"] isEqualToString:@"1"] ){
            
            [cell.imageFeaturedStar setHidden:NO];
        }else{
            [cell.imageFeaturedStar setHidden:YES];
        }
        
        [cell.viewCenterContainer setHidden:NO];
        [cell.viewBottomContainer setHidden:YES];
        
        cell.labelCenterName.text = dict[@"event_name"];
        cell.labelCenterAddress.text = dict[@"event_address"];
//        if(_isVenue){
//            cell.labelCenterAddress.text = dict[@"event_address"];
//        }else{
//            cell.labelCenterAddress.text = dict[@"event_venue"];
//        }
        
    }else{
        _isEvent = YES;
        [cell.imageFeaturedStar setHidden:YES];
        [cell.viewBottomContainer setHidden:NO];
        [cell.viewCenterContainer setHidden:YES];
        
        
        cell.lblEventName.text = dict[@"event_name"];
        cell.lblEventAddress.text = dict[@"event_venue"];
        cell.lblEventCity.text = dict[@"event_city"];
        
        if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"N %@", dict[@"ticket_price"]]]==false)
        {
            cell.lblEventPrice.text = [NSString stringWithFormat:@"N %@", dict[@"ticket_price"]];
        }
        else
        {
            cell.lblEventPrice.text = @"N";
        }
        
    }
    
    if(_isFromAccount)
    {
        [cell.imageFeaturedStar setHidden:YES];
        [cell.viewCenterContainer setHidden:YES];
        [cell.viewBottomContainer setHidden:NO];
        
        cell.lblEventName.text = dict[@"event_name"];
        cell.lblEventAddress.text = dict[@"event_venue"];
        cell.lblEventCity.text = dict[@"event_city"];
        
        if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"N %@", dict[@"ticket_price"]]])
        {

             cell.lblEventPrice.text = [NSString stringWithFormat:@"N %@", dict[@"ticket_price"]];
        }
        else
        {
            cell.lblEventPrice.text = @"N";
        }
        
        cell.buttonDelete.hidden = FALSE;
        
//        cell.buttonDelete.tag = ((indexPath.row+1)*100)+1;
        
        cell.buttonDelete.tag = indexPath.row;
        [cell.buttonDelete addTarget:self action:@selector(actionDeleteEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.buttonEdit.hidden = FALSE;
        
//        cell.buttonEdit.tag = ((indexPath.row+1)*100)+2;
        
        cell.buttonEdit.tag = indexPath.row;
        [cell.buttonEdit addTarget:self action:@selector(actionEditEvent:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    
    cell.imgEvent.alpha = 0.0f;
    
    NSArray *arrEventPics = [dict[@"event_pic"] componentsSeparatedByString:@","];
    
//    if ([dict[@"event_pic"] isEqualToString:@""])
    if ([arrEventPics[0] isEqualToString:@""]){
        [cell.imgEvent setBackgroundColor:[UIColor colorWithRed:0.09 green:0.31 blue:0.50 alpha:1.0]];
//        [cell.imgEvent setImage:[UIImage imageNamed:@"logo_small"]];
        cell.imgEvent.image = [UIImage imageNamed:@"logo_small"];
        
        
    }else{
        
        NSString *imageName = [NSString stringWithFormat:@"%@",arrEventPics[0]];
        imageName = [imageName stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:imageName]];
        [cell.imgEvent setImageWithURLRequest:req placeholderImage:[UIImage imageNamed:@"logo_small"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            cell.imgEvent.image = image;
            
            [UIView animateWithDuration:0.5 animations:^{
                cell.imgEvent.alpha = 1.0f;
            }];
            
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            cell.imgEvent.image = [UIImage imageNamed:@"logo_small"];
        }];
    }
    
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    dictEventInfo = _arrSearchResult[indexPath.row];
    
    if (!_isFromAccount){
        [self performSegueWithIdentifier:@"CBSearchResultDetail" sender:nil];
    }else{
        tableResultEvent.allowsSelection=NO;
        
    }
    
    
    
}
#pragma mark - Edit-Delete event
//actionDeleteEvent
//actionEditEvent

-(void)actionDeleteEvent:(UIButton*)sender
{
    deleteIndex = [sender tag];
//    long button = [sender tag] %100;
    
    NSDictionary *deleteEvent = _arrSearchResult[deleteIndex];
    
    NSLog(@"event id to be delete issss %@",deleteEvent[@"id"] );
    
    if ([AFNetworkReachabilityManager sharedManager].reachable){
        SHOW_NETWORK_ERROR_ALERT();
        return;
    }else{
        UIAlertController *alertController = [UIAlertController
                                             alertControllerWithTitle:@"Delete Event"
                                             message:@"Are you sure to delete this event ?"
                                             preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"Cancel action");
                                       }];
        
        
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"OK action");
                                       [self callDeleteEvent:deleteEvent[@"id"]];
                                   }];

        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    

}

-(void)actionEditEvent:(UIButton*)sender
{
    // SHOW_LOADING();
   // dispatch_async(dispatch_get_main_queue(), ^{
       
        editIndex = [sender tag];
        dictEditEvent = _arrSearchResult[editIndex];
      //  HIDE_LOADING();
        [self performSegueWithIdentifier:@"CBCreateEventViewController" sender:nil];
   // });
//    long button = [sender tag] %100;
    
    //Your main thread code goes in here
   
   

}


#pragma mark - DeleteEvent API

- (void)callDeleteEvent:(NSString *)eventID{

    WebserviceInputParameter *inputParam = [[WebserviceInputParameter alloc] init];
    inputParam.webserviceRelativePath = @"deleteEvent.php";
    inputParam.shouldShowLoadingActivity = YES;
    inputParam.serviceMethodType = WEBSERVICE_METHOD_TYPE_POST;
    inputParam.dictPostParameters = [@{
                                       @"event_id" : eventID
                                       } mutableCopy];
    
    [WDWebserviceHelper callWebserviceWithInputParameter:inputParam success:^(id response, NSError *error) {
        
        NSLog(@"Delete Event Response==>%@",response);
        
        if([[response[@"status"] valueForKeyPath:@"code"] isEqual:@"1"]){
            HIDE_LOADING();
            [UIAlertController showAlertWithTitle:appNAME message:[response[@"status"] valueForKeyPath:@"message"] onViewController:self];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_arrSearchResult removeObjectAtIndex:deleteIndex];
                [tableResultEvent reloadData];
                
            });
            
        } else if ([[response[@"status"] valueForKeyPath:@"code"] isEqual:@"0"]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIAlertController showAlertWithTitle:appNAME message:[response[@"status"] valueForKeyPath:@"message"] onViewController:self];
            });
        }
        
    } error:^(id response, NSError *error) {
//        [UIAlertController showAlertWithTitle:appNAME message:@"Something went wrong..!!" onViewController:self];
        NSLog(@"%@",error.userInfo);
    }];

}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"CBSearchResultDetail"])
    {
        CBHomeDetailsViewController *dVC = segue.destinationViewController;
        
        dVC.dictEventInfo2 = dictEventInfo;
        
        dVC.cityName = [USUserInfoModel sharedInstance].user_city;
        dVC.isFromSearch = YES;
        dVC.eventType = self.eventType;
        
        if(_isVenue)
        {
            dVC.isVenue = YES;
        }
        if (_isEvent == NO)
        {
            dVC.showUberView = YES;
        }
    }
    else if ([segue.identifier isEqualToString:@"CBCreateEventViewController"])
    {
        CBCreateEventViewController *editEventVC = segue.destinationViewController;
        editEventVC.editEvent = YES;
        editEventVC.editIndex = editIndex;
        editEventVC.dicctEditEvent = dictEditEvent;
    }
    
}

@end
