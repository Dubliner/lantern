//
//  ViewController.swift
//  MAS project
//
//  Created by ZHEN CHENG WANG on 4/4/15.
//  Copyright (c) 2015 CODEZ. All rights reserved.
//

import UIKit
import Foundation





class Initial: UIViewController {
    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        var camera = GMSCameraPosition.cameraWithLatitude(33.777442, longitude: -84.397217, zoom: 15) // coc 33.777442, longitude: -84.397217, zoom: 14
        mapView.camera = camera
        //var mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        // mapView.myLocationEnabled = true
        //self.view = mapView
        
        
        /*var camera = GMSCameraPosition.cameraWithLatitude(37.80948,
        longitude:5.965699, zoom:2)
        var mapView = GMSMapView.mapWithFrame(CGRectZero, camera:camera)
        
        // Available map types: kGMSTypeNormal, kGMSTypeSatellite, kGMSTypeHybrid,
        // kGMSTypeTerrain, kGMSTypeNone
        
        // Set the mapType to Satellite
        mapView.mapType = kGMSTypeSatellite
        self.view = mapView
        */
        
        var url : NSString = "http://173.236.254.243:8080/heatmaps/positive?lat=32.725371&lng= -117.160721&radius=2500&total=2"
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            println(NSString(data: data, encoding: NSUTF8StringEncoding))
        }
        
        task.resume()

            

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func login_button(sender : AnyObject) {
    }
    
    
}

