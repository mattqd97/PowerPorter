import UIKit
import CoreML

/**
  View controller for the "Training Nearest Neighbors" screen.
 */
class TrainNearestNeighborsViewController: UITableViewController {

  //@IBOutlet var allButton: UIBarButtonItem!

  let headerNib = UINib(nibName: "SectionHeaderView", bundle: nil)

  var model: MLModel!
  //var imagesByLabel: ImagesByLabel!
  //var imageLoader: ImageLoader!
  var selected: Set<IndexPath> = []
  var alreadyTrained = Set<IndexPath>()

  override func viewDidLoad() {
    super.viewDidLoad()

//    let cellNib = UINib(nibName: "ExampleCell", bundle: nil)
//    tableView.register(cellNib, forCellReuseIdentifier: "ExampleCell")

    //trainButton.isEnabled = false
    //Models.copyEmptyNearestNeighbors()
    model = Models.loadTrainedNearestNeighbors()
    assert(model.modelDescription.isUpdatable)

    //print(model.modelDescription.trainingInputDescriptionsByName)
    //print(model.modelDescription.parameterDescriptionsByKey)
  }

  // MARK: - Table view data source

//  override func numberOfSections(in tableView: UITableView) -> Int {
//    //imagesByLabel.numberOfLabels
//    0
//  }
//
//  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    //imagesByLabel.numberOfImages(for: imagesByLabel.labelName(of: section))
//    0
//  }
//
//  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//    //imagesByLabel.labelName(of: section)
//    0
//  }
//
//  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//    88
//  }
//
////  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//////    let view = headerNib.instantiate(withOwner: self, options: nil)[0] as! SectionHeaderView
//////    view.label.text = imagesByLabel.labelName(of: section)
//////    view.libraryButton.isHidden = true
//////    view.cameraButton.isHidden = true
//////    return view
////
////  }
//
//  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//    132
//  }
//
//  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////    let cell = tableView.dequeueReusableCell(withIdentifier: "ExampleCell", for: indexPath) as! ExampleCell
////    let label = imagesByLabel.labelName(of: indexPath.section)
////    if let image = imagesByLabel.image(for: label, at: indexPath.row) {
////      cell.exampleImageView.image = image
////    } else {
////      cell.exampleImageView.image = nil
////      cell.selectedLabel.isHidden = true
////    }
////    updateSelectionMark(forCell: cell, at: indexPath)
////    return cell
//  }

  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    alreadyTrained.contains(indexPath) ? nil : indexPath
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if selected.contains(indexPath) {
      selected.remove(indexPath)
    } else {
      selected.insert(indexPath)
    }

    updateSelectionMark(at: indexPath)
    tableView.deselectRow(at: indexPath, animated: true)

    updateTrainButton()
  }

  private func updateSelectionMark(at indexPath: IndexPath) {
//    if let cell = tableView.cellForRow(at: indexPath) as? ExampleCell {
//      updateSelectionMark(forCell: cell, at: indexPath)
//    }
  }

//  private func updateSelectionMark(forCell cell: ExampleCell, at indexPath: IndexPath) {
//    if alreadyTrained.contains(indexPath) {
//      cell.selectedLabel.isHidden = false
//      cell.selectedLabel.isEnabled = false
//      cell.selectedLabel.text = "☆"
//      cell.selectionStyle = .none
//    } else {
//      cell.selectedLabel.isHidden = !selected.contains(indexPath)
//      cell.selectedLabel.isEnabled = true
//      cell.selectedLabel.text = "★"
//      cell.selectionStyle = .default
//    }
//  }

  @IBAction func allButtonPressed() {
    selected = []
    for section in 0..<tableView.numberOfSections {
      for row in 0..<tableView.numberOfRows(inSection: section) {
        let indexPath = IndexPath(row: row, section: section)
        if !alreadyTrained.contains(indexPath) {
          selected.insert(indexPath)
        }
      }
    }

    tableView.reloadData()
    updateTrainButton()
  }

  // MARK: - Training

  private func updateTrainButton() {
    //trainButton.isEnabled = !selected.isEmpty
  }

  

  @IBAction func trainData(_ sender: Any) {
    DispatchQueue.global().async {
      self.train()
    }
  }
  
  
  
  //  @IBAction func trainButtonPressed() {
//    allButton.isEnabled = false
//    trainButton.isEnabled = false
//    view.isUserInteractionEnabled = false
//
//
//  }

  private func trainingDidComplete(success: Bool) {
    // Mark the examples as "already trained" and clear the selection.
    // Note that we don't remember this state after you leave this screen.
    alreadyTrained = alreadyTrained.union(selected)
    selected = []

    DispatchQueue.main.async {
      if success {
        //self.showDialog(message: "Training finished!")
        print("Training finished!")
      } else {
        //self.showDialog(message: "Errors during training")
        print("Errors during training")
      }

      self.tableView.reloadData()
      self.view.isUserInteractionEnabled = true
      //self.allButton.isEnabled = true
    }
  }

  private func batchProvider() throws -> MLBatchProvider {
    var batchInputs: [MLFeatureProvider] = []
    
    var infeat: [MLMultiArray] = []
    var label: [String] = [];
    var arrayTitle = [Float32]()

    arrayTitle.append(32)
    arrayTitle.append(21)
    arrayTitle.append(120)
    arrayTitle.append(39)

    
    
    let mlArray = try MLMultiArray(shape: [4], dataType: MLMultiArrayDataType.float32)
    
    for i in 0..<arrayTitle.count {
        mlArray[i] = NSNumber(value: arrayTitle[i])
        
    }
    
    for _ in 0..<10{
        infeat.append(mlArray)
        label.append("1")
    }

    for i in 0..<infeat.count {
        let featureProvider = HandskNNTrainingInput(features: infeat[i], label: label[i])
        batchInputs.append(featureProvider)
    }

    return MLArrayBatchProvider(array: batchInputs)
  }

  private func train() {
    do {
      let trainingData = try batchProvider()

      let updatableModelURL = Models.trainedNearestNeighborsURL
      //let updatableModelURL = Bundle.main.url(forResource: "HandskNN", withExtension: "mlmodel")

      let config = model.configuration

      let updateTask = try MLUpdateTask(forModelAt: updatableModelURL,
                                        trainingData: trainingData,
                                        configuration: config,
                                        completionHandler: { context in
        //print("Done!", context)

        // Overwrite the mlmodelc with the updated one.
        do {
          let tempURL = urlForModelInDocumentsDirectory("tempNearestNeighbors")
          try context.model.write(to: tempURL)

          Models.deleteTrainedNearestNeighbors()
          copyIfNotExists(from: tempURL, to: updatableModelURL)
          removeIfExists(at: tempURL)
        } catch {
          print("Error saving k-NN model:", error)
        }

        self.trainingDidComplete(success: true)
      })

      updateTask.resume()
    } catch {
      print("Error training k-NN:", error)
      trainingDidComplete(success: false)
    }
  }
}
