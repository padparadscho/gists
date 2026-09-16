// SPDX-FileCopyrightText: 2026 Padparadscho <contact@padparadscho.com>
// SPDX-License-Identifier: AGPL-3.0-only

namespace Gists.GitHub {
    public sealed class CredentialStore : Object {
        private const string ACCOUNT_ATTRIBUTE = "account";
        private const string DEFAULT_ACCOUNT = "default";

        private static Secret.Schema credential_schema = new Secret.Schema (
            Gists.Config.APP_ID + ".Credentials",
            Secret.SchemaFlags.NONE,
            ACCOUNT_ATTRIBUTE,
            Secret.SchemaAttributeType.STRING
        );

        public async Credentials? load (Cancellable? cancellable = null) throws GLib.Error {
            var json = yield Secret.password_lookupv (
                credential_schema,
                create_attributes (),
                cancellable
            );

            if (json == null) {
                return null;
            }

            return new Credentials.from_json (json);
        }

        public async void save (
            Credentials credentials,
            Cancellable? cancellable = null
        ) throws GLib.Error {
            var stored = yield Secret.password_storev (
                credential_schema,
                create_attributes (),
                Secret.COLLECTION_DEFAULT,
                Gists.Config.APP_NAME + " GitHub credentials",
                credentials.to_json (),
                cancellable
            );

            if (!stored) {
                throw new CredentialError.STORAGE_FAILED (
                          "Unable to store GitHub credentials"
                );
            }
        }

        public async bool clear (Cancellable? cancellable = null) throws GLib.Error {
            return yield Secret.password_clearv (
                credential_schema,
                create_attributes (),
                cancellable
            );
        }

        private static HashTable<string, string> create_attributes () {
            var attributes = new HashTable<string, string> (str_hash, str_equal);
            attributes[ACCOUNT_ATTRIBUTE] = DEFAULT_ACCOUNT;
            return attributes;
        }
    }
}
