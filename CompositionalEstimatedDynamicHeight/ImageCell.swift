//
//  ImageCell.swift
//  CompositionalEstimatedDynamicHeight
//
//  Created by Ting Yen Kuo on 2022/6/1.
//

import UIKit
import SnapKit
import SDWebImage

class ImageCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(0)
        }
    }
    
    func populate(with imageUrl: URL) {
        SDWebImageManager.shared.loadImage(with: imageUrl, progress: nil) { [weak self] image, _, error, _, _, _ in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let image = image {
                    self.imageView.image = image
                    self.updateImageHeightConstraint(size: image.size)
                    self.contentView.layoutIfNeeded()
                    self.layoutIfNeeded()
                }
            }
        }
    }
    
    private func updateImageHeightConstraint(size: CGSize) {
        let widthHeightRatio = size.height / size.width
        imageView.snp.remakeConstraints { make in
            let height = UIScreen.main.bounds.width * widthHeightRatio
            make.edges.equalToSuperview()
            make.height.equalTo(500)
        }
    }
}


