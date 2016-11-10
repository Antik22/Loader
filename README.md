# Loader
IOS application for downloading files from links and save them in your device's storage, used obj-c

Logic of app working: root view controller in UINavigationController is TableOfFilesVC based on UIViewController, which contains tableView, toolbar with two not active button (current app cache size/device's free space) and progress view, and navigation bar with buttons "edit" and "+". 
When "+" button was pressed navigation controller does segue at AddFileVC, when user enters link and name of file which will download, then called public method "addFileFromLink:link AndName:name" in tableOfFilesVC which initialize Loader with link and name and then add its to tableOfFilesVC's array.
Our tableOfFilesVC manage of mutableArray where Loaders contain and then tableView displays them in cell, at reusing cell take a loader for displays its value in cell. 
At removing cell by standard type, first of all we need removeObserver from Loader which update changes of variables, we doing that by get cellForIndexPath and called public method which removeObserver and than just removeObjectAtIndex from TableOfFilesVC's array and Loader must deallocate by automatically.
