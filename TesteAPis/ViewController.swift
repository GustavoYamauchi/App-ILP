//
//  ViewController.swift
//  TesteAPis
//
//  Created by Gustavo Yamauchi on 17/06/20.
//  Copyright © 2020 Gustavo Yamauchi. All rights reserved.
//

import UIKit
import Foundation

protocol AtualizarDelegate: class {
    func atualizar()
}

extension ViewController: AtualizarDelegate{
    func atualizar() {
        getTarefas()
        tableView.reloadData()
    }
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var retorno :Data?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var txtTitulo: UITextField!
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    var JSON = [Tarefa]()
    
    
    @IBAction func btnPost(_ sender: Any) {
        let tarefa = Tarefa(titulo: txtTitulo.text!, conteudo: "")

        var request = URLRequest(url: URL(string: "http://127.0.0.1:8080/add")!)

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONEncoder().encode(tarefa)
            print(String(data: request.httpBody!, encoding: .utf8)!)
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
        
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        let task2 = session.dataTask(with: request) {data, response, error in
            guard let data = data else { return }
            
            do {
                DispatchQueue.main.async {
                    self.getTarefas()
                }
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        task2.resume()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 70
        getTarefas()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //array.count
        return self.JSON.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let newCell:CustomCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomCell
        
        if self.JSON.count > 0 {
            newCell.id = self.JSON[indexPath.row].id!
            newCell.lblTitulo?.text = self.JSON[indexPath.row].titulo
            newCell.lblConteudo?.text = self.JSON[indexPath.row].conteudo
            newCell.atualizarDelegate = self
        }
        newCell.indentationWidth = 70
        
        return newCell
    }
    
    func getTarefas() {
        var request = URLRequest(url: URL(string: "http://127.0.0.1:8080/tarefa")!)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            
            do {
                self.JSON = try JSONDecoder().decode([Tarefa].self, from: data)
                print(self.JSON)
                DispatchQueue.main.async {
                   self.tableView.reloadData()
                }
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
                print("deu ruim")
            }
        }.resume()
    }
    
}

