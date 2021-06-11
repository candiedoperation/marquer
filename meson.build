# project name and programming language
project('com.github.candiedoperation.marquer', 'vala', 'c')

# Create a new executable, list the files we want to compile, list the dependencies we need, and install
executable(
    meson.project_name(),
    'src/Application.vala',
    'src/MainWindow.vala',
    'src/Widgets/LeftSelectDisk.vala',
    'src/Widgets/LeftSelectDrive.vala',
    'src/Widgets/RightSelectDisk.vala',
    'src/Widgets/RightSelectDrive.vala',
    'src/Widgets/DriveListRowItem.vala',
    'src/Widgets/ISOChooser.vala',        
    'src/Utils/DriveManager.vala',          
    dependencies: [
        dependency('gtk+-3.0'),
        dependency('granite'),
        dependency('libhandy-1')
    ],
    install: true
)

# Install our .desktop file so the Applications Menu will see it
install_data(
    join_paths('data', 'marquer.desktop'),
    install_dir: join_paths(get_option('datadir'), 'applications'),
    rename: meson.project_name() + '.desktop'
)

# Install our .appdata.xml file so AppCenter will see it
install_data(
    join_paths('data', 'marquer.appdata.xml'),
    install_dir: join_paths(get_option('datadir'), 'metainfo'),
    rename: meson.project_name() + '.appdata.xml'
)

# Install our icons in all the required sizes
#icon_sizes = ['16', '32', '48', '64', '128']

#foreach i : icon_sizes
#    install_data(
#        join_paths('data', i + '.svg'),
#        install_dir: join_paths(get_option('datadir'), 'icons', 'hicolor', i + 'x' + i, 'apps'),
#        rename: meson.project_name() + '.svg'
#    )
#    install_data(
#        join_paths('data', i + '.svg'),
#        install_dir: join_paths(get_option('datadir'), 'icons', 'hicolor', i + 'x' + i + '@2', 'apps'),
#        rename: meson.project_name() + '.svg'
#    )
#endforeach
