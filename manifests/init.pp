# showhidden_win
#
# Manage how hidden folders and file type extensions are displayed in Windows machines. This module leverages Microsoft Active Setup to set the hidden folder or hidden file extension preferences.
# Briefly, Active Setup is a registry key that runs "something" at logon one time for every user that logs into the machine. It's difficult for puppet to update HKCU registry keys, so to get past that you can have Active Setup run a command which updates the HKCU key for every user that logs in.
# This module runs reg add to update the HKCU registry entry for hiding or showing files and folders or file extensions. By default, this module sets Windows to show hidden files and folders and to show file extensions. You can adjust this to your preference.
# Another thing to note about using Active Setup to manage HKCU is that it will only run once per version number. Version numbers are a string value of '1,0,0' or similar. If you decide to change your preferences and want to only show file extensions but not hidden files and folders, you will need to increment the version number.
#
# @summary Manage how hidden folders and file type extensions are displayed in Windows machines.
#
# @example class { 'showhidden_win':
  #   show_file_ext_version       => '1,0,0',
  #   show_hidden_folders_version => '1,0,0',
  #   show_file_ext               => true,
  #   show_hidden_folders         => true,
  # }
#   include showhidden_win
class showhidden_win (
  Boolean $show_file_ext = true,
  Boolean $show_hidden_folders = true,
  String $show_file_ext_version = undef,
  String $show_hidden_folders_version = undef,
){
  case $show_file_ext {
    true: {
      $show_file_ext_number = 0
    }
    false: {
      $show_file_ext_number = 1
    }
    default: {
      $show_file_ext_number = 0
    }
  }

  $show_hidden_folders_number = Numeric($show_hidden_folders)

  registry_key { 'ShowFileExt':
    ensure => present,
    path   => 'HKLM\SOFTWARE\Microsoft\Active Setup\Installed Components\ShowFileExt',
  }
  registry_value { 'VersionShowFileExt':
    ensure  => present,
    path    => 'HKLM\SOFTWARE\Microsoft\Active Setup\Installed Components\ShowFileExt\Version',
    type    => string,
    data    => $show_file_ext_version,
    require => Registry_key['ShowFileExt'],
  }
  registry_value { 'StubPathShowFileExt':
    ensure  => present,
    path    => 'HKLM\SOFTWARE\Microsoft\Active Setup\Installed Components\ShowFileExt\StubPath',
    type    => string,
    data    => "reg add \"HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced\" /v HideFileExt /t REG_DWORD /d ${show_file_ext_number} /f",
    require => Registry_key['ShowFileExt'],
  }

# Set hidden folders and files to show
  registry_key { 'ShowHiddenFolders':
    ensure => present,
    path   => 'HKLM\SOFTWARE\Microsoft\Active Setup\Installed Components\ShowHiddenFolders',
  }
  registry_value { 'VersionShowHiddenFolders':
    ensure  => present,
    path    => 'HKLM\SOFTWARE\Microsoft\Active Setup\Installed Components\ShowHiddenFolders\Version',
    type    => string,
    data    => $show_hidden_folders_version,
    require => Registry_key['ShowHiddenFolders'],
  }
  registry_value { 'StubPathShowHiddenFolders':
    ensure  => present,
    path    => 'HKLM\SOFTWARE\Microsoft\Active Setup\Installed Components\ShowHiddenFolders\StubPath',
    type    => string,
    data    => "reg add \"HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced\" /v Hidden /t REG_DWORD /d ${show_hidden_folders_number} /f",
    require => Registry_key['ShowHiddenFolders'],
  }
}
