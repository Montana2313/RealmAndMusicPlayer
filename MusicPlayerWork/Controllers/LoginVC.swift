//
//  LoginVC.swift
//  MusicPlayerWork
//
//  Created by Mac on 25.07.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    private var emailAdress : UITextField!
    private var username : UITextField!
    private var password: UITextField!
    private var loginButton: UIButton!
    private let viewModel : LoginVCViewModel = LoginVCViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor =  .white
        
        self.view.setGradientBackGroundColor(location: [0.0 , 0.4,1.0], startPoint: CGPoint(x: 0, y: 0), startColor: UIColor.systemBlue.cgColor, endPoint: CGPoint(x: 0, y: 1), endColor: UIColor.white.cgColor)
        self.setEmailAdress()
        self.setUsername()
        self.setPassword()
        self.setLoginButton()
    }
}
//MARK:->  UI
extension LoginVC {
    func setEmailAdress(){
        self.emailAdress = UITextField()
        self.emailAdress.layer.borderWidth = 1.0
        self.emailAdress.layer.borderColor  =  UIColor.systemBlue.cgColor
        self.emailAdress.attributedPlaceholder = NSAttributedString(string: "Eposta Adresi",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemBlue])
        self.emailAdress.translatesAutoresizingMaskIntoConstraints  = false
        self.emailAdress.textAlignment = .center
        self.emailAdress.textColor = .systemBlue
        
        self.view.addSubview(self.emailAdress)
        
        self.emailAdress.leftAnchor.constraint(equalTo: self.view.leftAnchor , constant: 24).isActive = true
        self.emailAdress.rightAnchor.constraint(equalTo: self.view.rightAnchor , constant: -24).isActive = true
        self.emailAdress.centerYAnchor.constraint(equalTo: self.view.centerYAnchor , constant:  -50).isActive = true
        self.emailAdress.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.emailAdress.roundCorner(cornerRadius: 10)
    }
    func setUsername(){
          self.username = UITextField()
          self.username.attributedPlaceholder = NSAttributedString(string: "Kullanıcı adı",
                                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemBlue])
        self.username.layer.borderWidth = 1.0
        self.username.layer.borderColor  =  UIColor.systemBlue.cgColor
          self.username.translatesAutoresizingMaskIntoConstraints  = false
          self.username.textAlignment = .center
          self.username.textColor = .systemBlue
          
          self.view.addSubview(self.username)
          
          self.username.leftAnchor.constraint(equalTo: self.view.leftAnchor , constant: 24).isActive = true
          self.username.rightAnchor.constraint(equalTo: self.view.rightAnchor , constant: -24).isActive = true
         self.username.topAnchor.constraint(equalTo: self.emailAdress.bottomAnchor , constant: 10).isActive = true
          self.username.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.username.roundCorner(cornerRadius: 10)
      }
    func setPassword(){
          self.password = UITextField()
        self.password.layer.borderWidth = 1.0
        self.password.attributedPlaceholder = NSAttributedString(string: "Şifre",
          attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemBlue])
        self.password.layer.borderColor  =  UIColor.systemBlue.cgColor
          self.password.translatesAutoresizingMaskIntoConstraints  = false
          self.password.textAlignment = .center
          self.password.textColor = .systemBlue
        self.password.isSecureTextEntry = true
          
          self.view.addSubview(self.password)
          
          self.password.leftAnchor.constraint(equalTo: self.view.leftAnchor , constant: 24).isActive = true
          self.password.rightAnchor.constraint(equalTo: self.view.rightAnchor , constant: -24).isActive = true
          self.password.topAnchor.constraint(equalTo: self.username.bottomAnchor , constant: 10).isActive = true
          self.password.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
         self.password.roundCorner(cornerRadius: 10)
      }
    func setLoginButton(){

          self.loginButton = UIButton()
        self.loginButton.setTitle("Giriş yap", for: .normal)
        self.loginButton.setTitleColor(.white, for: .normal)
        self.loginButton.backgroundColor = .systemBlue
        self.loginButton.translatesAutoresizingMaskIntoConstraints  = false
          
          self.view.addSubview(self.loginButton)
          
          self.loginButton.leftAnchor.constraint(equalTo: self.view.leftAnchor , constant: 24).isActive = true
          self.loginButton.rightAnchor.constraint(equalTo: self.view.rightAnchor , constant: -24).isActive = true
          self.loginButton.topAnchor.constraint(equalTo: self.password.bottomAnchor , constant: 10).isActive = true
          self.loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.loginButton.layer.masksToBounds = true
        self.loginButton.layer.cornerRadius = 10
        self.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        self.loginButton.layoutIfNeeded()
        
        let blur = UIVisualEffectView(effect: UIBlurEffect(style:
            .dark))
        blur.frame = self.loginButton.bounds
        blur.isUserInteractionEnabled = false //This allows touches to forward to the button.
        self.loginButton.insertSubview(blur, at: 0)
      }
    
}
extension LoginVC {
    
    @objc func loginButtonTapped(){
        self.viewModel.loginUser(email: self.emailAdress.text!, username: self.username.text!, password: self.password.text!) { (res) in
            switch res {
            case .failure(let error):
                self.present(UIAlertController.createDefaultAlert(title: "Bilgi", desc: error.rawValue, buttonTitle: "Tamam" ) ,animated: true , completion: nil)
            case .success(let user):
                UserDefaults.standard.set(user.userName, forKey: "username")
                UserDefaults.standard.synchronize()
                UIViewController.seguePage(withController: MusicPlayerViewController())
            }
        }

    }
}

extension UIAlertController {
    static func createDefaultAlert(title :String , desc:String , buttonTitle :String)->UIAlertController{
        let alertController = UIAlertController(title: title, message: desc, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .cancel, handler: nil)
        
        alertController.addAction(action)
        
        return alertController
    }
}


extension UITextField {
    func roundCorner(cornerRadius : CGFloat){
        self.layer.masksToBounds = true
        self.layer.cornerRadius = cornerRadius
    }
}
extension UIView {
    func setGradientBackGroundColor(location : [NSNumber]? , startPoint : CGPoint , startColor : CGColor , endPoint : CGPoint , endColor : CGColor){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [startColor , endColor]
        gradient.locations = location
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        self.layer.insertSublayer(gradient, at: 0)
    }
}






