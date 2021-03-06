#!/usr/bin/env bash
# DESCRIPTION
#   Translate <DefaultValue> and add a new <Value> element to each <Resource> node.
#   To get a starting environement run the following command:
#     cp Resources.{en,fr}.xml # create a copy from source lang to target lang
#
# USAGE
#   ./xml-translator.bash en fr input.xml
#
# @author: Édouard Lopez <dev+xml-translator@edouard-lopez.com>


# @description should you hack Google translator
hackGoogle=false

# @description Xpath to each item is build as $xpath[i]/$i18nTag
xpath="/Resources/Resource"
i18nTag="DefaultValue"

sourceLang="$1"
targetLang="$2"
inputFile="$3"
outputFile="${inputFile%.xml}.$targetLang.xml"


# @description Translate a phrase in a source language to a target language
#
# @param    $1|$text  text to translate
# @param    $2|$sourceLang  language code for source (@see. https://developers.google.com/translate/v2/using_rest#language-params)
# @param    $3|$targetLang  language code for source (@see. https://developers.google.com/translate/v2/using_rest#language-params)
#
# @return    string   HTML page return by translator
function translate() {
  local text="$1"
  local sourceLang="$2"
  local targetLang="$3"

  if $hackGoogle; then
    curl  -A "Mozilla/5.0 XML-translator" -s \
          --data-urlencode text="$text" \
          "http://translate.google.com/translate_a/t?client=t&hl=en&sl=$sourceLang&tl=$targetLang&ie=UTF-8&oe=UTF-8&multires=1&prev=btn&ssel=0&tsel=0&sc=1" \
          | sed 's/\[\[\["\([^"]*\).*/\1/'
  else
    echo "dummy text [offline mode]"
  fi
}


#
function run() {
  local sourceLang="$1"
  local targetLang="$2"
  local let count=$(xmlstarlet sel -t -m "/" -v "count($xpath/$i18nTag)" "$inputFile")


  for ((i=1; i<=$count; i++));
  do
    local itemParent="$xpath[$i]"

    text="$(xmlstarlet sel -t \
        -m "$itemParent" \
        -v "$i18nTag/text()" \
        -n "$inputFile"
      )"
    trad="$(translate "$text" "$sourceLang" "$targetLang")"

    printf "[%s] %s -> %s\n" "$i" "$text" "$trad"
    xmlstarlet ed -a "$itemParent/$i18nTag" \
      -t elem -n "Value" \
      -v "$trad" "$outputFile" \
      > "$outputFile.tmp"
    cp "$outputFile"{.tmp,}
  done

  rm "$outputFile.tmp"
}


while :
do

  erase="y"
  [[ -f $outputFile ]] && read -p "Overwrite target file: $outputFile ? [Y/n]" erase

  if [[ -z $erase || $erase == [yY] ]]; then
    printf "\n"
    cp "$inputFile" "$outputFile"
    run "$sourceLang" "$targetLang"
    exit 0
  else
    exit 1
  fi
done
