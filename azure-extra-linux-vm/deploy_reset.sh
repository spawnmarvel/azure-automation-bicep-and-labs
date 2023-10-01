az vm extension set \
  --resource-group Rg-iac-linux-fu-0991 \
  --vm-name Vm-26276 \
  --name VMAccessForLinux \
  --publisher Microsoft.OSTCExtensions \
  --version 1.4 \
  --protected-settings key.json