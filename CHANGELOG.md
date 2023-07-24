## 0.0.14

- Fix another bug when text in file is not of primitive type string
  
## 0.0.13

- Fix another bug when text in file is not of primitive type string

## 0.0.12

- Fix bug when text in file is not of primitive type string

## 0.0.11

- Add new column (2nd column) to new excel template: 'type' to indicate that the word is what kind of UI; e.g. Label, Button, Textfield, etc

## 0.0.10

- Fix typo of version 0.0.9
- Replace \n with \\n (arb will be in correct json format)

## 0.0.9

- Handle language column name for english and thai wording variation

## 0.0.8

- Handle argument access overflow error

## 0.0.7

- Rename package to `arbxcel_with_options`
- Add name string value trimming
- Add translation key auto-converted to camel case (for flutter_gen compatibility)
- Change default sheet name to `Sheet1` - for google sheet export compatibility
- Add option to change sheet name when parsing .xlsx file
- Add `@@locale` key with locale e.g. `en` as value for 1st line of translated .arb files
- Change type of inserted string value as `Object` instead of `String`

## 0.0.6

- Rename bin name to `arbxcel`
- Add `executables` to pubspec.yaml 

## 0.0.5

- Add validation to each value on `name` column to check for not empty

## 0.0.4

- Changed package name to `arbxcel`
- Updated example file
- Updated README
- Updated LICENSE
- Removed `category` column

## 0.0.3-dev

- Add condition formats to the template
- Fixed default translation

## 0.0.2-dev

- Fixed embeded the excel template
- Fixed ARB format

## 0.0.1-dev

- Initial version
