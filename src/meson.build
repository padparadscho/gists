app_sources = files(
  'application.vala',
  'main.vala',
  'window.vala',
)

executable(
  binary_name,
  app_sources,
  meson.project_build_root() / 'config.vala',
  gists_resources,
  c_args: vala_generated_c_args,
  dependencies: app_dependencies,
  install: true,
)
