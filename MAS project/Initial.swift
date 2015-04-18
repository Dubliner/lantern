//
//  ViewController.swift
//  MAS project
//
//  Created by ZHEN CHENG WANG on 4/4/15.
//  Copyright (c) 2015 CODEZ. All rights reserved.
//

import UIKit
import Foundation





class Initial: UIViewController, GMSMapViewDelegate {
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
        

        var url : NSString = "http://173.236.254.243:8080/heatmaps/positive?lat=32.725371&lng=%20-117.160721&radius=2500&total=2"
        var queryURL : NSURL = NSURL(string: url as String)!
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(queryURL) {(data, response, error) in
            
            var myJSON = NSString(data: data, encoding: NSUTF8StringEncoding)
//            println(myJSON)
            
            /* Return to main thread so we can make call to Google Map SDK */
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                var seeif = 1
                let json = JSON(data: data) // put data not the encoded one
                
                println(json)
                let points : Array = json["response"].array!
                
//                self.routes = Array<Array<CLLocationCoordinate2D>>()
                
                
                for i in 0...points.count-1{
//                    //do something
                    println(points[i])
                    var pointcoord : CLLocationCoordinate2D = CLLocationCoordinate2DMake(points[i]["loc"]["coordinates"][0].double!, points[i]["loc"]["coordinates"][1].double!)
                    var weight : Int
                    weight = points[i]["weight"].int!
                    var value: Int
                    value = points[i]["value"].int!
                    println(pointcoord)
                    println(weight)
                    println(value)
                    
                    
                    
                }
                
            })
        }
        //    
        //        
        task.resume()
        

            

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func login_button(sender : AnyObject) {
    }
    
    
}

