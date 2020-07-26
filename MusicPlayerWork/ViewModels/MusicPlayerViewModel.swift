//
//  MusicPlayerViewModel.swift
//  MusicPlayerWork
//
//  Created by Mac on 25.07.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import RxSwift


class MusicPlayerViewModel {
    var currentUser = PublishSubject<UserModel>()
    private let userDataManager = UserDataManager()
    private let disposeBag = DisposeBag()
    func getCurrentUserInformation(){
        self.userDataManager.currentUserValue.asObserver().map { (user) in
            self.currentUser.onNext(user)
        }.subscribe().disposed(by: disposeBag)
        
        self.userDataManager.getCurrentUserInformations()
    }
    func deleteCurrentUserInformation(complition : (Result<Bool , UserModelErrors>)->Void){
        self.userDataManager.deleteCurrentUserInformations { res in
          switch res {
          case .failure(let error ):
            complition(.failure(error))
          case .success(let stat):
            if stat == true {
                UserDefaults.standard.removeObject(forKey: "username")
                UserDefaults.standard.synchronize()
            }
            complition(.success(stat))
            }
        }
    }
}
extension UIViewController {
    static func getLastViewController()-> UIViewController{
        let scene = UIApplication.shared.connectedScenes.first
        if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
            if let lastViewController = sd.window?.rootViewController?.children.last{
                return lastViewController
            }
        }
        return UIViewController()
    }
    
    
    static func seguePage(withController : UIViewController){
        if let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            if let window = scene.window{
                        UIView.transition(with: window, duration: 0.70, options: .transitionFlipFromTop, animations: {
                                let nav1 = UINavigationController()
                                nav1.viewControllers = [withController]
                                nav1.navigationBar.isHidden = true
                                scene.window!.rootViewController = nav1
                                scene.window?.makeKeyAndVisible()
                        }, completion: nil)
                    }
        }
            
    }
}
