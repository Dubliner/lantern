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
    
    var report_buttons: Array<UIButton> = [];
    var lighting_stars = 0;
    var lighting = UIView();

    func report(sender: UIButton!) {
        var alert = UIAlertController(title: "What would you like to report?", message: "", preferredStyle: UIAlertControllerStyle.Alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
//        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        
        
        let lightingAction = UIAlertAction(title: "Lighting", style: .Default, handler: {(action: UIAlertAction!) in
            NSLog("here");
            
            self.lighting.backgroundColor = UIColor.whiteColor();
            self.lighting.frame = CGRectMake(100, 180, 160, 80);
        
            var label = UILabel(frame: CGRectMake(0, 10, 160, 20))
            label.backgroundColor = UIColor.whiteColor();
            label.text = "Lighting";
        

            var one = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton;
            one.frame = CGRectMake(10, 30, 30, 30);
            one.setBackgroundImage(UIImage(named: "unselected.png"), forState: UIControlState.Normal);
            one.tag = 1;
            one.addTarget(self, action: Selector("report_lighting:"), forControlEvents: UIControlEvents.TouchUpInside);
            var two = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton;
            two.frame = CGRectMake(40, 30, 30, 30);
            two.setBackgroundImage(UIImage(named: "unselected.png"), forState: UIControlState.Normal);
            two.tag = 2;
            two.addTarget(self, action: Selector("report_lighting:"), forControlEvents: UIControlEvents.TouchUpInside);
            var three = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton;
            three.frame = CGRectMake(70, 30, 30, 30);
            three.setBackgroundImage(UIImage(named: "unselected.png"), forState: UIControlState.Normal);
            three.tag = 3;
            three.addTarget(self, action: Selector("report_lighting:"), forControlEvents: UIControlEvents.TouchUpInside);
            var four = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton;
            four.frame = CGRectMake(100, 30, 30, 30);
            four.setBackgroundImage(UIImage(named: "unselected.png"), forState: UIControlState.Normal);
            four.tag = 4;
            four.addTarget(self, action: Selector("report_lighting:"), forControlEvents: UIControlEvents.TouchUpInside);
            var five = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton;
            five.frame = CGRectMake(130, 30, 30, 30);
            five.setBackgroundImage(UIImage(named: "unselected.png"), forState: UIControlState.Normal);
            five.tag = 5;
            five.addTarget(self, action: Selector("report_lighting:"), forControlEvents: UIControlEvents.TouchUpInside);

            var ok_button = UIButton(frame: CGRectMake(0, 60, 80, 20));
            ok_button.setTitle("Ok", forState: .Normal);
            ok_button.setTitleColor(UIColor.blackColor(), forState: .Normal);
            ok_button.titleLabel!.textAlignment = .Center;
            ok_button.backgroundColor = UIColor.whiteColor();
            ok_button.addTarget(self, action: Selector("send_lighting_report:"), forControlEvents: UIControlEvents.TouchUpInside);

            var cancel_button = UIButton(frame: CGRectMake(80, 60, 80, 20));

            cancel_button.setTitle("Cancel", forState: .Normal);
            cancel_button.setTitleColor(UIColor.blackColor(), forState: .Normal);
            cancel_button.titleLabel!.textAlignment = .Center;
            cancel_button.backgroundColor = UIColor.whiteColor();
            cancel_button.addTarget(self, action: Selector("close_report_lighting:"), forControlEvents: UIControlEvents.TouchUpInside);
        
            self.report_buttons = [];
            self.report_buttons.append(one);
            self.report_buttons.append(two);
            self.report_buttons.append(three);
            self.report_buttons.append(four);
            self.report_buttons.append(five);

            self.lighting.addSubview(label);
            self.lighting.addSubview(one);
            self.lighting.addSubview(two);
            self.lighting.addSubview(three);
            self.lighting.addSubview(four);
            self.lighting.addSubview(five);
            self.lighting.addSubview(ok_button);
            self.lighting.addSubview(cancel_button);
        
            self.view.addSubview(self.lighting);
            
        });
        let policeAction = UIAlertAction(title: "Police Presence", style: .Default) { (_) in }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        alert.addAction(lightingAction)
        alert.addAction(policeAction)
        alert.addAction(cancelAction)

        self.presentViewController(alert, animated: true, completion: nil)

    }
    
    func lighting_handler(sender: UIButton!) {
//        performSegueWithIdentifier("segue_initial1", sender: sender);
        NSLog("reporting");
//        var alert = UIAlertController(title: "Report", message: "Report", preferredStyle: UIAlertControllerStyle.Alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
//        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
//        self.presentViewController(alert, animated: true, completion: nil)
        
    //        alertView.message = "message";

        
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
    
    func report_lighting(sender: UIButton!) {
        if(sender.tag == 1)
        {
            NSLog("1 star");
            report_buttons[0].setBackgroundImage(UIImage(named: "selected.png"), forState: UIControlState.Normal);
            report_buttons[1].setBackgroundImage(UIImage(named: "unselected.png"), forState: UIControlState.Normal);
            report_buttons[2].setBackgroundImage(UIImage(named: "unselected.png"), forState: UIControlState.Normal);
            report_buttons[3].setBackgroundImage(UIImage(named: "unselected.png"), forState: UIControlState.Normal);
            report_buttons[4].setBackgroundImage(UIImage(named: "unselected.png"), forState: UIControlState.Normal);
            lighting_stars = 1;
        }
        else if(sender.tag == 2)
        {
            NSLog("2 stars");
            report_buttons[0].setBackgroundImage(UIImage(named: "selected.png"), forState: UIControlState.Normal);
            report_buttons[1].setBackgroundImage(UIImage(named: "selected.png"), forState: UIControlState.Normal);
            report_buttons[2].setBackgroundImage(UIImage(named: "unselected.png"), forState: UIControlState.Normal);
            report_buttons[3].setBackgroundImage(UIImage(named: "unselected.png"), forState: UIControlState.Normal);
            report_buttons[4].setBackgroundImage(UIImage(named: "unselected.png"), forState: UIControlState.Normal);
            lighting_stars = 2;
        }
        if(sender.tag == 3)
        {
            NSLog("3 stars");
            report_buttons[0].setBackgroundImage(UIImage(named: "selected.png"), forState: UIControlState.Normal);
            report_buttons[1].setBackgroundImage(UIImage(named: "selected.png"), forState: UIControlState.Normal);
            report_buttons[2].setBackgroundImage(UIImage(named: "selected.png"), forState: UIControlState.Normal);
            report_buttons[3].setBackgroundImage(UIImage(named: "unselected.png"), forState: UIControlState.Normal);
            report_buttons[4].setBackgroundImage(UIImage(named: "unselected.png"), forState: UIControlState.Normal);
            lighting_stars = 3;
        }
        if(sender.tag == 4)
        {
            NSLog("4 stars");
            report_buttons[0].setBackgroundImage(UIImage(named: "selected.png"), forState: UIControlState.Normal);
            report_buttons[1].setBackgroundImage(UIImage(named: "selected.png"), forState: UIControlState.Normal);
            report_buttons[2].setBackgroundImage(UIImage(named: "selected.png"), forState: UIControlState.Normal);
            report_buttons[3].setBackgroundImage(UIImage(named: "selected.png"), forState: UIControlState.Normal);
            report_buttons[4].setBackgroundImage(UIImage(named: "unselected.png"), forState: UIControlState.Normal);
            lighting_stars = 4;
        }
        if(sender.tag == 5)
        {
            NSLog("5 stars");
            report_buttons[0].setBackgroundImage(UIImage(named: "selected.png"), forState: UIControlState.Normal);
            report_buttons[1].setBackgroundImage(UIImage(named: "selected.png"), forState: UIControlState.Normal);
            report_buttons[2].setBackgroundImage(UIImage(named: "selected.png"), forState: UIControlState.Normal);
            report_buttons[3].setBackgroundImage(UIImage(named: "selected.png"), forState: UIControlState.Normal);
            report_buttons[4].setBackgroundImage(UIImage(named: "selected.png"), forState: UIControlState.Normal);
            lighting_stars = 5;
        }
    }
    
    func send_lighting_report(sender: UIButton!) {
        lighting.removeFromSuperview();
        NSLog("sending lighting report");
    }
    
    func close_report_lighting(sender: UIButton) {
        lighting.removeFromSuperview();
        lighting_stars = 0;
        NSLog("cancelled lighting report");
    }

}