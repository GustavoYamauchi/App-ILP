//
//  CustomCell.swift
//  TesteAPis
//
//  Created by Gustavo Yamauchi on 05/08/20.
//  Copyright © 2020 Gustavo Yamauchi. All rights reserved.
//

import Foundation
import UIKit

class CustomCell: UITableViewCell {
    public var id : String!
    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var lblConteudo: UILabel!
    weak var atualizarDelegate: AtualizarDelegate?

    @IBAction func btnDeletar(_ sender: Any) {
        var tarefa = Tarefa(id: self.id, titulo: self.lblTitulo.text!, conteudo: self.lblConteudo.text!)
        var request = URLRequest(url: URL(string: "http://127.0.0.1:8080/delete")!)

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONEncoder().encode(tarefa)
            print(String(data: request.httpBody!, encoding: .utf8)!)
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
        
        //commit
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        let task2 = session.dataTask(with: request) {data, response, error in
            guard let data = data else { return }
            
            do {
                print(data)
                DispatchQueue.main.async {
                    self.atualizarDelegate?.atualizar()
                }
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
                print("deu ruim")
            }
        }
        task2.resume()
    }
    
}
