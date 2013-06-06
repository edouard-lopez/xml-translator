#!/usr/bin/env bash
# DESCRIPTION
#   Translate <DefaultValue> and add a new <Value> element to each <Resource> node.
#   To get a starting environement run the following command:
#     cp Resources.{en,fr}.xml # create a copy from source lang to target lang
#
# USAGE
#   ./xml-translator.bash en fr
#
# @author: Édouard Lopez dev+coaxis@edouard-lopez.com


sourceLang="$1"
targetLang="$2"
inputFile="./Resources.$sourceLang.xml"
outputFile="./Resources.$targetLang.xml"

let count=$(xmlstarlet sel -t -m "/" -v "count(/Resources/Resource/DefaultValue)" "$inputFile")

# Translates a phrase from English to Portuguese
function translate() {
  local text="$1"
  local sourceLang="$2"
  local targetLang="$3"
  curl -A "Mozilla/5.0 XML-translator" --data-urlencode text="$text" "http://translate.google.com/translate_a/t?client=t&hl=en&sl=$sourceLang&tl=$targetLang&ie=UTF-8&oe=UTF-8&multires=1&prev=btn&ssel=0&tsel=0&sc=1" | sed 's/\[\[\["\([^"]*\).*/\1/'
}


function run() {
  local sourceLang="$1"
  local targetLang="$2"

  for ((i=1; i<=$count; i++));
  do
    echo "$i"
    text="$(xmlstarlet sel -t \
        -m "/Resources/Resource[$i]" \
        -v "./DefaultValue" \
        -n "$inputFile"
      )"
    # trad="$(translate "$text" "$sourceLang" "$targetLang")"
    trad="dummy translation test"
    printf "%s -> %s\n" "$text" "$trad"
    xmlstarlet ed -a "/Resources/Resource[$i]/DefaultValue" \
      -t elem -n "Value" \
      -v "$trad" "$outputFile" \
      > "$outputFile.tmp"
    cp "$outputFile"{.tmp,}
  done
}

run "$sourceLang" "$targetLang"
