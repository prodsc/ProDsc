Configuration HostsFile_Config
{
    param
    (
        [Parameter()]
        [System.String[]]
        $NodeName = 'localhost'
    )

    Import-DSCResource -ModuleName ProDsc -ModuleVersion 1.0.0.0

    Node $NodeName
    {
        HostsFile HostEntry
        {
            HostName  = 'TestServer10'
            IPAddress = '172.16.100.10'
            Ensure    = 'Present'
        }
    }
}