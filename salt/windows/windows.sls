Install Tomcat:
  chocolatey.installed:
    - name: tomcat


Configure Tomcat run as buumi:
  module.run:
    - name: service.modify
    - m_name: Tomcat8
    - account_name: .\buumi