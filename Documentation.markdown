## Quicksilver Google Chrome plugin ##

This plugin adds functionality for accessing different aspects of [Google
Chrome](https://www.google.com/chrome) in Quicksilver.

This plugin contains adapted code from the [Safari
plugin](https://github.com/quicksilver/com.apple.Safari-qsplugin).

### Catalog ###

The following additions are made to the catalog:

* **Open web pages** - A container for the current open web pages in Chrome, access the actual web pages by right arrowing into the container. Also available when right arrowing into the Chrome application.
* **Bookmarks** - The top level bookmarks and bookmark folders from Chrome. Also available when right arrowing into the Chrome application
* **History** - The 300 latest history entries in Chrome. The number in the catalog is limited to 300 for performance reasons. The history entries are also available when right arrowing into the Chrome application, and it includes all of the history, no limits.

### Actions ###

The following actions are available:

* **Reveal tab in Chrome** - Activates the tab in Chrome that contains the selected web page. This is only available for Chrome Tab types, i.e. the listing under "Open web pages", or "Current Web Page".
* **Reload tab in Chrome** - Reloads the tab in Chrome that contains the selected web page. This is only available for Chrome Tab types, i.e. the listing under "Open web pages", or "Current Web Page".

### Proxies ###

The following proxies are available:

* **Current Web Page** - The web page currently displayed in the frontmost tab of the frontmost window in Chrome.
* **Current Web Site** - A web search on the site displayed in the frontmost tab of the frontmost window in Chrome.

### Types ###

The following new types are defined:

* **Chrome Tab** - A currently open tab in Chrome. Used as secondary type on URLs coming from Chrome tabs.

### Additional information ###

The icon used for the bookmarks folder is created by [Ernesto
Monasterio](http://ermonas.deviantart.com/), and can be found
[Here](http://ermonas.deviantart.com/art/Google-Chrome-Folder-Icon-201492913).
The icon is licensed under a [Creative Commons Attribution-Noncommercial-Share
Alike 3.0 License](http://creativecommons.org/licenses/by-nc-sa/3.0/).
