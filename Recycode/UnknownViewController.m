//
//  UnknownViewController.m
//  Recycode
//
//  Created by Angel Genov on 11/25/13.
//  Copyright (c) 2013 recycode. All rights reserved.
//

#import "UnknownViewController.h"
#import "CameraViewController2.h"
#import "TextFieldsViewController.h"
#import "ProductsCache.h"


NSString* hlp_urlenc(NSString *val)
{
    CFStringRef safeString =
    CFURLCreateStringByAddingPercentEscapes(NULL,
                                            (CFStringRef)val,
                                            NULL,
                                            //CFSTR("/%&=?$#+-~@<>|\*,.()[]{}^!"),
                                            CFSTR("!*'\"();:@&=+$,/?%#[]% "),
                                            kCFStringEncodingUTF8);
    return [NSString stringWithFormat:@"%@", safeString];
}

@interface UnknownViewController ()

@property(weak,nonatomic) TextFieldsViewController *textFields;
@end

@implementation UnknownViewController

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
    self.picture = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)buttonOK:(id)sender
{

    NSString * desc = self.textFields.desc.text;
    NSString * brand = self.textFields.brand.text;
    NSString * code = self.textFields.code.text;
    NSString * picfn = @"";
    
    if (desc.length && brand.length) {
        if (self.picture) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            picfn = [NSString stringWithFormat:@"img%@.jpg",self.barCode];
            NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:picfn];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:savedImagePath]) {
                [[NSFileManager defaultManager] removeItemAtPath:savedImagePath error:nil];
                NSLog(@"file removed from path");
            }
            NSLog(@"Saved Image Path : %@",savedImagePath);
            [self.pictureData writeToFile:savedImagePath atomically:YES];
            //send the product data
            NSURL * url;
            //url =[NSURL URLWithString: [NSString stringWithFormat:@"http://192.168.0.105:8088/product/img/%@",self.barCode]];
            url =[NSURL URLWithString: [NSString stringWithFormat:@"http://lit-depths-8391.herokuapp.com/product/img/%@",self.barCode]];
            
            NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody: self.pictureData];
            [request addValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error){
                NSString * resp = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"picture response: %@", resp);
            }];
        }
        ProductsCache * s = [ProductsCache sharedInstance];
        [s storeBarcode:self.barCode Description:desc Brand:brand Code:code Picture:picfn];
    
        //send the product data
        NSURL * url;
        //url =[NSURL URLWithString: @"http://192.168.0.105:8088/product/add"];
        url =[NSURL URLWithString: @"http://lit-depths-8391.herokuapp.com/product/add"];
        
        NSString * dataStr = [NSString stringWithFormat:@"barcode=%@&desc=%@&brand=%@&code=%@",
                                    hlp_urlenc(self.barCode),
                                    hlp_urlenc(desc),
                                    hlp_urlenc(brand),
                                    hlp_urlenc(code)];
        NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[dataStr dataUsingEncoding:NSUTF8StringEncoding]];

        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error){
            NSString * resp = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"product info response: %@", resp);
        }];
    }

    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)takePicture
{
    [self performSegueWithIdentifier:@"takePicture" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"takePicture"]) {
        CameraViewController2 * vc = segue.destinationViewController;
        vc.parent = self;
    }
    else if ([segue.identifier isEqualToString:@"textFields"]) {
        TextFieldsViewController * vc = segue.destinationViewController;
        self.textFields = vc;
    }
}


@end
