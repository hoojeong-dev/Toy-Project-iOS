//
//  ViewController.swift
//  Weather
//
//  Created by 김후정 on 2022/03/30.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var weatherStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // 날씨 가져오기 버튼을 눌렀을 때 호출되는 메서드
    @IBAction func tapFetchWeatherButton(_ sender: Any) {
        self.weatherStackView.isHidden = true
        if let cityName = self.cityNameTextField.text {
            self.getCurrentWeather(cityName: cityName)
            self.view.endEditing(true)
        }
    }
    
    // api에 연결하여 데이터를 가져오는 메서드
    func getCurrentWeather(cityName: String) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=3d58ff1b86071e2cd388fb7654328507") else { return }
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { [weak self] data, response, error in
            let successRange = (200..<300)
            guard let data = data, error == nil else { return }
            let decoder = JSONDecoder()
            
            // response의 statusCode 값이 200이라면 OK -> 디코딩 수행
            if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode){
                guard let weatherInformation = try? decoder.decode(WeatherInformation.self, from: data) else { return }
                DispatchQueue.main.async {
                    self?.weatherStackView.isHidden = false
                    self?.configureView(weatherInformation: weatherInformation)
                }
                // response의 statusCode 값이 404라면 NO -> error alert
            } else {
                guard let errorMessage = try? decoder.decode(ErrorMessage.self, from: data) else { return }
                DispatchQueue.main.async {
                    self?.showAlert(message: errorMessage.message)
                }
            }
            
        }.resume()
    }
    
    // api를 통해 받아온 데이터를 UIView의 컴포넌트에 연결
    func configureView(weatherInformation: WeatherInformation) {
        self.cityNameLabel.text = weatherInformation.name
        if let weather = weatherInformation.weather.first {
            self.weatherDescriptionLabel.text = weather.description
        }
        
        self.tempLabel.text = "\(Int(weatherInformation.temp.temp - 273.15))°C"
        self.minTempLabel.text = "min: \(Int(weatherInformation.temp.minTemp - 273.15))°C"
        self.maxTempLabel.text = "max: \(Int(weatherInformation.temp.maxTemp - 273.15))°C"
    }
    
    // 도시를 잘못 입력했을 때 나타나는 error alert
    func showAlert(message: String) {
        let alert = UIAlertController(title: "error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

