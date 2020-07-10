//
//  WalkDetailViewController.swift
//  vyatkawalks
//
//  Created by Елена Червоткина on 02.06.2020.
//

import UIKit
import CoreData

class WalkDetailViewController: UIViewController {

    let appDelegate = (UIApplication.shared.delegate as? AppDelegate)!
    var walk: WalkEntity?
    var places: [PlaceEntity]?
    
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
    
    func getPlaces() -> [PlaceEntity] {
        var places: [PlaceEntity] = []
        let request: NSFetchRequest<PlaceEntity> = PlaceEntity.fetchRequest()
//        if let walkID = walk?.id {
//            let predicate = NSPredicate(format: "ANY walk.id == %@", walkID)
//            request.predicate = predicate
//        }
//        do {
//            places = try appDelegate.persistentContainer.viewContext.fetch(request)
//        } catch {
//            print(error)
//        }
        if let placesId = walk?.placesid?.components(separatedBy: " "){
            for id in placesId {
                let predicate = NSPredicate(format: "id == %@", id)
                request.predicate = predicate
                do {
                    places += try appDelegate.persistentContainer.viewContext.fetch(request)
                } catch {
                    print(error)
                }
            }
        }
        return places
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if places == nil {
            places = getPlaces()
        }
        if segue.identifier == "showMap" {
            if let vc = segue.destination as? MapViewController {
                vc.places = places ?? []
                vc.route = true
            }
        }
        if segue.identifier == "showList" {
            if let vc = segue.destination as? ListViewController {
                vc.places = places ?? []
            }
        }
    }
    
}
