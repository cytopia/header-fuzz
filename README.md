# header-fuzz

[![Version](https://img.shields.io/github/v/tag/cytopia/header-fuzz)](https://github.com/cytopia/header-fuzz/releases)
[![Language](https://img.shields.io/badge/language-bash-blue)](https://github.com/cytopia/header-fuzz/blob/master/header-fuzz)
[![License](https://img.shields.io/github/license/cytopia/header-fuzz)](https://github.com/cytopia/header-fuzz/blob/master/LICENSE.txt)

[![Build Status](https://github.com/cytopia/header-fuzz/workflows/Linting/badge.svg)](https://github.com/cytopia/header-fuzz/actions?workflow=Linting)

header-fuzz allows you to fuzz any HTTP header with a wordlist and evaluate
success or failure based on the returning HTTP status code.


## :tada: Install
```bash
sudo make install
```


## :no_entry_sign: Uninstall
```bash
sudo make uninstall
```


## :computer: Usage

```bash
$ header-fuzz -h

Usage: header-fuzz [-H <header>] [-i <code>] [-p <proxy>] [-f <FUZZ>] -w </path/wordlist> -u <url>
       header-fuzz -h
       header-fuzz -v

Description:
    header-fuzz allows you to fuzz any HTTP header with a wordlist and evaluate
    success or failure based on the returning HTTP status code.

Required arguments::
    -w     Path to wordlist
    -u     URL to test against.

Optional arguments:
    -f     Fuzz string. Insert, prepend or apped %FUZZ% into your string.
           Default: %FUZZ%
    -H     Header name to fuzz.
           Default: Host
    -i     Comma separated string HTTP status codes to ignore.
           Default: 403
    -p     Use proxy for all requests.

Misc arguments:
    -h     Print this help.
    -v     Print version.
```


## :bulb: Examples

### Find virtual hosts
The following examples are trying to find various domains and subdomains based on a HTTP status
different than 403:
```bash
# Try to guess the domain
header-fuzz -H Host -f '%FUZZ%.tld'            -w /path/to/domains.txt -u 'http://10.0.0.1'

# Try to guess a subdomain
header-fuzz -H Host -f '%FUZZ%.domain.tld'     -w /path/to/domains.txt -u 'http://10.0.0.1'

# Try to guess part of a subdomain
header-fuzz -H Host -f 'pre-%FUZZ%.domain.tld' -w /path/to/domains.txt -u 'http://10.0.0.1'
header-fuzz -H Host -f '%FUZZ%-suf.domain.tld' -w /path/to/domains.txt -u 'http://10.0.0.1'
```

### Find protected `robots.txt` or `sitemap.xml`
Some sites only server the `robots.txt` or `sitemap.xml` if requested by specifc bot useragent,
such as google bot and others. If none of these files exist, you can try to check them with
different user agents.
```bash
header-fuzz -H User-Agent -w /path/to/useragents.txt -u 'http://10.0.0.1/robots.txt'
header-fuzz -H User-Agent -w /path/to/useragents.txt -u 'http://10.0.0.1/sitemap.xml'
```

### IP blacklisting
Sometimes IP blacklisting is poorly implemented base on the `X-FOrwarded-For` header.
Try to fuzz this.
```bash
header-fuzz -H X-Forwarded-For -w /path/to/ip-addresses.txt -u 'http://10.0.0.1'
```

### Proxy through Burpsuite
Send all your requests through Burp to later also quickly check the returned file sizes or
status codes and triage further based on this
```bash
header-fuzz -p http://localhost:8080 -w /path/to/wordlist.txt -u 'http://10.0.0.1'
```


## :lock: [cytopia](https://github.com/cytopia) sec tools

Below is a list of sec tools and docs I am maintaining.

| Name                 | Category             | Language   | Description |
|----------------------|----------------------|------------|-------------|
| **[offsec]**         | Documentation        | Markdown   | Offsec checklist, tools and examples |
| **[header-fuzz]**    | Enumeration          | Bash       | Fuzz HTTP headers |
| **[smtp-user-enum]** | Enumeration          | Python 2+3 | SMTP users enumerator |
| **[urlbuster]**      | Enumeration          | Python 2+3 | Mutable web directory fuzzer |
| **[netcat]**         | Pivoting             | Python 2+3 | Cross-platform netcat |
| **[badchars]**       | Reverse Engineering  | Python 2+3 | Badchar generator |
| **[fuzza]**          | Reverse Engineering  | Python 2+3 | TCP fuzzing tool |

[offsec]: https://github.com/cytopia/offsec
[header-fuzz]: https://github.com/cytopia/header-fuzz
[smtp-user-enum]: https://github.com/cytopia/smtp-user-enum
[urlbuster]: https://github.com/cytopia/urlbuster
[netcat]: https://github.com/cytopia/netcat
[badchars]: https://github.com/cytopia/badchars
[fuzza]: https://github.com/cytopia/fuzza


## :octocat: Contributing

See **[Contributing guidelines](CONTRIBUTING.md)** to help to improve this project.


## :exclamation: Disclaimer

This tool may be used for legal purposes only. Users take full responsibility for any actions performed using this tool. The author accepts no liability for damage caused by this tool. If these terms are not acceptable to you, then do not use this tool.


## :page_facing_up: License

**[MIT License](LICENSE.txt)**

Copyright (c) 2020 **[cytopia](https://github.com/cytopia)**
