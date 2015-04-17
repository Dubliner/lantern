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
    
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end