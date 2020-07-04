//
//  PlaceDetailViewController.swift
//  vyatkawalks
//
//  Created by Елена Червоткина on 22.06.2020.
//

import UIKit
import MapKit

class PlaceDetailViewController: UIViewController {
    
    var place: PlaceEntity?
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            guard let image = place?.image else {return}
            imageView.image = UIImage(named: image)
               }
    }
    
    @IBOutlet weak var textLabel: UILabel! {
        didSet {
            textLabel.text = place?.text
            textLabel.sizeToFit()
        }
    }
    
   // @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //mapView.delegate = self
        
        self.title = place?.name
        
//        if let latitude = place?.coordinateLatitude, let longitude = place?.coordinateLongitude {
//            let annotation = PlaceMKPointAnnotation()
//            annotation.coordinate = CLLocationCoordinate2D(latitude: Double(latitude) ?? 0, longitude: Double(longitude) ?? 0)
//            annotation.title = place?.name ?? ""
//            annotation.subtitle = place?.address ?? ""
//            annotation.imageURL = place?.image ?? ""
//            mapView.addAnnotations([annotation])
//            mapView.showAnnotations([annotation], animated: true)
//            print("!!!!!!!!")
//        }
//         mapView.isHidden = false
//
        
    }
    
}
