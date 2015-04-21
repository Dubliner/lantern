//
//  SearchDestination.swift
//  MAS project
//
//  Created by ZHEN CHENG WANG on 4/1/15.
//  Copyright (c) 2015 CODEZ. All rights reserved.
//

import Foundation

import UIKit

class SearchDestination: UIViewController {

    @IBOutlet weak var inputDest : UITextField!
    @IBOutlet weak var sendButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    @IBAction func sendDest(sender : AnyObject) {
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "segueTest") {
            
            
           // var geometry :
            var destCoord : CLLocationCoordinate2D = CLLocationCoordinate2DMake(33.772360, -84.394838)//= geometry["location"]
//            // doing http
//            var svc = segue.destinationViewController as! Routes;
//            svc.destString = inputDest.text
//            println("inputdest:\(inputDest.text)")
            
            /* Request latitude and longitude given address: */
            var destQuery = inputDest.text.componentsSeparatedByString(" ") //split(self.destString as String!){$0 == " "}
            
            var queryWrapper = join("+", destQuery)
            var destURL : NSString = "https://maps.googleapis.com/maps/api/geocode/json?address="+queryWrapper
            //        var destURL : NSString = "https://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA"
            var destStr : NSString = destURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            var destGeoURL : NSURL = NSURL(string: destStr as String)!
            
            
            
            let geocoderTask = NSURLSession.sharedSession().dataTaskWithURL(destGeoURL) {(dataGeo, response, error) in
                println(NSString(data: dataGeo, encoding: NSUTF8StringEncoding))
                // main thread:
                dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                    println("get here")
                    var geoReply = JSON(data: dataGeo)
                    println(geoReply)
                    var results = geoReply["results"].array!
//                    geometry = results[0]["geometry"]
                    destCoord = CLLocationCoordinate2DMake(results[0]["geometry"]["location"]["lat"].double!, results[0]["geometry"]["location"]["lng"].double!)
                    
                    //                            println("inputdest:\(inputDest.text)")
                    
                    //                            self.destLat = destCoord["lat"].double!
                    //                            self.destLng = destCoord["lng"].double!
                    //                                    println(self.destLat)
                    

                    
                })
            }
            geocoderTask.resume()
            var svc = segue.destinationViewController as! Routes;
            
            svc.destString = destCoord.latitude.description + "," + destCoord.longitude.description
            println("destString:\(svc.destString)")
            }
        
    }
    
    
}

