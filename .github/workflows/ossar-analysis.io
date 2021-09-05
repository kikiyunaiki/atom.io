# This workflow integrates a collection of open source static analysis tools
# with GitHub code scanning. For documentation, or to provide feedback, visit
# https://github.com/github/ossar-action
name: OSSAR

on:
  push:
    branches: [ main ]
  pull_request:
    # The branches below must be a subset of the branches above
    branches: [ main ]
  schedule:
    - cron: '29 21 * * 4'

jobs:
  OSSAR-Scan:
    # OSSAR runs on windows-latest.
    # ubuntu-latest and macos-latest support coming soon
    runs-on: windows-latest

    steps:
    - name: Checkout repository
      uses: actions/checkout@v2

    # Ensure a compatible version of dotnet is installed.
    # The [Microsoft Security Code Analysis CLI](https://aka.ms/mscadocs) is built with dotnet v3.1.201.
    # A version greater than or equal to v3.1.201 of dotnet must be installed on the agent in order to run this action.
    # GitHub hosted runners already have a compatible version of dotnet installed and this step may be skipped.
    # For self-hosted runners, ensure dotnet version 3.1.201 or later is installed by including this action:
    # - name: Install .NET
    #   uses: actions/setup-dotnet@v1
    #   with:
    #     dotnet-version: '3.1.x'

      # Run open source static analysis tools
    - name: Run OSSAR
      uses: github/ossar-action@v1
      id: ossar

      # Upload results to the Security tab
    - name: Upload OSSAR results
      uses: github/codeql-action/upload-sarif@v1
      with:
        sarif_file: ${{ steps.ossar.outputs.sarifFile }}
