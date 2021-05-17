#!/bin/bash

VERSION=3.14.0

yes | gh release delete $VERSION
git push --delete origin $VERSION

gh release create -t $VERSION -n "" $VERSION