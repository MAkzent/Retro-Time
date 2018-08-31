//
//  ChatTableViewController.swift
//  CCC
//
//  Created by Michael Arnold on 8/30/18.
//  Copyright © 2018 AkzLab. All rights reserved.
//

import UIKit
import Firebase

class ChatTableViewController: UITableViewController {
    
    // Voting! (just increase count, MVP)
    // Delete?
    
    //Mark Constants
    let listToUsers = "ListToUsers"
    var ref: DatabaseReference!
    
    //Properties
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference(withPath: "messages")
        ref.queryOrdered(byChild: "sentiment").observe(.value, with: { snapshot in
            var newMessages: [Message] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let message = Message(snapshot: snapshot) {
                    newMessages.append(message)
                }
            }
            self.messages = newMessages
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            self.tableView.reloadData()
        })
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    
    
    @IBAction func clickNewMessage(_ sender: AnyObject) {
        let alert = UIAlertController(title: "New Item",
                                      message: "Give it a title and your sentiment 🤔",
                                      preferredStyle: .alert)
        let positiveSave = UIAlertAction(title: "🤩",
                                       style: .default) { _ in
            // 1
            guard let textField = alert.textFields?.first,
                let text = textField.text else { return }
            
            // 2
            if text.count > 0 {
                let message = Message(message: text,
                                      sentiment: "0",
                                      user: "Anonymous")
                // 3
                let messageRef = self.ref.child(text.lowercased())
                
                // 4
                messageRef.setValue(message.toAnyObject())
            }
        }
        
        let mehSave = UIAlertAction(title: "😐",
                                       style: .default) { _ in
            // 1
            guard let textField = alert.textFields?.first,
                let text = textField.text else { return }
            
            // 2
            if text.count > 0 {
                let message = Message(message: text,
                                      sentiment: "1",
                                      user: "Anonymous")
                // 3
                let messageRef = self.ref.child(text.lowercased())
                
                // 4
                messageRef.setValue(message.toAnyObject())
            }
        }
        
        let negativeSave = UIAlertAction(title: "😤",
                                       style: .default) { _ in
            // 1
            guard let textField = alert.textFields?.first,
                let text = textField.text else { return }
            
            // 2
            if text.count > 0 {
                let message = Message(message: text,
                                      sentiment: "2",
                                      user: "Anonymous")
                // 3
                let messageRef = self.ref.child(text.lowercased())
                
                // 4
                messageRef.setValue(message.toAnyObject())
            }
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        
        alert.addTextField()
        
        alert.addAction(positiveSave)
        alert.addAction(mehSave)
        alert.addAction(negativeSave)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let singleMessage = messages[indexPath.row]
        cell.textLabel?.text = singleMessage.message
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        cell.detailTextLabel?.text = String(singleMessage.count) + " students agree"
        cell.detailTextLabel?.textColor = .white
        cell.textLabel?.textColor = .white
        if singleMessage.sentiment == "0" {
            cell.backgroundColor = self.hexStringToUIColor(hex: "#00B16A")
        } else if (singleMessage.sentiment == "1" ){
            cell.backgroundColor = self.hexStringToUIColor(hex: "#FABE58")
        } else if (singleMessage.sentiment == "2" ){
            cell.backgroundColor = self.hexStringToUIColor(hex: "#E74C3C")
        }
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 6
        cell.layer.cornerRadius = 8
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMessage = messages[indexPath.row]
        let newCount = selectedMessage.count + 1
        selectedMessage.ref?.updateChildValues([
            "count": newCount
            ])
    }
    
    // Helper Function
    func hexStringToUIColor (hex : String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
