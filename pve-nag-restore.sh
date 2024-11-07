#!/bin/sh
#
# pve-nag-restore.sh https://github.com/foundObjects/pve-nag-buster
#
# Restores Proxmox VE 6.x+ license nags
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

NAGTOKEN="data.status.toLowerCase() !== 'active'"
NAGFILE="/usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js"
SCRIPT="$(basename "$0")"

# enable license nag: https://johnscs.com/remove-proxmox51-subscription-notice/

if grep -qs "$NAGTOKEN" "$NAGFILE" > /dev/null 2>&1; then
  echo "$SCRIPT: Restoring Nag ..."
  mv -f "$NAGFILE.orig" "$NAGFILE"
  rm -f "$NAGFILE.orig"
  systemctl restart pveproxy.service
fi

# enable paid repo list

PAID_BASE="/etc/apt/sources.list.d/pve-enterprise"

if [ -f "$PAID_BASE.disabled" ]; then
  echo "$SCRIPT: Enabling PVE paid repo list ..."
  mv -f "$PAID_BASE.disabled" "$PAID_BASE.list"
fi

# enable paid ceph repo list if it exists

CEPH_PAID_BASE="/etc/apt/sources.list.d/ceph"

if [  -f "$CEPH_PAID_BASE.disabled" ]; then
    echo "$SCRIPT: Enabling ceph paid repo list ..."
  mv -f "$CEPH_PAID_BASE.disabled" "$CEPH_PAID_BASE.list"
fi