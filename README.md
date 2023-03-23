# JMeter Icon
(This is not the best practice. It's my answer for  [question on Stackowerflow](https://stackoverflow.com/questions/35615060/mac-osx-create-shortcut-to-usr-local-bin-jmeter/75822413#75822413))


It may not be relevant for you, but maybe my method will be useful to someone.

- I wanted to add a nice icon to the launcher.
- I wanted this icon to remain in the dock while the application is running.

How I did it:

1. I installed JMeter `brew install jmeter`
2. Created folder `JMeter.app` in home directory.
   ```
   mkdir -p ~/JMeter.app/Contents
   ```
3. Create `~/JMeter.app/Contents/Info.plist` with the contents
   ```
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
   <plist version="1.0">
   <dict>
	   <key>CFBundleDisplayName</key>
	   <string>JMeter</string>
	   <key>CFBundleDocumentTypes</key>
	   <array>
		   <dict>
			   <key>CFBundleTypeName</key>
			   <string>Folder</string>
			   <key>CFBundleTypeRole</key>
			   <string>Editor</string>
			   <key>LSItemContentTypes</key>
			   <array>
				   <string>public.folder</string>
			   </array>
		   </dict>
	   </array>
	   <key>CFBundleExecutable</key>
	   <string>JMeter</string>
	   <key>CFBundleIconFile</key>
	   <string>JMeter.icns</string>
	   <key>CFBundleIdentifier</key>
	  <string>dev.jmeter.jmeter-custom</string>
	  <key>CFBundleInfoDictionaryVersion</key>
	  <string>6.0</string>
	  <key>CFBundleName</key>
	  <string>JMeter</string>
	  <key>CFBundlePackageType</key>
	  <string>APPL</string>
	  <key>CFBundleShortVersionString</key>
	  <string>0.1.0</string>
	  <key>CFBundleURLTypes</key>
	  <array>
	    	<dict>
			   <key>CFBundleURLName</key>
			   <string>Custom App</string>
			   <key>CFBundleURLSchemes</key>
			   <array>
				   <string>JMeter</string>
			   </array>
		    </dict>
	   </array>
   </dict>
   </plist>
   ```

4. Create `~/JMeter.app/MacOS/JMeter` with next the contents (you may need to fix the path, in fact it is an analogue of the file  `cat $(which jmeter)` with some changes)

   ```
   #!/bin/bash
   JMETER_OPTS="${JMETER_OPTS} -Xdock:icon=/Applications/JMeter.app/Icon.png -Xdock:name=JMeter -Dapple.laf.useScreenMenuBar=true -Dapple.eawt.quitStrategy=CLOSE_ALL_WINDOWS" JAVA_HOME="/opt/homebrew/opt/openjdk" exec "/opt/homebrew/Cellar/jmeter/5.5/libexec/bin/jmeter"  "$@"

   ```
   And make it executable 
   ```
   chmod +x ~/JMeter.app/MacOS/JMeter
   ```


5. Create icon JMeter.icns in `~/JMeter.app/Resources/JMeter.icns`.
   How to:

   5.1 You can [download my png icon][1] to `~/JMeter.app/Icon.png`

   5.2 Save the script to `~/JMeter.app/icongen.sh` (I took it here https://stackoverflow.com/questions/646671/how-do-i-set-the-icon-for-my-applications-mac-os-x-app-bundle and little changed it)

       ```
       #/bin/zsh

       export PROJECT=JMeter
       export ICONDIR=Contents/Resources/$PROJECT.iconset
       export ORIGICON=Icon.png
       mkdir $ICONDIR
       
       # Normal screen icons
       for SIZE in 16 32 64 128 256 512; do
       sips -z $SIZE $SIZE $ORIGICON --out $ICONDIR/icon_${SIZE}x${SIZE}.png ;
       done

       # Retina display icons
       for SIZE in 32 64 256 512 1024; do
       sips -z $SIZE $SIZE $ORIGICON --out $ICONDIR/icon_$(expr $SIZE / 2)x$(expr $SIZE / 2)x2.png ;
       done

       # Make a multi-resolution Icon
       iconutil -c icns $ICONDIR -o Contents/Resources/$PROJECT.icns
       rm -rf $ICONDIR #it is useless now

 
     5.3 Run this step by step
     ```
     $ cd ~/JMeter.app
     $ chmod +x icongen.sh
     $ ./icongen.sh
     ```

6. As a result, you should get the following structure

   ```
   .
   ├── Contents
   │   ├── Info.plist
   │   ├── MacOS
   │   │   └── jmeter
   │   └── Resources
   │       └── JMeter.icns
   ├── Icon.png
   └── icongen.sh
   
   4 directories, 5 files
   ```
   Make sure in the Finder that the icon is loaded for ~/JMeter.app. You can run a command to speed this up.
   ```
   touch ~/JMeter.app

   ```
7. Final steps. I studied the file and found that the application icon is overridden by a parameter there. That's why we changed the startup script (symlink). We need to change the file `/opt/homebrew/Cellar/jmeter/5.5/libexec/bin/jmeter` . I commented out a block of code (line:133-145): 

   ```
   # case `uname` in
   #    Darwin*)
   #    # Add Mac-specific properties - should be ignored elsewhere (Bug 47064)
   #    if [ -f ${PRGDIR}/../xdocs/images/jmeter_square.png ]; then
   #        JMETER_OPTS="${JMETER_OPTS} -Xdock:icon=${PRGDIR}/../xdocs/images/jmeter_square.png"
   #    elif [ -f ${PRGDIR}/../docs/images/jmeter_square.png ]; then
   #        JMETER_OPTS="${JMETER_OPTS} -Xdock:icon=${PRGDIR}/../docs/images/jmeter_square.png"
   #    fi
   #    # Note: macOS still shows "java" process name (see https://bugs.openjdk.java.net/browse/JDK-8173753)
   #    # The workaround could be to distribute *.dmg bundle
   #    JMETER_OPTS="${JMETER_OPTS} -Xdock:name=JMeter -Xdock:icon=${PRGDIR}/../docs/images/jmeter_square.png -Dapple.laf.useScreenMenuBar=true -Dapple.eawt.quitStrategy=CLOSE_ALL_WINDOWS"
   #    ;;
   # esac
   ```
8. Well. Move `JMeter.app` to `/Applications/Jmeter.app`.
9. Try run it


  [1]: https://www.figma.com/file/F4vjP1HuMDOuhobdUIOvXF/JMeter-Icon?node-id=0%3A1&t=3Jz06JAsMsZoPRvK-1