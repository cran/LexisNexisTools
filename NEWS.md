# LexisNexisTools 1.0.0

* Fixes issue in tests
* articles parse from Nexis Uni now feature proper line breaks
* start removing classification data that comes from nexis

# LexisNexisTools 0.3.7

* Fixes issue in tests

# LexisNexisTools 0.3.6

* Fixes issue in tests

# LexisNexisTools 0.3.5

* Fixes issue in vignette

# LexisNexisTools 0.3.4

* Fixes for compliance with quanteda v3 (thank you @kbenoit)
* All images for building the vignette now live inside the package
* `lnt_read_lines` and `lnt_read` now ignore Word lock files

# LexisNexisTools 0.3.3

* Updated namespacing for planned v3 modularisation of quanteda (thank you @kbenoit)

# LexisNexisTools 0.3.2

* Fixed tests that caused problems on CRAN

# LexisNexisTools 0.3.1

* Added support for last remaining new format (zip).
* Fixed tests for compliance with dplyr 1.0.0 (dependency through tidytext).

# LexisNexisTools 0.3.0

* Added support for new formats introduced by Nexis Uni and Lexis Advance.
* Improved lnt_convert and added option for data.frame.
* Bug fixes and internal improvements.

# LexisNexisTools 0.2.3

* Added support for different download formats (.RTF, .DOC, .PDF[limited]).
* Fixed problems with changes in quanteda 1.5.
* Added function retrieve BibTeX entries from LNToutput.
* Added dim() method for LNToutput class.
* Improved lnt_lookup() by adding more word boundary options.

# LexisNexisTools 0.2.2

* Minor bug fixes in lnt_similarity().
* Improved way of telling users about missing packages (can now be installed directly).

# LexisNexisTools 0.2.1

* Improved headline cleaning in lnt_read() (Edition is now removed from headline).
* Minor bug fixes in lnt_similarity().
* Corrected inconsistency in lnt_convert().
* Some better error messages.
* Updated tests for lnt_diff() .

# LexisNexisTools 0.2.0

* Rewrote lnt_read() to be more stable (and faster) which rendered lnt_checkFiles() unnecessary (now deprecated).
* Added lnt_convert() to transform objects created by lnt_read() to formats used in popular text-as-data analysis packages.
* Enhanced lnt_similarity() which tended to crash when comparing longer texts due to memory limitations.
* Added lnt_diff() to display results from lnt_similarity() in a diff-like viewer.
* Added lnt_lookup() which can be used to check if the nexis keyword search worked properly or to apply simple dictionaries to subset the data.
* Added several methods to work with the S4 class `LNToutput`.
* Added vignette with basic usage.
* Enhanced documentation of of all functions.
* Started using testthat tests
