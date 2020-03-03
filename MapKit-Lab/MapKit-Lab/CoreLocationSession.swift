//
//  CoreLocationSession.swift
//  MapKit-Lab
//
//  Created by Chelsi Christmas on 3/3/20.
//  Copyright © 2020 Chelsi Christmas. All rights reserved.
//

import Foundation
import CoreLocation

class CoreLocationSession: NSObject {
  
  public var locationManager: CLLocationManager
  
  override init() {
    locationManager = CLLocationManager()
    super.init()
    locationManager.delegate = self
    
    locationManager.requestAlwaysAuthorization()
    locationManager.requestWhenInUseAuthorization()
    
    
    startSignificantLocationChanges()
    
 locationManager.startUpdatingLocation()
    
    
 
  }
  
  private func startSignificantLocationChanges() {
    if !CLLocationManager.significantLocationChangeMonitoringAvailable() {
      return
    }
    
    locationManager.startMonitoringSignificantLocationChanges()
  }
  
  public func convertCoordinateToPlacemark(coordinate: CLLocationCoordinate2D) {
   
    let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    
    CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
      if let error = error {
        print("reverseGeocodeLocation: \(error)")
      }
      if let firstPlacemark = placemarks?.first {
        print("placemark info: \(firstPlacemark)")
      }
    }
  }
  
    public func convertPlaceNameToCoordinate(addressString: String, completion: @escaping (Result< CLLocationCoordinate2D, Error >) -> ()) {
    // converting an address to a coordinate
    CLGeocoder().geocodeAddressString(addressString) { (placemarks, error) in
      if let error = error {
        print("geocodeAddressString: \(error)")
        completion(.failure(error))
      }
      if let firstPlacemark = placemarks?.first,
        let location = firstPlacemark.location {
        print("place name coordinate is \(location.coordinate)")
        let region = MKCoordinateRegion( center: location.coordinate, latitudinalMeters: CLLocationDistance(exactly: 5000)!, longitudinalMeters: CLLocationDistance(exactly: 5000)!)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
        completion(.success(location.coordinate))
      }
    }
  }
  
}
extension CoreLocationSession: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    print("didUpdateLocations: \(locations)")
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("didFailWithError: \(error)")
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .authorizedAlways:
      print("authorizedAlways")
    case .authorizedWhenInUse:
      print("authorizedWhenInUse")
    case .denied:
      print("denied")
    case .notDetermined:
      print("notDetermined")
    case .restricted:
      print("restricted")
    default:
      break
    }
  }
}
