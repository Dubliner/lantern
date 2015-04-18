//
//  Routes.swift
//  MAS project
//
//  Created by ZHEN CHENG WANG on 3/29/15.
//  Copyright (c) 2015 CODEZ. All rights reserved.
//

import UIKit
import MapKit

class Routes: UIViewController, GMSMapViewDelegate {
    
//    struct myvar {
//        var t : Int = 1
//    }
    var destString: String?
    var destLat: Double!
    var destLng: Double!
    
    var taplat : Double = 0.0
    var taplng : Double = 0.0
    var setRouteFlag = 0
    var routes = Array<Array<CLLocationCoordinate2D>>()
    var scores = Array<Int>()
    var indices = Array<Int>()
    var pathList : Array<GMSMutablePath> = Array<GMSMutablePath>()
    var pathPicked : Int = 0
    var indexPicked : Int = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        println(self.destString)
    
        var camera = GMSCameraPosition.cameraWithLatitude(33.777442, longitude: -84.397217, zoom: 15) // coc 33.777442, longitude: -84.397217, zoom: 14
        var mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        self.view = mapView
        
        
        var address = destString//"tech tower, GA, USA"//"1 Infinite Loop, CA, USA"
        var geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            if let placemark = placemarks?[0] as? CLPlacemark {
                println(placemark.location.coordinate.latitude)
                println(placemark.location.coordinate.longitude)
                self.destLat = placemark.location.coordinate.latitude
                self.destLng = placemark.location.coordinate.longitude
            }
        })
//        var marker = GMSMarker()
//        marker.position = CLLocationCoordinate2DMake(-33.86, 151.20)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
//        marker.map = mapView

//        var url : NSString =  "http://173.236.254.243:8080/routes?dest={\"lat\":33.781761,\"lng\":-84.405155}&start={\"lat\":33.781940,\"lng\": -84.376917}"
//        var url : NSString = "http://maps.googleapis.com/maps/api/directions/xml?origin=33.781940,-84.376917&destination=33.781761,-84.405155&sensor=false&units=metric&mode=walking"
//        var url : NSString = "http://173.236.254.243:8080/heatmaps/negative?lat=32.725371&lng= -117.160721&type=lighting&value=10"
//        var url : NSString = "http://173.236.254.243:8080/heatmaps/negative?lat=32.725371&lng= -117.160721&radius=2500&total=2"
        // start coc: 33.777442, -84.397217
        // end tower: 33.772601, -84.394774
//       var url : NSString = "http://173.236.254.243:8080/routes?dest={\"lat\":33.779208,\"lng\":-84.397602}&start={\"lat\":33.781777,\"lng\":-84.397709}" // latest working
        
        /* Request latitude and longitude given address: */
//        var destQuery = self.destString!.componentsSeparatedByString(" ") //split(self.destString as String!){$0 == " "}
//
//        var queryWrapper = join("+", destQuery)
//        var destURL : NSString = "https://maps.googleapis.com/maps/api/geocode/json?address="+queryWrapper
////        var destURL : NSString = "https://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA"
//        var destStr : NSString = destURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
//        var destGeoURL : NSURL = NSURL(string: destStr as String)!
//        
//        let geocoderTask = NSURLSession.sharedSession().dataTaskWithURL(destGeoURL) {(dataGeo, response, error) in
//            println(NSString(data: dataGeo, encoding: NSUTF8StringEncoding))
//            // main thread:
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                println("get here")
//                let geoReply = JSON(data: dataGeo)
//                let results : Array = geoReply["results"].array!
//                let geometry = results[0]["geometry"]
//                let destCoord = geometry["location"]
//                self.destLat = destCoord["lat"].double!
//                self.destLng = destCoord["lng"].double!
//                        println(self.destLat)
//            })
//        }
//        geocoderTask.resume() // if block out this line, http request for geocoding won't get called
        
        /* Request routes from server: */
        println("from outside:\(self.destLat)")
        
        var encodeDest = "{\"lat\":\(self.destLat),\"lng\":\(self.destLng)}"
        //var url : NSString = "http://173.236.254.243:8080/routes?dest="+encodeDest+"&start={\"lat\":33.777442,\"lng\":-84.397217}"

        var url : NSString = "http://173.236.254.243:8080/routes?dest={\"lat\":33.772601,\"lng\":-84.394774}&start={\"lat\":33.777442,\"lng\":-84.397217}" // coc to tower
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
                let routeposHeatmap : Array = json["response"]["heatmap"]["positive"].array!
                let routenegHeatmap : Array = json["response"]["heatmap"]["negative"].array!

                // Display heatmaps
//                for i in 0...routeposHeatmap.count-1{
//                    var pointcoord : CLLocationCoordinate2D = CLLocationCoordinate2DMake(routeposHeatmap[i]["loc"]["coordinates"][0].double!, routeposHeatmap[i]["loc"]["coordinates"][1].double!)
//                    var weight : Int
//                    weight = routeposHeatmap[i]["weight"].int!
//                    var value: Int
//                    value = routeposHeatmap[i]["value"].int!
//                    println(pointcoord)
//                    println(weight)
//                    println(value)
//                    
//                    var circ = GMSCircle(position: pointcoord, radius: 50)
//                    circ.fillColor = UIColor(red: 0.5, green: 0, blue: 0, alpha: 0.2)
//                    circ.strokeColor = UIColor.redColor()
//                    circ.map = mapView;
//                }
                
                for i in 0...routesList.count-1{
                    self.scores.append(routeScore[i].int!)
                    self.indices.append(routeIndex[i].int!)
                }
                
                self.routes = Array<Array<CLLocationCoordinate2D>>()
                
                /* Paths to render */
                self.pathList = Array<GMSMutablePath>()
                
                for i in 0...routesList.count-1{
                    var currRoute = routesList[i]["legs"][0] // no waypoints set
                    var currSteps = currRoute["steps"]
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
    
    /* Get the JSON file from server: */
    func getJSON(origin: String, destination: String, completionHandler: (String?, NSError?) -> Void ) -> NSURLSessionTask {
        // do calculations origin and destiantion with google distance matrix api
        
        
        var url : NSString = "http://173.236.254.243:8080/routes?dest={\"lat\":33.772601,\"lng\":-84.394774}&start={\"lat\":33.777442,\"lng\":-84.397217}" // coc to tower
        var urlStr : NSString = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        var queryURL : NSURL = NSURL(string: urlStr as String)!
        let urlSession = NSURLSession.sharedSession()
        
        let task = urlSession.dataTaskWithURL(queryURL) { data, response, error -> Void in
            if error != nil {
                // If there is an error in the web request, print it to the console
                // println(error.localizedDescription)
                completionHandler(nil, error)
                return
            }
            completionHandler(NSString(data: data, encoding: NSUTF8StringEncoding)! as String,nil)
            
            //println("parsing JSON");
//            let json = JSON(data: data)
//            if (json["status"].stringValue == "OK") {
//                if let totalTime = json["rows"][0]["elements"][0]["duration"]["value"].integerValue {
//                    // println(totalTime);
//                    completionHandler(totalTime, nil)
//                    return
//                }
//                let totalTimeError = NSError(domain: kAppDomain, code: kTotalTimeError, userInfo: nil) // populate this any way you prefer
//                completionHandler(nil, totalTimeError)
//            }
//            let jsonError = NSError(domain: kAppDomain, code: kJsonError, userInfo: nil) // again, populate this as you prefer
//            completionHandler(nil, jsonError)
        }
        task.resume()
        return task
    }
    
}