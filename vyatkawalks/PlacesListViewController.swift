//
//  PlacesListViewController.swift
//  vyatkawalks
//
//  Created by Елена Червоткина on 31.05.2020.
//

import UIKit
import CoreData
import MapKit

class PlacesListViewController: MapViewController {
    
    let appDelegate = (UIApplication.shared.delegate as? AppDelegate)!
    var places: [PlaceEntity]?
    
    @IBOutlet weak var placesListSegmentedControl: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationController?.navigationBar.topItem?.backBarButtonItem?.title = "Назад"
        
        listTableView.isHidden = true
        mapView.isHidden = false
        
        listTableView.delegate = self
        listTableView.dataSource = self
        mapView.delegate = self
        
        mapView.showsUserLocation = true
        
        let request: NSFetchRequest<PlaceEntity> = PlaceEntity.fetchRequest()
        do {
            places = try appDelegate.persistentContainer.viewContext.fetch(request)
            
                    var annotations: [MKPointAnnotation] = []
            
                    for i in 0..<places!.count {
                        let place = places![i]
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
            
        } catch {
            print(error)
        }
        
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch placesListSegmentedControl.selectedSegmentIndex {
        case 0:
            listTableView.isHidden = true
            mapView.isHidden = false
        case 1:
            mapView.isHidden = true
            listTableView.isHidden = false
        default: break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showMap" {
//            if let vc = segue.destination as? MapViewController {
//                vc.places = places ?? []
//            }
//        }
        if segue.identifier == "showPlaceDetail" {
            if let vc = segue.destination as? PlaceDetailViewController {
                vc.place = sender as? PlaceEntity
            }
        }
    }
}

extension PlacesListViewController: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return places!.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if let cell = Bundle.main.loadNibNamed("PlacesListTableViewCell", owner: self, options: nil)?.first as? PlacesListTableViewCell {
                cell.placeImageView.image = UIImage(named: places![indexPath.row].image ?? "")
                cell.nameLabel.text = places![indexPath.row].name ?? ""
                cell.addressLabel.text = places![indexPath.row].address ?? ""
                return cell
            }
            return UITableViewCell()
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let place = places![indexPath.row]
            self.performSegue(withIdentifier: "showPlaceDetail", sender: place)
        }
        
}
