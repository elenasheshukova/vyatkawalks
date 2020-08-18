//
//  MapViewController.swift
//  vyatkawalks
//
//  Created by Елена Червоткина on 25.06.2020.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    var locationManager = CLLocationManager()
    var isDetailPlace = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationEnabled()
    }
    
    func checkLocationEnabled(){
        if CLLocationManager.locationServicesEnabled() {
            setupManager()
            checkAuthorization()
        } else {
            showAlertLocation(title: "У Вас выключена служба геолокации", massage: "Хотите включить?", url: URL(string: "App-Prefs:root= LOCATION_SERVISES"))
        }
    }
    
    func setupManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
//            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
            break
        case .denied:
            showAlertLocation(title: "Вы запретели использовать местоположение", massage: "Хотите разрешить?", url: URL(string: UIApplication.openSettingsURLString))
            break
        case .restricted:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    func showAlertLocation(title: String, massage: String?, url: URL?) {
        let alert = UIAlertController(title: title, message: massage ?? "", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Настройки", style: .default) { (alert) in
            if let url = url {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        let cencelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(settingsAction)
        alert.addAction(cencelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPlaceDetail" {
            if let vc = segue.destination as? PlaceDetailViewController {
                vc.place = sender as? PlaceEntity
            }
        }
    }
    
}

extension MapViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.darkGray
            renderer.lineWidth = 4.0

            return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation) {
            return nil
        }
        
        let identifier = "PlacePin"
        let placeAnnotation = annotation as? PlaceMKPointAnnotation
        
        // Reuse the annotation if possible
        var annotationView: MKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: placeAnnotation, reuseIdentifier: identifier)
            annotationView?.pinTintColor = UIColor.darkGray
            annotationView?.canShowCallout = true
            
            if !isDetailPlace {
                annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
                if let imageURL = placeAnnotation?.imageURL {
                    let leftIconView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 53, height: 53))
                    leftIconView.image = UIImage(named: imageURL)
                    annotationView?.leftCalloutAccessoryView = leftIconView
                    //annotationView?.detailCalloutAccessoryView = leftIconView
                    //let offset = CGPoint(x: leftIconView.frame.size.width / 2, y: -(leftIconView.frame.size.height / 2) )
                    //annotationView?.centerOffset = offset
                }
            }
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation as? PlaceMKPointAnnotation {
            if control == view.rightCalloutAccessoryView{
 //               performSegue(withIdentifier: "showPlaceDetail", sender: places[annotation.id])
            }
        }
    }
    
}

extension MapViewController: CLLocationManagerDelegate{
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.last?.coordinate {
//            let region = MKCoordinateRegion(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
////            mapView.setRegion(region, animated: true)
//        }
//    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorization()
    }
}
