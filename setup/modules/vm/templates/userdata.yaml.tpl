#cloud-config
groups:
  - docker
users:
  - name: ${github_username}
    ssh_import_id:
      - gh:${github_username}
    lock_passwd: true
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: [docker] # for sudoless docker
    shell: /bin/bash

write_files:
  - path: /etc/ssh/banner
    content: |
      (             (         )      )
      )\ )    (     )\ )   ( /(   ( /(
      (()/(    )\   (()/(   )\())  )\())
      /(_))((((_)(  /(_)) ((_)\ |((_)\
      (_))   )\ _ )\(_))_    ((_)|_ ((_)
      | _ \  (_)_\(_)|   \  / _ \| |/ /
      |  _/   / _ \  | |) || (_) | ' <
      |_|    /_/ \_\ |___/  \___/ _|\_\


        _._     _,-'""`-._
      (,-.`._,'(       |\`-/|
          `-.-' \ )-`( , o o)
                `-    \`_`"'-

  - path: /etc/environment
    content: |
      DOCKER_BUILDKIT="1"
    append: true

runcmd:
  # Install banner
  - echo 'Banner /etc/ssh/banner' >> /etc/ssh/sshd_config.d/banner.conf
  - sudo systemctl restart sshd

  # Install aws cli
  - sudo apt install -y unzip
  - curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  - sudo unzip awscliv2.zip
  - sudo ./aws/install -i /usr/local/aws-cli -b /usr/local/bin
  - aws --version

  # Install tfswitch
  - curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | bash
  - tfswitch --version

  # Install tgswitch
  - curl -L https://raw.githubusercontent.com/warrensbox/tgswitch/release/install.sh | bash
  - tgswitch --version

  # Install direnv
  - curl -sfL https://direnv.net/install.sh | bash
  - direnv --version

  # Clone the exercise repository
  %{~ for repo_name, repo_url in repositories ~}
  - git clone "${repo_url}" "/home/${github_username}/${repo_name}" || echo "failed to clone ${repo_url}"
    # Set correct permissions for the repository
  - chown -R ${github_username}:${github_username} "/home/${github_username}/${repo_name}" || true # no fail if clone failed
  %{~ endfor }

  # copy aws credentials
  - mkdir /home/${github_username}/.aws
  - touch /home/${github_username}/.aws/credentials
  - echo "[default]" >> /home/${github_username}/.aws/credentials
  - echo "aws_access_key_id = ${aws_access_key_id}" >> /home/${github_username}/.aws/credentials
  - echo "aws_secret_access_key = ${aws_secret_access_key}" >> /home/${github_username}/.aws/credentials
