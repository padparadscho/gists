scaffolding_test = executable(
  'scaffolding-test',
  files('scaffolding-test.vala'),
  meson.project_build_root() / 'config.vala',
  gists_resources,
  c_args: vala_generated_c_args,
  dependencies: test_dependencies,
)

test('scaffolding-test', scaffolding_test)

auth_test = executable(
  'auth-test',
  files('auth-test.vala'),
  github_auth_sources,
  meson.project_build_root() / 'config.vala',
  c_args: vala_generated_c_args,
  dependencies: test_dependencies,
)

test('auth-test', auth_test)
