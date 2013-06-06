# XML-translator

`XML-translator` is a tiny `Bash` hack to demonstrate how [`XMLStarlet`](http://xmlstar.sourceforge.net/) can be used with online translator (e.g. [Google Translator](http://translate.google.com/)) to easily translate **arbitrary XML files**.

# Dependencies

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

