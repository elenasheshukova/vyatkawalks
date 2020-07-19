//
//  PlaceDetailViewController.swift
//  vyatkawalks
//
//  Created by Елена Червоткина on 22.06.2020.
//

import UIKit
import MapKit

class PlaceDetailViewController: UIViewController {
    
    var place: PlaceEntity? {
        didSet {
            for image in place?.images?.allObjects as! [ImageEntity] {
                if let imageName = image.name {
                    if let img = UIImage(named: imageName){
                        self.images.append(img)
                    }
                }
            }
            if self.images.count < 1, let imageName = place?.image {
                if let img = UIImage(named: imageName){
                    self.images.append(img)
                }
            }
        }
    }
    var images : [UIImage] = []
    var timer = Timer()
    var counter = 0
    
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var pageForSliderCollectionView: UIPageControl!
    
    @IBOutlet weak var textLabel: UILabel! {
        didSet {
            textLabel.text = place?.text
            textLabel.sizeToFit()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = place?.name
        
        sliderCollectionView.delegate = self
        sliderCollectionView.dataSource = self
        
        pageForSliderCollectionView.numberOfPages = images.count
        pageForSliderCollectionView.currentPage = 0
        if images.count <= 1 {
            pageForSliderCollectionView.isHidden = true
        }
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
    }
    
    @objc func changeImage(){
        if counter < images.count{
            let index = IndexPath.init(item: counter, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
        }
        pageForSliderCollectionView.currentPage = counter
        counter += 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMapForPlace" {
            if let vc = segue.destination as? MapViewController,  place != nil{
                var places : [PlaceEntity] = []
                places.append(place!)
                vc.places = places
                vc.route = false
                vc.isDetailPlace = true
            }
        }
    }
}

extension PlaceDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = sliderCollectionView.dequeueReusableCell(withReuseIdentifier: "image", for: indexPath)
        if let vc = cell.viewWithTag(11) {
            if let vc2 = vc.viewWithTag(111) as? UIImageView {
                vc2.image = images[indexPath.row]
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
