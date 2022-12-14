Feature: Match
  @no-clobber
  Scenario: Finds matches
    When I run `recog_match matching_banners_fingerprints.xml sample_banner.txt`
    Then it should pass with:
      """
      MATCH: {"matched"=>"Pure-FTPd Config data can be zero or more of: [privsep] [TLS]", "pureftpd.config"=>"[privsep] [TLS] ", "service.family"=>"Pure-FTPd", "service.product"=>"Pure-FTPd", "service.protocol"=>"ftp", "fingerprint_db"=>"matching_banners_fingerprints", "data"=>"---------- Welcome to Pure-FTPd [privsep] [TLS] ----------"}
      MATCH: {"matched"=>"SunOS/Solaris", "os.vendor"=>"Sun", "os.family"=>"Solaris", "os.product"=>"Solaris", "os.device"=>"General", "host.name"=>"polaris", "os.version"=>"5.8", "service.protocol"=>"ftp", "fingerprint_db"=>"matching_banners_fingerprints", "data"=>"polaris FTP server (SunOS 5.8) ready."}
      """

  @no-clobber
  Scenario: Fails at finding matches
    When I run `recog_match failing_banners_fingerprints.xml sample_banner.txt`
    Then it should pass with:
      """
      FAIL: ---------- Welcome to Pure-FTPd [privsep] [TLS] ----------
      FAIL: polaris FTP server (SunOS 5.8) ready
      """

  @no-clobber
  Scenario: Finds multiple matches
    When I run `recog_match multiple_banners_fingerprints.xml sample_banner.txt --multi-match`
    Then it should pass with:
      """
      MATCHES: {"matched"=>"Generic FTP, Checks for the existence of the word FTP in the line", "service.protocol"=>"", "fingerprint_db"=>"multiple_banners_fingerprints", "data"=>"---------- Welcome to Pure-FTPd [privsep] [TLS] ----------"},{"matched"=>"Pure-FTPd Config data can be zero or more of: [privsep] [TLS]", "pureftpd.config"=>"[privsep] [TLS] ", "service.family"=>"Pure-FTPd", "service.product"=>"Pure-FTPd", "service.protocol"=>"ftp", "fingerprint_db"=>"multiple_banners_fingerprints", "data"=>"---------- Welcome to Pure-FTPd [privsep] [TLS] ----------"}
      MATCHES: {"matched"=>"Generic FTP, Checks for the existence of the word FTP in the line", "service.protocol"=>"", "fingerprint_db"=>"multiple_banners_fingerprints", "data"=>"polaris FTP server (SunOS 5.8) ready."},{"matched"=>"SunOS/Solaris", "service.protocol"=>"ftp", "os.vendor"=>"Sun", "os.family"=>"Solaris", "os.product"=>"Solaris", "os.device"=>"General", "host.name"=>"polaris", "os.version"=>"5.8", "fingerprint_db"=>"multiple_banners_fingerprints", "data"=>"polaris FTP server (SunOS 5.8) ready."}
      """

  @no-clobber
  Scenario: Finds first matches using no-multi-match flag
    When I run `recog_match multiple_banners_fingerprints.xml sample_banner.txt --no-multi-match`
    Then it should pass with:
    """
    MATCH: {"matched"=>"Generic FTP, Checks for the existence of the word FTP in the line", "service.protocol"=>"", "fingerprint_db"=>"multiple_banners_fingerprints", "data"=>"---------- Welcome to Pure-FTPd [privsep] [TLS] ----------"}
    MATCH: {"matched"=>"Generic FTP, Checks for the existence of the word FTP in the line", "service.protocol"=>"", "fingerprint_db"=>"multiple_banners_fingerprints", "data"=>"polaris FTP server (SunOS 5.8) ready."}
    """

  @no-clobber
  Scenario: Finds matches JSON output format
    When I run `recog_match --format json matching_banners_fingerprints.xml sample_banner.txt`
    Then it should pass with:
    """
    {"data":"---------- Welcome to Pure-FTPd [privsep] [TLS] ----------","match":{"matched":"Pure-FTPd Config data can be zero or more of: [privsep] [TLS]","pureftpd.config":"[privsep] [TLS] ","service.family":"Pure-FTPd","service.product":"Pure-FTPd","service.protocol":"ftp","fingerprint_db":"matching_banners_fingerprints"}}
    {"data":"polaris FTP server (SunOS 5.8) ready.","match":{"matched":"SunOS/Solaris","os.vendor":"Sun","os.family":"Solaris","os.product":"Solaris","os.device":"General","host.name":"polaris","os.version":"5.8","service.protocol":"ftp","fingerprint_db":"matching_banners_fingerprints"}}
    """

  @no-clobber
  Scenario: Finds matches using multi-match flag and JSON output format
    When I run `recog_match --format json --multi-match multiple_banners_fingerprints.xml sample_banner.txt`
    Then it should pass with:
    """
    {"data":"---------- Welcome to Pure-FTPd [privsep] [TLS] ----------","matches":[{"matched":"Generic FTP, Checks for the existence of the word FTP in the line","service.protocol":"","fingerprint_db":"multiple_banners_fingerprints"},{"matched":"Pure-FTPd Config data can be zero or more of: [privsep] [TLS]","pureftpd.config":"[privsep] [TLS] ","service.family":"Pure-FTPd","service.product":"Pure-FTPd","service.protocol":"ftp","fingerprint_db":"multiple_banners_fingerprints"}]}
    {"data":"polaris FTP server (SunOS 5.8) ready.","matches":[{"matched":"Generic FTP, Checks for the existence of the word FTP in the line","service.protocol":"","fingerprint_db":"multiple_banners_fingerprints"},{"matched":"SunOS/Solaris","service.protocol":"ftp","os.vendor":"Sun","os.family":"Solaris","os.product":"Solaris","os.device":"General","host.name":"polaris","os.version":"5.8","fingerprint_db":"multiple_banners_fingerprints"}]}
    """
