//
//  NWPathMonitorViewController.swift
//  NWPathMonitor
//
//  Created by 今村京平 on 2021/12/04.
//

import UIKit
import RxSwift
import RxCocoa

final class NWPathMonitorViewController: UIViewController {
    @IBOutlet private weak var NWPathStatus: UILabel!
    @IBOutlet private weak var NWInterface1: UILabel!
    @IBOutlet private weak var NWInterface2: UILabel!
    @IBOutlet private weak var NWInterface3: UILabel!
    @IBOutlet private weak var NWInterface4: UILabel!
    @IBOutlet private weak var NWInterface5: UILabel!

    private let viewModel: NWMonitoringViewModelType
    private let disposeBag = DisposeBag()

    init?(coder: NSCoder, viewModel: NWMonitoringViewModelType) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        viewModel.inputs.viewDidLoad()
    }

    private func setupBinding() {
        viewModel.outputs.NWPathStatus
            .drive(NWPathStatus.rx.text)
            .disposed(by: disposeBag)

        viewModel.outputs.NWInterface1
            .drive(NWInterface1.rx.text)
            .disposed(by: disposeBag)

        viewModel.outputs.NWInterface2
            .drive(NWInterface2.rx.text)
            .disposed(by: disposeBag)

        viewModel.outputs.NWInterface3
            .drive(NWInterface3.rx.text)
            .disposed(by: disposeBag)

        viewModel.outputs.NWInterface4
            .drive(NWInterface4.rx.text)
            .disposed(by: disposeBag)

        viewModel.outputs.NWInterface5
            .drive(NWInterface5.rx.text)
            .disposed(by: disposeBag)
    }
}

extension NWPathMonitorViewController {
    static func instantiate(viewModel: NWMonitoringViewModelType) -> NWPathMonitorViewController {
        let storyBoard = UIStoryboard(name: "NWPathMonitor", bundle: nil)
        let nwPathMonitorViewController = storyBoard.instantiateInitialViewController { coder in
            NWPathMonitorViewController(coder: coder, viewModel: viewModel)
        }!
        return nwPathMonitorViewController
    }
}
