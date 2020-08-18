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
    @IBOutlet weak var mapViewContainer: UIView!
    @IBOutlet weak var listTableView: UITableView!
    
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
        mapViewContainer.isHidden = true
        descriptionView.isHidden = false
        
        listTableView.delegate = self
        listTableView.dataSource = self
    }

    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch placesListSegmentedControl.selectedSegmentIndex {
        case 0:
            listTableView.isHidden = true
            mapViewContainer.isHidden = true
            descriptionView.isHidden = false
        case 1:
            descriptionView.isHidden = true
            listTableView.isHidden = true
            mapViewContainer.isHidden = false
        case 2:
            descriptionView.isHidden = true
            mapViewContainer.isHidden = true
            listTableView.isHidden = false
        default: break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMap" {
            if let vc = segue.destination as? MapViewController {
                //vc.places = self.places
                vc.isWalk = true
            }
        }
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
