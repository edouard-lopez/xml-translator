# XML-translator

`XML-translator` is a tiny `Bash` hack to demonstrate how [`XMLStarlet`](http://xmlstar.sourceforge.net/) can be used with online translator (e.g. [Google Translator](http://translate.google.com/)) to easily translate **arbitrary XML files**.

# Dependencies

* [cURL](http://curl.haxx.se/): library and command-line tool for transferring data using various protocols ;
* [XMLStarlet](http://xmlstar.sourceforge.net/): command line XML toolkit ;
* [Google Translator](http://translate.google.com/): Google's free online language translation service. The service _can be disrupted or break compatibility_ without notice.

## Disclaimer
If you want to use this script you should **be aware that's it's a hack using [Google Translate](http://translate.google.com/)**, and shouldn't be considered as a real solution.

You should also be aware that Google provide a [Translation API](https://developers.google.com/translate/) as a paid service.

## Count characters to translate

If you want to get an idea of the cost of the translation, you can use the following command to count characters to translate.

First, define `xpath`, `i18nTag` and `inputFile` to your need :

    xpath="/xpath/to/parent"
    i18nTag="tag_with_i18n"
    inputFile=./input.xml

Then run this command to count:

    xmlstarlet sel -t -m "$xpath" -v "$i18nTag" "$inputFile" | wc -c

# Usage

Simply run (_psst_, read section [Be responsible](#Be responsible) below):

    ./xml-translator.bash en zh ./test.en.xml
    Overwrite target file: ./test.en.zh.xml ? [Y/n]

Result XML –with translated string– is store in `test.en.zh.xml` ; target language is appended to input filename.

## Be responsible

By default the script _doesn't reach for Google Translator_.
So running it will result in the use of dummy text:

    [1] Terms And Conditions -> dummy text [offline mode]
    [2] Catalog Menu -> dummy text [offline mode]
    [3] Store Catalog -> dummy text [offline mode]
    [4] Mini Shopping Cart -> dummy text [offline mode]

You must **take responsabilities** for the use of this script. In order to do so, you need to set the `hackGoogle` variable to `true` in _xml-translator.bash_:

```bash
hackGoogle=true
```

Then running again will use translated text:

    [1] Terms And Conditions -> 条款和条件
    [2] Catalog Menu -> 目录菜单
    [3] Store Catalog -> 商店目录
    [4] Mini Shopping Cart -> 迷你购物车

# Troubleshooting

If the script stop immediatly, check for XML **namespace as they are problematic** with current implementation.

A simple solution is to **remove namespace**, another one is to _submit a pull request_.

Enjoy! :)
