set -x
dt_today=`date +"%Y-%m-%d"`
audit_trail_id=$1
audit_profile_id=$2
audit_policy_id=$3

sleep 30

oci data-safe audit-trail start --audit-collection-start-time $dt_today --audit-trail-id $audit_trail_id --wait-for-state SUCCEEDED --wait-for-state FAILED --max-wait-seconds 300

oci data-safe audit-profile calculate-audit-volume-available --audit-profile-id $audit_profile_id --trail-locations '["UNIFIED_AUDIT_TRAIL", "UNIFIED_AUDIT_TRAIL"]' --audit-collection-start-time $dt_today

oci data-safe audit-profile calculate-audit-volume-collected --audit-profile-id $audit_profile_id --time-from-month $dt_today

oci data-safe audit-policy provision --audit-policy-id $audit_policy_id --provision-audit-conditions file://script/provision-audit-conditions.json --is-data-safe-service-account-excluded true
