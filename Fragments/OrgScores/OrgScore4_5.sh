#!/bin/zsh

script_dir=$(dirname ${0:A})
projectfolder=$(dirname $script_dir)

source ${projectfolder}/Header.sh

CISLevel="1"
audit="4.5 Ensure nfs server is not running. (Automated)"
orgScore="OrgScore4_5"
emptyVariables
# Verify organizational score
runAudit
# If organizational score is 1 or true, check status of client
if [[ "${auditResult}" == "1" ]]; then
	method="Script"
	remediate="Script > sudo launchctl disable system/com.apple.nfsd && sudo rm /etc/exports"

	httpServer=$(launchctl print-disabled system 2>&1 | grep -c '"com.apple.nfsd" => true')
	if [[ "${httpServer}" == "1" ]]; then
		result="Passed"
		comment="NFS server service: Disabled"
	else 
		result="Failed"
		comment="NFS server service: Enabled"
	fi
fi
printReport