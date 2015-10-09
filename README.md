# Convxml parser plugin for Embulk

embulkを使用して、xmlから好きな名前でカラムを作成する<br>
※複数のレコードにも対応※


## Overview

* **Plugin type**: parser
* **Guess supported**: no

## Example

* input.xml
```yaml
<root>
    <a name="a1">
        <b>bbb1</b>
        <b>bbb2</b>
        <b>bbb3</b>
        <c>ccc1</c>
    </a>
    <a>
        <b>bbb4</b>
        <b>bbb5</b>
        <b>bbb6</b>
        <c>ccc2</c>
    </a>
</root>
```
* config.yml
```yaml
in:
  type: file
  path_prefix: input.xml
  parser:
   type: singlexml
   schema:
   - {name: a_name1, type: string, exp: "doc.elements['root/a/a_b'].text"}
   - {name: c_name2, type: string, exp: "doc.elements['root/a/c/a_c_d2'].text"}
exec: {}
out:
 type: stdout
```
* preview
```yaml
+----------------+----------------+
| a_name1:string | c_name2:string |
+----------------+----------------+
|            a_b |           acd2 |
+----------------+----------------+
```
