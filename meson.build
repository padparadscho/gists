project(
  'gists',
  ['vala', 'c'],
  version: '0.1.0',
  license: 'AGPL-3.0-only',
  license_files: 'LICENSE',
  meson_version: '>= 1.10.0',
  default_options: [
    'buildtype=debugoptimized',
    'c_std=gnu17',
    'warning_level=2',
  ],
)

app_id = 'io.github.padparadscho.Gists'
app_name = 'Gists'
binary_name = 'gists'

gnome = import('gnome')
cc = meson.get_compiler('c')

glib_dep = dependency('glib-2.0', version: '>= 2.88')
gio_dep = dependency('gio-2.0', version: '>= 2.88')
gtk_dep = dependency('gtk4', version: '>= 4.22')
adwaita_dep = dependency('libadwaita-1', version: '>= 1.9')

app_dependencies = [
  glib_dep,
  gio_dep,
  gtk_dep,
  adwaita_dep,
]

test_dependencies = [
  glib_dep,
  gio_dep,
]

vala_generated_c_args = cc.get_supported_arguments(
  '-Wno-unused-parameter',
  '-Wno-unused-variable',
)

config_data = configuration_data()
config_data.set_quoted('APP_ID', app_id)
config_data.set_quoted('APP_NAME', app_name)
config_data.set_quoted('VERSION', meson.project_version())

configure_file(
  input: 'src/config.vala.in',
  output: 'config.vala',
  configuration: config_data,
)

subdir('data')
subdir('src')
subdir('tests')
