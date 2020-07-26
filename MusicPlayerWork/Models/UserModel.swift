//
//  UserModel.swift
//  MusicPlayerWork
//
//  Created by Mac on 25.07.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import RealmSwift

class UserModel: Object {
    @objc dynamic var userEmailAddress : String = ""
    @objc dynamic var userName : String = ""
    @objc dynamic var userPassword : String = ""
    @objc dynamic var userListenCount : Int = 0
}
