#!/bin/bash

num_funcs=$(grep -c "://" "$1")
num_pkgs=$(grep "://" "$1" | sed 's/.*:\/\///' | cut -f1 -d "/" | grep . | sort | uniq | wc -l)
num_paths=$(grep "://" "$1" | grep '\[' | sed 's/.*:\/\///' | sed 's/.*\]//' | grep . | sort | uniq | wc -l)
num_edges=$(awk '{$1=$1;print}' "$1" | sed s/,$// | grep -c "^\\d\\+$")
num_sources1=$(awk '{$1=$1;print}' "$1" | grep -c '"nodes": \[')
num_sources2=$(awk '{$1=$1;print}' "$1" | grep "\[$" | grep -c "\"\\d\\+\"")
num_sources=$((num_sources1+num_sources2))

num_funcs=$(echo "$num_funcs" | tr -d ' ')
num_pkgs=$(echo "$num_pkgs" | tr -d ' ')
num_paths=$(echo "$num_paths" | tr -d ' ')
num_edges=$(echo "$num_edges" | tr -d ' ')
num_sources=$(echo "$num_sources" | tr -d ' ')

echo "Functions: $num_funcs"
echo "Packages:  $num_pkgs"
echo "Paths:     $num_paths"
echo "Edges:     $num_edges"
echo "Sources:   $num_sources"

# HOW TO GET CALL GRAPHS
#
# JSA
# src/rust/target/release/jsa --print-cg --json-output $repo_or_jsfile_path > jsa_$project.json
#
# JSCG
# bazel run //src/golang/internal.endor.ai/service/endorctl/plugin/jsplugin/main:jscg -- -callgraph -dir $repo_path -dumpPath jscg_$project.json
# for single .js file scans, need to copy to a folder first:
#   mkdir /tmp/jscg && cp $js_file_path /tmp/jscg
#   bazel run //src/golang/internal.endor.ai/service/endorctl/plugin/jsplugin/main:jscg -- -callgraph -dir /tmp/jscg -dumpPath jscg_$project.json
#
# Jelly (static)
# jelly -j jelly_orig.json $repo_or_jsfile_path
# bazel run //src/golang/internal.endor.ai/pkg/x/jelly2endor -- --in jelly_orig.json --out jelly_conv.json --src $repo_path
# cat jelly_conv.json | jq  > jelly_$project.json
# OR
# env NODE_OPTIONS=--max-old-space-size=$mem_guess jelly -j jelly_orig.json $repo_or_jsfile_path && bazel run //src/golang/internal.endor.ai/pkg/x/jelly2endor -- --in $PWD/jelly_orig.json --out $PWD/jelly_conv.json --src $repo_path && cat jelly_conv.json | jq  > jelly_$project.json
#
# Jelly (dynamic)
# TBD