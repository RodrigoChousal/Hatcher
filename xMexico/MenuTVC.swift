//
//  MenuTVC.swift
//  xMexico
//
//  Created by Development on 2/18/17.
//  Copyright © 2017 Rodrigo Chousal. All rights reserved.
//

import UIKit

class MenuTVC: UITableViewController {
    
    var indicatorView = UIView()
	let impact = UIImpactFeedbackGenerator(style: .light)
	let profilePicturePlaceholderView = LoadingPlaceholderView()

    @IBOutlet weak var userCell: UITableViewCell!
    @IBOutlet weak var accountTitleLabel: UILabel!
	@IBOutlet weak var userPictureContainerView: UIView!
    @IBOutlet weak var userPictureView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
	
    @IBOutlet weak var campaignsCell: UITableViewCell!
	@IBOutlet weak var portfolioCell: UITableViewCell!
	@IBOutlet weak var matchmakingCell: UITableViewCell!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		userPictureContainerView.layer.cornerRadius = userPictureContainerView.frame.width/2
		userPictureContainerView.clipsToBounds = true
		
		NotificationCenter.default.addObserver(self, selector: #selector(setupView), name: .userSettingsDidChange, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(uncoverProfilePicture), name: .profileImageFinished, object: nil)
		
        self.revealViewController().rearViewRevealWidth = 200
        self.revealViewController().rearViewRevealDisplacement = 0
        self.revealViewController().springDampingRatio = 1.0
		
		setupCellStyles()
		
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
		impact.impactOccurred()
        if let localUser = Global.localUser {
			if let profilePicture = localUser.profilePicture {
				userPictureView.image = profilePicture.circleMasked
			} else {
				profilePicturePlaceholderView.cover(userPictureContainerView)
			}
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 { // userCell is taller
            if isVisitor {
                return 54
            }
            return 125
        }
        return 54 // menu item cells
    }
    
    // MARK: - Helper Methods
	
	func setupCellStyles() {
		let backgroundView = UIView()
		backgroundView.backgroundColor = UIColor(red: 40/255, green: 140/255, blue: 255/255, alpha: 1.0)
		userCell.selectedBackgroundView = backgroundView
		campaignsCell.selectedBackgroundView = backgroundView
		portfolioCell.selectedBackgroundView = backgroundView
		matchmakingCell.selectedBackgroundView = backgroundView
	}
    
    @objc func setupView() {
		
        if !isVisitor {
            DispatchQueue.main.async {
				if let user = Global.localUser {
					self.userNameLabel.text = user.fullName
					if let profilePicture = user.profilePicture {
						self.userPictureView.image = profilePicture.circleMasked
					}
				}
            }
            
        } else {
            userNameLabel.removeFromSuperview()
            userPictureView.removeFromSuperview()
            accountTitleLabel.removeFromSuperview()

            // Use campaignsCell for size because userCell will be resized after viewDidLoad in heightForRow
            let accessLabel = UILabel(frame: userNameLabel.frame)
            accessLabel.center = campaignsCell.contentView.center
            accessLabel.center.x = campaignsCell.contentView.center.x
            accessLabel.center.y = campaignsCell.contentView.center.y
            accessLabel.text = "Crear Cuenta"
            accessLabel.textAlignment = .center
            accessLabel.font = UIFont(name: "Avenir-Heavy", size: 14)
            accessLabel.textColor = .blue

            userCell.contentView.addSubview(accessLabel)
        }
    }
	
	@objc func uncoverProfilePicture() {
		profilePicturePlaceholderView.uncover()
		DispatchQueue.main.async {
			if let user = Global.localUser {
				if let profilePicture = user.profilePicture {
					self.userPictureView.image = profilePicture.circleMasked
				}
			}
		}
	}
}

