# Notes on using extensions in FA 2.4

## Extensionsimport_multijournalentries
### import_multijournalentries
* [Forum Post](http://frontaccounting.com/punbb/viewtopic.php?pid=26370#p26370) - Replace line 163 ````if $Refs->exists($type, $reference)) {```` in file ````/modules/import_multijournalentries/import_multijournalentries.php```` with ````if (!($Refs->is_new_reference($reference,$type))) {````

