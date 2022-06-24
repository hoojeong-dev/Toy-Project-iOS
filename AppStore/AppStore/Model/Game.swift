import Foundation

struct Game {
    var header: String
    var appIcon: String
    var appRank: String
    var appTitle: String
    var appDescription: String
    var appProduce: String
    var isPurchase: Bool
}

struct GameList {
    var gameList = [
        Game(header: "무료 게임 순위", appIcon: "icApp", appRank: "1", appTitle: "헌터W", appDescription: "사냥의 재미를 찢는다! 헌터의 혼을 불태워라!", appProduce: "4399 KOREA", isPurchase: true),
        Game(header: "무료 게임 순위", appIcon: "icApp", appRank: "2", appTitle: "헌터W", appDescription: "사냥의 재미를 찢는다! 헌터의 혼을 불태워라!", appProduce: "4399 KOREA", isPurchase: true),
        Game(header: "무료 게임 순위", appIcon: "icApp", appRank: "3", appTitle: "헌터W", appDescription: "사냥의 재미를 찢는다! 헌터의 혼을 불태워라!", appProduce: "4399 KOREA", isPurchase: true),
        Game(header: "무료 게임 순위", appIcon: "icApp", appRank: "4", appTitle: "헌터W", appDescription: "사냥의 재미를 찢는다! 헌터의 혼을 불태워라!", appProduce: "4399 KOREA", isPurchase: true),
        Game(header: "무료 게임 순위", appIcon: "icApp", appRank: "5", appTitle: "헌터W", appDescription: "사냥의 재미를 찢는다! 헌터의 혼을 불태워라!", appProduce: "4399 KOREA", isPurchase: true)
    ]
}
