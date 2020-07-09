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
    
    var images = [
        UIImage(named: "04be8e18cb112fcd23312797abca0feb"),
        UIImage(named: "trifon")
    ]
    
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var pageForSliderCollectionView: UIPageControl!
    
    
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
        
        sliderCollectionView.delegate = self
        sliderCollectionView.dataSource = self
        
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

extension PlaceDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = sliderCollectionView.dequeueReusableCell(withReuseIdentifier: "image", for: indexPath)
        if let vc = cell.viewWithTag(11) as? UIView {
            if let vc2 = vc.viewWithTag(111) as? UIImageView {
            vc2.image = images[indexPath.row]
                
         print("!!!")
            }
        }
        return cell
    }
}

extension PlaceDetailViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = sliderCollectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
