#!/bin/sh

#  update20.sh
#  ExercisePlatform
#
#  Created by Andrei Puni on 23/09/15.
#  Copyright © 2015 WeHeartSwift. All rights reserved.

`xcode-select -p`/Toolchains/XcodeDefault.xctoolchain/usr/bin/swift-update $1 2> /dev/null

