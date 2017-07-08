#### Design and implement Azure App Service apps

**Deploy Web Apps**

- [ ] [define deployment slots](https://docs.microsoft.com/en-us/azure/app-service-web/web-sites-staged-publishing#add-a-deployment-slot)
- [ ] [roll back deployments](https://docs.microsoft.com/en-us/azure/app-service-web/web-sites-staged-publishing#to-rollback-a-production-app-after-swap)
- [ ] implement pre and post deployment actions _(not found related content)_
- [ ] create, configure, and deploy packages _(ambiguous)_
- [ ] [create App Service plans](https://docs.microsoft.com/en-us/azure/app-service/azure-web-sites-web-hosting-plans-in-depth-overview#create-an-app-service-plan-or-use-existing-one)
- [ ] [migrate Web Apps between App Service plans](https://docs.microsoft.com/en-us/azure/app-service/azure-web-sites-web-hosting-plans-in-depth-overview#move-an-app-to-a-different-app-service-plan)
- [ ] create a Web App within an App Service plan

Video: [demo1](https://www.youtube.com/watch?v=68Q3C5m9gu4) [demo2](https://youtu.be/Yp6x43gORY8)

**Configure Web Apps**

- [ ] [define and use app settings](https://docs.microsoft.com/en-us/azure/app-service-web/web-sites-configure#application-settings)
- [ ] [connection strings](https://docs.microsoft.com/en-us/azure/app-service-web/web-sites-configure#connection-strings), [handlers](https://docs.microsoft.com/en-us/azure/app-service-web/web-sites-configure#handler-mappings), and [virtual directories](https://docs.microsoft.com/en-us/azure/app-service-web/web-sites-configure#virtual-applications-and-directories)
- [ ] [configure certificates](https://docs.microsoft.com/en-us/azure/app-service-web/web-sites-configure#ssl)
- [ ] [configure custom domains](https://docs.microsoft.com/en-us/azure/app-service-web/web-sites-custom-domain-name)
- [ ] [configure SSL bindings](https://docs.microsoft.com/en-us/azure/app-service-web/web-sites-configure-ssl-certificate#step-2-upload-and-bind-the-custom-ssl-certificate)
- [ ] [configure runtime configurations](https://docs.microsoft.com/en-us/azure/app-service-web/web-sites-configure#general-settings) _(_[_PHP_](https://docs.microsoft.com/en-us/azure/app-service-web/web-sites-php-configure)_,_ [_Java_](https://docs.microsoft.com/en-us/azure/app-service-web/web-sites-java-add-app)_,_ [_Python_](https://docs.microsoft.com/en-us/azure/app-service-web/web-sites-python-configure)_)_
- [ ] manage Web Apps by using [Azure PowerShell](https://docs.microsoft.com/en-us/azure/app-service-web/app-service-web-app-azure-resource-manager-powershell) and [Xplat-CLI](https://docs.microsoft.com/en-us/azure/app-service-web/app-service-web-app-azure-resource-manager-xplat-cli)

Video: [Custom domain](https://www.youtube.com/watch?v=3287BiRfKeU) [certificate](https://www.youtube.com/watch?v=2F6TUQq-NYE)

**Configure diagnostics, monitoring, and analytics**

- [ ] [retrieve diagnostics data](https://docs.microsoft.com/en-us/azure/app-service-web/web-sites-enable-diagnostic-log)
- [ ] [view streaming logs](https://docs.microsoft.com/en-us/azure/app-service-web/web-sites-streaming-logs-and-console)
- [ ] [configure endpoint monitoring](https://docs.microsoft.com/en-us/azure/application-insights/app-insights-monitor-web-app-availability) _(_[_Application Insights replacing endpoint monitoring_](https://docs.microsoft.com/en-us/azure/application-insights/app-insights-migrate-azure-endpoint-tests#so-whats-happening-to-my-endpoint-tests) _as 31 October 2016, not sure about the exam update)_
- [ ] [configure alerts](https://docs.microsoft.com/en-us/azure/monitoring-and-diagnostics/monitoring-overview-alerts)
- [ ] [configure diagnostics](https://docs.microsoft.com/en-us/azure/app-service-web/web-sites-enable-diagnostic-log#a-nameenablediagahow-to-enable-diagnostics)
- [ ] [use remote debugging](https://docs.microsoft.com/en-us/azure/app-service-web/web-sites-dotnet-troubleshoot-visual-studio#a-nameremotedebugaremote-debugging-web-apps)
- [ ] [monitor Web App resources](https://docs.microsoft.com/en-us/azure/app-service-web/web-sites-monitor#monitoring-quotas-and-metrics-in-the-azure-portal)

Video: [Ignite](https://www.youtube.com/watch?v=wUf4sm8aA_w)

**Configure Web Apps for scale and resilience**

- [ ] [configure auto-scale using built-in and custom schedules](https://docs.microsoft.com/en-us/azure/monitoring-and-diagnostics/insights-how-to-scale#scale-based-on-a-schedule)
- [ ] [configure by metric](https://docs.microsoft.com/en-us/azure/monitoring-and-diagnostics/insights-how-to-scale#scaling-based-on-a-pre-set-metric)
- [ ] [change the size of an instance](https://docs.microsoft.com/en-us/azure/app-service-web/web-sites-scale#scale-up-your-pricing-tier)
- [ ] [configure Traffic Manager](https://docs.microsoft.com/en-us/azure/app-service-web/web-sites-traffic-manager)

Video: [demo1](https://youtu.be/cDNOTiBRwzA) [demo2](https://www.youtube.com/watch?v=MU8jJ_UC9SY) [demo3](https://www.youtube.com/watch?v=-73e8nLMV6s)

#### Create and manage Azure Resource Manager Virtual Machines

**Deploy workloads on Azure Resource Manager (ARM) virtual machines (VMs)**

- [ ] identify workloads that can and cannot be deployed
- [ ] run workloads, including [Microsoft](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/overview) and [Linux](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/overview)
- [ ] create VMs [Windows](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/creation-choices) / [Linux](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/creation-choices)
- [ ] connect to a [Windows](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/connect-logon) / [Linux](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/mac-create-ssh-keys) VM

**Perform configuration management**

- [ ] automate configuration management by using [PowerShell Desired State Configuration (DSC)](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/extensions-dsc-overview) and [VM Agent](https://docs.microsoft.com/en-us/azure/virtual-machines/virtual-machines-windows-agent-user-guide) ([custom script extensions](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/extensions-customscript))
- [ ] configure VMs using a configuration management tool, such as Puppet or [Chef](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/chef-automation)
- [ ] [enable remote debugging](https://docs.microsoft.com/en-us/azure/vs-azure-tools-debug-cloud-services-virtual-machines#debugging-azure-virtual-machines)

**Design and implement VM storage**

- [ ] configure disk caching _(should be host caching, clear instructions not found in documentation)_
- [ ] [plan storage capacity](https://docs.microsoft.com/en-us/azure/storage/storage-about-disks-and-vhds-windows)
- [ ] [configure operating system disk redundancy](https://docs.microsoft.com/en-us/azure/storage/storage-redundancy) (not sure [managed disks](https://docs.microsoft.com/en-us/azure/storage/storage-managed-disks-overview) are part of the exam)
- [ ] [configure shared storage using Azure File service](https://docs.microsoft.com/en-us/azure/storage/storage-dotnet-how-to-use-files)
- [ ] [configure geo-replication](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/regions-and-availability#storage-availability)
- [ ] [encrypt disks](https://docs.microsoft.com/en-us/azure/security/azure-security-disk-encryption)
- [ ] [implement ARM VMs with Standard and Premium Storage](https://docs.microsoft.com/en-us/azure/storage/storage-about-disks-and-vhds-windows?toc=%2fazure%2fvirtual-machines%2fwindows%2ftoc.json#types-of-disks)

**Monitor ARM VMs**

- [ ] [configure ARM VM monitoring](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/vm-monitoring)
- [ ] [configure alerts](https://docs.microsoft.com/en-us/azure/monitoring-and-diagnostics/insights-alerts-portal)
- [ ] [configure diagnostic and monitoring storage location](https://docs.microsoft.com/en-us/azure/storage/storage-monitor-storage-account)

**Monitor ARM VM availability**

- [ ] [configure multiple ARM VMs in an availability set for redundancy](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/manage-availability#configure-multiple-virtual-machines-in-an-availability-set-for-redundancy)
- [ ] [configure each application tier into separate availability sets](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/manage-availability#configure-each-application-tier-into-separate-availability-sets)
- [ ] [combine the Load Balancer with availability sets](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/manage-availability#combine-a-load-balancer-with-availability-sets)

**Scale ARM VMs**

- [ ] [scale up and scale down VM sizes](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/resize-vm)
- [ ] [deploy ARM VM Scale Sets (VMSS)](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/vmss-powershell-creating) [Linux](https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-overview?toc=%2fazure%2fvirtual-machines%2flinux%2ftoc.json) _(_[_VMSS doc_](https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-overview)_)_
- [ ] configure ARM VMSS auto-scale [Linux](https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-linux-autoscale) / [Windows](https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-windows-autoscale)

#### Design and implement a storage strategy

**Implement Azure storage blobs and Azure files**

- [ ] read data, change data, set metadata on a container
- [ ] [store data using block and page blobs](https://docs.microsoft.com/en-us/rest/api/storageservices/fileservices/understanding-block-blobs--append-blobs--and-page-blobs)
- [ ] stream data using blobs
- [ ] [access blobs securely](https://docs.microsoft.com/en-us/azure/storage/storage-security-guide)
- [ ] [implement async blob copy](https://blogs.msdn.microsoft.com/windowsazurestorage/2012/06/12/introducing-asynchronous-cross-account-copy-blob/) _(might be better to know how to actually use this with_ [_AzCopy_](https://docs.microsoft.com/en-us/azure/storage/storage-use-azcopy#blob-copy) _or_ [_PowerShell_](https://docs.microsoft.com/en-us/powershell/module/azure.storage/start-azurestorageblobcopy?view=azurermps-1.2.9)_)_
- [ ] [configure a Content Delivery Network (CDN)](https://docs.microsoft.com/en-us/azure/cdn/cdn-create-a-storage-account-with-cdn)
- [ ] [design blob hierarchies](https://docs.microsoft.com/en-us/rest/api/storageservices/fileservices/naming-and-referencing-containers--blobs--and-metadata)
- [ ] [configure custom domains](https://docs.microsoft.com/en-us/azure/storage/storage-custom-domain-name)
- [ ] scale blob storage _(ambiguous as we don’t really have to worry about it)_

**Manage access**

- [ ] [create and manage shared access signatures](https://docs.microsoft.com/en-us/azure/storage/storage-dotnet-shared-access-signature-part-1)
- [ ] [use stored access policies](https://docs.microsoft.com/en-us/rest/api/storageservices/fileservices/establishing-a-stored-access-policy)
- [ ] [regenerate keys](https://docs.microsoft.com/en-us/azure/storage/storage-create-storage-account#manage-your-storage-account) (PowerShell [Get](https://docs.microsoft.com/en-us/powershell/module/azurerm.storage/get-azurermstorageaccountkey?view=azurermps-3.7.0) and [New](https://docs.microsoft.com/en-us/powershell/module/azurerm.storage/new-azurermstorageaccountkey?view=azurermps-3.7.0))

**Configure diagnostics, monitoring, and analytics**

- [ ] [set retention policies and logging levels](https://docs.microsoft.com/en-us/rest/api/storageservices/fileservices/enabling-storage-logging-and-accessing-log-data)
- [ ] [analyze logs](https://docs.microsoft.com/en-us/rest/api/storageservices/fileservices/enabling-storage-logging-and-accessing-log-data#a-namefindingyourstoragelogginglogdataa-finding-your-storage-logging-log-data)

**Implement Azure SQL Databases**

- [ ] [choose the appropriate database tier and performance level](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-service-tiers)
- [ ] [configure point-in-time recovery](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-automated-backups), [geo-replication](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-geo-replication-overview), and [data sync](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-get-started-sql-data-sync)
- [ ] [import](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-import-portal) and [export](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-export) data and schema
- [ ] [design a scaling strategy](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-elastic-scale-introduction)

**Implement recovery services**

- [ ] [create a backup vault](https://docs.microsoft.com/en-us/azure/backup/backup-try-azure-backup-in-10-mins#create-a-recovery-services-vault) _(backup vault seems deprecated in favor of recovery services vault)_
- [ ] [deploy a backup agent](https://docs.microsoft.com/en-us/azure/backup/backup-configure-vault#install-and-register-the-agent)
- [ ] [back up](https://docs.microsoft.com/en-us/azure/backup/backup-configure-vault#create-the-backup-policy) and [restore data](https://docs.microsoft.com/en-us/azure/backup/backup-azure-restore-windows-server#recover-data-to-the-same-machine)

#### Implement an Azure Active Directory

**Integrate an Azure Active Directory (Azure AD) with existing directories**

- [ ] [implement Azure AD Connect and single sign-on with on-premises Windows Server 2012 R2](https://docs.microsoft.com/en-us/azure/active-directory/connect/active-directory-aadconnect)
- [ ] [add custom domains](https://docs.microsoft.com/en-us/azure/active-directory/active-directory-add-domain) _(classic portal as Azure AD is still in preview in the new portal)_
- [ ] [monitor Azure AD](https://docs.microsoft.com/en-us/azure/active-directory/active-directory-reporting-azure-portal) _(ambiguous)_

**Configure Application Access**

- [ ] [configure single sign-on with SaaS applications using federation](https://docs.microsoft.com/en-us/azure/active-directory/active-directory-sso-integrate-saas-apps) and [password based](https://docs.microsoft.com/en-us/azure/active-directory/active-directory-appssoaccess-whatis#password-based-single-sign-on)
- [ ] add [users](https://docs.microsoft.com/en-us/azure/active-directory/active-directory-managing-access-to-apps) and [groups](https://docs.microsoft.com/en-us/azure/active-directory/active-directory-accessmanagement-group-saasapps) to applications
- [ ] [revoke access to SaaS applications](https://docs.microsoft.com/en-us/azure/active-directory/active-directory-coreapps-remove-assignment-azure-portal) _(link to new Azure Poral, but if you know how to add, you should know how to remove anyway)_
- [ ] [configure access](https://docs.microsoft.com/en-us/azure/active-directory/active-directory-managing-access-to-apps) _(could also be_ [_conditional access_](https://docs.microsoft.com/en-us/azure/active-directory/active-directory-conditional-access) _and_ [_MFA_](https://docs.microsoft.com/en-us/azure/multi-factor-authentication/)_)_
- [ ] configure federation with [Facebook](https://docs.microsoft.com/en-us/azure/active-directory-b2c/active-directory-b2c-setup-fb-app) and [Google ID](https://docs.microsoft.com/en-us/azure/active-directory-b2c/active-directory-b2c-setup-goog-app) _(could be the other way around;_ [_Google G Suite_](https://docs.microsoft.com/en-us/azure/active-directory/active-directory-saas-google-apps-tutorial) _and_ [_Facebook Workplace_](https://docs.microsoft.com/en-us/azure/active-directory/active-directory-saas-facebook-at-work-tutorial)_)_

**Integrate an app with Azure AD**

- [ ] implement [Azure AD integration in web](https://docs.microsoft.com/en-us/azure/active-directory/active-directory-application-proxy-get-started) and [desktop applications](https://docs.microsoft.com/en-us/azure/active-directory/active-directory-application-proxy-native-client)
- [ ] [leverage Graph API](https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-graph-api-quickstart) _(_[_Microsoft Graph API_](https://developer.microsoft.com/en-us/graph/docs)_)_

**Implement Azure AD B2C and Azure B2B**

- [ ] [create an Azure AD B2C Directory](https://docs.microsoft.com/en-us/azure/active-directory-b2c/active-directory-b2c-get-started)
- [ ] [register an application](https://docs.microsoft.com/en-us/azure/active-directory-b2c/active-directory-b2c-app-registration)
- [ ] [implement social identity provider authentication](https://docs.microsoft.com/en-us/azure/active-directory-b2c/active-directory-b2c-setup-msa-app)
- [ ] [enable multi-factor authentication](https://docs.microsoft.com/en-us/azure/active-directory-b2c/active-directory-b2c-reference-mfa)
- [ ] [set up self-service password reset](https://docs.microsoft.com/en-us/azure/active-directory-b2c/active-directory-b2c-reference-sspr)
- [ ] [implement B2B collaboration](https://docs.microsoft.com/en-us/azure/active-directory/active-directory-b2b-what-is-azure-ad-b2b)
- [ ] [configure partner users](https://docs.microsoft.com/en-us/azure/active-directory/active-directory-b2b-admin-add-users) _(_[_by user_](https://docs.microsoft.com/en-us/azure/active-directory/active-directory-b2b-iw-add-users)_)_
- [ ] [integrate with applications](https://docs.microsoft.com/en-us/azure/active-directory/active-directory-b2b-configure-saas-apps)

#### Implement virtual networks

**Configure virtual networks**

- [ ] [deploy a VM into a virtual network](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-create-vnet-arm-pportal)
- [ ] configure [external](https://docs.microsoft.com/en-us/azure/load-balancer/load-balancer-get-started-internet-portal) and [internal](https://docs.microsoft.com/en-us/azure/load-balancer/load-balancer-get-started-ilb-arm-portal) load balancing
- [ ] [implement Application Gateway](https://docs.microsoft.com/en-us/azure/application-gateway/application-gateway-introduction)
- [ ] [design subnets](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-vnet-plan-design-arm#design)
- [ ] configure static, [public](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-deploy-static-pip-arm-portal), and [private](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-static-private-ip-arm-pportal) IP addresses
- [ ] [set up Network Security Groups (NSGs)](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-create-nsg-arm-pportal) _(_[_plan NSGs_](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-nsg)_)_
- [ ] [DNS at the virtual network level](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-name-resolution-for-vms-and-role-instances)
- [ ] [HTTP and TCP health probes](https://docs.microsoft.com/en-us/azure/load-balancer/load-balancer-custom-probe-overview)
- [ ] [public IPs](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-public-ip-address)
- [ ] [User Defined Routes (UDRs)](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-udr-overview)
- [ ] firewall rules, and direct server return

**Modify network configuration**

- [ ] modify subnets, NSGs, and UDRs _(I think covered by above)_

**Design and implement a multi-site or hybrid network**

- [ ] [choose the appropriate solution between ExpressRoute, site-to-site, and point-to-site](https://azure.microsoft.com/en-us/blog/expressroute-or-virtual-network-vpn-whats-right-for-me/) _(not so recent but seems not much changed about this)_
- [ ] [choose the appropriate gateway](https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-plan-design#planning)
- [ ] [identify supported devices and software VPN solutions](https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpn-devices)
- [ ] identify networking prerequisites
- [ ] configure virtual networks and multi-site virtual networks

#### Design and deploy ARM templates

**Implement ARM templates**

- [ ] [author ARM templates](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-authoring-templates)
- [ ] [create ARM templates](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-manager-create-first-template) to deploy ARM [Resource Providers](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-overview#resource-providers) resources
- [ ] deploy templates with [PowerShell](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-template-deploy), [CLI](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-template-deploy-cli), and [REST API](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-template-deploy-rest)

_Check also my_ [_ARM templates 101_](https://medium.com/@zaab_it/azure-resource-manager-template-101-1ccddc797f65) _article._

**Control access**

- [ ] [leverage service principles with ARM authentication](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-authenticate-service-principal)
- [ ] [use Azure Active Directory Authentication with ARM](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-manager-api-authentication)
- [ ] [set management policies](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-manager-policy)
- [ ] [lock resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-lock-resources)

**Design role-based access control (RBAC)**

- [ ] [secure resource scopes, such as the ability to create VMs and Azure Web Apps](https://docs.microsoft.com/en-us/azure/active-directory/role-based-access-control-what-is)
- [ ] [implement Azure role-based access control (RBAC) standard roles](https://docs.microsoft.com/en-us/azure/active-directory/role-based-access-built-in-roles)
- [ ] [design Azure RBAC custom roles](https://docs.microsoft.com/en-us/azure/active-directory/role-based-access-control-custom-roles)


* * *