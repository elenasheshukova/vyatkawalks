//
//  ViewController.swift
//  vyatkawalks
//
//  Created by Елена Червоткина on 31.05.2020.
//

import UIKit
import  CoreData

class WalksListViewController: UIViewController {
    
    @IBOutlet weak var walksListCollectionView: UICollectionView!
    
    var walks: [WalkEntity] = []
    
    let appDelegate = (UIApplication.shared.delegate as? AppDelegate)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        walksListCollectionView.dataSource = self
        walksListCollectionView.delegate = self
        
        let request: NSFetchRequest<WalkEntity> = WalkEntity.fetchRequest()
        do {
            walks = try appDelegate.persistentContainer.viewContext.fetch(request)
        } catch {
            print(error)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWalkDetail" {
            if let vc = segue.destination as? WalkDetailViewController {
                vc.walk = sender as? WalkEntity
            }
        }
    }

}

extension WalksListViewController: UICollectionViewDataSource, UICollectionViewDelegate/*, UICollectionViewDelegateFlowLayout*/{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return walks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = walksListCollectionView.dequeueReusableCell(withReuseIdentifier: "walksListCell", for: indexPath) as? WalksListCollectionViewCell {
            
            cell.nameLabel.attributedText = NSMutableAttributedString(string: walks[indexPath.item].name ?? "", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17)])
            //cell.nameLabel.text = walks[indexPath.item].name
            
            cell.imageView.image = UIImage(named: walks[indexPath.item].image ?? "")
            if let places = walks[indexPath.item].places {
                cell.countPlacesLabel.text = declensionOfNouns(number: places.count, form1: "остановка", form2: "остановки", form3: "остановок")
            } else {
                cell.countPlacesLabel.text = ""
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let walk = walks[indexPath.item]
        self.performSegue(withIdentifier: "showWalkDetail", sender: walk)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 200, height: 200)
//    }
    
    
    func declensionOfNouns(number: Int, form1: String, form2: String, form3: String) -> String {
        var str = ""
        if number >= 11 && number <= 19 {
            str = form3
        }
        else {
            var rest = number
            while rest > 10 {
                rest = rest % 10
            }
            switch rest {
            case 1:
                str = form1
            case 2, 3, 4:
                str = form2
            default:
                str = form3
            }
        }
        return "\(number) \(str)"
    }
}
