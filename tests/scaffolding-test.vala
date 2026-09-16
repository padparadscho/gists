// SPDX-FileCopyrightText: 2026 Padparadscho <contact@padparadscho.com>
// SPDX-License-Identifier: AGPL-3.0-only

private void test_configuration () {
    assert (Gists.Config.APP_ID == "io.github.padparadscho.Gists");
    assert (Gists.Config.APP_NAME == "Gists");
    assert (Gists.Config.VERSION == "0.1.0");
}

private void test_window_resource () {
    try {
        var resource = resources_lookup_data (
            "/io/github/padparadscho/Gists/ui/window.ui",
            ResourceLookupFlags.NONE
        );
        assert (resource.get_size () > 0);
    } catch (Error error) {
        critical ("Unable to load the window resource: %s", error.message);
        assert_not_reached ();
    }
}

public int main (string[] args) {
    Test.init (ref args);
    Test.add_func ("/scaffolding/configuration", test_configuration);
    Test.add_func ("/scaffolding/window-resource", test_window_resource);
    return Test.run ();
}
