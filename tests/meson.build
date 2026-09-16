scaffolding_test = executable(
  'scaffolding-test',
  files('scaffolding-test.vala'),
  meson.project_build_root() / 'config.vala',
  gists_resources,
  c_args: vala_generated_c_args,
  dependencies: test_dependencies,
)

test('scaffolding-test', scaffolding_test)
