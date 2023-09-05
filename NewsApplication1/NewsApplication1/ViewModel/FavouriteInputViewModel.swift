//
//  FavouriteInputViewModel.swift
//  NewsApplication1
//
//  Created by Madhu Mangadoddi on 05/09/23.
//

import Foundation
import CoreData
class FavouriteInputViewModel{
    var dummy : [Marked]!
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
    
}
