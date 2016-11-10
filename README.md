# Loader

#### *IOS app for downloading files from links and save them in your device's storage, written on Obj-C*

**Logic of app working**: root view controller in UINavigationController is TableOfFilesVC based on UIViewController, which contains: 
- tableView, 
- toolbar with two not active bar button (current app cache size/device's free space) 
- progress view, and navigation bar with buttons "edit" and "+". 
When "+" button was pressed navigation controller does segue at AddFileVC, when user enters link and name of file which will download, then called public method "addFileFromLink:link AndName:name" in tableOfFilesVC which initialize Loader with link and name and then add its to tableOfFilesVC's array. Our tableOfFilesVC manage of mutableArray where Loaders contain and then tableView displays them in cell.
All working with downloading file and then save its to storage doing Loader. 
At reusing or creating cell take a loader for displays its value in cell, exactly are progress of downloading, current size, expected size, start date and name. At removing cell by standard type, first of all we need removeObserver from Loader which update changes of variables, we doing that by get cellForIndexPath and called public method which removeObserver and than just removeObjectAtIndex from TableOfFilesVC's array and Loader must deallocate by automatically. 

## Screenshots:
<p align="center">
<img src="https://pp.vk.me/c836420/v836420107/da15/czbKWWwVIok.jpg" width="250">
<img src="https://pp.vk.me/c836420/v836420107/da0c/B2b2wHD-RJc.jpg" width="250"> <br />   
<img src="https://pp.vk.me/c836420/v836420107/d9fa/OeeJ3pDckFA.jpg" width="250"> 
<img src="https://pp.vk.me/c836420/v836420107/d9f1/J43Auj3PtCs.jpg" width="250"> 
</p>
