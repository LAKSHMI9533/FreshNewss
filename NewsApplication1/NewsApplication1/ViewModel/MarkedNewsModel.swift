//
//  MarkedNewsModel.swift
//  NewsApplication1
//
//  Created by Madhu Mangadoddi on 05/09/23.
//

import Foundation
import CoreData
class MarkedNewsModel{
    var dummy : [Marked]!
    
    func fetching()->[Marked]{
        do{
            let fetchRequest = NSFetchRequest<Marked>(entityName: "Marked")

            let results = try PersistentStorage.shared.persistentContainer.viewContext.fetch(fetchRequest)
            return results
        }catch{
            print(error)
        }
        return dummy
    }
    func fetching(titleToSearch :  String)->[Marked]{
        let fetchRequest = NSFetchRequest<Marked>(entityName: "Marked")
        fetchRequest.predicate = NSPredicate(format: "title == %@", titleToSearch)

        do{
            let results = try PersistentStorage.shared.persistentContainer.viewContext.fetch(fetchRequest)
            return results
            //dummy = results
        }catch{
            print(error)
        }
        return dummy
    }
    func DeleteOperation (ob : NSManagedObject) -> Bool{
       let context  = PersistentStorage.shared.persistentContainer.viewContext
       context.delete(ob)
       print("deleted")
       do{
           try context.save()
       }catch{
           print(error)
       }
       return true
   }
    func DeetingSearch()-> Bool{
        let fetchRequest = NSFetchRequest<Marked>(entityName: "Marked")
        do{
            let results = try PersistentStorage.shared.persistentContainer.viewContext.fetch(fetchRequest)
            for i in results{
                DeleteOperation(ob: i)
                if i == results.last{
                    return true
                }
            }
        }catch{
            print(error)
        }
        return false

    }
}
