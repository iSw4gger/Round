

import UIKit

protocol SpecialVCDelegate {
    func sendSpecialInstructions(instructions: String)
}

class SpecialInstructionViewController: UIViewController {

    @IBOutlet var superView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var titleView: UIView!
    
    var delegate: SpecialVCDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        textView.resignFirstResponder()
    }
    

    @IBAction func saveButtonPressed(_ sender: Any) {
        delegate?.sendSpecialInstructions(instructions: textView.text)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func viewTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupViews(){
        mainView.layer.cornerRadius = 15
        titleView.layer.cornerRadius = 15
        titleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        textView.becomeFirstResponder()
    }
    
    
}
