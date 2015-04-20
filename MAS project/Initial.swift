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
    
    func next_screen(sender: UIButton!) {
        performSegueWithIdentifier("segue_initial1", sender: sender);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var camera = GMSCameraPosition.cameraWithLatitude(33.777442, longitude: -84.397217, zoom: 15)
        var mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.camera = camera
        mapView.myLocationEnabled = true
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        self.view = mapView
        
        NSLog("Here we are");
//        var X_Co = self.view.frame.size.width - 100;
//        var Y_Co = self.view.frame.size.height - 40;
        var button1 = UIButton(frame: CGRectMake(30, 550, 300, 40));
//        button1.center.x = self.view.frame.size.width/2;
        button1.titleLabel!.text = "Where do you want to go?";
        button1.titleLabel!.textColor = UIColor.blackColor();
        button1.titleLabel!.textAlignment = .Center;
        button1.backgroundColor = UIColor.whiteColor();
        button1.addTarget(self, action: Selector("next_screen:"), forControlEvents: UIControlEvents.TouchUpInside);
        
        self.view.addSubview(button1);

        var url : NSString = "http://173.236.254.243:8080/heatmaps/positive?lat=33.777442&lng=-84.397217&radius=2500&total=2"
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
                    var pointcoord : CLLocationCoordinate2D = CLLocationCoordinate2DMake(points[i]["loc"]["coordinates"][1].double!, points[i]["loc"]["coordinates"][0].double!)
                    var weight : Int
                    weight = points[i]["weight"].int!
                    var value: Int
                  //  value = points[i]["value"].int!
                    println(pointcoord.latitude)
                    println(pointcoord.longitude)
                    println(weight)
                    //println(value)
                    
                    var circ = GMSCircle(position: pointcoord, radius: 5)
                    circ.fillColor = UIColor(red: 0.8, green: 0, blue: 0, alpha: 1)
                    circ.strokeColor = UIColor.redColor()
                    circ.map = mapView;
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

