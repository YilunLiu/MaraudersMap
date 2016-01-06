//
//  ChatViewController.swift
//  MaraudersMap
//
//  Created by Yilun Liu on 12/25/15.
//  Copyright © 2015 Robocat. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: JSQMessagesViewController
{
    
    static let COLOR_OUTGOING = UIColor(red: 0.47, green: 1, blue: 1, alpha: 1)
    static let COLOR_INCOMING = UIColor(red: 0.898, green: 0.917, blue: 1, alpha: 1)
    
    var bubbleImageOutgoing: JSQMessagesBubbleImage!
    var bubbleImageIncoming: JSQMessagesBubbleImage!
    var avatarImageBlank: JSQMessagesAvatarImage!

    var groupViewModel: GroupViewModel!
    var group: Group!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabbarController = self.tabBarController as! GroupTabBarController
        self.group = tabbarController.group

        // Do any additional setup after loading the view.
        self.senderId = User.currentUser()!.objectId
        self.senderDisplayName = User.currentUser()!.nickName
        
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        self.bubbleImageOutgoing = bubbleFactory.outgoingMessagesBubbleImageWithColor(ChatViewController.COLOR_OUTGOING)
        self.bubbleImageIncoming = bubbleFactory.incomingMessagesBubbleImageWithColor(ChatViewController.COLOR_INCOMING)
        avatarImageBlank = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: "chat_blank"), diameter: 30)
        
        self.groupViewModel = GroupViewModel.groupViewModel(group)
        self.groupViewModel.lastMessage.producer.startWithNext{
            lastMessage in
            self.collectionView?.reloadData()
        }
        
        self.navigationItem.title = self.group.name
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController!.tabBar.hidden = true
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        collectionView?.collectionViewLayout.springinessEnabled = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.tabBarController!.tabBar.hidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    // MARK: - JSQMessagesCollectionViewDataSource
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return self.groupViewModel.messages.value[indexPath.item]
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        if isIncoming(self.groupViewModel.messages.value[indexPath.item]){
            return self.bubbleImageIncoming
        } else {
            return self.bubbleImageOutgoing
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return self.avatarImageBlank
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        if (shouldDisplayTime(indexPath: indexPath)){
            let message = self.groupViewModel.messages.value[indexPath.item]
            return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date())
        }
        return nil
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        if shouldDisplayName(indexPath: indexPath){
            return  NSAttributedString(string: self.groupViewModel.messages.value[indexPath.item].senderDisplayName())
        }
        return nil
    }

    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        return nil
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.groupViewModel.messages.value.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let message = self.groupViewModel.messages.value[indexPath.item]
        let color = self.isIncoming(message) ? UIColor.blackColor() : UIColor.whiteColor()
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        cell.textView?.textColor = color
        cell.textView?.linkTextAttributes = [NSForegroundColorAttributeName: color, NSUnderlineStyleAttributeName: 1]
        return cell
    }
    
    // MARK: - JSQMessage FlowLayout Delegate
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        if (shouldDisplayTime(indexPath: indexPath)){
            return 20.0
        } else {
            return 0
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        if shouldDisplayName(indexPath: indexPath){
            return 20.0
        }
        return 0.0
    }
    
    // MARK: - Responding to Events
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        let data: [String: AnyObject] = [
            Message.AUTHORID_KEY: User.currentUser()!.objectId!,
            Message.GROUPID_KEY: self.group.objectId!,
            Message.CREATED_AT_KEY: date.toFullString(),
            Message.CONTENT_KEY: text,
            Message.AUTHOR_NAME_KEY: User.currentUser()!.nickName
        ]
        let messageURL = Message.FB_MESSAGE_URL + "/" + group.objectId!
        let firebaseRef = Firebase(url: messageURL)
        let messageRef = firebaseRef.childByAutoId()
        messageRef.setValue(data)
        self.inputToolbar?.contentView?.textView?.text = ""
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        // TODO
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, header headerView: JSQMessagesLoadEarlierHeaderView!, didTapLoadEarlierMessagesButton sender: UIButton!) {
        // TODO
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapAvatarImageView avatarImageView: UIImageView!, atIndexPath indexPath: NSIndexPath!) {
        // TODO
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAtIndexPath indexPath: NSIndexPath!) {
        // TODO
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapCellAtIndexPath indexPath: NSIndexPath!, touchLocation: CGPoint) {
        // TODO
    }
    
    // MARK: - Target & Action
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.tabBarController?.selectedIndex = 0
    }
    
    // MARK: - Helper
    private func isIncoming(message:Message) -> Bool{
        return message.senderId() != self.senderId
    }
    
    
    private func shouldDisplayName(indexPath indexPath:NSIndexPath) -> Bool{
        let message = self.groupViewModel.messages.value[indexPath.item]
        
        if self.isIncoming(message){
            if indexPath.item > 0{
                let previous = self.groupViewModel.messages.value[indexPath.item-1]
                if previous.senderId() == message.senderId() {
                    return false
                }
                return true
            }
            return true
        }
        return false
    }
    
    private func shouldDisplayTime(indexPath indexPath:NSIndexPath) -> Bool{
        let message = messageAtIndexPath(indexPath.item)
        if indexPath.item > 0{
            let previous = messageAtIndexPath(indexPath.item-1)
            if message.createdAt.timeIntervalSinceDate(previous.createdAt) < 300{
                return false
            }
        }
        return true
    }
    
    private func messageAtIndexPath(index: Int) -> Message{
        return self.groupViewModel.messages.value[index]
        
    }
    
}
