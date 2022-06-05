import UserNotifications

extension UNUserNotificationCenter {
    func addNotificationRequests(by alert: Alert) {
        let content = UNMutableNotificationContent()
        
        content.title = "물 마셔"
        content.body = "살 빼야지"
        content.sound = .default
        content.badge = 1
        
        let component = Calendar.current.dateComponents([.hour, .minute], from: alert.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: alert.isOn)
        let request = UNNotificationRequest(identifier: alert.id, content: content, trigger: trigger)
        
        self.add(request, withCompletionHandler: nil)
    }
}
