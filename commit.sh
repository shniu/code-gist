#!/bin/bash

git add .

commitMsg=$1
if [ "$commitMsg" == "" ] ; then
    commitMsg="publish content @ $(date)"
fi
git commit -m "$commitMsg"
git push origin master
