//
//  ViewController.swift
//  elsa-ble
//
//  Created by Michael Irimus on 01.08.18.
//  Copyright © 2018 Michael Irimus. All rights reserved.
//

import UIKit
import CoreBluetooth

var txCharacteristic        : CBCharacteristic!
var rxCharacteristic        : CBCharacteristic!
var activeCharacteristic    : CBCharacteristic!

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager:CBCentralManager!
    var elsa:CBPeripheral!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    //Central Manager init
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        var message = ""
        
        //check BLE state of the device
        switch central.state {
        case CBManagerState.poweredOn:
            message = "BLE is Powered ON"
            //scan only for peripherals with the defined Services
            centralManager.scanForPeripherals(withServices: SERVICES, options: nil)
        case CBManagerState.poweredOff:
            message = "Bluetooth on this device is currently powered off."
        case CBManagerState.unsupported:
            message = "This device does not support Bluetooth Low Energy."
        case CBManagerState.unauthorized:
            message = "This app is not authorized to use Bluetooth Low Energy."
        case CBManagerState.resetting:
            message = "The BLE Manager is resetting; a state update is pending."
        case CBManagerState.unknown:
            message = "The state of the BLE Manager is unknown."
        }
        print(message)
        if(message == "BLE is Powered ON"){
            print("Start Scanning...")
        }
    }
    
    //Discover Peripherals
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("\nPeripheral found:", peripheral.name!)
        //if more peripherals are found with the same SERVICES, choose explicitly my cylinder
        if(peripheral.name! == "E-v3-4"){
            centralManager.stopScan()
            print("This is Elsa. Stop scanning and connecting to device...")
            elsa = peripheral.self
            centralManager.connect(elsa, options: nil)
        }
    }
    
    //Connection Successfull
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connection successfull")
        elsa.delegate = self
        print("\nServices of \(elsa.name!):")
        elsa.discoverServices(SERVICES)
    }
    
    //Exception Handling @ connection establishment
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Connection failed")
    }
    
    //Discover Services
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        //iterate through all services of a given Peripheral
        for CBService in peripheral.services!{
            print("\n\(CBService) has Characteristics:")
            //discover the Characteristics of every Service
            elsa.discoverCharacteristics(CMD_SERVICE_CHARACTERISTICS, for: CBService)
        }
    }
    
    //Discover Characteristics
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        //iterate through all characteristics of a given Service
        for characteristic in service.characteristics!{
            print(characteristic)
            if(characteristic.uuid == TX_CHARACTERISTIC){
                txCharacteristic = characteristic
            } else if(characteristic.uuid == RX_CHARACTERISTIC){
                rxCharacteristic = characteristic
                //Subscribe to RX-Characteristic so that every new Value is published and printed
                elsa.setNotifyValue(true, for: characteristic)
            } else if(characteristic.uuid == ACTIVE_CHARACTERISTIC){
                activeCharacteristic = characteristic
                //Activate Bridge (0 deactivated, 1 activated)
                print("\nActivating Bridge..")
                elsa.writeValue(dataWithHexString(hex: "01"), for: characteristic, type: CBCharacteristicWriteType.withResponse)
                elsa.readValue(for: characteristic)
            }
        }
    }
    
    @IBAction func INIT_DATA_BUTTON(_ sender : UIButton){
        print("\nINIT_DATA")
        sleep(1)
        let initDataRequest : InitDataRequest! = InitDataRequest()
        initDataRequest.setParameter(communicationKey: Array(DEV_KEY.utf8), busAddress: BusAddress.BCU, localOnly: false)
        elsa.writeValue(createRequest(request: initDataRequest), for: txCharacteristic, type: CBCharacteristicWriteType.withoutResponse)
        elsa.readValue(for: txCharacteristic)
        sleep(1)
    }
    
    @IBAction func SYNC_START_BUTTON(_ sender : UIButton){
        print("\nSYNC_START")
        sleep(1)
        let syncStartRequest : SyncStartRequest! = SyncStartRequest()
        syncStartRequest.setParameter(usingOddKey: 0, authorizationID: 0)
        elsa.writeValue(createRequest(request: syncStartRequest), for: txCharacteristic, type: CBCharacteristicWriteType.withoutResponse)
        //elsa.writeValue(dataWithHexString(hex: VALID_SYNC_START_REQUEST), for: txCharacteristic, type: CBCharacteristicWriteType.withoutResponse)
        elsa.readValue(for: txCharacteristic)
        sleep(1)
    }
    
    @IBAction func SYNC_END_BUTTON(_ sender : UIButton){
        print("\nSYNC_END")
        sleep(1)
        let syncEndRequest : SyncEndRequest! = SyncEndRequest()
        syncEndRequest.setParameter(status: syncStartResponse.getStatus(), ekRndARndB2: _ekRndARndB2)
        elsa.writeValue(createRequest(request: syncEndRequest), for: txCharacteristic, type: CBCharacteristicWriteType.withoutResponse)
        //elsa.writeValue(dataWithHexString(hex: VALID_SYNC_END_REQUEST), for: txCharacteristic, type: CBCharacteristicWriteType.withoutResponse)
        elsa.readValue(for: txCharacteristic)
        sleep(1)
    }
    
    @IBAction func DEINIT_BUTTON(_ sender: UIButton){
        print("\nDEINIT")
        sleep(1)
        elsa.writeValue(dataWithHexString(hex: VALID_DEINIT_REQUEST), for: txCharacteristic, type: CBCharacteristicWriteType.withoutResponse)
        elsa.readValue(for: txCharacteristic)
        sleep(1)
    }
    
    @IBAction func GET_VERSION_BUTTON(_ sender: UIButton){
        print("\nGET_VERSION")
        sleep(1)
        let getVersionRequest : GetVersionRequest! = GetVersionRequest()
        elsa.writeValue(createRequest(request: getVersionRequest), for: txCharacteristic, type: CBCharacteristicWriteType.withoutResponse)
        //elsa.writeValue(dataWithHexString(hex: VALID_GET_VERSION_REQUEST), for: txCharacteristic, type: CBCharacteristicWriteType.withoutResponse)
        elsa.readValue(for: txCharacteristic)
        sleep(1)
    }
    
    @IBAction func GET_BATTERY_LEVEL_BUTTON(_ sender: UIButton){
        print("\nGET_BATTERY_LEVEL")
        sleep(1)
        elsa.writeValue(dataWithHexString(hex: VALID_GET_BATTERY_LEVEL_REQUEST), for: txCharacteristic, type: CBCharacteristicWriteType.withoutResponse)
        elsa.readValue(for: txCharacteristic)
        sleep(1)
    }
    
    @IBAction func GET_AUTHORIZATION_IDENTIFIER_BUTTON(_ sender: UIButton){
        print("\nGET_AUTHORIZATION_IDENTIFIER")
        sleep(1)
        elsa.writeValue(dataWithHexString(hex: VALID_GET_AUTHORIZATION_IDENTIFIER_REQUEST), for: txCharacteristic, type: CBCharacteristicWriteType.withoutResponse)
        elsa.readValue(for: txCharacteristic)
        sleep(1)
    }
    
    @IBAction func GET_TIME_BUTTON(_ sender : UIButton){
        print("\nGET_TIME")
        sleep(1)
        elsa.writeValue(dataWithHexString(hex: VALID_GET_TIME_REQUEST), for: txCharacteristic, type: CBCharacteristicWriteType.withoutResponse)
        elsa.readValue(for: txCharacteristic)
        sleep(1)
    }
    
    //Called @ Updates of subscribed Characteristics
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        sleep(1)
        if(characteristic.uuid == TX_CHARACTERISTIC){
            guard let data = characteristic.value else { return }
            print("Sending:     \(data.toHexEncodedString())")
        } else if(characteristic.uuid == RX_CHARACTERISTIC){
            //read the mutated Data
            guard let data = characteristic.value else { return }
            let dataString = data.toHexEncodedString()
            print("Received:    \(dataString)")
            //check received data and create responses
            messageTransform(dataString: dataString)
        } else if(characteristic.uuid == ACTIVE_CHARACTERISTIC){
            guard let data = characteristic.value else { return }
            if(data.toHexEncodedString() == "01"){
                print("Bridge Activated. Please select one Command on the Screen...")
            } else {
                print("Bridge not Activated")
            }
        }
        //Exception Handling
        if(error != nil){
            print("\nError while reading from Characteristic:\n\(characteristic). Error Message:")
            print(error as Any)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("\nConnection disrupted")
    }
    
    @IBAction func disconnectButton(_ sender: UIButton) {
        if elsa != nil {
            centralManager?.cancelPeripheralConnection(elsa!)
        }
    }
}
