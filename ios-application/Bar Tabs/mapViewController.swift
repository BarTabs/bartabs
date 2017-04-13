//
//  mapViewController.swift
//  Bar Tabs
//
//  Created by Dexstrum on 4/5/17.
//  Copyright © 2017 muhlenberg. All rights reserved.
//

import UIKit
import GoogleMaps

class mapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate{
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var zoomLevel: Float = 15.0
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        print(locationManager.location?.coordinate.longitude.description)

//        drawGeoFence()
        
    }
    func drawGeoFence() {
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: self.latitude!, longitude: self.longitude!)
        marker.title = "Muhlenberg College"
        marker.snippet = "Muhlenberg"
        marker.map = mapView
        
        let circleCenter = CLLocationCoordinate2D(latitude: self.latitude!, longitude: self.longitude!)
        let circ = GMSCircle(position: circleCenter, radius: 30)
        
        circ.fillColor = UIColor(red: 0.35, green: 0, blue: 0, alpha: 0.05)
        circ.strokeColor = .red
        circ.strokeWidth = 1
        circ.map = mapView
        circ.map = mapView

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Get Current Location
        let location = locations.last! as CLLocation
        print(location.coordinate.latitude.description)
        let userLocation:CLLocation = locations[0] as CLLocation
        
        //Save current lat long
        UserDefaults.standard.set(userLocation.coordinate.latitude, forKey: "LAT")
        UserDefaults.standard.set(userLocation.coordinate.longitude, forKey: "LON")
        UserDefaults().synchronize()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.black]
        self.navigationController?.navigationBar.isHidden = false
    }
    
}
