//
//  UserDataManager.swift
//  MusicPlayerWork
//
//  Created by Mac on 25.07.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

enum UserModelErrors : String , Error {
    case invalidData  = "Gelen veri hatalı"
    case typeError  = "Gelen veri tiplerinde hatalar var"
    case errorOccured  = "Bir hata meydana geldi"
}

class UserDataManager {
    private let realm = try! Realm()
    var currentUserValue = PublishSubject<UserModel>()
    func login( _ user : UserModel , complition :@escaping( Result<UserModel , UserModelErrors>)->Void){
        do {
            try realm.write{
                realm.add(user)
                print("Saved")
            }
            complition(.success(user))
        }catch {
            complition(.failure(.errorOccured))
        }
    }
    func getCurrentUserInformations(){
        if let username = UserDefaults.standard.string(forKey: "username") {
            let mSavedItems = realm.objects(UserModel.self)
            guard let currentUser = mSavedItems.filter({$0.userName == username}).first else {return}
            self.currentUserValue.onNext(currentUser)
        }
    }
    func deleteCurrentUserInformations(complition : (Result<Bool , UserModelErrors>)->Void){
        if let username = UserDefaults.standard.string(forKey: "username") {
            let savedItems = realm.objects(UserModel.self)
            guard let currentUser = savedItems.filter(
                {
                  $0.userName == username
                }
            ).first else {
                return
            }
            do {
                try realm.write{
                    realm.delete(currentUser)
                }
                complition(.success(true))
            }
            catch {
                complition(.failure(.errorOccured))
            }
        }else {
            complition(.failure(.invalidData))
        }
    }
}
