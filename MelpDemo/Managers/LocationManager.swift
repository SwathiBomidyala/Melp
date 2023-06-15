//
//  LocationManager.swift
//  MelpDemo
//
//  Created by Bomidyala Swathi on 15/06/23.
//

import Foundation
import CoreLocation



class LocationManager: NSObject {
    
    var locationManager: CLLocationManager?
    static let instance = LocationManager()
    var fetchedLocation: CLLocation?
    var hasAccess: Bool = false
    
    private override init() {
        super.init()
        self.startLocation()
    }
    
    private func startLocation() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
    }
    
    func hasLocationAccess() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch self.locationManager?.authorizationStatus {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            case .none:
                return false
            @unknown default:
                return false
            }
        } else {
            return false
        }

    }
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied:
            hasAccess = false
        case .notDetermined:
            hasAccess = false
        case .authorizedWhenInUse:
            hasAccess = true
            locationManager?.requestLocation()
        case .authorizedAlways:
            hasAccess = true
            locationManager?.requestLocation()
        case .restricted:
            hasAccess = true
        default:
            hasAccess = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        fetchedLocation = locations.first
        locationManager?.stopUpdatingLocation()
        NotificationCenter.default.post(name: Notification.Name(NotificationConstants.locationUpdate), object: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            locationManager?.stopMonitoringSignificantLocationChanges()
            return
        }
    }
}



