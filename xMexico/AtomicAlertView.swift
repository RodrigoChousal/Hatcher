//
//  AtomicAlertView.swift
//  xMexico
//
//  Created by Rodrigo Chousal on 9/26/18.
//  Copyright © 2018 Rodrigo Chousal. All rights reserved.
//

import UIKit

class AtomicAlertView: UIView {
	
	var backgroundView = UIView()
	var dialogView = UIView()
	var linkIdentity = String()
	
	convenience init(title: String, message: String, link: Bool) {
		self.init(frame: UIScreen.main.bounds)
		self.linkIdentity = message
		initialize(title: title, message: message, link: link)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func initialize(title: String, message: String, link: Bool) {
		
		// Constants
		let viewPadding = CGFloat(32)
		let verticalPadding = CGFloat(8)
		var currentY = verticalPadding
		
		dialogView.clipsToBounds = true
		
		backgroundView.frame = frame
		backgroundView.backgroundColor = UIColor.black
		backgroundView.alpha = 0.6
		backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedOnBackgroundView)))
		addSubview(backgroundView)
		
		let dialogViewWidth = frame.width - (viewPadding * 2)
		
		let titleLabel = UILabel(frame: CGRect(x: 8, y: currentY, width: dialogViewWidth-16, height: 30))
		titleLabel.text = title
		titleLabel.textAlignment = .center
		dialogView.addSubview(titleLabel)
		
		currentY += verticalPadding + titleLabel.frame.height
		let separatorLineView = UIView()
		separatorLineView.frame.origin = CGPoint(x: 0, y: currentY)
		separatorLineView.frame.size = CGSize(width: dialogViewWidth, height: 1)
		separatorLineView.backgroundColor = UIColor.groupTableViewBackground
		dialogView.addSubview(separatorLineView)
		
		currentY += verticalPadding + separatorLineView.frame.height
		let heightOfNext = CGFloat(30)
		if link {
			let linkTextField = UITextField(frame: CGRect(x: 8, y: currentY, width: dialogViewWidth - 16, height: heightOfNext))
			linkTextField.backgroundColor = .gray
			linkTextField.text = message
			linkTextField.textColor = .white
			linkTextField.font = UIFont(name: "Menlo-Regular", size: 16)
			linkTextField.textAlignment = .center
			dialogView.addSubview(linkTextField)
		} else {
			let messageLabel = UILabel(frame: CGRect(x: 8, y: currentY, width: dialogViewWidth - 16, height: heightOfNext))
			messageLabel.text = message
			messageLabel.textAlignment = .center
			dialogView.addSubview(messageLabel)
		}
		
		currentY += verticalPadding + heightOfNext
		let separatorLineView2 = UIView()
		separatorLineView2.frame.origin = CGPoint(x: 0, y: currentY)
		separatorLineView2.frame.size = CGSize(width: dialogViewWidth, height: 1)
		separatorLineView2.backgroundColor = UIColor.groupTableViewBackground
		dialogView.addSubview(separatorLineView2)
		
		// Copy link to clipboard
		currentY += verticalPadding + separatorLineView2.frame.height
		let actionButton = UIButton(type: .system)
		actionButton.frame = CGRect(x: 8, y: currentY, width: dialogViewWidth-16, height: 30)
		if link {
			actionButton.setTitle("COPY", for: .normal)
			actionButton.backgroundColor = .red
			actionButton.addTarget(self, action: #selector(copyPressed), for: .touchUpInside)
		} else {
			actionButton.setTitle("OK", for: .normal)
			actionButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
		}
		dialogView.addSubview(actionButton)
		
		let dialogViewHeight = currentY + actionButton.frame.height + 16
		dialogView.frame.origin = CGPoint(x: 32, y: frame.height)
		dialogView.frame.size = CGSize(width: frame.width-64, height: dialogViewHeight)
		dialogView.backgroundColor = UIColor.white
		dialogView.layer.cornerRadius = 6
		addSubview(dialogView)
	}
	
	@objc func copyPressed(sender: UIButton) {
		UIPasteboard.general.string = self.linkIdentity
		sender.setTitle("Link copied to clipboard", for: .normal)
		sender.isEnabled = false
	}
	
	func show(animated: Bool) {
		self.backgroundView.alpha = 0
		self.dialogView.center = CGPoint(x: self.center.x, y: self.frame.height + self.dialogView.frame.height/2)
		if let window = UIApplication.shared.keyWindow {
			window.addSubview(self)
			if animated {
				UIView.animate(withDuration: 0.33, animations: {
					self.backgroundView.alpha = 0.66
				})
				UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: {
					self.dialogView.center  = self.center
				}, completion: { (completed) in
					
				})
			} else {
				self.backgroundView.alpha = 0.66
				self.dialogView.center  = self.center
			}
		}
	}
	
	@objc func dismiss() {
		UIView.animate(withDuration: 0.33, animations: {
			self.backgroundView.alpha = 0
		}, completion: { (completed) in
			
		})
		UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: {
			self.dialogView.center = CGPoint(x: self.center.x, y: self.frame.height + self.dialogView.frame.height/2)
		}, completion: { (completed) in
			self.removeFromSuperview()
		})
	}
	
	@objc func didTappedOnBackgroundView(){
		dismiss()
	}
}
