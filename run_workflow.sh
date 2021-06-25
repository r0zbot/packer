#!/bin/bash

VERSION=3.14.1
# VERSION=2.4.14

yes | gh release delete $VERSION
git push --delete origin $VERSION

gh release create -t $VERSION -n "" $VERSION
