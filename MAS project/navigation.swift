//
//  navigation.swift
//  MAS project
//
//  Created by Aditya Kadur on 4/20/15.
//  Copyright (c) 2015 CODEZ. All rights reserved.
//

import UIKit
import Foundation





class navigation: UIViewController, GMSMapViewDelegate {
    
    func report(sender: UIButton!) {
//        performSegueWithIdentifier("segue_initial1", sender: sender);
        NSLog("reporting");
    }
    func end_navigation(sender: UIButton!) {
        performSegueWithIdentifier("segue_end", sender: sender);
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var camera = GMSCameraPosition.cameraWithLatitude(33.777442, longitude: -84.397217, zoom: 13)
        var mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.camera = camera
        mapView.myLocationEnabled = true
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        self.view = mapView
        
        NSLog("Here we are");
        //        var X_Co = self.view.frame.size.width - 100;
        //        var Y_Co = self.view.frame.size.height - 40;
        var button1 = UIButton(frame: CGRectMake(30, 550, 150, 40));
        //        button1.center.x = self.view.frame.size.width/2;
        button1.titleLabel!.text = "Report";
        button1.titleLabel!.textColor = UIColor.blackColor();
        button1.titleLabel!.textAlignment = .Center;
        button1.backgroundColor = UIColor.whiteColor();
        button1.addTarget(self, action: Selector("report:"), forControlEvents: UIControlEvents.TouchUpInside);
        
        self.view.addSubview(button1);
        var button2 = UIButton(frame: CGRectMake(200, 550, 150, 40));
        //        button1.center.x = self.view.frame.size.width/2;
        button2.titleLabel!.text = "End";
        button2.titleLabel!.textColor = UIColor.blackColor();
        button2.titleLabel!.textAlignment = .Center;
        button2.backgroundColor = UIColor.whiteColor();
        button2.addTarget(self, action: Selector("end_navigation:"), forControlEvents: UIControlEvents.TouchUpInside);
        
        self.view.addSubview(button2);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}