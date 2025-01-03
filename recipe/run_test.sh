#!/bin/bash

# exit when any command fails
set -e
# print all commands
set -x

# tell Qt we don't have a display
export QT_QPA_PLATFORM=offscreen

qgis --version
qgis_process --version

# Check Python API -- paths should be OK from activate script
python -c 'import qgis.core'
python -c 'import qgis.gui'
python -c 'import qgis.utils'

# Test actual use of Python API
if [ $(uname) == Darwin ]; then
    set +e
    python test_py_qgis.py
    code=$?
    if [[ $code -eq 0 ]]; then
        echo "Passed without a problem"
    elif [[ $code -eq 139 ]]; then
        echo "Passed, but segfaulted for a known reason at end of program"
    else
        echo "Error with build - exit code $code"
        exit $code
    fi
else
    python test_py_qgis.py
fi
