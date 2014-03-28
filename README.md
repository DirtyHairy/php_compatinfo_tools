# What it is

This is a bunch of utilities for use with the awesome 
[php_compatinfo](https://github.com/llaville/php-compat-info) tool.

WARNING: This is not polished, and any additonal references are likely to be not
accurate concerning either the version of the extension or the PHP versions supported.

# What it contains

## Additional references

* Translit:
  Supports the PECL translit extension
* CS_ALL:
  Extends the ALL reference set to include Translit

## Misc stuff

* ```bin/analyze_extensions.pl```:
   This perl script processes the XML report generated by php_compatinfo with
   the -vvv option and collects all referenced extensions together with the
   files in which they are referenced (and which functions / constants
   / namespaces / classes are used). No new information is added, but the data
   is grouped w.r.t. extensions rather than files.

# Usage

If you like these tools, feel free to use them. If you modifiy and republish
them, please include a reference to where you got them from. If you like them,
drop me a line and buy me a beer ;)

Copyright (c) 2014 Christian Speckner <cnspeckn@googlemail.com>
