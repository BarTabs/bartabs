//
//  mapViewController.swift
//  Bar Tabs
//
//  Created by Dexstrum on 4/5/17.
//  Copyright © 2017 muhlenberg. All rights reserved.
/*
    This view controller lets the user view what bars
    are in his/her general vacinity. We implemented
    Google Maps in order to allow for geofencing to section
    off what bars are in the area that people specify.
*/

import UIKit
import GoogleMaps

class mapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate{
    
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Location Manager code to fetch current location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
    }
    
    override func loadView() {
        
        
        let latitude = locationManager.location?.coordinate.latitude
        let longitude = locationManager.location?.coordinate.longitude

        print("Latitude: \(String(describing: latitude)) & longitude: \(String(describing: longitude))")
        
        //sets the camera position on the map
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude!, longitude: longitude!, zoom: 18)
        
        
        //creates the map itself on the view controller
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        //creates a marker to show where the user is
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        marker.title = "Muhlenberg College"
        marker.snippet = "Muhlenberg"
        marker.map = mapView
        
        //creates a geofence to show the area the user is in
        let circleCenter = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        let circ = GMSCircle(position: circleCenter, radius: 30)
        
        circ.fillColor = UIColor(red: 0.35, green: 0, blue: 0, alpha: 0.05)
        circ.strokeColor = .red
        circ.strokeWidth = 1
        circ.map = mapView
        circ.map = mapView

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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
    }
}
