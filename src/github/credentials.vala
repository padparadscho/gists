// SPDX-FileCopyrightText: 2026 Padparadscho <contact@padparadscho.com>
// SPDX-License-Identifier: AGPL-3.0-only

namespace Gists.GitHub {
    internal sealed class Credentials : Object {
        private const int64 FORMAT_VERSION = 1;

        public string access_token { get; private set; }
        public int64 access_token_expires_at { get; private set; }
        public string refresh_token { get; private set; }
        public int64 refresh_token_expires_at { get; private set; }
        public int64 account_id { get; private set; }
        public string login { get; private set; }
        public string avatar_url { get; private set; }

        public Credentials (
            string access_token,
            int64 access_token_expires_at,
            string refresh_token,
            int64 refresh_token_expires_at,
            int64 account_id,
            string login,
            string avatar_url
        )
        requires (access_token != "")
        requires (access_token_expires_at > 0)
        requires (refresh_token != "")
        requires (refresh_token_expires_at > 0)
        requires (account_id > 0)
        requires (login != "")
        requires (avatar_url != "")
        {
            this.access_token = access_token;
            this.access_token_expires_at = access_token_expires_at;
            this.refresh_token = refresh_token;
            this.refresh_token_expires_at = refresh_token_expires_at;
            this.account_id = account_id;
            this.login = login;
            this.avatar_url = avatar_url;
        }

        public Credentials.from_json (string json) throws CredentialError {
            var parser = new Json.Parser ();

            try {
                parser.load_from_data (json);
            } catch (GLib.Error error) {
                throw new CredentialError.INVALID_DATA (
                          "Stored GitHub credentials are not valid JSON: %s",
                          error.message
                );
            }

            var root_node = parser.get_root ();
            if (root_node == null || root_node.get_node_type () != Json.NodeType.OBJECT) {
                throw new CredentialError.INVALID_DATA (
                          "Stored GitHub credentials must be a JSON object"
                );
            }

            var json_object = root_node.get_object ();
            var format_version = require_positive_int (json_object, "format_version");

            if (format_version != FORMAT_VERSION) {
                throw new CredentialError.INVALID_DATA (
                          "Unsupported GitHub credential format version: %" + int64.FORMAT,
                          format_version
                );
            }

            access_token = require_nonempty_string (json_object, "access_token");
            access_token_expires_at = require_positive_int (
                json_object,
                "access_token_expires_at"
            );
            refresh_token = require_nonempty_string (json_object, "refresh_token");
            refresh_token_expires_at = require_positive_int (
                json_object,
                "refresh_token_expires_at"
            );
            account_id = require_positive_int (json_object, "account_id");
            login = require_nonempty_string (json_object, "login");
            avatar_url = require_nonempty_string (json_object, "avatar_url");
        }

        public string to_json () {
            var builder = new Json.Builder ();
            builder.begin_object ();
            builder.set_member_name ("format_version");
            builder.add_int_value (FORMAT_VERSION);
            builder.set_member_name ("access_token");
            builder.add_string_value (access_token);
            builder.set_member_name ("access_token_expires_at");
            builder.add_int_value (access_token_expires_at);
            builder.set_member_name ("refresh_token");
            builder.add_string_value (refresh_token);
            builder.set_member_name ("refresh_token_expires_at");
            builder.add_int_value (refresh_token_expires_at);
            builder.set_member_name ("account_id");
            builder.add_int_value (account_id);
            builder.set_member_name ("login");
            builder.add_string_value (login);
            builder.set_member_name ("avatar_url");
            builder.add_string_value (avatar_url);
            builder.end_object ();

            var root_node = builder.get_root ();
            assert (root_node != null);

            var generator = new Json.Generator ();
            generator.set_root (root_node);
            return generator.to_data (null);
        }

        private static string require_nonempty_string (
            Json.Object json_object,
            string member_name
        ) throws CredentialError {
            var member_node = json_object.get_member (member_name);

            if (
                member_node == null ||
                member_node.get_node_type () != Json.NodeType.VALUE ||
                member_node.get_value_type () != typeof (string)
            ) {
                throw_invalid_member (member_name);
            }

            var value = member_node.get_string ();
            if (value == null || value == "") {
                throw_invalid_member (member_name);
            }

            return value;
        }

        private static int64 require_positive_int (
            Json.Object json_object,
            string member_name
        ) throws CredentialError {
            var member_node = json_object.get_member (member_name);

            if (
                member_node == null ||
                member_node.get_node_type () != Json.NodeType.VALUE ||
                member_node.get_value_type () != typeof (int64)
            ) {
                throw_invalid_member (member_name);
            }

            var value = member_node.get_int ();
            if (value <= 0) {
                throw_invalid_member (member_name);
            }

            return value;
        }

        private static void throw_invalid_member (string member_name) throws CredentialError {
            throw new CredentialError.INVALID_DATA (
                      "Stored GitHub credentials have an invalid '%s' value",
                      member_name
            );
        }
    }
}
