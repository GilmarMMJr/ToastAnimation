//
//  UIViewController+ExpandableToast.swift
//  Toast
//
//  Created by Gilmar Manoel de Mendonça Junior on 20/08/25.
//

import UIKit

extension UIViewController {
    func showExpandableToast(
        message: String,
        durationBeforeExpand: TimeInterval = 2.0,
        expandDuration: TimeInterval = 0.5
    ) {
        
        // Fundo expansível
        let toastBackground = UIView()
        toastBackground.backgroundColor = UIColor.gray
        toastBackground.alpha = 0.0
        toastBackground.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toastBackground)
        
        // Label fixo embaixo (fora do fundo)
        let label = UILabel()
        label.text = message
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        // Constraints do fundo (inicial pequeno)
        let initialHeight: CGFloat = 50
        let heightConstraint = toastBackground.heightAnchor.constraint(equalToConstant: initialHeight)
        let bottomConstraint = toastBackground.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        let leadingConstraint = toastBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40)
        let trailingConstraint = toastBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        
        NSLayoutConstraint.activate([
            leadingConstraint,
            trailingConstraint,
            bottomConstraint,
            heightConstraint
        ])
        
        toastBackground.layer.cornerRadius = initialHeight / 2
        toastBackground.clipsToBounds = true
        
        // Constraints do label (fixo na tela, não no fundo)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -28), // mesma posição
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Fade in
        UIView.animate(withDuration: 0.3) {
            toastBackground.alpha = 1.0
            label.alpha = 1.0
        }
        
        // Após alguns segundos, expandir só o fundo
        DispatchQueue.main.asyncAfter(deadline: .now() + durationBeforeExpand) {
            NSLayoutConstraint.deactivate([heightConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
            
            NSLayoutConstraint.activate([
                toastBackground.topAnchor.constraint(equalTo: self.view.topAnchor),
                toastBackground.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                toastBackground.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                toastBackground.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            ])
            
            UIView.animate(withDuration: expandDuration, animations: {
                self.view.layoutIfNeeded()
                toastBackground.layer.cornerRadius = 0
            }) { _ in
                // some depois de expandir
                UIView.animate(withDuration: 0.3, delay: 1.5, options: .curveEaseOut, animations: {
                    toastBackground.alpha = 0.0
                    label.alpha = 0.0
                }) { _ in
                    toastBackground.removeFromSuperview()
                    label.removeFromSuperview()
                }
            }
        }
    }
}
