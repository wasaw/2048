//
//  DatabaseService.swift
//  2048
//
//  Created by Александр Меренков on 2/18/22.
//

import CoreData
import UIKit

final class DatabaseService {
    static let shared = DatabaseService()
    
//    MARK: - Properties
        
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func saveBestScore(score: Int, completion: @escaping(ResultStatus<Bool>) -> Void) {
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
                completion(.success(true))
            } catch {
                completion(.failure(CoreDataError.notSave))
            }
        } catch {
            completion(.failure(CoreDataError.notSave))
        }
    }
    
    func getBestScore(completion: @escaping(ResultStatus<Int>) -> Void) {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Score")
        
        do {
            let result = try context.fetch(fetchRequest)
            for data in result {
                if let data = data as? NSManagedObject {
                    let score = data.value(forKey: "best") as? Int ?? 0
                    completion(.success(score))
                }
            }
        } catch {
            completion(.failure(CoreDataError.notRead))
        }
    }
}
