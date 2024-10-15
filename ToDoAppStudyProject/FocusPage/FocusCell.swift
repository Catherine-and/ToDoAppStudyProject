//
//  FocusCell.swift
//  ToDoAppStudyProject
//
//  Created by Ekaterina Isaeva on 12.10.2024.
//

import UIKit


protocol FocusCellDelegate: AnyObject {
    func cellTapped(cell: FocusCell)
}

class FocusCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var focusNameLabel: UILabel!
    @IBOutlet weak var focusTimeLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    weak var delegate: FocusCellDelegate?
    
    static let identifier = "FocusCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "FocusCell",
                     bundle: nil)
    }
    
    public func configure(with title: String, timeTitle: String?) {
        
        focusNameLabel.text = title
        focusTimeLabel.text = timeTitle
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGesture = UITapGestureRecognizer(target: self , action: #selector(handleTap))
        self.contentView.addGestureRecognizer(tapGesture)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @objc func handleTap() {
        delegate?.cellTapped(cell: self)
    }
    
}
