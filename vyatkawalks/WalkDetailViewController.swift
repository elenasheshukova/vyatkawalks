//
//  WalkDetailViewController.swift
//  vyatkawalks
//
//  Created by Елена Червоткина on 02.06.2020.
//

import UIKit

class WalkDetailViewController: UIViewController {

    var walk: WalkEntity? {
        didSet {
            if let placesId = walk?.placesid?.components(separatedBy: " "){
                for id in placesId {
                    if let place = (walk?.places?.allObjects as! [PlaceEntity]).first(where: {$0.id == id}) {
                        self.places.append(place)
                    }
                }
            }
        }
    }
    var places: [PlaceEntity] = []
    
    @IBOutlet weak var placesListSegmentedControl: UISegmentedControl!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var mapViewContainer: UIView!
    @IBOutlet weak var listViewContainer: UIView!
    
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
        
        listViewContainer.isHidden = true
        mapViewContainer.isHidden = true
        descriptionView.isHidden = false
    }

    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch placesListSegmentedControl.selectedSegmentIndex {
        case 0:
            listViewContainer.isHidden = true
            mapViewContainer.isHidden = true
            descriptionView.isHidden = false
        case 1:
            descriptionView.isHidden = true
            listViewContainer.isHidden = true
            mapViewContainer.isHidden = false
        case 2:
            descriptionView.isHidden = true
            mapViewContainer.isHidden = true
            listViewContainer.isHidden = false
        default: break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMap" {
            if let vc = segue.destination as? MapViewController {
                vc.places = places
                vc.route = true
            }
        }
        if segue.identifier == "showList" {
            if let vc = segue.destination as? ListViewController {
                vc.places = places
            }
        }
    }
    
}
