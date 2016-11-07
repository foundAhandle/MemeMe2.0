import UIKit

class MemeEditorViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var actionButton: UIBarButtonItem!

    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!

    let topPlaceholderText = "TOP"
    let bottomPlaceholderText = "BOTTOM"
    var currentTextField: UITextField?

	let memeTextAttributes = [
	  NSStrokeColorAttributeName:	  UIColor.black,
	  NSForegroundColorAttributeName: UIColor.white,
	  NSFontAttributeName:			  UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
	  NSStrokeWidthAttributeName:	  CGFloat(-3.0)
	] as [String : Any]

    @IBOutlet weak var memeImageView: UIImageView!

    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
	override var prefersStatusBarHidden: Bool {
	  return true
	}

    override func viewDidLoad() {
	  super.viewDidLoad()

	  actionButton.isEnabled = false
	  initTxtField(topText)
	  initTxtField(bottomText)
	  clrAndHideTxt()
    }

    /// Runs when the view appears
    override func viewWillAppear(_ animated: Bool) {
	  super.viewWillAppear(animated)

	  cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)

	  subscribeToKeyboardNotifications()
    }
    
    /// Runs when the view disappears
    override func viewWillDisappear(_ animated: Bool) {
	  super.viewWillDisappear(animated)
	  unsubscribeFromKeyboardNotifications()
    }

	// TEXT DELEGATE

    func textFieldDidBeginEditing(_ textField: UITextField) {
	  clearPlaceholderText(textField)
	  currentTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
	  showPlaceholderText(textField)
	  currentTextField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
	  textField.resignFirstResponder()
	  return true
    }

    // KEYBOARD

    func subscribeToKeyboardNotifications() {
	  NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
	  NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
	  NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
	  NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification: Notification) {
	  if bottomText.isFirstResponder {
		view.frame.origin.y = getKeyboardHeight(notification) * (-1)
	  }
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
	  let userInfo = (notification as NSNotification).userInfo
	  let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
	  return keyboardSize.cgRectValue.height
    }
    
    func keyboardWillHide(_ notification: Notification) {
	  view.frame.origin.y = 0
    }

	// MEME

    fileprivate func makeMemeImage() -> UIImage {
	  hideToolbars()
	  UIGraphicsBeginImageContext(view.frame.size)
	  view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
	  let image = UIGraphicsGetImageFromCurrentImageContext()
	  UIGraphicsEndImageContext()
	  showToolbars()
        
	  return image!
    }

    fileprivate func save(_ comp: UIImage) {
	  let backgroundImage = self.memeImageView.image == nil ?
		UIImage() : self.memeImageView.image
	  let meme = Meme(
		topTxt:		self.topText.text!,
		btmTxt:		self.bottomText.text!,
		img:		backgroundImage!,
		composite:	comp
	  )

	  let appDelegate = UIApplication.shared.delegate as! AppDelegate
	  appDelegate.memes.append(meme)
	}

	// TOOLBARS

    fileprivate func hideToolbars() {
	  navBar.isHidden = true
	  bottomToolbar.isHidden = true
    }
    
    fileprivate func showToolbars() {
	  navBar.isHidden = false
	  bottomToolbar.isHidden = false
    }

	// TEXT FIELDS

	fileprivate func initTxtField (_ textField: UITextField){
	  textField.defaultTextAttributes = memeTextAttributes
	  textField.textAlignment = NSTextAlignment.center
	  textField.delegate = self
	}

    fileprivate func clearPlaceholderText(_ textField: UITextField) {
	  if textField == topText && textField.text! == topPlaceholderText{
		textField.text = ""
	  }

	  if textField == bottomText && textField.text! == bottomPlaceholderText{
		textField.text = ""
	  }
    }
    
    fileprivate func showPlaceholderText(_ textField: UITextField) {
	  if textField == topText && textField.text! == "" {
		textField.text = topPlaceholderText
	  }

	  if textField == bottomText && textField.text! == "" {
		textField.text = bottomPlaceholderText
	  }
    }
   
    fileprivate func showTxt() {
	  self.topText.isHidden = false
	  self.bottomText.isHidden = false
    }

    fileprivate func clrAndHideTxt() {
	  self.topText.text = ""
	  self.bottomText.text = ""
	  self.topText.isHidden = true
	  self.bottomText.isHidden = true
    }

	// ACTIONS

    @IBAction func didPressAction(_ sender: UIBarButtonItem) {
	  let image = makeMemeImage()
	  let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
	  activity.completionWithItemsHandler = {
		(type, completed: Bool, returnedItems: [Any]?, error: Error?) in
		  if completed {
			self.save(image)
			self.dismiss(animated: true, completion: nil)
		  }
	  }
	  present(activity, animated: true, completion: nil)
    }

    @IBAction func didPressCancel(_ sender: UIBarButtonItem) {
	  clrAndHideTxt()
	  self.memeImageView.isHidden = true
	  self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPressPhoto(_ sender: UIBarButtonItem) {
	  presentVC(UIImagePickerControllerSourceType.photoLibrary)
    }

    @IBAction func didPressCamera(_ sender: UIBarButtonItem) {
	  presentVC(UIImagePickerControllerSourceType.camera)
    }

	fileprivate func presentVC(_ type: UIImagePickerControllerSourceType){
	  showPlaceholderText(topText)
	  showPlaceholderText(bottomText)

	  let picker = UIImagePickerController()
	  picker.sourceType = type
	  picker.delegate = self
	  present(picker, animated: true, completion: nil)
	}

	// IMAGE PICKER

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
	 self.memeImageView.isHidden = false

	  if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
		memeImageView.image = image
		actionButton.isEnabled = true
		showTxt()
	  }

	  self.dismiss(animated: true, completion: nil)
    }
}
