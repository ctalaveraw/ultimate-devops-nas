[![Build Status](https://travis-ci.com/chriswayg/ansible-msmtp-mailer.svg?branch=master)](https://travis-ci.com/chriswayg/ansible-msmtp-mailer)

# ansible-msmtp-mailer

This ansible role deploys msmtp as a mailer for Debian, Ubuntu, Arch & Alpine Linux

## Prerequisite
* Access to a functioning SMTP server.

## How to install
* Either use github to clone/download into your roles directory:
  - `git clone https://github.com/chriswayg/ansible-msmtp-mailer.git`
* Or use ansible galaxy:
  - `ansible-galaxy install chriswayg.msmtp-mailer`

## Variables
  All the default variables are located **defaults/main.yml**. Mostly you would need to configure the following variables.
  - *msmtp_accounts:* You can define one or more smtp accounts:

      ```
      msmtp_accounts:
      - account:   gmail
        host:      smtp.gmail.com
        port:      587
        auth:      "on"
        from:      example@gmail.example
        user:      example@gmail.example
        password:  "some password"
      - account:   mysmtp
        host:      smtp.example
        port:      587
        auth:      "on"
        from:      admin@example.org
        user:      myuser@example.org
        password:  plain-text-password2
        tls_starttls: "off"
      ```
  - *msmtp_default_account:* Default smtp account to use

    ```msmtp_default_account: "gmail"```

  - Logging
     - Option A (syslog)
       ```
        msmtp_log : "syslog"
       ```

     - Option B (file logging)
       ```
        msmtp_log     : "file"
        msmtp_logfile : /var/log/msmtp.log
       ```

     - Option C (No logging)
       ```
        msmtp_log     : "no"
       ```

  - Mail aliases
     - *msmtp_alias_default:* default email this required

         `msmtp_alias_default : ops@example.com`

     - *msmtp_alias_root:* root email this is optional

         `msmtp_alias_root : root@example.com`

     - *msmtp_alias_cron:* cron email this optional

         `msmtp_alias_cron : cron@example.com`

  - Configuration file permissions
     - *msmtprc_owner:* owner of /etc/msmtprc, default `root`

         `msmtprc_owner : root`

     - *msmtprc_group:* group of /etc/msmtprc, default `root`

         `msmtprc_group : root`

     - *msmtprc_mode:* group of /etc/msmtprc, default `0644`

         `msmtprc_mode : 0644`

## Configure
You can configure your variables in ansible with one of the following

 * Create a variable in host/group variables directory.
 * Editing vars/main.yml
 * Run ansible-playbook with -e
 * Edit the defaults/main.yml (not recommended)

## Example Playbook
```yaml
---
- hosts: all
  roles:
    - ansible-msmtp-mailer
```

## Run
- mstmp used to function out of the box with the provided defaults/main.yml settings, because the configuration used a real smtp server for testing, but Yandex does not allow this any more. Instead use a Gmail account for testing.

  ```ansible-playbook -l hostname msmtp.yml```

## Test
  You should get a test mail if it works as expected on the root mail

## Documentation
[msmtp manual](http://msmtp.sourceforge.net/doc/msmtp.html)

## Authors:
- Forked from [GitHub - AutomationWithAnsible/ansible-msmtp: Ansible MSTMP](https://github.com/AutomationWithAnsible/ansible-msmtp)
  - By [Adham Helal](https://github.com/ahelal)
- [Christian Wagner](https://github.com/chriswayg)

## License:
- Apache 2.0
