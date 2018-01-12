# showhidden_win
Manage how hidden folders and file type extensions are displayed in Windows machines.  This module leverages [Microsoft Active Setup](http://www.itninja.com/blog/view/an-active-setup-primer) to set the hidden folder or hidden file extension preferences.

Briefly, Active Setup is a registry key that runs "something" at logon one time for every user that logs into the machine.  It's difficult for puppet to update HKCU registry keys, so to get past that you can have Active Setup run a command which updates the HKCU key for every user that logs in.

This module runs `reg add` to update the HKCU registry entry for hiding or showing files and folders or file extensions.  By default, this module sets Windows to **show** hidden files and folders and to **show** file extensions.  You can adjust this to your preference.

Another thing to note about using Active Setup to manage HKCU is that it will only run once per version number.  Version numbers are a string value of '1,0,0' or similar.  If you decide to change your preferences and want to only show file extensions but not hidden files and folders, you will need to increment the version number.

For example, say you initially set your preferences to:

```ruby
class { 'showhidden_win':
    show_file_ext_version       => '1,0,0',
    show_hidden_folders_version => '1,0,0',
    show_file_ext               => true,
    show_hidden_folders         => true,
  }
```

and now you want to change those preferences to **not** show hidden folders.  You would then set your preferences to:

```ruby
class { 'showhidden_win':
  show_file_ext_version       => '1,0,0',
  show_hidden_folders_version => '1,0,1',  # <--- MUST INCREMENT THIS NUMBER
  show_file_ext               => true,
  show_hidden_folders         => false,
}
```

By incrementing the version number, Active Setup will run again on a users next login to update the preferences you have set.  If you do not update the version number, the settings will not re-run.

## Parameters

 * ```show_file_ext``` - [Optional] Boolean.  Defaults to true.  ```true``` if you want to **show** file extensions.  ```false``` if you want to **hide**.
 * ```show_hidden_folders``` - [Optional] Boolean.  Defaults to true.  ```true``` if you want to **show** hidden files and folders.  ```false``` if you want to **hide**.
 * ```show_file_ext_version``` - [Required] String value version number.  Must be comma values, not periods.  IE: ```1,0,0```, NOT ```1.0.0``` <-- invalid.
 * ```show_hidden_folders_version``` - [Required] String value version number.  Must be comma values, not periods.  IE: ```1,0,0```, NOT ```1.0.0``` <-- invalid.

## Usage
At minimum you must specify the version numbers for ```show_file_ext_version``` and ```show_hidden_folders_version```.  The module defaults to **show** both hidden files/folders and file extensions.

## Example
```ruby
class { 'showhidden_win':
  show_file_ext_version       => '1,0,0',
  show_hidden_folders_version => '1,0,0',
  show_file_ext               => true, # Show file extensions
  show_hidden_folders         => true, # Show hidden files/folders
}
```

or

```ruby
class { 'showhidden_win':
  show_file_ext_version       => '1,0,0',
  show_hidden_folders_version => '1,0,0',
  show_file_ext               => true, # Show file extensions
  show_hidden_folders         => false, # DON'T show hidden files/folders
}
```

or minimal usage

```ruby
class { 'showhidden_win':
  show_file_ext_version       => '1,0,0',
  show_hidden_folders_version => '1,0,0',
}