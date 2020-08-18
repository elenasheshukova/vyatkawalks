//
//  WalkDetailViewController.swift
//  vyatkawalks
//
//  Created by Елена Червоткина on 02.06.2020.
//

import UIKit
import  MapKit

class WalkDetailViewController: MapViewController {

    var walk: WalkEntity? {
        didSet {
//            if let placesId = walk?.placesid?.components(separatedBy: " "){
//                for id in placesId {
//                    if let place = (walk?.places?.allObjects as! [PlaceEntity]).first(where: {$0.id == id}) {
//                        self.places.append(place)
//                    }
//                }
//            }
            
            self.stops = walk?.stops?.allObjects as! [WalksStopEntity]
        }
    }
    var stops: [WalksStopEntity] = []
    
    
    @IBOutlet weak var placesListSegmentedControl: UISegmentedControl!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            guard let image = walk?.image else {return}
            imageView.image = UIImage(named: image)
        }
    }
    
    @IBOutlet weak var textLabel: UILabel!{
        didSet {
            textLabel.text = walk?.text
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = walk?.name
        
        listTableView.isHidden = true
        mapView.isHidden = true
        descriptionView.isHidden = false
        
        listTableView.delegate = self
        listTableView.dataSource = self
        
        mapView.delegate = self
        
        var annotations: [MKPointAnnotation] = []
        
        for i in 0..<stops.count {
            let stop = stops[i]
            if let latitude = stop.place?.coordinateLatitude, let longitude = stop.place?.coordinateLongitude {
                let annotation = PlaceMKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: Double(latitude) ?? 0, longitude: Double(longitude) ?? 0)
                annotation.title = stop.name ?? ""
                annotation.subtitle = stop.place?.address ?? ""
                annotation.imageURL = stop.image ?? ""
                annotation.id = i
                annotations.append(annotation)
            }
        }
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(annotations, animated: true)
        
        //Рисуем маршрут
        if annotations.count > 1 {
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
        
        //Центрируем карту
        if let location = annotations.first?.coordinate {
            mapView.setRegion(MKCoordinateRegion(center: location, latitudinalMeters: 500, longitudinalMeters: 500), animated: true)
        }
        
    }

    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch placesListSegmentedControl.selectedSegmentIndex {
        case 0:
            listTableView.isHidden = true
            mapView.isHidden = true
            descriptionView.isHidden = false
        case 1:
            descriptionView.isHidden = true
            listTableView.isHidden = true
            mapView.isHidden = false
        case 2:
            descriptionView.isHidden = true
            mapView.isHidden = true
            listTableView.isHidden = false
        default: break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPlaceDetail" {
            if let vc = segue.destination as? PlaceDetailViewController {
                vc.place = sender as? PlaceEntity
            }
        }
    }
    
}

extension WalkDetailViewController: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return stops.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            print(stops[indexPath.row].name ?? "")
            //let cell = listTableView.dequeueReusableCell(withIdentifier: "placeCell") as! PlacesListTableViewCell
            if let cell = Bundle.main.loadNibNamed("PlacesListTableViewCell", owner: self, options: nil)?.first as? PlacesListTableViewCell {
                cell.placeImageView.image = UIImage(named: stops[indexPath.row].image ?? "")
                cell.nameLabel.text = stops[indexPath.row].name ?? ""
                cell.addressLabel.text = stops[indexPath.row].place?.address ?? ""
                return cell
            }
            return UITableViewCell()
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let place = stops[indexPath.row].place!
            self.performSegue(withIdentifier: "showPlaceDetail", sender: place)
        }
        
}
