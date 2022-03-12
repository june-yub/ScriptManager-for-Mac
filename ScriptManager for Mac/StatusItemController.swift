//
//  StatusItemController.swift
//  ScriptManager for Mac
//
//  Created by Jason Jeon on 3/11/22.
//

import Cocoa
import Combine
import Carbon

final class StatusItemController
{
    let kAppToolTip = "ScriptManager for Mac"
    let kAppIcon = "scroll.fill"
    
    let kQuitName = "Quit"
    let kQuitKey = "Q"
    
    /* Temporary */
    let kDarkModeApplescriptName = "Switch Dark Mode"
    let kDarkModeApplescriptKey = "D"
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    
    private let contextMenu = NSMenu()
    
    var statusButton: NSStatusBarButton?
    {
        return statusItem.button
    }
    
    init()
    {
        if let button = statusButton
        {
            button.image = NSImage(named: kAppIcon)
            button.toolTip = kAppToolTip
            button.target = self
            button.action = #selector(handleStatusButtonPressed(_:))
            button.sendAction(on: [ .leftMouseUp, .rightMouseUp] )
        }
        
        contextMenu.items = [
            
            NSMenuItem(title: kDarkModeApplescriptName, action: #selector(handleDarkModeMenuItemPressed(_:)), target:self),
            
            NSMenuItem.separator(),
            
            NSMenuItem(title:kQuitName, action:#selector(NSApp.terminate(_:)), keyEquivalent: kQuitKey),
   
        ]
    }
    
    
    func showContextMenu(_ sender: AnyObject)
    {
        statusItem.menu = contextMenu;
        
        // clear the menu property
        defer
        {
            statusItem.menu = nil;
        }
        
        statusButton?.performClick(sender);
    }
    
    
    @objc private func handleStatusButtonPressed(_ sender: NSStatusBarButton)
    {
        guard let event = NSApp.currentEvent else{ return }
        
        guard event.clickCount > 0 else { return }
        
        let controlKey = event.modifierFlags.contains(.control)
        
        
// TODO: provide different feature between right click and left click later
        if event.type == .rightMouseUp || ( controlKey && event.type == .leftMouseUp )
        {
            showContextMenu(sender);
        }
        else if event.type == .leftMouseUp
        {
            showContextMenu(sender);
        }
        
    }
    
    @objc func handleDarkModeMenuItemPressed(_ sender: NSMenuItem )
    {
//        let manager = FileManager()
//        // Note that this assumes your .scpt file is located somewhere in the Documents directory
//        let script: URL? = try? manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//        if let scriptPath = script?.appendingPathComponent("sampleTest").appendingPathExtension("scpt").path {
//            let process = Process()
//            if process.isRunning == false {
//                let pipe = Pipe()
//                process.launchPath = "/usr/bin/osascript"
//                process.arguments = [scriptPath]
//                process.standardError = pipe
//                process.launch()
//            }
//        }

        //MARK: - ddd
        
        let sample = SampleScript()

        let parameters = NSAppleEventDescriptor.list()
        parameters.insert(NSAppleEventDescriptor(string: "Hello Cruel World!"), at: 0)

        let event = NSAppleEventDescriptor(
            eventClass: AEEventClass(kASAppleScriptSuite),
            eventID: AEEventID(kASSubroutineEvent),
            targetDescriptor: nil,
            returnID: AEReturnID(kAutoGenerateReturnID),
            transactionID: AETransactionID(kAnyTransactionID)
        )
        event.setDescriptor(NSAppleEventDescriptor(string: "displayMessage"), forKeyword: AEKeyword(keyASSubroutineName))
        event.setDescriptor(parameters, forKeyword: AEKeyword(keyDirectObject))

        var error: NSDictionary? = nil
        let result = sample.script.executeAppleEvent(event, error: &error) as NSAppleEventDescriptor?
        print(error)

    }
}

