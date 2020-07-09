//
//  MapViewController.swift
//  vyatkawalks
//
//  Created by Елена Червоткина on 25.06.2020.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var locationManager = CLLocationManager()
    var places: [PlaceEntity] = []
    var route: Bool = false
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        var annotations: [MKPointAnnotation] = []
        
        for i in 0..<places.count {
            let place = places[i]
            if let latitude = place.coordinateLatitude, let longitude = place.coordinateLongitude {
                let annotation = PlaceMKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: Double(latitude) ?? 0, longitude: Double(longitude) ?? 0)
                annotation.title = place.name ?? ""
                annotation.subtitle = place.address ?? ""
                annotation.imageURL = place.image ?? ""
                annotation.id = i
                annotations.append(annotation)
            }
        }
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(annotations, animated: true)
            
        //Рисуем маршрут
        if route && annotations.count > 1 {
            for i in 0..<annotations.count - 1 {
                let startPoint = MKPlacemark(coordinate: annotations[i].coordinate)
                let endPoint = MKPlacemark(coordinate: annotations[i + 1].coordinate)
                let requestDirections = MKDirections.Request()
                    requestDirections.source = MKMapItem(placemark: startPoint)
                requestDirections.destination = MKMapItem(placemark: endPoint)
                requestDirections.transportType = .walking
                let directions = MKDirections(request: requestDirections)
                directions.calculate { (response, error) in
                    // guard response = response else { return }
                    for route in response!.routes {
                        self.mapView.addOverlay(route.polyline)
                    }
                }
            }
        }
                
                
        if let location = annotations.first?.coordinate {
            mapView.setRegion(MKCoordinateRegion(center: location, latitudinalMeters: 500, longitudinalMeters: 500), animated: true)
        }
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
            mapView.showsUserLocation = true
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
            
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            if let imageURL = placeAnnotation?.imageURL {
                let leftIconView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 53, height: 53))
                leftIconView.image = UIImage(named: imageURL)
                annotationView?.leftCalloutAccessoryView = leftIconView
                //annotationView?.detailCalloutAccessoryView = leftIconView
                //let offset = CGPoint(x: leftIconView.frame.size.width / 2, y: -(leftIconView.frame.size.height / 2) )
                //annotationView?.centerOffset = offset
            }
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation as? PlaceMKPointAnnotation {
            if control == view.rightCalloutAccessoryView{
                performSegue(withIdentifier: "showPlaceDetail", sender: places[annotation.id])
            }
        }
    }
    
}

extension MapViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorization()
    }
}
