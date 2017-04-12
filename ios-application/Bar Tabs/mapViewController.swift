//
//  mapViewController.swift
//  Bar Tabs
//
//  Created by Dexstrum on 4/5/17.
//  Copyright © 2017 muhlenberg. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps

class mapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        let camera = GMSMutableCameraPosition.camera(withLatitude: 40.597498, longitude: -75.510077, zoom: 17)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 40.597498, longitude: -75.510077)
        marker.title = "Muhlenberg College"
        marker.snippet = "Muhlenberg"
        marker.map = mapView
        
        let circleCenter = CLLocationCoordinate2D(latitude: 40.597498, longitude: -75.510077)
        let circ = GMSCircle(position: circleCenter, radius: 50)
        
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
    

}
