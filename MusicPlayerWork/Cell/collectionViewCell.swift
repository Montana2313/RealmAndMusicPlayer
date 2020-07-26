//
//  collectionViewCell.swift
//  MusicPlayerWork
//
//  Created by Mac on 25.07.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import AVFoundation


class collectionViewCell: UICollectionViewCell {
    private var musicTitleLabel : UILabel!
    var backgroundImageView: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundImageView  = UIImageView()
        self.backgroundImageView.frame = self.bounds
        self.backgroundImageView.image = UIImage(named: "bgImage.jpg")
        self.addSubview(backgroundImageView)
        backgroundImageView.isHidden = true
        let regularBlur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: regularBlur)
        blurView.frame = backgroundImageView.bounds
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        backgroundImageView.addSubview(blurView)
        backgroundImageView.isHidden = false

        self.setMusicTitleLabel()
    }
    private func setMusicTitleLabel(){
        self.musicTitleLabel = UILabel()
        self.musicTitleLabel.font = UIFont(name: "Avenir-Heavy", size: 20.0)
        self.addSubview(self.musicTitleLabel)
        self.musicTitleLabel.textColor = .white
        self.musicTitleLabel.textAlignment = .center
        self.musicTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.musicTitleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.musicTitleLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.musicTitleLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setTitle(name :String){
        self.musicTitleLabel.text = name
    }
}

class customCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttrbs = super.layoutAttributesForElements(in: rect)
        
        
        layoutAttrbs?.forEach({ (attrb) in
            if attrb.representedElementKind == UICollectionView.elementKindSectionHeader {
                guard let collectionView = collectionView else {return}
                let contentOffsetY = collectionView.contentOffset.y
                if contentOffsetY > 0 {
                    return
                }
                let width = collectionView.frame.width
                let heigth = attrb.frame.height - contentOffsetY
                
                attrb.frame = CGRect(x: 0, y: contentOffsetY, width: width, height: heigth)
            }
        })
        
        return layoutAttrbs
    }
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        // collectionView scroll yapıldığında bound değişikliği yapılması için
        return true
    }
}



