//
//  AppDelegate.swift
//  vyatkawalks
//
//  Created by Елена Червоткина on 31.05.2020.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        deleteAllRecords()
        
        let defaults = UserDefaults.standard
        let isPreloaded = defaults.bool(forKey: "isPreloaded")
        if isPreloaded {
            preloadData()
            defaults.set(true, forKey: "isPreloaded")
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
//    static var container: NSPersistentContainer {
//        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer
//    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "vyatkawalks")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    func preloadData(){
        let appDelegate = (UIApplication.shared.delegate as? AppDelegate)!
        
        if let filePath = Bundle.main.path(forResource: "places", ofType: "json") {
            let jsonData = try! String(contentsOfFile: filePath).data(using: .utf8)!
            let places = try! JSONDecoder().decode(Array<Place>.self, from: jsonData)
            for place in places {
                let placeEntity = PlaceEntity(context: appDelegate.persistentContainer.viewContext)
                placeEntity.id = place.id //UUID().uuidString
                placeEntity.name = place.name
                placeEntity.image = place.image
                placeEntity.text = place.text
                placeEntity.address = place.address
                placeEntity.coordinateLatitude = place.coordinateLatitude
                placeEntity.coordinateLongitude = place.coordinateLongitude
                
                for image in place.images {
                    let imageEntity = ImageEntity(context: appDelegate.persistentContainer.viewContext)
                    imageEntity.id = UUID().uuidString
                    imageEntity.name = image
                    imageEntity.place = placeEntity
                }
            }
        }
        
        if let filePath = Bundle.main.path(forResource: "walks", ofType: "json") {
            //let jsonData = try! String(contentsOfFile: "/Users/elenachervotkina/Desktop/Deveioper/vyatkawalks/vyatkawalks/walks.json").data(using: .utf8)!
            let jsonData = try! String(contentsOfFile: filePath).data(using: .utf8)!
            let walks = try! JSONDecoder().decode(Array<Walk>.self, from: jsonData)
            for walk in walks {
                let walkEntity = WalkEntity(context: appDelegate.persistentContainer.viewContext)
                walkEntity.id = walk.id //UUID().uuidString
                walkEntity.name = walk.name
                walkEntity.image = walk.image
                walkEntity.text = walk.text
                walkEntity.placesid = walk.places.joined(separator:" ")
            
//                if walk.places.count > 0 {
//                    let request: NSFetchRequest<PlaceEntity> = PlaceEntity.fetchRequest()
//                    let predicate = NSPredicate(format: "id IN %@", walk.places)
//                    request.predicate = predicate
//                    let pl = try! appDelegate.persistentContainer.viewContext.fetch(request)
//                    walkEntity.places = NSSet(array: pl)
//                }
                
                var sort = 1
                if walk.stops.count > 0 {
                    //print(walk.stops)
                    for stop in walk.stops {
                        let stopEntity = WalksStopEntity(context: appDelegate.persistentContainer.viewContext)
                        stopEntity.id = stop.id
                        stopEntity.name = stop.name
                        stopEntity.text = stop.text
                        stopEntity.image = stop.image
                        stopEntity.walk = walkEntity
                        stopEntity.sort = Int16(sort)
                        sort += 1
                        let request: NSFetchRequest<PlaceEntity> = PlaceEntity.fetchRequest()
                        let predicate = NSPredicate(format: "id == %@", stop.place)
                        request.predicate = predicate
                        let pl = try! appDelegate.persistentContainer.viewContext.fetch(request)
                        stopEntity.place = pl.first!
                    }
                }
            }
        }
        
        appDelegate.saveContext()
    }
    
    func deleteAllRecords() {
        //delete all data
        let appDelegate = (UIApplication.shared.delegate as? AppDelegate)!
        
        let deleteFetchWalk = NSFetchRequest<NSFetchRequestResult>(entityName: "WalkEntity")
        let deleteRequestWalk = NSBatchDeleteRequest(fetchRequest: deleteFetchWalk)
        let deleteFetchStop = NSFetchRequest<NSFetchRequestResult>(entityName: "WalksStopEntity")
        let deleteRequestStop = NSBatchDeleteRequest(fetchRequest: deleteFetchStop)
        let deleteFetchPlace = NSFetchRequest<NSFetchRequestResult>(entityName: "PlaceEntity")
        let deleteRequestPlace = NSBatchDeleteRequest(fetchRequest: deleteFetchPlace)
        let deleteFetchImage = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageEntity")
        let deleteRequestImage = NSBatchDeleteRequest(fetchRequest: deleteFetchImage)

        do {
            try appDelegate.persistentContainer.viewContext.execute(deleteRequestWalk)
            try appDelegate.persistentContainer.viewContext.execute(deleteRequestStop)
            try appDelegate.persistentContainer.viewContext.execute(deleteRequestPlace)
            try appDelegate.persistentContainer.viewContext.execute(deleteRequestImage)
            appDelegate.saveContext()
        } catch {
            print ("There was an error")
        }
        
    }
}
