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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var camera = GMSCameraPosition.cameraWithLatitude(33.777442, longitude: -84.397217, zoom: 13)
        var mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.camera = camera
        mapView.myLocationEnabled = true
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        self.view = mapView
        

        var url : NSString = "http://173.236.254.243:8080/heatmaps/positive?lat=32.725371&lng=%20-117.160721&radius=2500&total=2"
        var queryURL : NSURL = NSURL(string: url as String)!
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(queryURL) {(data, response, error) in
            
            var myJSON = NSString(data: data, encoding: NSUTF8StringEncoding)
//            println(myJSON)
            
            /* Return to main thread so we can make call to Google Map SDK */
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                var marker = GMSMarker()
                marker.position = CLLocationCoordinate2DMake(33.777442, -84.397217)
                marker.title = "Sydney"
                marker.snippet = "Australia"
                marker.map = mapView
                var seeif = 1
                let json = JSON(data: data) // put data not the encoded one
                
                println(json)
                let points : Array = json["response"].array!
                
                for i in 0...points.count-1{
                    println(points[i])
                    var pointcoord : CLLocationCoordinate2D = CLLocationCoordinate2DMake(points[i]["loc"]["coordinates"][0].double!, points[i]["loc"]["coordinates"][1].double!)
                    var weight : Int
                    weight = points[i]["weight"].int!
                    var value: Int
                    value = points[i]["value"].int!
                    println(pointcoord.latitude)
                    println(pointcoord.longitude)
                    println(weight)
                    println(value)
                    
                    var circ = GMSCircle(position: pointcoord, radius: 3)
                    circ.fillColor = UIColor(red: 0.35, green: 0, blue: 0, alpha: 0.05)
                    circ.strokeColor = UIColor.redColor()
//                    circ.map = mapView;
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

