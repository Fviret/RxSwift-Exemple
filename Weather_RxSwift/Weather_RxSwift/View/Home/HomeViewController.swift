//
//  HomeViewController.swift
//  Weather_RxSwift
//
//  Created by Florian on 28/07/2022.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController, UIScrollViewDelegate {

    
    // MARK: - IBOutlet
    @IBOutlet private var searchCityName: UITextField!
    @IBOutlet private var tempLbl: UILabel!
    @IBOutlet private var humidityLbl: UILabel!
    @IBOutlet private var iconLbl: UILabel!
    @IBOutlet private var cityNameLbl: UILabel!
    @IBOutlet weak var tableview: UITableView!
    
    private let viewModel = HomeViewModel()
    private let bag = DisposeBag()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()


        
        HomeViewModel.shared.currentWeather(for: "RxSwift")
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { data in
                self.tempLbl.text = "\(data.temperature)° C"
                self.iconLbl.text = data.icon
                self.humidityLbl.text = "\(data.humidity)%"
                self.cityNameLbl.text = data.cityName
               
                
            })
            
        
            .disposed(by: bag)
                
        
        let search = searchCityName.rx
            .controlEvent(.editingDidEndOnExit)
            .map { self.searchCityName.text ?? "" }
            .filter{ !$0.isEmpty }
            .flatMap({ text in
                HomeViewModel.shared
                    .currentWeather(for: text)
                    .catchAndReturn(.unknow)
            })
            .asDriver(onErrorJustReturn: .empty)
    
        
        
        
        
        search.map { "\($0.temperature)° C" }
            .drive(tempLbl.rx.text)
            .disposed(by: bag)
        
        search.map(\.icon)
          .drive(iconLbl.rx.text)
          .disposed(by: bag)

        search.map { "\($0.humidity)%" }
          .drive(humidityLbl.rx.text)
          .disposed(by: bag)
        
        search.map(\.cityName)
          .drive(cityNameLbl.rx.text)
          .disposed(by: bag)
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
    }

    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()

//      Appearance.applyBottomLine(to: searchCityName)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
    }

    override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        
        searchCityName.text = ""
        tempLbl.text = ""
        humidityLbl.text = ""
        iconLbl.text = ""
        cityNameLbl.text = "cherchez une ville pour commencer"
    }
    
    
   
}
