//
//  ViewController.swift
//  MusicPlayerWork
//
//  Created by Mac on 25.07.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import AVFoundation

class MusicPlayerViewController: UIViewController {
    
    private var player : AVAudioPlayer!
    
    private let musicNames : [String] = ["Bölüm 1","Bölüm 2","Bölüm 3","Bölüm 4","Bölüm 5","Bölüm 6"]
    private let collectionViewHeaderIdentifier = "HeaderSection"
    private let collectionViewCellIdentifier = "CellSection"
    
    private var collectionView : UICollectionView!
    private var collectionViewFlowLayout : UICollectionViewFlowLayout!
    override func viewDidLoad() {
     //   
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setCollectionView()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = " "
        self.navigationController?.navigationBar.tintColor = .brown
        self.navigationController?.navigationBar.isHidden = true
    }
}
extension MusicPlayerViewController  {
    func setCollectionView(){
        self.collectionViewFlowLayout = customCollectionViewFlowLayout()
        self.collectionViewFlowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
        self.collectionViewFlowLayout.scrollDirection = .vertical
        
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.collectionViewFlowLayout)
        
        self.collectionView.register(collectionViewCell.self, forCellWithReuseIdentifier: self.collectionViewCellIdentifier)
        self.collectionView.register(collectionViewHeaderSection.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: self.collectionViewHeaderIdentifier)
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = .darkText
        
        self.collectionView.translatesAutoresizingMaskIntoConstraints  = false
        self.view.addSubview(self.collectionView)
        
        self.collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.collectionView.layoutIfNeeded()
    }
}


extension MusicPlayerViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.musicNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.collectionViewCellIdentifier, for: indexPath) as? collectionViewCell else {
            fatalError()
        }
        cell.setTitle(name: self.musicNames[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let newSong:[String: Int] = ["songNumber": indexPath.row]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "songChanged"), object: nil , userInfo: newSong)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.collectionViewHeaderIdentifier, for: indexPath) as? collectionViewHeaderSection else {
            fatalError()
        }
        return header
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 400)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
}

