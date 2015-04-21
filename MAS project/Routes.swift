//
//  Routes.swift
//  MAS project
//
//  Created by ZHEN CHENG WANG on 3/29/15.
//  Copyright (c) 2015 CODEZ. All rights reserved.
//

import UIKit
import MapKit

class Routes: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate{ // last get current location
    
//    struct myvar {
//        var t : Int = 1
//    }
    
    /* Globals: */
    var manager : CLLocationManager!
    var startLat : String!
    var startLng : String!
    var startLatLng : String!
    var startMutex : Bool = true
    
    var destString: String?
    var destLat: String!
    var destLng: String!
    
    var taplat : Double = 0.0
    var taplng : Double = 0.0
    var setRouteFlag = 0
    var routes = Array<Array<CLLocationCoordinate2D>>()
    var scores = Array<Int>()
    var indices = Array<Int>()
    var pathList : Array<GMSMutablePath> = Array<GMSMutablePath>()
    var pathPicked : Int = 0
    var indexPicked : Int = 0
    
    func next_screen(sender: UIButton!) {
        var url = "http://173.236.254.243:8080/routes/select/";
        url += indexPicked.description;
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "POST"

        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                println("error=\(error)")
                return
            }
            
            println("response = \(response)")
            
            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("responseString = \(responseString)")
        }
        task.resume()
        performSegueWithIdentifier("segue_route", sender: sender);
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if(startMutex){
            println("locations = \(locations)")
            println("description:"+locations.description)
            var startCoord : NSString = locations.description
            var coordHead = startCoord.rangeOfString("<").location+2 // <+
            var coordTail = startCoord.rangeOfString(">").location-1 // >
            var coordLength = coordTail - coordHead
            var startString : String = startCoord as String!
            startLatLng = startCoord.substringWithRange(NSRange(location:coordHead, length:coordLength))
            println(coordHead)
            println(coordTail)
            println(startLatLng)
            var startArr = split(startLatLng) {$0 == ","}
            startLat = startArr[0]
            startLng = startArr[1]
            startMutex = false
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        println(self.destString)
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
    
        var camera = GMSCameraPosition.cameraWithLatitude(33.777442, longitude: -84.397217, zoom: 15) // coc 33.777442, longitude: -84.397217, zoom: 14
        var mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        self.view = mapView
        
        var button1 = UIButton(frame: CGRectMake(30, 550, 300, 40));
        //        button1.center.x = self.view.frame.size.width/2;
        button1.titleLabel!.text = "Select route";
        button1.titleLabel!.textColor = UIColor.blackColor();
        button1.titleLabel!.textAlignment = .Center;
        button1.backgroundColor = UIColor.whiteColor();
        button1.addTarget(self, action: Selector("next_screen:"), forControlEvents: UIControlEvents.TouchUpInside);
        
        self.view.addSubview(button1);
        
        /* Request routes from server: */
        var coordArray = self.destString!.componentsSeparatedByString(",")
        self.destLat = coordArray[0]
        self.destLng = coordArray[1]
        
        println("from outside"+self.destLat)
        var encodeDest = "{\"lat\":"+self.destLat+",\"lng\":"+self.destLng+"}"
//        var encodeStart = "{\"lat\":"+self.startLat+",\"lng\":"+self.startLng+"}"
//        var encodeDest = "{\"lat\":\(self.destLat),\"lng\":\(self.destLng)}"
        var url : NSString = "http://173.236.254.243:8080/routes?dest="+encodeDest+"&start={\"lat\":33.777442,\"lng\":-84.397217}"
//        var url : NSString = "http://173.236.254.243:8080/routes?dest="+encodeDest+"&start="+encodeStart
//        var url : NSString = "http://173.236.254.243:8080/routes?dest={\"lat\":33.772601,\"lng\":-84.394774}&start={\"lat\":33.777442,\"lng\":-84.397217}" // coc to tower
        var urlStr : NSString = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        var queryURL : NSURL = NSURL(string: urlStr as String)!


        let task = NSURLSession.sharedSession().dataTaskWithURL(queryURL) {(data, response, error) in

            var myJSON = NSString(data: data, encoding: NSUTF8StringEncoding)
            
            /* Return to main thread so we can make call to Google Map SDK */
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                var seeif = 1
                        println("from outside:\(self.destLat)")
                let json = JSON(data: data) // put data not the encoded one
                let routesList : Array = json["response"]["routes"].array!
                let routeScore : Array = json["response"]["score"].array!
                let routeIndex : Array = json["response"]["route_index"].array!
                let routeposHeatmap : Array = json["response"]["heatmaps"]["positive"].array!
                let routenegHeatmap : Array = json["response"]["heatmaps"]["negative"].array!

//                 Display heatmaps
                for i in 0...routeposHeatmap.count-1{
                    var pointcoord : CLLocationCoordinate2D = CLLocationCoordinate2DMake(routeposHeatmap[i]["loc"]["coordinates"][0].double!, routeposHeatmap[i]["loc"]["coordinates"][1].double!)
                    var weight : Int
                    weight = routeposHeatmap[i]["weight"].int!
//                    var value: Int
//                    value = routeposHeatmap[i]["value"].int!
                    println(pointcoord.latitude)
                    println(pointcoord.longitude)
                    println(weight)
//                    println(value)
                    
                    var circ = GMSCircle(position: pointcoord, radius: 150)
                    circ.fillColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.2)
                    circ.strokeColor = UIColor.redColor()
                    circ.map = mapView;
                }
                
                for i in 0...routesList.count-1{
                    self.scores.append(routeScore[i].int!)
                    self.indices.append(routeIndex[i].int!)
                }
                
                self.routes = Array<Array<CLLocationCoordinate2D>>()
                
                /* Paths to render */
                self.pathList = Array<GMSMutablePath>()
                
                for i in 0...routesList.count-1{
                    var currRoute = routesList[i]["legs"][0] // no waypoints set
                    var currSteps = currRoute["steps"].array!
                    var routesItem = Array<CLLocationCoordinate2D>()
                    
                    var currPath = GMSMutablePath()
                    for j in 0...currSteps.count-1{ // notice the index
                        var currStep = currSteps[j]
                        
                        var currStart = currStep["start_location"]
                        var testcurr = currStep["start_location"]["lat"]
//                        println(testcurr)
                        var startCoord : CLLocationCoordinate2D = CLLocationCoordinate2DMake(currStart["lat"].double!, currStart["lng"].double!)
                        routesItem.append(startCoord)
                        
                        var currEnd = currStep["end_location"]
                        var endCoord : CLLocationCoordinate2D = CLLocationCoordinate2DMake(currEnd["lat"].double!, currEnd["lng"].double!)
                        routesItem.append(endCoord)
                        
                        currPath.addCoordinate(startCoord)
                        currPath.addCoordinate(endCoord)
                    }
                    self.routes.append(routesItem)
                    self.pathList.append(currPath)
                }
            
                
                /* Render paths on map */
                var R = CGFloat(20)
                var G = CGFloat(20)
                var B = CGFloat(20)
//                let polycolor = UIColor(red: R/255.0, green: G/255.0, blue: B/255.0, alpha: 1.0)
//                var polyline = GMSPolyline(path : pathList[0])
//                polyline.spans = [GMSStyleSpan(color: polycolor)]
//                polyline.map = mapView
                for i in 0...self.pathList.count-1{
                    
                    let polycolor = UIColor(red: R/255.0, green: G/255.0, blue: B/255.0, alpha: 1.0)
                    var polyline = GMSPolyline(path : self.pathList[i])
                    polyline.spans = [GMSStyleSpan(color: polycolor)]
                    polyline.strokeWidth = CGFloat(6.0)
                    polyline.map = mapView
                    
                    R = CGFloat(R+50)
                    G = CGFloat(G+50)
                    B = CGFloat(B+50)
                    
                }
                
                
//
//                println("routes count: \(routesDraw.count)")
//                println("route 1 step ct: \(routesDraw[1].count)")

                

            })
            
            //        var star = ""
            //        var dest = ""
            //        getJSON(star, destination : dest) { routeJSON, error in
            //            if let routeJSON = routeJSON{
            //                var marker = GMSMarker()
            //                marker.position = CLLocationCoordinate2DMake(-34.429130, 150.886080)
            //                marker.title = "Wolongong"
            //                marker.snippet = "Australia"
            //                marker.map = mapView
            //                println(routeJSON)
            //
            //            }
            //            else{
            //                
            //            }
            //            
            //        }
            
            //       println("myvart:\(t)")
            

            //
        }
//    
//        
        task.resume()
        
        // magic code:
        mapView.delegate = self
       
//        println("taplat\(taplat)") // won't catch change in listener
        
        
    }
    
    // the function name need to be mapView
    func mapView(mapView: GMSMapView!, didLongPressAtCoordinate coord: CLLocationCoordinate2D){
        var pressLat = coord.latitude
        var pressLng = coord.longitude
//        println("pressed \(pressLat)")
        
        if setRouteFlag == 0 {
            
            var marker = GMSMarker()
            marker.position = coord
            marker.map = mapView
            
            taplat = coord.latitude
            taplng = coord.longitude
            setRouteFlag = 1
            
            self.scores[0] = 88
            self.scores[1] = 98
            self.scores[2] = 77
            
            var candidates = Array<Int>()
            var bestCandidate : Int = -1
            var bestCandidateScore : Int = Int.min
            var bestInd : Int = 0
            var bestScore : Int = Int.min
            for i in 0...self.scores.count-1{
                if self.scores[i]>bestScore{
                    bestScore = self.scores[i]
                    bestInd = i
                }
                var currPath : GMSPath = self.pathList[i]
                if GMSGeometryIsLocationOnPathTolerance(coord, currPath, false, CLLocationDistance(10.0)){
                    candidates.append(i)
                    if self.scores[i]>bestCandidateScore{
                        bestCandidateScore = self.scores[i]
                        bestCandidate = i
                    }
//                    self.pathPicked = i
                }
            }
            
            if candidates.count==0{
                self.pathPicked = bestInd
            }
            else{
                self.pathPicked = bestCandidate
            }
            
            self.indexPicked = self.indices[self.pathPicked]
            
            var polyline = GMSPolyline(path : self.pathList[self.pathPicked])
            polyline.spans = [GMSStyleSpan(color: UIColor.greenColor())]
            polyline.strokeWidth = CGFloat(6.0)
            polyline.map = mapView

            
            
            println("pathPicked:\(self.pathPicked)")
        }
//        // http://173.236.254.243:8080/routes/select/1425850320099
//        let sendRoute = NSURL(fileURLWithPath: "http://173.236.254.243:8080/")
//        let postRequest = NSMutableURLRequest(URL: sendRoute!)
//        postRequest.HTTPMethod = "POST"
//        let postString = "routes/select/1428551941572"
//        postRequest.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
//        let postTask = NSURLSession.sharedSession().dataTaskWithRequest(postRequest){
//            data, response, error in
//            
//            if error != nil{
//                println("error\(error)")
//                return
//            }
//            println("response=\(response)")
//            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
//            println("response data = \(responseString)")
//            
//        }
//        postTask.resume()
        
//        println("taplat:\(taplat)")
        
        // if user select wrong, return best score
        // if user on any route, pick the one
        // if pick several, choose best scored one
     
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "segue_route") {
            var svc = segue.destinationViewController as! navigation;
            
            svc.route_index = indexPicked.description
//            svc.destString = inputDest.text
//            println("inputdest:\(inputDest.text)")
        }
    }
    
}