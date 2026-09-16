// SPDX-FileCopyrightText: 2026 Padparadscho <contact@padparadscho.com>
// SPDX-License-Identifier: AGPL-3.0-only

public int main (string[] args) {
    Environment.set_application_name (Gists.Config.APP_NAME);

    var application = new Gists.Application ();
    return application.run (args);
}
