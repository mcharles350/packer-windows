node default {
  include download_file

  class { 'download_file' :
    enable => true;
  }

}
