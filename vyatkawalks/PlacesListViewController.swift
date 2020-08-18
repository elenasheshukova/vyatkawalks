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
    @IBOutlet weak var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationController?.navigationBar.topItem?.backBarButtonItem?.title = "Назад"
        
        listTableView.isHidden = true
        mapViewContainer.isHidden = false
        
        listTableView.delegate = self
        listTableView.dataSource = self
        
        let request: NSFetchRequest<PlaceEntity> = PlaceEntity.fetchRequest()
        do {
            places = try appDelegate.persistentContainer.viewContext.fetch(request)
        } catch {
            print(error)
        }
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch placesListSegmentedControl.selectedSegmentIndex {
        case 0:
            listTableView.isHidden = true
            mapViewContainer.isHidden = false
        case 1:
            mapViewContainer.isHidden = true
            listTableView.isHidden = false
        default: break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMap" {
            if let vc = segue.destination as? MapViewController {
                vc.places = places ?? []
            }
        }
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
