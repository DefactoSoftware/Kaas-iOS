//
//  KAAXingOAuthViewController.m
//  kaas
//
//  Created by Girgis on 21/11/13.
//  Copyright (c) 2013 Jurre Stender. All rights reserved.
//

#import "KAAXingOAuthViewController.h"
#import <gtm-oauth/GTMOAuthAuthentication.h>
#import <gtm-oauth/GTMOAuthViewControllerTouch.h>
#import <gtm-oauth/GTMHTTPFetcher.h>
#import "KAAAPIClient.h"
#import "KAASkillCell.h"
#import "KAAAppDelegate.h"

static NSString *const KAAXingConsumerKey = @"6a875450a5af3a3ce6a9";
static NSString *const KAAXingConsumerSecret = @"9a3057d7b93b7fed0520022f4ee8217391be4c72";
static NSString *const KAAXingAPIBaseUrl = @"https://api.xing.com/v1/";
static NSString *const KAAXingRequestEndpoint = @"request_token";
static NSString *const KAAXingAccessEndpoint = @"access_token";
static NSString *const KAAXingAuthorizeEndpoint = @"authorize";
static NSString *const KAAXingMeEndpoint = @"users/me";
static NSString *const KAAOAuthCallbackUrl = @"http://kaas.defacto.nl/success";
static NSString *const KAAXingKeychainItemName = @"xing";
static NSString *const KAASkillCellIdentifier = @"SkillCell";
static NSString *const KAAQuestionsNavigationControllerIdentifier = @"KAANavigationControllerQuestions";

@interface KAAXingOAuthViewController()
@property (nonatomic, strong) NSArray *skills;
@property (nonatomic, strong) NSMutableArray *skillStates;
@property (nonatomic, assign) NSInteger skillsImportCount;
@end

@implementation KAAXingOAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.skillsTableView.hidden = YES;
    self.importButton.enabled = NO;
    
    self.skillsTableView.dataSource = self;
    self.skillsTableView.delegate = self;
    
    self.skillStates = [[NSMutableArray alloc] init];
}

- (void)fetchSkillsWithAuthentication:(GTMOAuthAuthentication *)authentication {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@%@", KAAXingAPIBaseUrl, KAAXingMeEndpoint];
    [request setURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [authentication authorizeRequest:request];
    
    NSURLResponse *response;
    NSError *error;
    NSData *userResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary* user = [NSJSONSerialization JSONObjectWithData:userResponseData
                                                         options:kNilOptions
                                                           error:&error];
    
    if (error == nil) {
        self.connectButton.hidden = YES;
        self.skillsTableView.hidden = NO;
        self.importButton.enabled = YES;
        
        NSString *skills = user[@"users"][0][@"haves"];

        NSArray *untrimmedSkils = [skills componentsSeparatedByString: @","];
        NSMutableArray *trimmedSkills = [[NSMutableArray alloc] initWithCapacity:[untrimmedSkils count]];

        for (NSString *skill in untrimmedSkils) {
            NSString *trimmedSkill = [skill stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            [trimmedSkills addObject:trimmedSkill];
        }

        self.skills = trimmedSkills;

        for (NSString *skill in self.skills) {
            [self.skillStates addObject:@NO];
        }
        [self.skillsTableView reloadData];
    }
}

- (void)toQuestionsViewController {
    KAAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	appDelegate.window.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:KAAQuestionsNavigationControllerIdentifier];
}

#pragma mark - Importing skills

- (void)importSkills {
    if (self.skills.count > 0) {
        self.skillsImportCount = 0;
        [self importNextSkill];
    }
}

- (void)importNextSkill {
    if (self.skillsImportCount < self.skills.count) {
        // Read if user wants to import skill
        KAASkillCell *skillCell = (KAASkillCell *) [self tableView:self.skillsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.skillsImportCount inSection:0]];
    
        NSString *skillName = skillCell.nameLabel.text;
        BOOL import = [[self.skillStates objectAtIndex:self.skillsImportCount] boolValue];
    
        if (import) {
            // Import skill
            __weak KAAXingOAuthViewController *_self = self;
            [[KAAAPIClient sharedClient] postUserCategoryWithUserId:self.loggedInUser.userId name:skillName completion:^(BOOL success) {
                _self.skillsImportCount++;
                [_self importNextSkill];
            }];
        } else {
            self.skillsImportCount++;
            [self importNextSkill];
        }
    } else {
        [self toQuestionsViewController];
    }
}

#pragma mark - Xing authentication

- (GTMOAuthAuthentication *)xingAuthentication {
    GTMOAuthAuthentication *authentication = [[GTMOAuthAuthentication alloc] initWithSignatureMethod:kGTMOAuthSignatureMethodHMAC_SHA1
                                                                               consumerKey:KAAXingConsumerKey
                                                                                privateKey:KAAXingConsumerSecret];
    
    [authentication setServiceProvider:@"XING"];
    
    return authentication;
}

- (void)signInToXing {
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", KAAXingAPIBaseUrl, KAAXingRequestEndpoint];
    NSString *accessUrl = [NSString stringWithFormat:@"%@%@", KAAXingAPIBaseUrl, KAAXingAccessEndpoint];
    NSString *authorizeUrl = [NSString stringWithFormat:@"%@%@", KAAXingAPIBaseUrl, KAAXingAuthorizeEndpoint];
    NSString *scope = @"";
    
    GTMOAuthAuthentication *authentication = [self xingAuthentication];

    [authentication setCallback:KAAOAuthCallbackUrl];

    GTMOAuthViewControllerTouch *viewController;
    viewController = [[GTMOAuthViewControllerTouch alloc] initWithScope:scope
                                                               language:nil
                                                        requestTokenURL:[NSURL URLWithString:requestUrl]
                                                      authorizeTokenURL:[NSURL URLWithString:authorizeUrl]
                                                         accessTokenURL:[NSURL URLWithString:accessUrl]
                                                         authentication:authentication
                                                         appServiceName:KAAXingKeychainItemName
                                                               delegate:self
                                                       finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    
    [[self navigationController] pushViewController:viewController animated:YES];
}

#pragma mark - OAuth response callback

// Gets called after XING connect
- (void)viewController:(UIViewController *)viewController
        finishedWithAuth:(GTMOAuthAuthentication *)authentication
                   error:(NSError *)error {
    if (error != nil) {
        // sign in failed
    } else {
        [self fetchSkillsWithAuthentication:authentication];
    }
}

#pragma mark - Actions

- (IBAction)connectButtonPressed:(id)sender {
    [self signInToXing];
}

- (IBAction)skipButtonPressed:(id)sender {
    [self toQuestionsViewController];
}

- (IBAction)importButtonPressed:(id)sender {
    [self importSkills];
}

#pragma mark - UITableView 

- (IBAction)toggleSkillSwitch:(UISwitch *)skillSwitch {
    NSInteger row = skillSwitch.tag;

    [self.skillStates replaceObjectAtIndex:row withObject:[NSNumber numberWithBool:[skillSwitch isOn]]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KAASkillCell *cell = [self.skillsTableView dequeueReusableCellWithIdentifier:KAASkillCellIdentifier];
	if (!cell) {
		cell = [[KAASkillCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KAASkillCellIdentifier];
	}
    
    NSString *skill = [self.skills objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = skill;
    cell.skillSwitch.tag = indexPath.row;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.skills.count;
}

@end
