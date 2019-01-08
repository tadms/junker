# junker
Recursively delete ALL 'junk files' in a given directory.  


Junk file types/patterns are defined in the script as a global variable: 

* `JUNK_FILE_TYPES="*.nfo *.txt *.png *.jpg *.lnk"`

##Usage: 

        # Run against current directory
        ./junker.sh

        # Specify directory as /foo/bar
        ./junker.sh /foo/bar