//
//  ViewController.swift
//  Where am I
//
//  Created by Justin Vallely on 5/20/15.
//  Copyright (c) 2015 JMVapps. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var map: MKMapView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Used to request permission and get user's location
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Add a pin on long press
        // "action" function will be called when pressed. Colon is used to send gesture recognizer to function.
        var uilpgr = UILongPressGestureRecognizer(target: self, action: "action:")
        
        // Set the minimum press duration time to recognize
        uilpgr.minimumPressDuration = 2
        
        map.addGestureRecognizer(uilpgr)
        
        
    }
    
    func action(gesturesRecognizer:UIGestureRecognizer) {
        
        // Get the touch point that user pressed relative to the view(map)
        var touchPoint = gesturesRecognizer.locationInView(self.map)
        
        // Convert the relative touch point to a map coordinate
        var newCoordinate:CLLocationCoordinate2D = map.convertPoint(touchPoint, toCoordinateFromView: self.map)
        
        // Add a pin with annotation
        var annotation = MKPointAnnotation()
        
        annotation.coordinate = newCoordinate
        annotation.title = "New Place"
        annotation.subtitle = "new subtitle goes here"
        
        map.addAnnotation(annotation)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        println(locations)
        
        // Convert AnyObject to a CLLocation type
        var userLocation:CLLocation = locations[0] as! CLLocation
        
        var latitude = userLocation.coordinate.latitude
        var longitude = userLocation.coordinate.longitude
        
        // Essentially a zoom level
        var latDelta:CLLocationDegrees = 0.001
        var longDelta:CLLocationDegrees = 0.001
        
        // A span is a combination of two deltas
        var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        
        // location is a combination of latitude and longitude
        var location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        // Set the region based on location and span(zoom)
        var region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        // Combine all the above to create the map object
        // Add "self." here because we're in a closure
        self.map.setRegion(region, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

