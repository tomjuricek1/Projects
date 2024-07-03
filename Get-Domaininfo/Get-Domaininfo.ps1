function Get-DomainInfo {

    <#
.SYNOPSIS
    Checks information about a domain or IP address to help determine if it is used maliciously.

.DESCRIPTION
    The Get-DomainInfo function uses the AbuseIPDB and Whois APIs to check Whois information and AbuseIPDB data to help identify a malicious IP address or domain.
    The function requires AbuseIPDB and Whois API credentials, along with an IP address or domain name. The function will automatically resolve a domain name to an IP address.

.PARAMETER Domain
    The IP address or domain name to get information about.

.PARAMETER abuseipdbAPI 
    Your AbuseIPDB API key for database information.

.PARAMETER whoisAPI
    Your Whois API key to pull Whois information about a domain.

.PARAMETER timeframe
    The timeframe for which you want the AbuseIPDB domain information check to go back.
#>

    param (
        [string]$Domain,
        [string]$timeframe =30,
        [Parameter(Mandatory = $true)] [string]$abipKey,
        [Parameter(Mandatory = $true)] [string]$whoisKey
    )

    $parsedIP = $null

    #Function to resolve a domain name to a IP address
    function Resolve-DomainToIP {
        param (
            [string]$Domain
        )
        try {
            $ips = [System.Net.Dns]::GetHostAddresses($Domain)
            return $ips.IPAddressToString
        }
        catch {
            Write-Error "Unable to resolve domain to IP addresses."
            return $null
        }
    }
    #Checks user input to see if a IP or a domain was entered, and resolves domain
    if ([System.Net.IPAddress]::TryParse($Domain, [ref]$parsedIP)) {
        $ips = @($Domain)
        $whoisdomain = $ips
    }
    else {
        $whoisdomain = $Domain
        $ips = Resolve-DomainToIP -Domain $Domain | Select-Object -First 1
        Write-Host -ForegroundColor Green "Domain name resolved to: $ips"
    }
    if ($null -eq $ips) {
        Write-Error "No IP Addresses to check."
        return
    }
    #Headers for APIs
    $headerabip = @{
        "Key"    = $abipKey
        "Accept" = "application/json"
    }
    $headerwhois = @{
        "Authorization" = $whoisKey
    }
    #Get API Information
    try {
        $response = Invoke-RestMethod -Uri "https://api.abuseipdb.com/api/v2/check?ipAddress=$ips&days=$timeframe" -Method Get -Headers $headerabip
    }
    catch {
        Write-Host -ForegroundColor Red "An error occurred while fetching AbuseIPD data"
    }

    try {
        $whoisResponse = Invoke-RestMethod -Uri "https://jsonwhoisapi.com/api/v1/whois?identifier=$whoisdomain" -Headers $headerwhois
    }
    catch {
        Write-Host -ForegroundColor Red "An error occurred while fetching WHOIS data"
    }
    #Display data to user
    $isp = $response.data.isp
    $ipaddr = $response.data.ipAddress
    $reportnum = $response.data.totalReports
    $country = $response.data.countryCode
    $abuseConfidenceScore = $response.data.abuseConfidenceScore
    $usagetype = $response.data.usageType
    $lastreport = $response.data.lastReportedAt
    $created = $whoisResponse.created
    $expires = $whoisResponse.expires
    $name = $whoisResponse.name
    $nameservers = $whoisResponse.nameservers
    $registrar = $whoisResponse.registrar
    $status = $whoisResponse.status

    Write-Host -ForegroundColor Yellow "AbuseIPD Info:"
    Write-Host "Timeframe of AbuseIPD: $timeframe days"
    Write-Host "IP Address: $ipaddr"
    Write-Host "Abuse Confidence Score: $abuseConfidenceScore"
    Write-Host "Country: $country"
    Write-Host "ISP: $isp"
    Write-Host "Usage Type: $usagetype"
    Write-Host "Total Reports: $reportnum"
    Write-Host "Last reported: $lastreport"
    Write-Host -ForegroundColor Yellow "WhoIs Info:"
    Write-Host "Name: $name"
    Write-Host "Status: $status"
    Write-Host "Created: $created"
    Write-Host "Expires: $expires"
    Write-Host "Nameservers: $nameservers"
    Write-Host "Registrar: $registrar"
}