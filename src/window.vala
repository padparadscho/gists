// SPDX-FileCopyrightText: 2026 Padparadscho <contact@padparadscho.com>
// SPDX-License-Identifier: AGPL-3.0-only

namespace Gists {
    [GtkTemplate (ui = "/io/github/padparadscho/Gists/ui/window.ui")]
    public sealed class Window : Adw.ApplicationWindow {
        public Window (Gtk.Application application) {
            Object (application: application);
        }
    }
}
