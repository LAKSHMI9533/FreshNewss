//
//  UserDataRepository.swift
//  NewsApplication1
//
//  Created by Lakshmi Donthamsetti on 29/08/23.
//

import Foundation
import CoreData

final class PersistentStorage{
    
    private init(){}
    static let shared = PersistentStorage()
    
    lazy var persistentContainer:NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores{
            description, error in
            if let error = error{
                fatalError("Unable to store persistent stores: \(error)")
            }
        }
        return container
    }()
    
    
    func saveContext(){
        let context = persistentContainer.viewContext
        if context.hasChanges{
            do{
                try context.save()
            }catch{
                let nserror = error as NSError
                fatalError("Unable to store persistent stores: \(nserror)")
            }
        }
    }
}
