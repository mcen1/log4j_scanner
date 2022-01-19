
logstash {
  ansiColor('xterm') {
    node (label:'ansible') {
      stage ('Checkout SCM') {
        checkout scm
      }
      stage ('Run playbook'){
        swGCDLinuxRunAnsibleDI(REMOTEUSER: "ansible", PLAYBOOK: ANSIBLE_PLAYBOOK, ANSIBLE_DI_PUPPET_METHOD: "host", ANSIBLE_DI_PUPPET_SEARCH: ANSIBLE_DI_PUPPET_SEARCH)
      }
    }
  }
}
