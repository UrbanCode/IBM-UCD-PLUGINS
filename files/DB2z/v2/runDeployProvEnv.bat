REM The following steps describe the entire processs for creating a new target environment, and for deploying the demo application onto that 
REM environment. Therefore, a particular user role might not need to run every step every time. For example, deployment engineers who are 
REM responisble for building the application process in Urban Code Deploy might use only steps 1 - 6. However, they might also run step 7 to
REM evaluate the procedure in the test environment.
REM Then, after the deployment process is defined in UCD, deployment coordinators, who are responsible for deploying applications on mulitple 
REM environments, might run only step 7 to do deploy the applications.

REM Before you begin:
REM a. Download "curl" for Windows, and add the directory for the curl command into the system environment variable.
REM b. Import the exported application snapshot file, "snapshot+v2_artifacts.zip", as a new application on the UCD web UI.
REM c. Ensure that all the referenced JSON files are available from where the batch file is executed
REM d. Replace the names of applications/environments/resources as needs
REM e. Replace the values of following properties as needed, but do not change the property names
REM     a) srcDirectory, which is a working folder of the process
REM     b) symbolicReplacement, which defines the environment specific values of the application to be deployed
REM     c) connection information: connectionURL, connectionPwd, connectionUser, jdbcDriver, jdbcJAR, jesHost, jesPort, jesRACF, jesUser
REM    note: the connectionPwd is still required until the RACF PassTickets support is ready for UCD SQL-JDBC plugin.

REM Step 1. import the exported application snapshot, and choose "Create Component" and "Create Process" in the dialog "Import Applications"

REM Step 2. create a new environment:
curl -k -u admin:admin "https://plxeditor.usca.ibm.com:8443/cli/environment/createEnvironment?application=Deploy%20Demo&name=Deploy%20ProvEnv" -X PUT

REM Step 3. create a resource to map the component:
curl -k -u admin:admin https://plxeditor.usca.ibm.com:8443/cli/resource/create -X PUT -d @UTBaseRes.json
curl -k -u admin:admin https://plxeditor.usca.ibm.com:8443/cli/resource/create -X PUT -d @UTAgent.json
curl -k -u admin:admin https://plxeditor.usca.ibm.com:8443/cli/resource/create -X PUT -d @UTResPrep.json
curl -k -u admin:admin https://plxeditor.usca.ibm.com:8443/cli/resource/create -X PUT -d @UTResComp.json

REM Step 4. add base resource to the environment:
curl -k -u admin:admin "https://plxeditor.usca.ibm.com:8443/cli/environment/addBaseResource?environment=Deploy%20ProvEnv&application=Deploy%20Demo&resource=%2FDeployNewResource" -X PUT

REM Step 5. add environment properties:
curl -k -u admin:admin "https://plxeditor.usca.ibm.com:8443/cli/environment/propValue?environment=Deploy%20ProvEnv&application=Deploy%20Demo&name=srcDirectory&value=/u/oeusr05/testsrc" -X PUT
curl -k -u admin:admin "https://plxeditor.usca.ibm.com:8443/cli/environment/propValue?environment=Deploy%20ProvEnv&application=Deploy%20Demo&name=symbolicReplacement&value=fvtsym.prop" -X PUT

REM Step 6. add resource properties:
curl -k -u admin:admin "https://plxeditor.usca.ibm.com:8443/cli/resource/setProperty?resource=%2FDeployNewResource%2FLABEC431.vmec.svl.ibm.com%2FDeployDemo&name=connectionURL&value=jdbc:db2://labec431.vmec.svl.ibm.com:446/STLEC1" -X PUT
curl -k -u admin:admin "https://plxeditor.usca.ibm.com:8443/cli/resource/setProperty?resource=%2FDeployNewResource%2FLABEC431.vmec.svl.ibm.com%2FDeployDemo&name=connectionPwd&value=c0deshop&isSecure=true" -X PUT
curl -k -u admin:admin "https://plxeditor.usca.ibm.com:8443/cli/resource/setProperty?resource=%2FDeployNewResource%2FLABEC431.vmec.svl.ibm.com%2FDeployDemo&name=connectionUser&value=SYSADM" -X PUT
curl -k -u admin:admin "https://plxeditor.usca.ibm.com:8443/cli/resource/setProperty?resource=%2FDeployNewResource%2FLABEC431.vmec.svl.ibm.com%2FDeployDemo&name=jdbcDriver&value=com.ibm.db2.jcc.DB2Driver" -X PUT
curl -k -u admin:admin "https://plxeditor.usca.ibm.com:8443/cli/resource/setProperty?resource=%2FDeployNewResource%2FLABEC431.vmec.svl.ibm.com%2FDeployDemo&name=jdbcJAR&value=/usr/lpp/db2/devbase_jdbc/classes/db2jcc4.jar" -X PUT
curl -k -u admin:admin "https://plxeditor.usca.ibm.com:8443/cli/resource/setProperty?resource=%2FDeployNewResource%2FLABEC431.vmec.svl.ibm.com%2FDeployDemo&name=jesHost&value=labec431.vmec.svl.ibm.com" -X PUT
curl -k -u admin:admin "https://plxeditor.usca.ibm.com:8443/cli/resource/setProperty?resource=%2FDeployNewResource%2FLABEC431.vmec.svl.ibm.com%2FDeployDemo&name=jesPort&value=6715" -X PUT
curl -k -u admin:admin "https://plxeditor.usca.ibm.com:8443/cli/resource/setProperty?resource=%2FDeployNewResource%2FLABEC431.vmec.svl.ibm.com%2FDeployDemo&name=jesRACF&value=/usr/include/java_classes/IRRRacf.jar" -X PUT
curl -k -u admin:admin "https://plxeditor.usca.ibm.com:8443/cli/resource/setProperty?resource=%2FDeployNewResource%2FLABEC431.vmec.svl.ibm.com%2FDeployDemo&name=jesUser&value=SYSADM" -X PUT

REM Step 7. launch process:
REM curl -k -u admin:admin https://plxeditor.usca.ibm.com:8443/cli/applicationProcessRequest/request -X PUT -d @deployDemoFVTEnv.json
REM curl -k -u admin:admin https://plxeditor.usca.ibm.com:8443/cli/applicationProcessRequest/request -X PUT -d @deployDemoRegEnv.json
REM curl -k -u admin:admin https://plxeditor.usca.ibm.com:8443/cli/applicationProcessRequest/request -X PUT -d @deployDemoUTEnv.json
curl -k -u admin:admin https://plxeditor.usca.ibm.com:8443/cli/applicationProcessRequest/request -X PUT -d @deployDemoProvEnv.json