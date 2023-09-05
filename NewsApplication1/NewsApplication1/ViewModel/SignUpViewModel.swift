//
//  SignUpViewModel.swift
//  NewsApplication1
//
//  Created by Lakshmi Donthamsetti on 29/08/23.
//

import Foundation
import CoreData

class RegisterViewModel{
    
    init(){}
    var logData:[Entity] = []

    
    func CreateUser(user: inout userDetails){
        let userEntity = Entity(context: PersistentStorage.shared.persistentContainer.viewContext)
        userEntity.userName = user.userName
        userEntity.firstName = user.firstName
        userEntity.email = user.email
        userEntity.lastName = user.lastName
        userEntity.phoneNo = user.phoneNo
        userEntity.password = user.password
        PersistentStorage.shared.saveContext()
    }
    
    func fetchUser(){
        do{
            guard let result = try
                    PersistentStorage.shared.persistentContainer.viewContext.fetch(Entity.fetchRequest()) as? [Entity] else {return}
            result.forEach({debugPrint($0.userName)})
            result.forEach({logData.append($0)})
            debugPrint(logData)
        }catch let error{ debugPrint(error) }
    }
    
    func fetchByIdentifier(byIdentifier userName:String) -> Entity? {
        
        let fetchRequest = NSFetchRequest<Entity>(entityName: "Entity")
        let predicate = NSPredicate(format: "userName=%@", userName as CVarArg)
        fetchRequest.predicate = predicate
        var record:Entity?
        
        do{
            guard let result = try PersistentStorage.shared.persistentContainer.viewContext.fetch(fetchRequest).first as Entity? else { return nil}
            return result
        }catch let error{debugPrint(error)}
        return record
    }
    
    func deleteUser(byIdentifier userName:String) -> Bool{
        let record = fetchByIdentifier(byIdentifier: userName)
        guard PersistentStorage.shared.persistentContainer.viewContext.delete(record!) != nil else{ return false}
        PersistentStorage.shared.saveContext()
        return true
    }
    
    func validateUserName(userName name:String)->Bool{
        
        return false
    }
    
}

func validatePhoneNo(_ phoneNo:String) -> String?{
    let valid = /[0-9]{10,10}/
    guard (phoneNo.wholeMatch(of: valid) != nil) else{
        return "Invalid Phone No"
    }
    if phoneNo.count != 10{
        return "Phone No must contain 10 digits"
    }
    
    var letterCount = 0
    var digitCount = 0

    for uni in phoneNo.unicodeScalars {
        if letters.contains(uni) {
            letterCount += 1
        } else if digits.contains(uni) {
            digitCount += 1
        }
    }

    return nil
}

func validateFirstName(_ firstName:String) -> String?{
    let valid = /[A-Z]+[A-Za-z]{3,10}/
    
    
    for currentCharacter in firstName.unicodeScalars {
        if upperCase.contains(currentCharacter) {
            print("Character code \(currentCharacter) is UPPERCASE.")
        } else {
            print("Character code \(currentCharacter) is neither upper- nor lowercase.")
        }
    }
    
    guard (firstName.wholeMatch(of: valid) != nil) else{
        return "First Name should start with Uppercase and contain min 3 and max 10 alphabets"
    }
    return nil
}

func validateLastName(_ lastName:String) -> String?{
    let valid = /[A-Z]*[a-z]+[A-Z]*/
    guard ((lastName.wholeMatch(of: valid)) != nil) else{
        return "lastName should contain only alphabets"
    }
    return nil
}

func validateEmail(_ email:String) -> String?{
    let valid = /[a-zA-Z0-9]+@[a-zA-Z0-9]+.[a-zA-Z]{2,64}/
    guard ((email.wholeMatch(of: valid)) != nil) else{
        return "Invalid email address"
    }
    return nil
}
func validateUserName(_ userName:String) -> String?{
    let valid = /[a-zA-Z0-9_&$#()@]{3,15}/
    
    guard ((userName.wholeMatch(of: valid)) != nil) else{
        return "Invalid User Name"
    }
    return nil
}
func validatePassword(_ password:String) -> String?{
    let a = "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}"
    let valid = /[a-zA-Z0-9%$#@!~^&*()_`+={}|";':<>,.?]{6,15}/
    guard ((password.wholeMatch(of: valid)) != nil) else{
        return "Invalid password"
    }
    return nil
}
