//
//  ViewController.swift
//  MapKit-Lab
//
//  Created by Chelsi Christmas on 3/3/20.
//  Copyright © 2020 Chelsi Christmas. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    private var placeName: String?
    
    private var userTrackingButton: MKUserTrackingButton!
    
    private var annotations = [MKPointAnnotation]()
    
    private let locationSession = CoreLocationSession()
    
    private var isShowingNewAnnotations = false
    
    private var locations = [OpenData]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        searchTextField.delegate = self
        mapView.delegate = self
        userTrackingButton = MKUserTrackingButton(frame: CGRect(x: 20, y: 20, width: 40, height: 40))
        mapView.addSubview(userTrackingButton)
        userTrackingButton.mapView = mapView
        getSchools()
        
        
        
        
    }
    
    private func loadMap() {
        let annotations = makeAnnotations(locations)
        mapView.addAnnotations(annotations)
        
        print("Somthing is happening \(annotations)")
    }
    
    private func getSchools() {
        NYCOpenDataAPIClient.getLocations(completion: { (result) in
            switch result {
            case .failure(let error):
                print("Error: \(error)")
            case .success(let data):
                self.locations = data
                DispatchQueue.main.async {
                    self.loadMap()
                }
                
            }
        })
    }
    
    
    private func makeAnnotations(_ schoolLocations: [OpenData]) -> [MKPointAnnotation] {
           var annotations = [MKPointAnnotation]()
       
           for location in schoolLocations {
               let annotation = MKPointAnnotation()
               annotation.title = location.schoolName
//            annotation.coordinate.latitude = Double(location.latitude)!
//            annotation.coordinate.longitude = Double(location.longitude)!
            annotation.coordinate = CLLocationCoordinate2D(latitude: Double(location.latitude)!, longitude: Double(location.longitude)!)
               annotations.append(annotation)

           }
           
           isShowingNewAnnotations = true
           self.annotations = annotations
           return annotations
       }
    
    private func convertPlaceNameToCoordinate(_ placeName: String) {
        locationSession.convertPlaceNameToCoordinate(addressString: placeName) { (result) in
            switch result {
            case .failure(let error):
                print("geocoding error: \(error)")
            case .success(let coordinate):
                print("coordinate: \(coordinate)")
                // set map view at given coordinate
                let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1600, longitudinalMeters: 1600)
                self.mapView.setRegion(region, animated: true)
            }
        }
        
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        guard let searchText = textField.text,
            !searchText.isEmpty else {
                return true
        }
        convertPlaceNameToCoordinate(searchText)
        return true
    }
    
}

extension ViewController: MKMapViewDelegate {

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "annoationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier:  identifier)
            annotationView?.canShowCallout = true
            annotationView?.glyphImage = UIImage(named: "duck")
            annotationView?.glyphTintColor = .systemYellow
            annotationView?.glyphText = annotation.title ?? "No title"
            
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        if isShowingNewAnnotations {
            mapView.showAnnotations(annotations, animated: false)
           
        }
        isShowingNewAnnotations = false
    }
}


