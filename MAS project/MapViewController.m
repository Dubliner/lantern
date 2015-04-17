//
//  ViewController.m
//  MAS project
//
//  Created by Aditya Kadur on 3/26/15.
//  Copyright (c) 2015 CODEZ. All rights reserved.
//

#import "MapViewController.h"
@interface MapViewController()

@end

@implementation MapViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.myLocationEnabled = YES;
    self.mapView.mapType = kGMSTypeNormal;
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.delegate = self;
    
    NSString *heatmapURL = @"http://173.236.254.243:8080/heatmaps/positive?lat=32.725371&lng= -117.160721&radius=2500&total=2";
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithURL:[NSURL URLWithString:heatmapURL]
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    NSError *jsonParsingError = nil;
                    NSArray *heatmap_array = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
                   // NSDictionary *heatmap;
    
                    for(int i = 0; i < [heatmap_array count]; i++)
                    {
                        NSLog(@"heatmap: %@", [[heatmap_array objectAtIndex:i]objectForKey:@"response"]);
                    }
    
                }] resume];
    
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL
                                                              URLWithString:@"http://173.236.254.243:8080/heatmaps/positive?lat=32.725371&lng=%20-117.160721&radius=2500&total=2"]];
        NSData *response = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:nil error:nil];
        NSString *strData = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"%@", strData);
        NSError *jsonParsingError = nil;
        NSArray *heatmap_array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:&jsonParsingError];
     NSDictionary *heatmap;
        NSLog(@"length: %lu", (unsigned long)[heatmap_array count]);
        for(int i = 0; i < [heatmap_array count]; i++)
        {
    //        NSLog(@"heatmap: %@", [[heatmap_array objectAtIndex:i]objectForKey:@"success"]);
            NSLog(@"heatmap: %@", [heatmap_array objectAtIndex:i]);
        }
        NSLog(@"The code runs through here!");
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end