/* extension.js
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 */
import Gio from 'gi://Gio';
import GLib from 'gi://GLib';
import GObject from 'gi://GObject';

import * as Main from 'resource:///org/gnome/shell/ui/main.js';

import { Extension, gettext as _ } from 'resource:///org/gnome/shell/extensions/extension.js';
import { QuickMenuToggle, SystemIndicator } from 'resource:///org/gnome/shell/ui/quickSettings.js';
import { PopupSubMenuMenuItem } from 'resource:///org/gnome/shell/ui/popupMenu.js';

import { AsyncHandler, RejectReason } from './asyncHandler.js';

Gio._promisify(Gio.Subprocess.prototype, 'communicate_utf8_async');

const NORDVPN_CLIENT = 'nordvpn';
const NORDVPN_ICON_NAME = 'nordvpn-symbolic';

/**
 * Execute a command asynchronously and return the output from `stdout` on
 * success or throw an error with output from `stderr` on failure.
 *
 * If given, @input will be passed to `stdin` and @cancellable can be used to
 * stop the process before it finishes.
 *
 * @param {string[]} argv - a list of string arguments
 * @param {string} [input] - Input to write to `stdin` or %null to ignore
 * @param {Gio.Cancellable} [cancellable] - optional cancellable object
 * @returns {Promise<string>} - The process output
 */
async function execCommunicate(argv, input = null, cancellable = null) {
  let cancelId = 0;
  let flags = Gio.SubprocessFlags.STDOUT_PIPE |
              Gio.SubprocessFlags.STDERR_PIPE;

  if (input !== null)
      flags |= Gio.SubprocessFlags.STDIN_PIPE;

  const proc = new Gio.Subprocess({argv, flags});
  proc.init(cancellable);

  if (cancellable instanceof Gio.Cancellable)
      cancelId = cancellable.connect(() => proc.force_exit());

  try {
    const [stdout, stderr] = await proc.communicate_utf8_async(input, null);

    const status = proc.get_exit_status();

    if (status !== 0) {
        throw new Gio.IOErrorEnum({
            code: Gio.IOErrorEnum.FAILED,
            message: stderr ? stderr.trim() : `Command '${argv}' failed with exit code ${status}`,
        });
    }

    return stdout.trim();
  } finally {
      if (cancelId > 0)
          cancellable.disconnect(cancelId);
  }
}

const NordVPNMenuToggle = GObject.registerClass(
  class NordVPNMenuToggle extends QuickMenuToggle {
    constructor(path) {
      super({
        title: 'NordVPN'
      });

      this.path = path;
      this.gicon = this.getGicon(NORDVPN_ICON_NAME);
      this.asyncHandler = new AsyncHandler();

      this.setHeader();
      this.setCountries();

      this.connect('clicked', () => {
        if (this.checked) {
          this.unCheck();
          execCommunicate([NORDVPN_CLIENT, 'disconnect']);
        } else {
          this.check(this.getGicon(NORDVPN_ICON_NAME));
          execCommunicate([NORDVPN_CLIENT, 'connect'])
            .catch(() => this.unCheck());
        }
      });
    }

    setHeader() {
      execCommunicate([NORDVPN_CLIENT, 'version'])
        .then((version) => {
          this.menu.setHeader(
            this.getGicon(NORDVPN_ICON_NAME),
            version.replace('Daemon: ', '')
          );
        })
        .catch(() => {
          this.menu.setHeader(
            this.getGicon(NORDVPN_ICON_NAME),
            _('NordVPN client not found')
          );
        });
    }

    setCountries() {
      execCommunicate([NORDVPN_CLIENT, 'countries'])
        .then((countries) => {
          this.selectCountryMenuItem = new PopupSubMenuMenuItem(_('Select country'), false);
          this.selectCountryMenuItem.hide();
          const regex = countries.includes(',') ? /\,/ : /\r?\n/;
          countries.split(regex).forEach((item) => {
            const country = item.trim();
            const gicon = this.getGicon(country);
            this.selectCountryMenuItem.menu.addAction(
              country.replaceAll('_', ' '),
              () => {
                this.check(gicon);
                execCommunicate([NORDVPN_CLIENT, 'connect', country])
                  .catch(() => this.unCheck());
              },
              gicon
            );
          });
          this.menu.connect('open-state-changed', () => this.onOpenStateChanged());
          this.menu.addMenuItem(this.selectCountryMenuItem);
        });
    }

    check(gicon) {
      this.checked = true;
      this.gicon = gicon;
    }

    unCheck() {
      this.checked = false;
      this.gicon = this.getGicon(NORDVPN_ICON_NAME);
    }

    getGicon(icon) {
      const iconPath = GLib.build_filenamev([this.path, 'icons', `${icon}.svg`]);
      const file = Gio.File.new_for_path(iconPath);
      return new Gio.FileIcon({ file });
    }

    onOpenStateChanged() {
      this.asyncHandler.clear();
      if (this.menu.isOpen) {
        this.asyncHandler.when(() => this.menu.box.opacity > 0)
          .then(() => this.openCountriesSubMenu())
          .catch((reason) => {
            if (reason == RejectReason.MAX_NUMBER_OF_TRIES)
              this.openCountriesSubMenu();
          });
      }
    }

    openCountriesSubMenu() {
      if (this.menu.isOpen)
        this.selectCountryMenuItem.menu.open(false);
    }

    destroy() {
      this.asyncHandler.clear();
      super.destroy();
    }
  });

const NordVPNIndicator = GObject.registerClass(
  class NordVPNIndicator extends SystemIndicator {
    constructor(path) {
      super();

      this._indicator = this._addIndicator();

      const toggle = new NordVPNMenuToggle(path);
      toggle.bind_property('checked',
        this._indicator, 'visible',
        GObject.BindingFlags.SYNC_CREATE);
      toggle.bind_property('gicon',
        this._indicator, 'gicon',
        GObject.BindingFlags.SYNC_CREATE);
      this.quickSettingsItems.push(toggle);
    }
  });

export default class QuickSettingsNordVPNExtension extends Extension {
  enable() {
    this._indicator = new NordVPNIndicator(this.path);
    Main.panel.statusArea.quickSettings.addExternalIndicator(this._indicator);
  }

  disable() {
    this._indicator.quickSettingsItems.forEach(item => item.destroy());
    this._indicator.destroy();
    this._indicator = null;
  }
}
