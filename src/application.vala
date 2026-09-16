// SPDX-FileCopyrightText: 2026 Padparadscho <contact@padparadscho.com>
// SPDX-License-Identifier: AGPL-3.0-only

namespace Gists {
    public sealed class Application : Adw.Application {
        public Application () {
            Object (
                application_id: Config.APP_ID,
                flags: ApplicationFlags.DEFAULT_FLAGS
            );
        }

        protected override void activate () {
            var window = active_window as Window;
            if (window == null) {
                window = new Window (this);
            }

            window.present ();
        }
    }
}
