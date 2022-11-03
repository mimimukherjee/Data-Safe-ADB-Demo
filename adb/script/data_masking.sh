set -x
masking_policy_id=$1
target_id=$2
oci data-safe masking-policy add --masking-policy-id $masking_policy_id --wait-for-state SUCCEEDED --wait-for-state FAILED
oci data-safe masking-policy mask-data --masking-policy-id $masking_policy_id --target-id $target_id --wait-for-state SUCCEEDED --wait-for-state FAILED
