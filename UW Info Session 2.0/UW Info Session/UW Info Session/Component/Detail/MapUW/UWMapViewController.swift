//
//  UWMapViewController.swift
//  UW Info Session
//
//  Created by Qiu Zefeng on 2015-09-06.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import UIKit

class UWMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var addressLabel: UILabel!

    let locationManager = CLLocationManager()
    
    var infoSessionLocationString: String?
    
    struct infoSessionLoaction {
        static let DC = CLLocationCoordinate2DMake(43.4726266424767, -80.5422597751021)
        static let TC = CLLocationCoordinate2DMake(43.469270804792, -80.5414594709873)
        static let Fed = CLLocationCoordinate2DMake(43.4731935543136, -80.5485197156668)
        static let UClub = CLLocationCoordinate2DMake(43.4722962253136, -80.5473452433944)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        mapView.delegate = self
        
        setDestinationMarker(infoSessionLocationString!)
    }
    
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()

        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let address = response?.firstResult() {
                
                let lines = address.lines as! [String]
                self.addressLabel.text = lines.joinWithSeparator("\n")
                
                let labelHeight = self.addressLabel.intrinsicContentSize().height
                self.mapView.padding = UIEdgeInsets(top: self.topLayoutGuide.length, left: 0,
                    bottom: labelHeight, right: 0)
                
                UIView.animateWithDuration(0.25) {
                    self.view.layoutIfNeeded()
                }
//                print("locations = \(coordinate.latitude) \(coordinate.longitude)")
            }
        }
    }
    
    private func setDestinationMarker(location: String) {
        let marker = GMSMarker()
        
        if (location.containsMatch("DC") != nil) {
            marker.position = infoSessionLoaction.DC
            marker.title = "DC"
            title = "DC"
        }else if (location.containsMatch("Fed") != nil) {
            marker.position = infoSessionLoaction.Fed
            marker.title = "Fed Hall"
            title = "Fed Hall"
        }else if (location.containsMatch("TC") != nil) {
            marker.position = infoSessionLoaction.TC
            marker.title = "TC"
            title = "TC"
        }else if (location.containsMatch("University Club") != nil) {
            marker.position = infoSessionLoaction.UClub
            marker.title = "University Club"
            title = "University Club"
        }else {
            title = "Not in Campus, Tap Google😉"
        }
        marker.snippet = "UWaterloo"
        marker.map = mapView
    }

}

extension UWMapViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
    }
}

extension UWMapViewController: GMSMapViewDelegate {
    func mapView(mapView: GMSMapView!, idleAtCameraPosition position: GMSCameraPosition!) {
        reverseGeocodeCoordinate(position.target)
    }
}







