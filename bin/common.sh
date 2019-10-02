#!/bin/bash

template_compile () {
    service_path="$(dirname ${0})"
    template_path="$service_path/$1"
    out="$2"

    awk '{
      while (match($0, /\$\{[^\}]+}/)) {
          search = substr($0, RSTART + 2, RLENGTH - 3)
           $0 = substr($0, 1, RSTART - 1)    \
             ENVIRON[search]              \
             substr($0, RSTART + RLENGTH)
      }
      print
   }' < "$template_path" > "$out"

#    awk '{while(match($0,"[$]{[^}]*}")) {var=substr($0,RSTART+2,RLENGTH -3);gsub("[$]{"var"}",ENVIRON[var])}}1' < $template
}


