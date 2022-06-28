#!/bin/bash
#set -e
##################################################################################################################
# Author 	: Erik Dubois
# Website   : https://www.erikdubois.be
# Website	: https://www.arcolinux.info
# Website	: https://www.arcolinux.com
# Website	: https://www.arcolinuxd.com
# Website	: https://www.arcolinuxb.com
# Website	: https://www.arcolinuxiso.com
# Website	: https://www.arcolinuxforum.com
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################

installed_dir=$(dirname $(readlink -f $(basename `pwd`)))

if [ -f /usr/local/bin/get-nemesis-on-alci ]; then

	echo
	tput setaf 2
	echo "################################################################"
	echo "################### We are on ALCI"
	echo "################################################################"
	tput sgr0
	echo

	sudo pacman -S --noconfirm --needed edu-skel-git
  	sudo pacman -S --noconfirm --needed edu-system-git

  	test=$(systemctl is-enabled qemu-guest-agent.service)
  	if [ $test == "enabled" ]; then
  		sudo systemctl disable qemu-guest-agent.service
	fi

	if [ -f /etc/default/grub ]; then

		sudo pacman -S --noconfirm --needed arcolinux-grub-theme-vimix-git
		sudo cp $installed_dir/settings/alci/grub /etc/default/grub
		sudo cp $installed_dir/settings/alci/theme.txt /boot/grub/themes/Vimix/theme.txt

		sudo grub-mkconfig -o /boot/grub/grub.cfg
	fi

	if [ -f /etc/environment ]; then
		echo "QT_QPA_PLATFORMTHEME=qt5ct" | sudo tee /etc/environment
		echo "EDITOR=nano" | sudo tee -a /etc/environment
	fi

	if [ -f /usr/lib/sddm/sddm.conf.d/default.conf ]; then
		sudo cp /usr/lib/sddm/sddm.conf.d/default.conf /etc/sddm.conf
		echo
		echo "Changing sddm theme"
		echo
		sudo pacman -S --noconfirm --needed arcolinux-sddm-simplicity-git
		FIND="Current="
		REPLACE="Current=arcolinux-simplicity"
		sudo sed -i "s/$FIND/$REPLACE/g" /etc/sddm.conf
	fi

	if [ -f /etc/nanorc ]; then
    	sudo cp $installed_dir/settings/nano/nanorc /etc/nanorc
	fi

	if [ -f /usr/share/xsessions/xfce.desktop ]; then
		echo
		tput setaf 2
		echo "################################################################"
		echo "################### We are on Xfce4"
		echo "################################################################"
		tput sgr0
		echo

		cp -arf /etc/skel/. ~

		echo "Changing the whiskermenu"
		echo
		cp $installed_dir/settings/alci/whiskermenu-7.rc ~/.config/xfce4/panel/whiskermenu-7.rc
		sudo cp $installed_dir/settings/alci/whiskermenu-7.rc /etc/skel/.config/xfce4/panel/whiskermenu-7.rc

		echo
		echo "Changing the icons and theme"
		echo

		FIND="Arc-Dark"
		REPLACE="Arc-Dawn-Dark"
		sed -i "s/$FIND/$REPLACE/g" ~/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
		sudo sed -i "s/$FIND/$REPLACE/g" /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml

		FIND="Sardi-Arc"
		REPLACE="Edu-Papirus-Dark-Tela"
		sed -i "s/$FIND/$REPLACE/g" ~/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
		sudo sed -i "s/$FIND/$REPLACE/g" /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml

	fi

	if grep -q alci-iso-lts /usr/local/bin/get-nemesis-on-alci ; then
		sudo pacman -S --noconfirm --needed xdg-user-dirs-gtk
	fi

	if grep -q alci-iso-zen /usr/local/bin/get-nemesis-on-alci ; then
		sudo pacman -S --noconfirm --needed xdg-user-dirs-gtk
	fi	

fi
