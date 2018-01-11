# showhidden
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include showhidden
class showhidden (
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
    data    => "reg add 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced' /v HideFileExt /t REG_DWORD /d ${show_file_ext_number} /f",
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
    data    => "reg add 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced' /v Hidden /t REG_DWORD /d ${show_hidden_folders_number} /f",
    require => Registry_key['ShowHiddenFolders'],
  }
}
