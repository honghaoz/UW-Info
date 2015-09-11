//
//  NoteCell.swift
//  UW Info Session
//
//  Created by Qiu Zefeng on 2015-09-06.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {
    
    @IBOutlet var textView: UITextView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var textString: String {
        get {
            return textView?.text ?? ""
        }
        set {
            textView?.text = newValue
            textView.textColor = UIColor.blackColor()
            textViewDidChange(textView!)
        }
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Disable scrolling inside the text view so we enlarge to fitted size
        textView?.scrollEnabled = false
        textView?.delegate = self
        textView.text = "Take some notes here"
        textView.textColor = UIColor.lightGrayColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if selected {
            textView?.becomeFirstResponder()
           
        } else {
            textView?.resignFirstResponder()
        }
    }

}

extension NoteCell: UITextViewDelegate {
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let oldText: NSString = textView.text
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: text)
        textView.textColor = UIColor.blackColor()
        
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        
        let size = textView.bounds.size
        let newSize = textView.sizeThatFits(CGSize(width: size.width, height: CGFloat.max))
        
        // Resize the cell only when cell's size is changed
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            tableView?.beginUpdates()
            tableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
            
            if let thisIndexPath = tableView?.indexPathForCell(self) {
                tableView?.scrollToRowAtIndexPath(thisIndexPath, atScrollPosition: .Bottom, animated: false)
            }
        }
    }
}

extension NoteCell: TableViewInfo {
    class func identifier() -> String {
        return NSStringFromClass(NoteCell.self)
    }
    
    class func estimatedRowHeight() -> CGFloat {
        return 150
    }
    
    class func registerInTableView(tableView: UITableView) {
        let cellnib = UINib(nibName: "NoteCell", bundle: NSBundle(forClass: NoteCell.self))
        tableView.registerNib(cellnib, forCellReuseIdentifier: NoteCell.identifier())
    }
}

