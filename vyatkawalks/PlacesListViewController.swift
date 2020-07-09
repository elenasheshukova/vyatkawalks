//
//  PlacesListViewController.swift
//  vyatkawalks
//
//  Created by Елена Червоткина on 31.05.2020.
//

import UIKit
import CoreData

class PlacesListViewController: UIViewController {
    
    let appDelegate = (UIApplication.shared.delegate as? AppDelegate)!
    var places: [PlaceEntity]?
    
    @IBOutlet weak var placesListSegmentedControl: UISegmentedControl!
    @IBOutlet weak var mapViewContainer: UIView!
    @IBOutlet weak var listViewContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationController?.navigationBar.topItem?.backBarButtonItem?.title = "Назад"
        
        listViewContainer.isHidden = true
        mapViewContainer.isHidden = false
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch placesListSegmentedControl.selectedSegmentIndex {
        case 0:
            listViewContainer.isHidden = true
            mapViewContainer.isHidden = false
        case 1:
            mapViewContainer.isHidden = true
            listViewContainer.isHidden = false
        default: break
        }
    }

    func getPlaces() -> [PlaceEntity] {
        var places: [PlaceEntity] = []
        let request: NSFetchRequest<PlaceEntity> = PlaceEntity.fetchRequest()
        let predicate = NSPredicate(format: "image != %@", "")
        request.predicate = predicate
        do {
            places = try appDelegate.persistentContainer.viewContext.fetch(request)
        } catch {
            print(error)
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
            }
        }
        if segue.identifier == "showList" {
            if let vc = segue.destination as? ListViewController {
                vc.places = places ?? []
            }
        }
    }
}
