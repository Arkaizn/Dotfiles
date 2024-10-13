# install gnome extensions
array=( https://extensions.gnome.org/extension/1328/disable-workspace-switch-animation/
https://extensions.gnome.org/extension/19/user-themes/
https://extensions.gnome.org/extension/3193/blur-my-shell/
https://extensions.gnome.org/extension/4684/useless-gaps/
https://extensions.gnome.org/extension/307/dash-to-dock/
https://extensions.gnome.org/extension/3628/arcmenu/
https://extensions.gnome.org/extension/1010/archlinux-updates-indicator/
https://extensions.gnome.org/extension/779/clipboard-indicator/
https://extensions.gnome.org/extension/3843/just-perfection/
https://extensions.gnome.org/extension/841/freon/
https://extensions.gnome.org/extension/3730/floating-dock/
https://extensions.gnome.org/extension/1460/vitals/ )

for i in "${array[@]}"
do
    EXTENSION_ID=$(curl -s $i | grep -oP 'data-uuid="\K[^"]+')
    VERSION_TAG=$(curl -Lfs "https://extensions.gnome.org/extension-query/?search=$EXTENSION_ID" | jq '.extensions[0] | .shell_version_map | map(.pk) | max')
    wget -O ${EXTENSION_ID}.zip "https://extensions.gnome.org/download-extension/${EXTENSION_ID}.shell-extension.zip?version_tag=$VERSION_TAG"
    gnome-extensions install --force ${EXTENSION_ID}.zip
    if ! gnome-extensions list | grep --quiet ${EXTENSION_ID}; then
        busctl --user call org.gnome.Shell.Extensions /org/gnome/Shell/Extensions org.gnome.Shell.Extensions InstallRemoteExtension s ${EXTENSION_ID}
    fi
    gnome-extensions enable ${EXTENSION_ID}
    rm ${EXTENSION_ID}.zip
done