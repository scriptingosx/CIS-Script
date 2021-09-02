#!/bin/zsh

projectfolder=$(dirname "${0:A}")

source ${projectfolder}/Header.sh

CISLevel="2"
audit="2.6.2 iCloud keychain (Manual)"
orgScore="OrgScore2_6_2"
emptyVariables
# Verify organizational score
runAudit
# If organizational score is 1 or true, check status of client
if [[ "${auditResult}" == "1" ]]; then
	method="Profile"
	remediate="Configuration profile - payload > com.apple.applicationaccess) allowCloudKeychainSync=false"

	appidentifier="com.apple.applicationaccess"
	value="allowCloudKeychainSync"
	prefValue=$(getPrefValue "${appidentifier}" "${value}")
	prefIsManaged=$(getPrefIsManaged "${appidentifier}" "${value}")
	comment="iCloud keychain: Disabled"
	if [[ "${prefIsManaged}" == "True" && "${prefValue}" == "False" ]]; then
		countPassed=$((countPassed + 1))
		result="Passed"
	else
		if [[ "${prefValue}" == "False" ]]; then
			countPassed=$((countPassed + 1))
			result="Passed"
	else
		countFailed=$((countFailed + 1))
		result="Failed"
		comment="iCloud keychain: Enabled"
		fi
	fi
fi
printReport