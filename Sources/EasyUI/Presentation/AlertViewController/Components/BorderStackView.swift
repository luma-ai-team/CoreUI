//
//  BorderStackView.swift
//  AlertTryout
//
//  Created by Roi Mulia on 26/01/2023.
//

import UIKit

class BorderStackView: UIStackView {
    
    var borderViews: [UIView] = []

    func updateBorderViews() {
        borderViews.forEach { $0.removeFromSuperview() }
        
        guard arrangedSubviews.count > 0 else {
            return
        }
        
        for view in arrangedSubviews {
            borderViews.append(createBorderView(inside: view, isOnTop: true))
        }
        
        for pair in Array(arrangedSubviews.pairs()) {
            borderViews.append(createBorderView(inside: pair.0, isOnTop: axis == .vertical))
        }
    }
    
    private func createBorderView(inside view: UIView, isOnTop: Bool) -> UIView {
        let borderView = UIView()
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.backgroundColor = UIColor(hex: "969696")
        view.addSubview(borderView)
        
        if isOnTop {
            NSLayoutConstraint.activate([
                borderView.heightAnchor.constraint(equalToConstant: 0.333),
                borderView.widthAnchor.constraint(equalTo: view.widthAnchor),
                borderView.centerYAnchor.constraint(equalTo: view.topAnchor),
                borderView.centerXAnchor.constraint(equalTo: borderView.centerXAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                borderView.widthAnchor.constraint(equalToConstant: 0.333),
                borderView.heightAnchor.constraint(equalTo: view.heightAnchor),
                borderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                borderView.centerXAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        }
        
        return borderView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateBorderViews()
    }
    
}

fileprivate extension Collection {
    func pairs() -> AnySequence<(Element, Element)> {
        return AnySequence(zip(self, self.dropFirst()))
    }
}
