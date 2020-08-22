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

extension WalksListViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return walks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = walksListCollectionView.dequeueReusableCell(withReuseIdentifier: "walksListCell", for: indexPath) as? WalksListCollectionViewCell {
            
            cell.nameLabel.attributedText = NSMutableAttributedString(string: walks[indexPath.item].name ?? "", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)])
            //cell.nameLabel.text = walks[indexPath.item].name
            
            cell.imageView.image = UIImage(named: walks[indexPath.item].image ?? "")
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let walk = walks[indexPath.item]
        self.performSegue(withIdentifier: "showWalkDetail", sender: walk)
    }
}

extension WalksListViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (walksListCollectionView.frame.width - 10)/2, height: (walksListCollectionView.frame.width - 10)/3)
    }
}
