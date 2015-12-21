#!/bin/bash -e
# vim: set ts=4 sw=4 sts=4 et :

source "${SCRIPTSDIR}/distribution.sh"

echo "--> Installing Personal User Formulas of 'nrgaway'."
yumInstall qubes-mgmt-salt-user-nrgaway
