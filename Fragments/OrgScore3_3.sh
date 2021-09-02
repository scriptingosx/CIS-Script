#!/bin/zsh

projectfolder=$(dirname "${0:A}")

source ${projectfolder}/Header.sh

CISLevel="1"
audit="3.3 Retain install.log for 365 or more days with no maximum size (Automated)"
orgScore="OrgScore3_3"
emptyVariables
# Verify organizational score
runAudit
# If organizational score is 1 or true, check status of client
if [[ "${auditResult}" == "1" ]]; then
	method="Script"
	remediate="Script > add 'ttl=365' to /etc/asl/com.apple.install"
	
	installRetention="$(grep -c ttl=365 /etc/asl/com.apple.install)"
	if [[ "${installRetention}" = "1" ]]; then
		countPassed=$((countPassed + 1))
		result="Passed"
		comment="Retain install.log: 365 or more days"
	else 
		countFailed=$((countFailed + 1))
		result="Failed"
		comment="Retain install.log: Less than 365 days"
	fi
fi
printReport