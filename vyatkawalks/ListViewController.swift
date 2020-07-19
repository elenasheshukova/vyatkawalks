//
//  ListViewController.swift
//  vyatkawalks
//
//  Created by Елена Червоткина on 25.06.2020.
//

import UIKit

class ListViewController: UIViewController {
        
    var places: [PlaceEntity] = []

    @IBOutlet weak var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        listTableView.delegate = self
        listTableView.dataSource = self
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPlaceDetail" {
            if let vc = segue.destination as? PlaceDetailViewController {
                vc.place = sender as? PlaceEntity
            }
        }
    }
        
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return places.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = listTableView.dequeueReusableCell(withIdentifier: "placeCell") as! PlacesListTableViewCell
            cell.placeImageView.image = UIImage(named: places[indexPath.row].image ?? "")
            cell.nameLabel.text = places[indexPath.row].name ?? ""
            cell.addressLabel.text = places[indexPath.row].address ?? ""
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let place = places[indexPath.row]
            self.performSegue(withIdentifier: "showPlaceDetail", sender: place)
        }
        
}
