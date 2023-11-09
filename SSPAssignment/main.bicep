param prefix string
param serviceTag string
param environment string
param regionTag string

var resourcePrefix = '${prefix}-${serviceTag}-${environment}-${regionTag}'
var storageAccountName = replace(toLower('${resourcePrefix}-SA-1'), '-', '')
var functionAppName = '${resourcePrefix}-FA-1'

param serverfarms_WestEuropePlan_name string = 'WestEuropePlan'

resource storageAccounts_sspassignmentstorage_name_resource 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: 'westeurope'
  sku: {
    name: 'Standard_RAGRS'
    tier: 'Standard'
  }
  kind: 'StorageV2'
  properties: {
    dnsEndpointType: 'Standard'
    defaultToOAuthAuthentication: false
    publicNetworkAccess: 'Enabled'
    allowCrossTenantReplication: false
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: true
    allowSharedKeyAccess: true
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      requireInfrastructureEncryption: false
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}

resource serverfarms_WestEuropePlan_name_resource 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: serverfarms_WestEuropePlan_name
  location: 'West Europe'
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
    size: 'Y1'
    family: 'Y'
    capacity: 0
  }
  kind: 'functionapp'
  properties: {
    perSiteScaling: false
    elasticScaleEnabled: false
    maximumElasticWorkerCount: 1
    isSpot: false
    reserved: false
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: false
  }
}

resource storageAccounts_sspassignmentstorage_name_default 'Microsoft.Storage/storageAccounts/blobServices@2023-01-01' = {
  parent: storageAccounts_sspassignmentstorage_name_resource
  name: 'default'
  sku: {
    name: 'Standard_RAGRS'
    tier: 'Standard'
  }
  properties: {
    changeFeed: {
      enabled: false
    }
    restorePolicy: {
      enabled: false
    }
    containerDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
    cors: {
      corsRules: []
    }
    deleteRetentionPolicy: {
      allowPermanentDelete: false
      enabled: true
      days: 7
    }
    isVersioningEnabled: false
  }
}

resource Microsoft_Storage_storageAccounts_fileServices_storageAccounts_sspassignmentstorage_name_default 'Microsoft.Storage/storageAccounts/fileServices@2023-01-01' = {
  parent: storageAccounts_sspassignmentstorage_name_resource
  name: 'default'
  sku: {
    name: 'Standard_RAGRS'
    tier: 'Standard'
  }
  properties: {
    protocolSettings: {
      smb: {}
    }
    cors: {
      corsRules: []
    }
    shareDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
  }
}

resource Microsoft_Storage_storageAccounts_queueServices_storageAccounts_sspassignmentstorage_name_default 'Microsoft.Storage/storageAccounts/queueServices@2023-01-01' = {
  parent: storageAccounts_sspassignmentstorage_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource Microsoft_Storage_storageAccounts_tableServices_storageAccounts_sspassignmentstorage_name_default 'Microsoft.Storage/storageAccounts/tableServices@2023-01-01' = {
  parent: storageAccounts_sspassignmentstorage_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource sites_sspassignment641496_name_resource 'Microsoft.Web/sites@2022-09-01' = {
  name: functionAppName
  location: 'West Europe'
  kind: 'functionapp'
  properties: {
    enabled: true
    hostNameSslStates: [
      {
        name: '${functionAppName}.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Standard'
      }
      {
        name: '${functionAppName}.scm.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Repository'
      }
    ]
    serverFarmId: serverfarms_WestEuropePlan_name_resource.id
    reserved: false
    isXenon: false
    hyperV: false
    vnetRouteAllEnabled: false
    vnetImagePullEnabled: false
    vnetContentShareEnabled: false
    siteConfig: {
      numberOfWorkers: 1
      acrUseManagedIdentityCreds: false
      alwaysOn: false
      http20Enabled: false
      functionAppScaleLimit: 200
      minimumElasticInstanceCount: 0
    }
    scmSiteAlsoStopped: false
    clientAffinityEnabled: false
    clientCertEnabled: false
    clientCertMode: 'Required'
    hostNamesDisabled: false
    customDomainVerificationId: '878EE5489481B1D7EC54EB94477651D546CDCBE65E76038F72ADDE173BD590D7'
    containerSize: 1536
    dailyMemoryTimeQuota: 0
    httpsOnly: true
    redundancyMode: 'None'
    storageAccountRequired: false
    keyVaultReferenceIdentity: 'SystemAssigned'
  }
}

resource sites_sspassignment641496_name_ftp 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2022-09-01' = {
  parent: sites_sspassignment641496_name_resource
  name: 'ftp'
  location: 'West Europe'
  properties: {
    allow: true
  }
}

resource sites_sspassignment641496_name_scm 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2022-09-01' = {
  parent: sites_sspassignment641496_name_resource
  name: 'scm'
  location: 'West Europe'
  properties: {
    allow: true
  }
}

resource sites_sspassignment641496_name_web 'Microsoft.Web/sites/config@2022-09-01' = {
  parent: sites_sspassignment641496_name_resource
  name: 'web'
  location: 'West Europe'
  properties: {
    numberOfWorkers: 1
    defaultDocuments: [
      'Default.htm'
      'Default.html'
      'Default.asp'
      'index.htm'
      'index.html'
      'iisstart.htm'
      'default.aspx'
      'index.php'
    ]
    netFrameworkVersion: 'v6.0'
    requestTracingEnabled: false
    remoteDebuggingEnabled: false
    remoteDebuggingVersion: 'VS2019'
    httpLoggingEnabled: false
    acrUseManagedIdentityCreds: false
    logsDirectorySizeLimit: 35
    detailedErrorLoggingEnabled: false
    publishingUsername: '$sspassignment641496'
    scmType: 'None'
    use32BitWorkerProcess: true
    webSocketsEnabled: false
    alwaysOn: false
    managedPipelineMode: 'Integrated'
    virtualApplications: [
      {
        virtualPath: '/'
        physicalPath: 'site\\wwwroot'
        preloadEnabled: false
      }
    ]
    loadBalancing: 'LeastRequests'
    experiments: {
      rampUpRules: []
    }
    autoHealEnabled: false
    vnetRouteAllEnabled: false
    vnetPrivatePortsCount: 0
    localMySqlEnabled: false
    ipSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 2147483647
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 2147483647
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictionsUseMain: false
    http20Enabled: false
    minTlsVersion: '1.2'
    scmMinTlsVersion: '1.2'
    ftpsState: 'FtpsOnly'
    preWarmedInstanceCount: 0
    functionAppScaleLimit: 200
    functionsRuntimeScaleMonitoringEnabled: false
    minimumElasticInstanceCount: 0
    azureStorageAccounts: {}
  }
}

resource sites_sspassignment641496_name_14ee20f9e4a44af482e23783f4f16c2c 'Microsoft.Web/sites/deployments@2022-09-01' = {
  parent: sites_sspassignment641496_name_resource
  name: '14ee20f9e4a44af482e23783f4f16c2c'
  location: 'West Europe'
  properties: {
    status: 4
    author_email: 'N/A'
    author: 'N/A'
    deployer: 'ZipDeploy'
    message: 'Created via a push deployment'
    start_time: '2023-11-09T13:54:03.5015396Z'
    end_time: '2023-11-09T13:54:05.3058948Z'
    active: true
  }
}

resource sites_sspassignment641496_name_4d8e596e000a44b0b4db23ba1cc6403d 'Microsoft.Web/sites/deployments@2022-09-01' = {
  parent: sites_sspassignment641496_name_resource
  name: '4d8e596e000a44b0b4db23ba1cc6403d'
  location: 'West Europe'
  properties: {
    status: 4
    author_email: 'N/A'
    author: 'N/A'
    deployer: 'ZipDeploy'
    message: 'Created via a push deployment'
    start_time: '2023-11-09T13:34:20.3408811Z'
    end_time: '2023-11-09T13:34:21.9525247Z'
    active: false
  }
}

resource sites_sspassignment641496_name_a4abf37ca8d14ef98f5c58825570a0b7 'Microsoft.Web/sites/deployments@2022-09-01' = {
  parent: sites_sspassignment641496_name_resource
  name: 'a4abf37ca8d14ef98f5c58825570a0b7'
  location: 'West Europe'
  properties: {
    status: 4
    author_email: 'N/A'
    author: 'N/A'
    deployer: 'ZipDeploy'
    message: 'Created via a push deployment'
    start_time: '2023-11-09T13:25:29.3180304Z'
    end_time: '2023-11-09T13:25:45.4425898Z'
    active: false
  }
}

resource sites_sspassignment641496_name_GetFinalImageList 'Microsoft.Web/sites/functions@2022-09-01' = {
  parent: sites_sspassignment641496_name_resource
  name: 'GetFinalImageList'
  location: 'West Europe'
  properties: {
    script_root_path_href: 'https://sspassignment641496.azurewebsites.net/admin/vfs/site/wwwroot/GetFinalImageList/'
    script_href: 'https://sspassignment641496.azurewebsites.net/admin/vfs/site/wwwroot/bin/SSPAssignment.dll'
    config_href: 'https://sspassignment641496.azurewebsites.net/admin/vfs/site/wwwroot/GetFinalImageList/function.json'
    test_data_href: 'https://sspassignment641496.azurewebsites.net/admin/vfs/data/Functions/sampledata/GetFinalImageList.dat'
    href: 'https://sspassignment641496.azurewebsites.net/admin/functions/GetFinalImageList'
    config: {}
    invoke_url_template: 'https://sspassignment641496.azurewebsites.net/api/getfinalimagelist'
    language: 'DotNetAssembly'
    isDisabled: false
  }
}

resource sites_sspassignment641496_name_ImageWeatherProcessing 'Microsoft.Web/sites/functions@2022-09-01' = {
  parent: sites_sspassignment641496_name_resource
  name: 'ImageWeatherProcessing'
  location: 'West Europe'
  properties: {
    script_root_path_href: 'https://sspassignment641496.azurewebsites.net/admin/vfs/site/wwwroot/ImageWeatherProcessing/'
    script_href: 'https://sspassignment641496.azurewebsites.net/admin/vfs/site/wwwroot/bin/SSPAssignment.dll'
    config_href: 'https://sspassignment641496.azurewebsites.net/admin/vfs/site/wwwroot/ImageWeatherProcessing/function.json'
    test_data_href: 'https://sspassignment641496.azurewebsites.net/admin/vfs/data/Functions/sampledata/ImageWeatherProcessing.dat'
    href: 'https://sspassignment641496.azurewebsites.net/admin/functions/ImageWeatherProcessing'
    config: {}
    language: 'DotNetAssembly'
    isDisabled: false
  }
}

resource sites_sspassignment641496_name_ImageWeatherTrigger 'Microsoft.Web/sites/functions@2022-09-01' = {
  parent: sites_sspassignment641496_name_resource
  name: 'ImageWeatherTrigger'
  location: 'West Europe'
  properties: {
    script_root_path_href: 'https://sspassignment641496.azurewebsites.net/admin/vfs/site/wwwroot/ImageWeatherTrigger/'
    script_href: 'https://sspassignment641496.azurewebsites.net/admin/vfs/site/wwwroot/bin/SSPAssignment.dll'
    config_href: 'https://sspassignment641496.azurewebsites.net/admin/vfs/site/wwwroot/ImageWeatherTrigger/function.json'
    test_data_href: 'https://sspassignment641496.azurewebsites.net/admin/vfs/data/Functions/sampledata/ImageWeatherTrigger.dat'
    href: 'https://sspassignment641496.azurewebsites.net/admin/functions/ImageWeatherTrigger'
    config: {}
    invoke_url_template: 'https://sspassignment641496.azurewebsites.net/api/imageweathertrigger'
    language: 'DotNetAssembly'
    isDisabled: false
  }
}

resource sites_sspassignment641496_name_WriteWeatherDataToImage 'Microsoft.Web/sites/functions@2022-09-01' = {
  parent: sites_sspassignment641496_name_resource
  name: 'WriteWeatherDataToImage'
  location: 'West Europe'
  properties: {
    script_root_path_href: 'https://sspassignment641496.azurewebsites.net/admin/vfs/site/wwwroot/WriteWeatherDataToImage/'
    script_href: 'https://sspassignment641496.azurewebsites.net/admin/vfs/site/wwwroot/bin/SSPAssignment.dll'
    config_href: 'https://sspassignment641496.azurewebsites.net/admin/vfs/site/wwwroot/WriteWeatherDataToImage/function.json'
    test_data_href: 'https://sspassignment641496.azurewebsites.net/admin/vfs/data/Functions/sampledata/WriteWeatherDataToImage.dat'
    href: 'https://sspassignment641496.azurewebsites.net/admin/functions/WriteWeatherDataToImage'
    config: {}
    language: 'DotNetAssembly'
    isDisabled: false
  }
}

resource sites_sspassignment641496_name_sites_sspassignment641496_name_azurewebsites_net 'Microsoft.Web/sites/hostNameBindings@2022-09-01' = {
  parent: sites_sspassignment641496_name_resource
  name: '${functionAppName}.azurewebsites.net'
  location: 'West Europe'
  properties: {
    siteName: 'sspassignment641496'
    hostNameType: 'Verified'
  }
}

resource storageAccounts_sspassignmentstorage_name_default_azure_webjobs_hosts 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  parent: storageAccounts_sspassignmentstorage_name_default
  name: 'azure-webjobs-hosts'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [

    storageAccounts_sspassignmentstorage_name_resource
  ]
}

resource storageAccounts_sspassignmentstorage_name_default_azure_webjobs_secrets 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  parent: storageAccounts_sspassignmentstorage_name_default
  name: 'azure-webjobs-secrets'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [

    storageAccounts_sspassignmentstorage_name_resource
  ]
}

resource storageAccounts_sspassignmentstorage_name_default_devopsassignment 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  parent: storageAccounts_sspassignmentstorage_name_default
  name: 'devopsassignment'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [

    storageAccounts_sspassignmentstorage_name_resource
  ]
}

resource storageAccounts_sspassignmentstorage_name_default_imageswithweatherdata 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  parent: storageAccounts_sspassignmentstorage_name_default
  name: 'imageswithweatherdata'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'Blob'
  }
  dependsOn: [

    storageAccounts_sspassignmentstorage_name_resource
  ]
}

resource storageAccounts_sspassignmentstorage_name_default_sspassignment20231108202542 'Microsoft.Storage/storageAccounts/fileServices/shares@2023-01-01' = {
  parent: Microsoft_Storage_storageAccounts_fileServices_storageAccounts_sspassignmentstorage_name_default
  name: 'sspassignment20231108202542'
  properties: {
    accessTier: 'TransactionOptimized'
    shareQuota: 5120
    enabledProtocols: 'SMB'
  }
  dependsOn: [

    storageAccounts_sspassignmentstorage_name_resource
  ]
}

resource storageAccounts_sspassignmentstorage_name_default_sspassignment641496 'Microsoft.Storage/storageAccounts/fileServices/shares@2023-01-01' = {
  parent: Microsoft_Storage_storageAccounts_fileServices_storageAccounts_sspassignmentstorage_name_default
  name: 'sspassignment641496'
  properties: {
    accessTier: 'TransactionOptimized'
    shareQuota: 5120
    enabledProtocols: 'SMB'
  }
  dependsOn: [

    storageAccounts_sspassignmentstorage_name_resource
  ]
}

resource storageAccounts_sspassignmentstorage_name_default_imageeditedqueue 'Microsoft.Storage/storageAccounts/queueServices/queues@2023-01-01' = {
  parent: Microsoft_Storage_storageAccounts_queueServices_storageAccounts_sspassignmentstorage_name_default
  name: 'imageeditedqueue'
  properties: {
    metadata: {}
  }
  dependsOn: [

    storageAccounts_sspassignmentstorage_name_resource
  ]
}

resource storageAccounts_sspassignmentstorage_name_default_imageeditedqueue_poison 'Microsoft.Storage/storageAccounts/queueServices/queues@2023-01-01' = {
  parent: Microsoft_Storage_storageAccounts_queueServices_storageAccounts_sspassignmentstorage_name_default
  name: 'imageeditedqueue-poison'
  properties: {
    metadata: {}
  }
  dependsOn: [

    storageAccounts_sspassignmentstorage_name_resource
  ]
}

resource storageAccounts_sspassignmentstorage_name_default_imagequeue 'Microsoft.Storage/storageAccounts/queueServices/queues@2023-01-01' = {
  parent: Microsoft_Storage_storageAccounts_queueServices_storageAccounts_sspassignmentstorage_name_default
  name: 'imagequeue'
  properties: {
    metadata: {}
  }
  dependsOn: [

    storageAccounts_sspassignmentstorage_name_resource
  ]
}

resource storageAccounts_sspassignmentstorage_name_default_imagetable 'Microsoft.Storage/storageAccounts/tableServices/tables@2023-01-01' = {
  parent: Microsoft_Storage_storageAccounts_tableServices_storageAccounts_sspassignmentstorage_name_default
  name: 'imagetable'
  properties: {}
  dependsOn: [

    storageAccounts_sspassignmentstorage_name_resource
  ]
}
