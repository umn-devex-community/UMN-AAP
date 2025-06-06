
@{

  # Script module or binary module file associated with this manifest.
  RootModule = 'UMN-AAP.psm1'
  
  # Version number of this module.
  ModuleVersion = '1.0.0'
  
  # Supported PSEditions
  # CompatiblePSEditions = @()
  
  # ID used to uniquely identify this module
  GUID = 'b78031f9-ba93-404f-b389-9909cf205692'

  # Author of this module
  Author = 'Travis Sobeck'
  
  # Company or vendor of this module
  CompanyName = 'University of Minnesota'

  # Copyright statement for this module
  Copyright = '(c) 2024 University of Minnesota. All rights reserved.'
  
  # Description of the functionality provided by this module
  Description = 'Powershell helper for AAP'
  
  # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
  FunctionsToExport = '*'
  
  # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
  CmdletsToExport = '*'
  
  # Variables to export from this module
  VariablesToExport = '*'
  
  # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
  AliasesToExport = '*'
  PrivateData = @{
    
        PSData = @{
            ReleaseNotes = 'Init'  
        } # End of PSData hashtable  
    } # End of PrivateData hashtable
  }
  