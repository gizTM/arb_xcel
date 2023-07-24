# ARB Excel

For reading, creating and updating ARB files from XLSX files.

> **Has custom change for specific excel file structure**
> When generating new excel template, a file with columns' title should be `name`, `type`, `description`, `en`, `vi`.
> The up to the 4th column is the translated language text column; it's up to user to edit the generated excel file.

## Install

```bash
pub global activate arbxcel
```

## Usage

```bash
pub global run arbxcel

arbxcel [OPTIONS] path/to/file/name

OPTIONS
-n, --new      New translation sheet
-a, --arb      Export to ARB files
-e, --excel    Import ARB files to sheet
```

Creates a XLSX template file.

```bash
pub global run arbxcel -n app.xlsx
```

Generates ARB files from a XLSX file.

```bash
pub global run arbxcel -a app.xlsx
```

Creates a XLSX file from ARB files.

```bash
pub global run arbxcel -e app_en.arb
```
