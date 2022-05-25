az containerapp env storage set --name managedEnvironment-VaultWarden-9bfb --resource-group VaultWarden `
    --storage-name mystorage `
    --azure-file-account-name vaultwardenconfig `
    --azure-file-account-key rKyU6bC6X5UEAt8TuH+KNc2LtQSVskN9SIPgfLmvsxel3dE/v3cfkBdBl4W/KWqEFr1lLMl1/Npu+AStkBW41g== `
    --azure-file-share-name config `
    --access-mode ReadWrite

vaultwardenconfig

rKyU6bC6X5UEAt8TuH+KNc2LtQSVskN9SIPgfLmvsxel3dE/v3cfkBdBl4W/KWqEFr1lLMl1/Npu+AStkBW41g==

DefaultEndpointsProtocol=https;AccountName=vaultwardenconfig;AccountKey=rKyU6bC6X5UEAt8TuH+KNc2LtQSVskN9SIPgfLmvsxel3dE/v3cfkBdBl4W/KWqEFr1lLMl1/Npu+AStkBW41g==;EndpointSuffix=core.windows.net




sudo mkdir /mnt/config
if [ ! -d "/etc/smbcredentials" ]; then
sudo mkdir /etc/smbcredentials
fi
if [ ! -f "/etc/smbcredentials/vaultwardenconfig.cred" ]; then
    sudo bash -c 'echo "username=vaultwardenconfig" >> /etc/smbcredentials/vaultwardenconfig.cred'
    sudo bash -c 'echo "password=rKyU6bC6X5UEAt8TuH+KNc2LtQSVskN9SIPgfLmvsxel3dE/v3cfkBdBl4W/KWqEFr1lLMl1/Npu+AStkBW41g==" >> /etc/smbcredentials/vaultwardenconfig.cred'
fi
sudo chmod 600 /etc/smbcredentials/vaultwardenconfig.cred

sudo bash -c 'echo "//vaultwardenconfig.file.core.windows.net/config /mnt/config cifs nofail,vers=3.0,credentials=/etc/smbcredentials/vaultwardenconfig.cred,dir_mode=0777,file_mode=0777,serverino" >> /etc/fstab'
sudo mount -t cifs //vaultwardenconfig.file.core.windows.net/config /mnt/config -o vers=3.0,credentials=/etc/smbcredentials/vaultwardenconfig.cred,dir_mode=0777,file_mode=0777,serverino,nosharesock,actimeo=30