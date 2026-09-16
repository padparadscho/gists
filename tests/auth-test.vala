// SPDX-FileCopyrightText: 2026 Padparadscho <contact@padparadscho.com>
// SPDX-License-Identifier: AGPL-3.0-only

private Gists.GitHub.Credentials create_test_credentials () {
    return new Gists.GitHub.Credentials (
        "access-token",
        1800000000,
        "refresh-token",
        1900000000,
        42,
        "octocat",
        "https://avatars.githubusercontent.com/u/42"
    );
}

private void test_credentials_round_trip () {
    try {
        var original = create_test_credentials ();
        var restored = new Gists.GitHub.Credentials.from_json (original.to_json ());

        assert (restored.access_token == original.access_token);
        assert (restored.access_token_expires_at == original.access_token_expires_at);
        assert (restored.refresh_token == original.refresh_token);
        assert (restored.refresh_token_expires_at == original.refresh_token_expires_at);
        assert (restored.account_id == original.account_id);
        assert (restored.login == original.login);
        assert (restored.avatar_url == original.avatar_url);
    } catch (Gists.GitHub.CredentialError error) {
        critical ("Unable to restore credentials: %s", error.message);
        assert_not_reached ();
    }
}

private void assert_invalid_credentials (string json) {
    try {
        new Gists.GitHub.Credentials.from_json (json);
        assert_not_reached ();
    } catch (Gists.GitHub.CredentialError error) {
        assert (error.code == Gists.GitHub.CredentialError.INVALID_DATA);
    }
}

private void test_invalid_credentials () {
    assert_invalid_credentials ("not-json");
    assert_invalid_credentials ("{\"format_version\":2}");
    assert_invalid_credentials ("{\"format_version\":1}");
}

private void assert_cancelled (GLib.Error error) {
    assert (error.matches (IOError.quark (), IOError.CANCELLED));
}

private async void test_credential_store_cancellation_async () {
    var credential_store = new Gists.GitHub.CredentialStore ();
    var cancellable = new Cancellable ();
    cancellable.cancel ();

    try {
        yield credential_store.load (cancellable);
        assert_not_reached ();
    } catch (GLib.Error error) {
        assert_cancelled (error);
    }

    try {
        yield credential_store.save (create_test_credentials (), cancellable);
        assert_not_reached ();
    } catch (GLib.Error error) {
        assert_cancelled (error);
    }

    try {
        yield credential_store.clear (cancellable);
        assert_not_reached ();
    } catch (GLib.Error error) {
        assert_cancelled (error);
    }
}

private void test_credential_store_cancellation () {
    var main_loop = new MainLoop ();

    test_credential_store_cancellation_async.begin ((_source_object, result) => {
        test_credential_store_cancellation_async.end (result);
        main_loop.quit ();
    });

    main_loop.run ();
}

public int main (string[] args) {
    Test.init (ref args);
    Test.add_func ("/auth/credentials/round-trip", test_credentials_round_trip);
    Test.add_func ("/auth/credentials/invalid-data", test_invalid_credentials);
    Test.add_func ("/auth/credential-store/cancellation", test_credential_store_cancellation);
    return Test.run ();
}
