//
//  CustomTableViewCell.swift
//  ToDoAppStudyProject
//
//  Created by Ekaterina Isaeva on 08.09.2024.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    var isChecked = false
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var checkBoxButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        checkBoxButton.addTarget(self, action: #selector(checkBoxButtonClicked(sender:)), for: .touchUpInside)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @objc func checkBoxButtonClicked(sender: UIButton) {
        isChecked = !isChecked  // Toggle the checked state
        let imageName = isChecked ? "selected" : "unselected"
        checkBoxButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
}
