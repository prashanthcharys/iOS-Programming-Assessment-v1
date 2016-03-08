//
//  ViewController.m
//  Acronyms and Initialisms
//
//  Created by Prashanth on 3/7/16.
//  Copyright © 2016 Prashanth. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"


static NSString *
const BaseURLString
                  =
@"http://www.nactem.ac.uk/software/acromine/dictionary.py?sf=";

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}



- (IBAction)goButton:(id)sender {
    
    
    //MBProgress Bar Starts
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //Get the Value form user input
    
    NSString *inputWord = self.inputText.text;
    
    // BaseURL + User Keyword
    
    NSString *string = [NSString stringWithFormat:@"%@%@", BaseURLString,             inputWord];
    
    // URL
    NSURL *url = [NSURL URLWithString:string];
    
    // Request Object
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    
    // AFHTTPRequestOperation object initialization
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    // Add content type "text/plain"
    
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", nil];
    
    
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
       //MBProgress Bar Stops
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
        // Create dictionary object to store the entire response objcet as a dictionary
        
        NSDictionary *dic = (NSDictionary *) responseObject;
        
        // There are 2 main keys
        // 1st key is lfs ----> array of longform objects
        // 2nd Key is sf -----> Abbreviation for which definitions are to be retrieved.
        
       
        NSArray *lfs = [dic valueForKey:@"lfs"];
    
        
        // lf ------> Fullforms for which abbreviations to be retrieved.
        
        NSArray *lf = [lfs valueForKey:@"lf"];
        
        
        // new is a string that store the raw value (which cntains space,commas,brackets,quotes
        
        NSString *new = [NSString stringWithFormat:@"%@",lf];
        
        
        
        
        NSString *stringWithoutSpaces = [new
                                         stringByReplacingOccurrencesOfString:@"(" withString:@""];
        
        
        stringWithoutSpaces = [stringWithoutSpaces
                               stringByReplacingOccurrencesOfString:@")" withString:@""];
        
        stringWithoutSpaces = [stringWithoutSpaces
                               stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        
        stringWithoutSpaces = [stringWithoutSpaces
                               stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
        
         // stringWithoutSpaces is the plain text
        stringWithoutSpaces = [NSString stringWithFormat:@" %@",stringWithoutSpaces];
        
        
        
        // Displays the output in the UITextView
        self.result.text = stringWithoutSpaces;
        self.result.textColor = [UIColor blueColor];
        self.result.textAlignment = NSTextAlignmentJustified;
          self.result.font = [UIFont fontWithName:@"georgia-italic" size:20.0];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Data"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    
    [operation start];
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.inputText resignFirstResponder];
    [self.result resignFirstResponder];
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
    
}



@end
