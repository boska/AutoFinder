import UIKit
extension UIViewController {
  func presentAlert(title: String) {
    let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
    let dismiss = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
    alert.addAction(dismiss)
    present(alert, animated: true)
  }
}
