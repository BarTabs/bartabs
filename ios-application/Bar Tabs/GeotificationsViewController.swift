/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import MapKit
import CoreLocation
import SwiftyJSON
import Alamofire

struct PreferencesKeys {
    static let savedItems = "savedItems"
}

var _annotation: MKPointAnnotation?


class GeotificationsViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var addButton: UIBarButtonItem!
    @IBAction func addButtonPressed(_ sender: Any) {
        if !addButton.isEnabled {
            showAlert(withTitle: "Warning", message: "Hold to drop a pin before attempting to add")
        }
    }
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Long press to drop pin
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotationOnLongPress(gesture:)))
        longPressGesture.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(longPressGesture)
        mapView.delegate = self
        addButton.isEnabled = false
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        
        loadAllGeotifications()
        mapView.zoomToUserLocation()
    }
    
    func addAnnotationOnLongPress(gesture: UILongPressGestureRecognizer) {
        
        if _annotation != nil {
            mapView.removeAnnotation(_annotation!)
            addButton.isEnabled = true
        }
        
        let point = gesture.location(in: self.mapView)
        let coordinate = self.mapView.convert(point, toCoordinateFrom: self.mapView)
        //Now use this coordinate to add annotation on map.
        _annotation = MKPointAnnotation()
        _annotation?.coordinate = coordinate
        //Set title and subtitle
        _annotation?.title = "New Bar"
        _annotation?.subtitle = "Click + to add geofence"
        
        mapView.addAnnotation(_annotation!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addGeotification" {
            let navigationController = segue.destination as! UINavigationController
            let vc = navigationController.viewControllers.first as! AddGeotificationViewController
            vc.delegate = self
        }
    }
    
    // MARK: Loading and saving functions
    func loadAllGeotifications() {
        _geotifications.removeAll()
        
        let service = "bar/getbars"
        let parameters : Parameters = [
            
        :]
        
        let dataService = DataService(view: self)
        dataService.fetchData(service: service, parameters: parameters, completion: {(response: JSON) -> Void in
            
            for bar in response.arrayValue {
                let objectID = bar.dictionaryValue["objectID"]?.int64Value
                let name = bar.dictionaryValue["name"]?.stringValue
                let latitude = bar.dictionaryValue["location"]?["latitude"].doubleValue
                let longitude = bar.dictionaryValue["location"]?["longitude"].doubleValue
                let radius = bar.dictionaryValue["location"]?["radius"].doubleValue
                
                let coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                let geotification = Geotification(objectID: objectID!, name: name!, coordinate: coordinate, radius: radius!)
                
                self.add(geotification: geotification)
            }
        })
        
    }
    
    func saveAllGeotifications() {
        var items: [Data] = []
        for geotification in _geotifications {
            let item = NSKeyedArchiver.archivedData(withRootObject: geotification)
            items.append(item)
        }
        UserDefaults.standard.set(items, forKey: PreferencesKeys.savedItems)
    }
    
    // MARK: Functions that update the model/associated views with geotification changes
    func add(geotification: Geotification) {
        _geotifications.append(geotification)
        mapView.addAnnotation(geotification)
        addRadiusOverlay(forGeotification: geotification)
        startMonitoring(geotification: geotification)
        updateGeotificationsCount()
    }
    
    func remove(geotification: Geotification) {
        if let indexInArray = _geotifications.index(of: geotification) {
            _geotifications.remove(at: indexInArray)
        }
        mapView.removeAnnotation(geotification)
        removeRadiusOverlay(forGeotification: geotification)
        stopMonitoring(geotification: geotification)
        updateGeotificationsCount()
    }
    
    func updateGeotificationsCount() {
        title = "Geotifications (\(_geotifications.count))"
    }
    
    // MARK: Map overlay functions
    func addRadiusOverlay(forGeotification geotification: Geotification) {
        mapView?.add(MKCircle(center: geotification.coordinate, radius: geotification.radius))
    }
    
    func removeRadiusOverlay(forGeotification geotification: Geotification) {
        // Find exactly one overlay which has the same coordinates & radius to remove
        guard let overlays = mapView?.overlays else { return }
        for overlay in overlays {
            guard let circleOverlay = overlay as? MKCircle else { continue }
            let coord = circleOverlay.coordinate
            if coord.latitude == geotification.coordinate.latitude && coord.longitude == geotification.coordinate.longitude && circleOverlay.radius == geotification.radius {
                mapView?.remove(circleOverlay)
                break
            }
        }
    }
    
    func createBar(bar: ClientBar) {
        let service = "bar/createbar"

        let dataService = DataService(view: self)        
        dataService.post(service: service, parameters: bar.dictionaryRepresentation, completion: {(response: JSON) -> Void in
            print("Bar added successfully")
        })
    }
    
    @IBAction func zoomToCurrentLocation(_ sender: Any) {
        mapView.zoomToUserLocation()
    }
    
    @IBAction func onBackButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: AddGeotificationViewControllerDelegate
extension GeotificationsViewController: AddGeotificationsViewControllerDelegate {
    
    func addGeotificationViewController(controller: AddGeotificationViewController, didAddCoordinate coordinate: CLLocationCoordinate2D, name: String, radius: Double) {
        controller.dismiss(animated: true, completion: nil)
        let geotification = Geotification(objectID: -1, name: name, coordinate: coordinate, radius: radius)
        var bar = ClientBar(geotification: geotification)
        bar.ownerID = Int64(UserDefaults.standard.string(forKey: "userID")!)
        
        let service = "bar/createbar"
        
        let dataService = DataService(view: self)
        dataService.post(service: service, parameters: bar.dictionaryRepresentation, completion: {(response: JSON) -> Void in
            print("Bar added successfully")
            self.add(geotification: geotification)
            self.mapView.removeAnnotation(_annotation!)
        })
        
    }
    
}

// MARK: - Location Manager Delegate
extension GeotificationsViewController: CLLocationManagerDelegate {
    
}

// MARK: - MapView Delegate
extension GeotificationsViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "myGeotification"
        if annotation is Geotification {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                let removeButton = UIButton(type: .custom)
                removeButton.frame = CGRect(x: 0, y: 0, width: 23, height: 23)
                removeButton.setImage(UIImage(named: "DeleteGeotification")!, for: .normal)
                annotationView?.leftCalloutAccessoryView = removeButton
            } else {
                annotationView?.annotation = annotation
            }
            return annotationView
        }
        return nil
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.lineWidth = 1.0
            circleRenderer.strokeColor = .purple
            circleRenderer.fillColor = UIColor.purple.withAlphaComponent(0.4)
            return circleRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // Delete geotification
        let geotification = view.annotation as! Geotification
        remove(geotification: geotification)
    }
    
}
