//
//  LoginVCViewModel.swift
//  MusicPlayerWork
//
//  Created by Mac on 25.07.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation


class LoginVCViewModel {
    private let userDataManager : UserDataManager = UserDataManager()
    func loginUser(email : String , username : String , password: String , complition :@escaping( Result<UserModel , UserModelErrors>)->Void) {
        let user = UserModel()
        user.userEmailAddress = email
        user.userName = username
        user.userPassword = password
        user.userListenCount = 0
        self.userDataManager.login(user) { (res) in
            switch res {
            case .failure(let error):
                complition(.failure(error))
            case .success(let user):
                complition(.success(user))
            }
        }
    }
}
