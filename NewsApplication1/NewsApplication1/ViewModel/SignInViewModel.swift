//
//  SignInViewModel.swift
//  NewsApplication1
//
//  Created by Lakshmi Donthamsetti on 29/08/23.
//

import Foundation
import CoreData

func validateLogin(userNameInput:String, passwordInput:String) -> Bool {
    
    var bool:Bool = false
    
    let fetchRequest = NSFetchRequest<Entity>(entityName: "Entity")
    let predicate = NSPredicate(format: "userName==%@", userNameInput as CVarArg)
    fetchRequest.predicate = predicate

    do {
        guard let result = try
                PersistentStorage.shared.persistentContainer.viewContext.fetch(fetchRequest) as? [Entity] else {
            return false
        }
        result.forEach( {
            if (userNameInput == $0.userName && passwordInput == $0.password) {
                bool = true
                username =  userNameInput
            }
        } )
    } catch let error {
        debugPrint(error)
    }
    
    return bool
}
