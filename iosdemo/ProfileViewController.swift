import UIKit
import ParseSwift

class ProfileViewController: UIViewController {
    
    // Passed in from the login screen
    var loggedInUser: User!
    var userDataObject: UserData? // Used for reading/updating quote

    @IBOutlet weak var quoteField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserData()
    }

    // Fetch the user's data from Back4App using helper function
    func loadUserData() {
        UserData.fetch(for: loggedInUser) { userData in
            DispatchQueue.main.async {
                if let data = userData {
                    self.userDataObject = data
                    self.quoteField.text = data.favoriteQuote
                    self.statusLabel.text = "📄 Quote loaded."
                } else {
                    self.statusLabel.text = "⚠️ No user data found."
                }
            }
        }
    }

    // Called when user taps "Update Quote" button
    @IBAction func updateQuotePressed(_ sender: Any) {
        guard var dataToUpdate = userDataObject else { return }

        dataToUpdate.favoriteQuote = quoteField.text
        quoteField.resignFirstResponder() // dismiss keyboard

        dataToUpdate.save { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let updated):
                    print("Quote updated: \(updated.favoriteQuote ?? "")")
                    self.statusLabel.text = "✅ Quote updated!"
                case .failure(let error):
                    print("Failed to update: \(error)")
                    self.statusLabel.text = "❌ Failed to update quote."
                }
            }
        }
    }
}
