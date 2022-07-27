//
//  ViewController.swift
//  PlayWithFilter
//
//  Created by Tushar Khandaker on 7/20/22.
//

import UIKit
import CoreImage

class ViewController: UIViewController {
    
    @IBOutlet weak var filterCollectionView: UICollectionView!
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.image = UIImage(named: "sampleImage.jpg", in: Bundle(for: type(of: self)), compatibleWith: nil)
        }
    }
    var filters = [AnyObject]()
    var context = CIContext()
    var currentFilter = [String : Any]()
    var currentImage = UIImage()
    var currentSliderValue = 0.0

    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        currentImage = UIImage(named: "sampleImage.jpg", in: Bundle(for: type(of: self)), compatibleWith: nil)!
        filters = readPlistData()
        collectionviewFlowlayoutSet()
        

    }
    
    @IBAction func didChangedSlideValue(_ sender: UISlider) {
        currentSliderValue = Double(sender.value)
       // applyFilter()
    }
    
    @IBAction func didTappedOnImportButton(_ sender: UIButton) {
    }
    
    @IBAction func didTappedOnSaveButton(_ sender: UIButton) {
    }
    
    
}

extension ViewController {
    
    func readPlistData()-> [AnyObject] {
        let name = "Filters"
        let fileName = name.components(separatedBy: ".")[0]
        let url = Bundle.main.url(forResource: fileName, withExtension: "plist")!
        let plistData = try! Data(contentsOf: url)
        let plistProperty = try! PropertyListSerialization.propertyList(from: plistData, options: [], format: nil)
        return plistProperty as! [AnyObject]
    }
    
    func applyFilter() {
        let sourceCIImage = CIImage(image: currentImage)
        let name = currentFilter["filter"] as! String
        if name == "-" {
            imageView.image = currentImage
            return
        }
        guard let filter = CIFilter(name: name) else { return }
        
        filter.setValue(sourceCIImage, forKey: kCIInputImageKey)
        
        
        
        filter.setValue(sourceCIImage, forKey: kCIInputImageKey)
            
            for key in self.currentFilter.keys {
                let value = self.currentFilter[key] as! String
                
                if key == "inputIntensity" {
                    filter.setValue(NSNumber(value: Float(value)!), forKey: kCIInputIntensityKey)
                }
                
                if key == "inputRadius" {
    // value from slider
                filter.setValue(value, forKey: kCIInputRadiusKey)
                    
                    
                }
                
                if key == "color" {
                    let colorValue = value.components(separatedBy: ",")
                    var r: Float
                    var g: Float
                    var b: Float
                    r = Float(colorValue[0]) ?? 0.0
                    g = Float(colorValue[1]) ?? 0.0
                    b = Float(colorValue[2]) ?? 0.0
                    
                    let color = CIColor(red: CGFloat(r / 255.0), green: CGFloat(g / 255.0), blue: CGFloat(b / 255.0))
                    filter.setValue(color, forKey: kCIInputColorKey)
                }
                
                if key == "inputAngle" {
                    filter.setValue(value, forKey: kCIInputAngleKey)
                }
                
                if key == "inputPower" {
                    filter.setValue(value, forKey: "inputPower")
                }
                
                if key == "inputAmount" {
       // slider value
                        filter.setValue(NSNumber(value: Float(value)!), forKey: kCIInputAmountKey)
                    
                }
                
                if key == "inputLevels" {
                    filter.setValue(value, forKey: "inputLevels")
                }
                
                if key == "inputCenter" {
                    let centerValue = value.components(separatedBy: ",")
                    let x = Float(centerValue[0]) ?? 150.0
                    let y = Float(centerValue[1]) ?? 150.0
                    let vector = CIVector(x: CGFloat(x), y: CGFloat(y))
                    filter.setValue(vector, forKey: kCIInputCenterKey)
                }
                
                if key == "inputScale" {
                    //value from slider
                    filter.setValue(value, forKey: kCIInputScaleKey)
                }
                
            }

        if let cgimg = context.createCGImage(filter.outputImage!, from: filter.outputImage!.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            self.imageView.image = processedImage
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }
        //cell.label.text = filters[indexPath.item]["name"] as! String
        cell.imageView.image = currentImage
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //center need
        currentFilter = filters[indexPath.item] as! [String : Any]
        applyFilter()
    }
}

extension ViewController {
    func collectionviewFlowlayoutSet() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let width = (filterCollectionView.bounds.width - 40) / 5.5
        layout.itemSize = CGSize(width: width, height: filterCollectionView.bounds.height)
        filterCollectionView.collectionViewLayout = layout
    }
}
