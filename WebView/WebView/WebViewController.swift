import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webViewGroup: UIView!/** 배경 뷰 */
    
    private var webView: WKWebView!/** 웹 뷰 */
    
    var search: String!/** 검색어 */
    var url: String!/** url */
    
    
    /** life cycle */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /** 네비게이션 바 타이틀 */
        self.navigationItem.title = search
        
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = true
        
        let contentController = WKUserContentController()
        contentController.add(self, name: "bridge")
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.userContentController = contentController
        
        webView = WKWebView(frame: self.view.bounds, configuration: configuration)
        
        var components = URLComponents(string: url)!
        components.queryItems = [ URLQueryItem(name: "query", value: search) ]
        
        let request = URLRequest(url: components.url!)
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webViewGroup.addSubview(webView)
        setAutoLayout(from: webView, to: webViewGroup)
        webView.load(request)
        
        webView.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.webView.alpha = 1
        }) { _ in
            
        }
    }
    
    /** auto leyout 설정 */
    public func setAutoLayout(from: UIView, to: UIView) {
        
        from.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.init(item: from, attribute: .leading, relatedBy: .equal, toItem: to, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint.init(item: from, attribute: .trailing, relatedBy: .equal, toItem: to, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint.init(item: from, attribute: .top, relatedBy: .equal, toItem: to, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint.init(item: from, attribute: .bottom, relatedBy: .equal, toItem: to, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        view.layoutIfNeeded()
    }

}

extension WebViewController: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        print("\(navigationAction.request.url?.absoluteString ?? "")" )
        
        decisionHandler(.allow)
    }
}

extension WebViewController: WKUIDelegate {
    
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
    }
}

extension WebViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        print(message.name)
    }
}
