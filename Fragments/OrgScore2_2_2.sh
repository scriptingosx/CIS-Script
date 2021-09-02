#!/bin/zsh

projectfolder=$(dirname "${0:A}")

source ${projectfolder}/Header.sh

CISLevel="1"
audit="2.2.2 Ensure time set is within appropriate limits (Automated)"
orgScore="OrgScore2_2_2"
emptyVariables
# Verify organizational score
runAudit
# If organizational score is 1 or true, check status of client
if [[ "${auditResult}" == "1" ]]; then
	method="Script"
	remediate="Script > sudo /usr/sbin/systemsetup -setusingnetworktime on && sudo /usr/sbin/systemsetup -setnetworktimeserver time.euro.apple.com"

	networkTimeserver=$(systemsetup -getnetworktimeserver 2>&1 | grep -c 'Network Time Server')
	printCLIResult=$(systemsetup -getnetworktimeserver)
	if [[ "$networkTimeserver" != "0" ]]; then
		countPassed=$((countPassed + 1))
		result="Passed"
		comment="${printCLIResult}"
	else
		countFailed=$((countFailed + 1))
		result="Failed"
		comment="Set Network Time Server"
		# Remediation
		/usr/sbin/systemsetup -setusingnetworktime on && sudo /usr/sbin/systemsetup -setnetworktimeserver time.euro.apple.com
		countRemediated=$((countRemediated + 1))
		# re-check
		networkTimeserver=$(systemsetup -getnetworktimeserver 2>&1 | grep -c 'Network Time Server')
		printCLIResult=$(systemsetup -getnetworktimeserver)
		if [[ "$networkTimeserver" != "0" ]]; then
			countPassedAfterRemediated=$((countPassedAfterRemediated + 1))
			result="Passed After Remdiation"
			comment="${printCLIResult}"
		else
			countFailedAfterRemediation=$((countFailedAfterRemediation + 1))
			result="FailedAfterRemediation"
		fi
	fi
fi
printReport