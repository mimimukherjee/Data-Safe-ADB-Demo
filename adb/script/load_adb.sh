set -x
wallet=$1/wallet.zip
conn=${2}_low
admin_passwd=$3

wallet_dir=/tmp/wallet
mkdir -p $wallet_dir
unzip -d $wallet_dir $wallet
sed -i 's/?\/network\/admin/\/tmp\/wallet/g' $wallet_dir/sqlnet.ora
TNS_ADMIN=$wallet_dir
export TNS_ADMIN
echo exit|sqlplus ADMIN/$admin_passwd@$conn @$1/script/load-data-safe-sample-data_admin.sql
rm -fr $wallet_dir

