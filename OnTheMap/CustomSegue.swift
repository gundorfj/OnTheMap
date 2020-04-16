//
//  CustomSegue.swift
//  OnTheMap
//
//  Created by Jan Gundorf on 16/04/2020.
//  Copyright © 2020 Jan Gundorf. All rights reserved.
//

import UIKit

class CustomSegue: UIStoryboardSegue {
    override func perform() {
      self.source.present(self.destination, animated: false, completion: nil)
    }
}
