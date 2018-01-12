require 'spec_helper'

describe 'showhidden_win' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it {
        is_expected.to contain_registry_value('VersionShowFileExt').with(
          'ensure'  => 'present',
          'path'    => 'HKLM\SOFTWARE\Microsoft\Active Setup\Installed Components\ShowFileExt\Version',
          'type'    => 'string',
          'data'    => '1,0,0',
          'require' => Registry_key['ShowFileExt'],
        )
      }

      it {
        is_expected.to contain_registry_value('VersionShowHiddenFolders').with(
          'ensure'  => 'present',
          'path'    => 'HKLM\SOFTWARE\Microsoft\Active Setup\Installed Components\ShowHiddenFolders\Version',
          'type'    => 'string',
          'data'    => '1,0,0',
          'require' => Registry_key['ShowHiddenFolders'],
        )
      }

      it { is_expected.to compile }
    end
  end
end
