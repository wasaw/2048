//
//  DatabaseService.swift
//  2048
//
//  Created by Александр Меренков on 2/18/22.
//

import CoreData
import UIKit

class DatabaseService {
    
//    MARK: - Properties
    
    static let shared = DatabaseService()
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func saveBestScore(score: Int) {
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Score")
        do {
            let result = try context.fetch(fetchRequest)
            if (!result.isEmpty) {
                let deleteObject = result.first as! NSManagedObject
                context.delete(deleteObject)
            }
            guard let entity = NSEntityDescription.entity(forEntityName: "Score", in: context) else { return }
            let newScore = NSManagedObject(entity: entity, insertInto: context)
            
            newScore.setValue(score, forKey: "best")
            do {
                try context.save()
            } catch let error as NSError {
                print(error)
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    func getBestScore() -> Int {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Score")
        
        do {
            let result = try context.fetch(fetchRequest)
            for data in result {
                if let data = data as? NSManagedObject {
                    let score = data.value(forKey: "best") as? Int ?? 0
                    return score
                }
            }
        } catch let error as NSError {
            print(error)
        }
        
        return 0
    }
}
