//
//  SearchViewController.m
//  Recycode
//
//  Created by Angel Genov on 11/25/13.
//  Copyright (c) 2013 recycode. All rights reserved.
//

#import "SearchViewController.h"
#import "UnknownViewController.h"
#import "YesViewController.h"
#import "NoViewController.h"
#import "ProductsCache.h"

@interface SearchViewController () {
    NSURLConnection * _connection;
    NSMutableData * _jsonData;
    NSInteger _statusCode;
    NSString * _info;
}

@property (strong) IBOutlet UIActivityIndicatorView * activityIndicator;

@end


@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"SearchViewController viewDidAppear");
    if (_barCode) {
        [_activityIndicator startAnimating];
        if ([_barCode isEqualToString:@"0078693417962"]) {
            _barCode = @"0620221215092";
        }
        
        ProductsCache * cache = [ProductsCache sharedInstance];
        NSString * d = [cache getBarcode:_barCode];
        
        
        if (d) {
            _info=d;
            NSArray * p = [d componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
            if([(NSString*)[p objectAtIndex:2] length]) {
                [self performSegueWithIdentifier:@"showYes" sender:self];
            }
            else {
                [self performSegueWithIdentifier:@"showNo" sender:self];
            }
        }
        else {
            
            if ([_barCode isEqualToString:@"0061328870003xxx"]) {
                [self performSegueWithIdentifier:@"showYes" sender:self];
            }
            else
                if ([_barCode isEqualToString:@"0078693417962xxxx"]) {
                    [self performSegueWithIdentifier:@"showNo" sender:self];
                }
                else {
                   // [self performSegueWithIdentifier:@"showNotFound" sender:self];
                }
            //do request
            NSURL * url;
            //url =[NSURL URLWithString:[NSString stringWithFormat:@"http://recycode.herokuapp.com/gtin/%@",_barCode]];
            url =[NSURL URLWithString:[NSString stringWithFormat:@"http://lit-depths-8391.herokuapp.com/product/%@",_barCode]];
            //url =[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.0.105:8088/product/%@",_barCode]];
            NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url];
            [request setHTTPMethod:@"GET"];
            _jsonData = [[NSMutableData alloc] init];
            _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        }
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"SearchViewController viewDidDiasppear");
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//obsolete
- (void)fireTimer:(NSTimer*)timer
{
    ProductsCache * cache = [ProductsCache sharedInstance];
    NSString * d = [cache getBarcode:_barCode];
    
    if (d) {
        NSArray * p = [d componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
        if([(NSString*)[p objectAtIndex:2] length]) {
            [self performSegueWithIdentifier:@"showYes" sender:self];
        }
        else {
            [self performSegueWithIdentifier:@"showNo" sender:self];
        }
    }
    else {
        
        if ([_barCode isEqualToString:@"0061328870003"]) {
            [self performSegueWithIdentifier:@"showYes" sender:self];
        }
        else
            if ([_barCode isEqualToString:@"0078693417962"]) {
                [self performSegueWithIdentifier:@"showNO" sender:self];
            }
            else {
                [self performSegueWithIdentifier:@"showNotFound" sender:self];
            }
    }
    [_activityIndicator stopAnimating];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [_activityIndicator stopAnimating];
    
    if ([segue.identifier isEqualToString:@"showNotFound"]) {
        UnknownViewController * vc = segue.destinationViewController;
        vc.barCode = _barCode;
    }
    else if ([segue.identifier isEqualToString:@"showYes"]) {
        YesViewController * vc = segue.destinationViewController;
        vc.barCode = _barCode;
        vc.info = _info;
    }
    else if ([segue.identifier isEqualToString:@"showNo"]) {
        NoViewController * vc = segue.destinationViewController;
        vc.barCode = _barCode;
        vc.info = _info;
    }
    
    _barCode = nil;
}


#pragma mark NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_jsonData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSString *dataString = [[NSString alloc] initWithData:_jsonData encoding:NSUTF8StringEncoding];
    if (_statusCode == 200) {
        NSError * error;
        NSMutableDictionary * data = [NSJSONSerialization JSONObjectWithData:_jsonData options:NSJSONReadingMutableContainers error:&error];
        NSString * desc = [data objectForKey:@"desc"];
        NSString * brand = [data objectForKey:@"brand"];
        NSString * code = [data objectForKey:@"code"];
        
        if (data != nil) {
            NSURL * url;
            //url =[NSURL URLWithString: [NSString stringWithFormat:@"http://192.168.0.105:8088/product/img/%@",self.barCode]];
            url =[NSURL URLWithString: [NSString stringWithFormat:@"http://lit-depths-8391.herokuapp.com/product/img/%@",self.barCode]];
            NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url];
            [request setHTTPMethod:@"GET"];
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error){
                NSString * resp = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"picture get response: %@", resp);
                NSString * pic = @"";
                if(resp == nil && error == nil) {
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory = [paths objectAtIndex:0];
                    pic = @"imgtmp.jpg";
                    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:pic];
                    
                    if ([[NSFileManager defaultManager] fileExistsAtPath:savedImagePath]) {
                        [[NSFileManager defaultManager] removeItemAtPath:savedImagePath error:nil];
                        NSLog(@"file removed from path");
                    }
                    NSLog(@"Saved Image Path : %@",savedImagePath);
                    [data writeToFile:savedImagePath atomically:YES];
                }
                
                if (code.length) {
                    _info = [NSString stringWithFormat:@"%@,%@,%@,%@",desc,brand,code,pic];
                    [self performSegueWithIdentifier:@"showYes" sender:self];
                }
                else {
                    _info = [NSString stringWithFormat:@"%@,%@,,%@",desc,brand,pic];
                    [self performSegueWithIdentifier:@"showNo" sender:self];
                }
                
            }];
        }
        else {
            [self performSegueWithIdentifier:@"showNotFound" sender:self];
        }
    }
    else {
        NSLog(@"Error: %d", _statusCode);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    NSLog(@"Connection failed: %@",[error localizedDescription]);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _statusCode = ((NSHTTPURLResponse*)response).statusCode;
}

@end
