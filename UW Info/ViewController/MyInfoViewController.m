//
//  MyInfoViewController.m
//  UW Info
//
//  Created by Zhang Honghao on 2/10/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import "MyInfoViewController.h"
#import "InfoSessionCell.h"
#import "InfoSessionModel.h"
#import "LoadingCell.h"
#import "DetailViewController.h"
#import "UWTabBarController.h"
#import "InfoSessionsViewController.h"
#import "SearchViewController.h"
#import "MoreViewController.h"
#import "MoreNavigationViewController.h"
#import "UWGoogleAnalytics.h"
#import "UIImage+ApplyAlpha.h"

//#import "GADBannerView.h"
#import "GADBannerViewDelegate.h"
//#import "GADAdMobExtras.h"

@interface MyInfoViewController () <GADBannerViewDelegate>

@end

@implementation MyInfoViewController {
    UIRefreshControl *refreshControl;
    UIBarButtonItem *editButton;
    
    GADBannerView *_googleBannerView;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _tabBarController.lastTapped = -1;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.navigationController.navigationBar performSelector:@selector(setBarTintColor:) withObject:UWGold];
    self.navigationController.navigationBar.tintColor = UWBlack;
    
    UIImage *settingImage = [UIImage imageNamed:@"settings"];
    UIImageView *buttonImageView = [[UIImageView alloc] initWithImage:settingImage];
    UIButton *settingButton = [[UIButton alloc] initWithFrame:buttonImageView.frame];
    [settingButton setImage:settingImage forState:UIControlStateNormal];
    [settingButton setImage:[settingImage imageByApplyingAlpha:0.4] forState:UIControlStateHighlighted];
    
//    [settingButton addSubview:imageView];
    [settingButton addTarget:self action:@selector(showMoreViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *moreButton = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    
//    UIBarButtonItem *moreButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings"] style:UIBarButtonItemStyleBordered target:self action:@selector(showMoreViewController)];
    
    [self.navigationItem setRightBarButtonItem:moreButton];
    [self setRedDotToSettingButton:NO];
    
//    UIBarButtonItem *configButton = [[UIBarButtonItem alloc] initWithTitle:@"\u2699" style:UIBarButtonItemStyleBordered target:self action:@selector(configuration)];
//    UIFont *smallerFont = [UIFont systemFontOfSize:[UIFont systemFontSize] - 6.0];
//    UIFont *regularFont = [UIFont systemFontOfSize:[UIFont systemFontSize] + 10.0];
//    
//    // create the attributes
//    NSDictionary *attrsForSmaller = [NSDictionary dictionaryWithObjectsAndKeys:smallerFont, NSFontAttributeName, nil];
//    NSDictionary *attrsForRegular = [NSDictionary dictionaryWithObjectsAndKeys:regularFont, NSFontAttributeName, nil];
//    UIFont *customFont = [UIFont fontWithName:@"Helvetica" size:24.0];
//    NSDictionary *fontDictionary = @{UITextAttributeFont : customFont};
//    [configButton setTitleTextAttributes:fontDictionary forState:UIControlStateNormal];
//    [self.navigationItem setLeftBarButtonItem:configButton];
    
    
    // initiate the left buttons
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(enterEditMode:)] animated:YES];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(reloadTable) forControlEvents:UIControlEventValueChanged];
    [self reloadTable];
    
    // receive every minute from notification center
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshEveryMinute) name:@"OneMinute" object:nil];
    
    // Google Analytics
    [UWGoogleAnalytics analyticScreen:@"My Info Session Screen"];
//    
//    // Google Ad
//    _googleBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
//    _googleBannerView.adUnitID = @"ca-app-pub-5080537428726834/3638663901";
//    _googleBannerView.rootViewController = self;
//    _googleBannerView.alpha = 0;
//    
//    CGRect contentFrame = self.view.bounds;
//    CGRect bannerFrame = _googleBannerView.frame;
//    bannerFrame.origin.y = contentFrame.size.height - self.navigationController.navigationBar.frame.size.height - bannerFrame.size.height;
//    
//    [_googleBannerView setFrame:bannerFrame];
//    
//    //[self.view addSubview:_googleBannerView];
//    [_googleBannerView setDelegate:self];
//    
//    GADRequest *request = [GADRequest request];
//    [request setLocationWithDescription:@"N2L3G1 CA"];
//    //    GADAdMobExtras *extras = [[GADAdMobExtras alloc] init];
//    //    extras.additionalParameters =
//    //    [NSMutableDictionary dictionaryWithObjectsAndKeys:
//    //     @"DDDDDD", @"color_bg",
//    //     @"999999", @"color_bg_top",
//    //     @"BBBBBB", @"color_border",
//    //     @"FF9735", @"color_link",
//    //     @"999999", @"color_text",
//    //     @"FF9735", @"color_url",
//    //     nil];
//    
//    //    [request registerAdNetworkExtras:extras];
//    [_googleBannerView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 

- (void)setRedDotToSettingButton:(BOOL)isSet {
    [self.navigationItem.rightBarButtonItem.customView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (isSet) {
        NSLog(@"isSet");
        UIView *redDot = [[UIView alloc] initWithFrame:CGRectMake(17, -3, 12, 12)];
        [redDot setBackgroundColor:[UIColor colorWithRed:1 green:0.23 blue:0.19 alpha:1]];
        redDot.layer.cornerRadius = redDot.frame.size.width / 2;
        [self.navigationItem.rightBarButtonItem.customView addSubview:redDot];
    }
}

- (void)reloadTable {
    [self.tableView reloadData];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    // end refreshControl
    [self.refreshControl endRefreshing];
}

- (void)refreshEveryMinute {
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_infoSessionModel == nil || [_infoSessionModel.myInfoSessions count] == 0) {
        return 1;
    } else {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (_infoSessionModel == nil || [_infoSessionModel.myInfoSessions count] == 0 ){
            return 1;
        } else {
            return [_infoSessionModel.myInfoSessions count];
        };
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (_infoSessionModel == nil || [_infoSessionModel.myInfoSessions count] == 0) {
            LoadingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoadingCell"];
            cell.loadingIndicator.hidden = YES;
            cell.loadingLabel.text = @"No Info Sessions Saved";
            [cell.loadingLabel setTextAlignment:NSTextAlignmentCenter];
            [cell.loadingLabel setTextColor:[UIColor lightGrayColor]];
            return cell;

        } else {
            InfoSessionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoSessionCell"];
            [self configureCell:cell withIndexPath:indexPath];
            return cell;
        }
    } else {
        LoadingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoadingCell"];
        cell.loadingIndicator.hidden = YES;
        cell.loadingLabel.text = [NSString stringWithFormat:@"%lu Info Sessions", (unsigned long)[_infoSessionModel.myInfoSessions count]];
        [cell.loadingLabel setTextAlignment:NSTextAlignmentCenter];
        [cell.loadingLabel setTextColor:[UIColor lightGrayColor]];
        return cell;
    }
}

/**
 *  Configure InfoSessionCell
 *
 *  @param cell      InfoSessionCell
 *  @param indexPath IndexPath for the cell
 */
- (void)configureCell:(InfoSessionCell *)cell withIndexPath:(NSIndexPath *)indexPath {
    InfoSession *infoSession = [_infoSessionModel.myInfoSessions objectAtIndex:indexPath.row];
    
    // if current time is befor start time, set dark (future sessions)
    if ([[NSDate date] compare:infoSession.startTime] == NSOrderedAscending) {
        [cell.employer setTextColor:[UIColor blackColor]];
        [cell.locationLabel setTextColor:[UIColor darkGrayColor]];
        [cell.location setTextColor:[UIColor darkGrayColor]];
        [cell.dateLabel setTextColor:[UIColor darkGrayColor]];
        [cell.date setTextColor:[UIColor darkGrayColor]];
    }
    // if current time is between start time and end time, set blue (ongoing sessions)
    else if ( ([infoSession.startTime compare:[NSDate date]] == NSOrderedAscending) && ([[NSDate date] compare:infoSession.endTime] == NSOrderedAscending) ){
        UIColor *fontColor = UWGold;
        //[UIColor colorWithRed:0.08 green:0.46 blue:1 alpha:1]
        [cell.employer setTextColor:fontColor];
        cell.employer.shadowColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
        cell.employer.shadowOffset  = CGSizeMake(0.0, 1.0);
        [cell.locationLabel setTextColor:fontColor];
        [cell.location setTextColor:fontColor];
        [cell.dateLabel setTextColor:fontColor];
        [cell.date setTextColor:fontColor];
    }
    // set light grey (past sessions)
    else {
        [cell.employer setTextColor: [UIColor lightGrayColor]];
        [cell.locationLabel setTextColor:[UIColor lightGrayColor]];
        [cell.location setTextColor:[UIColor lightGrayColor]];
        [cell.dateLabel setTextColor:[UIColor lightGrayColor]];
        [cell.date setTextColor:[UIColor lightGrayColor]];
        
    }
//    
//    cell.employer.text = infoSession.employer;
//    cell.location.text = infoSession.location;
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"MMM d, y"];
//    [timeFormatter setDateFormat:@"h:mm a"];
//    
//    cell.date.text = [NSString stringWithFormat:@"%@ - %@, %@", [timeFormatter stringFromDate:infoSession.startTime], [timeFormatter stringFromDate:infoSession.endTime], [dateFormatter stringFromDate:infoSession.date]];
    NSMutableAttributedString *employerString = [[NSMutableAttributedString alloc] initWithString:infoSession.employer];
    NSMutableAttributedString *locationString = [[NSMutableAttributedString alloc] initWithString:infoSession.location];
    
    //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *dateFormatter = [InfoSession estDateFormatter];
    NSDateFormatter *timeFormatter = [InfoSession estDateFormatter];
    // set the locale to fix the formate to read and write;
    //NSLocale *enUSPOSIXLocale= [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    //[dateFormatter setLocale:enUSPOSIXLocale];
    //[timeFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setDateFormat:@"MMM d, ccc"];
    [timeFormatter setDateFormat:@"h:mm a"];
    // set timezone to EST
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"EST"]];
    // set timezone to EST
    //[timeFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"EST"]];
    
    NSString *dateNSString = [NSString stringWithFormat:@"%@, %@ - %@", [dateFormatter stringFromDate:infoSession.date], [timeFormatter stringFromDate:infoSession.startTime], [timeFormatter stringFromDate:infoSession.endTime]];
    NSMutableAttributedString *dateString = [[NSMutableAttributedString alloc] initWithString:dateNSString];
    if (infoSession.isCancelled) {
        [employerString addAttribute:NSStrikethroughStyleAttributeName value:@2 range:NSMakeRange(0, [employerString length])];
        [locationString addAttribute:NSStrikethroughStyleAttributeName value:@2 range:NSMakeRange(0, [locationString length])];
        [dateString addAttribute:NSStrikethroughStyleAttributeName value:@2 range:NSMakeRange(0, [dateString length])];
    }
    [cell.employer setAttributedText:employerString];
    [cell.location setAttributedText:locationString];
    [cell.date setAttributedText:dateString];
}

/**
 *  set different cell height for different cell
 *
 *  @param tableView tableView
 *  @param indexPath indexPath
 *
 *  @return for LoadingCell, return 44.0f, for InfoSessionCell, return 72.0f
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // empty cell
    if (indexPath.section == 0) {
        if (_infoSessionModel == nil || [_infoSessionModel.myInfoSessions count] == 0) {
            return 44.0f;
        } else {
            // info session cell
            return 72.0f;
        }
    } else {
        return 44.0f;
    }
    
}


/**
 *  select row at indexPath
 *
 *  @param tableView tableView
 *  @param indexPath indexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        // empty cell
        if (_infoSessionModel == nil || [_infoSessionModel.myInfoSessions count] == 0) {
            return;
        } else {
            // info session cell
            [self performSegueWithIdentifier:@"ShowDetailFromMyInfoSessions" sender:[[NSArray alloc] initWithObjects:@"MyInfoViewController", _infoSessionModel.myInfoSessions[indexPath.row], _infoSessionModel, nil]];
        }
    }
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        // empty cell
        if (_infoSessionModel == nil || [_infoSessionModel.myInfoSessions count] == 0) {
            return NO;
        } else {
            // info session cell
            return YES;
        }
    } else {
        return NO;
    }
    
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        InfoSession *infoSessionToBeDeleted = _infoSessionModel.myInfoSessions[indexPath.row];
        if ([_infoSessionModel deleteInfoSessionInMyInfo:infoSessionToBeDeleted] == UWDeleted) {
            [_tabBarController setBadge];
            
            UINavigationController *infoSessionVCNavigationController = self.tabBarController.infoSessionsViewController.navigationController;
            // if count > 1, means detailView is shown
            if ([infoSessionVCNavigationController.viewControllers count] > 1) {
                UITableViewController *controller = infoSessionVCNavigationController.viewControllers[1];
                if ([controller isKindOfClass:[DetailViewController class]]) {
                    // get the tabbar item0's detailViewController
                    DetailViewController *detailController = (DetailViewController *)controller;
                    // if the tabbar item0's detailView is shown infoSession to be deleted, then let it pop up.
                    if ([infoSessionToBeDeleted isEqual:detailController.infoSession]) {
                        NSLog(@"tab1->tab0");
                        //if ([senderClass isEqualToString:@"UIBarButtonItem"]) {
                        detailController.infoSession = detailController.originalInfoSession;
                        detailController.openedMyInfo = NO;
                        //} else {
                        //  detailController.infoSessionBackup = nil;
                        //}
                    }
                }
            }
            
            UINavigationController *searchVCNavigationController = self.tabBarController.searchViewController.navigationController;
            // if count > 1, means detailView is shown
            if ([searchVCNavigationController.viewControllers count] > 1) {
                UITableViewController *controller = searchVCNavigationController.viewControllers[1];
                if ([controller isKindOfClass:[DetailViewController class]]) {
                    // get the tabbar item0's detailViewController
                    DetailViewController *detailController = (DetailViewController *)controller;
                    // if the tabbar item0's detailView is shown infoSession to be deleted, then let it pop up.
                    if ([infoSessionToBeDeleted isEqual:detailController.infoSession]) {
                        NSLog(@"tab1->tab2");
                        detailController.infoSession = detailController.originalInfoSession;
                        detailController.openedMyInfo = NO;
                        //                            if ([senderClass isEqualToString:@"UIBarButtonItem"]) {
                        //                                detailController.infoSession = detailController.originalInfoSession;
                        //                                detailController.openedMyInfo = NO;
                        //                            } else {
                        //                                detailController.infoSessionBackup = nil;
                        //                            }
                    }
                }
            }
//            
//            UINavigationController *infoSessionVCNavigationController = _tabBarController.infoSessionsViewController.navigationController;
//            // if count > 1, means detailView is shown
//            if ([infoSessionVCNavigationController.viewControllers count] > 1) {
//                UITableViewController *controller = infoSessionVCNavigationController.viewControllers[1];
//                if ([controller isKindOfClass:[DetailViewController class]]) {
//                    // get the tabbar item0's detailViewController
//                    DetailViewController *detailController = (DetailViewController *)controller;
//                    // if the tabbar item0's detailView is shown infoSession to be deleted, then let it pop up.
//                    if ([infoSessionToBeDeleted isEqual:detailController.infoSession]) {
//                        detailController.infoSessionBackup = nil;
//                    }
//                }
//            }
            // save to file
            [_infoSessionModel saveInfoSessions];
        }
        if ([_infoSessionModel.myInfoSessions count] != 0) {
            //NSLog(@"not 0");
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        // if last item is deleted
        else {
            //NSLog(@"is 0");
            [tableView reloadData];
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            //NSLog(@"reloaded");
            if ([self.tableView isEditing]){
                [self enterEditMode:nil];
            }
        }
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)enterEditMode:(id)sender {
    if ([self.tableView isEditing]) {
        [self.tableView setEditing:NO animated:YES];
        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(enterEditMode:)] animated:YES];
    } else {
        [self.tableView setEditing:YES animated:YES];
        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(enterEditMode:)] animated:YES];
    }
}


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DetailViewController *controller = segue.destinationViewController;
    _tabBarController.detailViewControllerOfTabbar1 = controller;
    controller.caller = sender[0];
    controller.infoSession = sender[1];
    controller.infoSessionModel = sender[2];
    controller.tabBarController = _tabBarController;

}

- (void)showMoreViewController {
    MoreViewController *newMoreVC = [[MoreViewController alloc] initWithStyle:UITableViewStyleGrouped];
    MoreNavigationViewController *newMoreNaviVC = [[MoreNavigationViewController alloc] initWithRootViewController:newMoreVC];
    //[self presentViewController:newMoreVc animated:YES completion:^(){}];
    //[self.navigationController pushViewController:newMoreNaviVC animated:YES];
    [self presentViewController:newMoreNaviVC animated:YES completion:^(){}];
}


@end
