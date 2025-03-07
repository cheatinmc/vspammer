param(
    [string]$message,
    [int]$delay,
    [string]$random,
    [string]$ping,
    [string]$userid,
    [int]$limit
)

try {
    Add-Type -AssemblyName System.Windows.Forms
    $wshell = New-Object -ComObject wscript.shell
    $isPaused = $false
    $running = $true

    Add-Type @"
    using System;
    using System.Runtime.InteropServices;
    public class KeyboardHelper {
        [DllImport("user32.dll")]
        public static extern short GetAsyncKeyState(int vKey);
    }
"@ -Language CSharp

    Write-Host '[' -NoNewline
    Write-Host 'INFO' -NoNewline -ForegroundColor Blue
    Write-Host '] Starting in 5 seconds... Press ESC to stop, CTRL+P to pause'
    Start-Sleep -Seconds 5

    $count = 1
    while($running) {
        Start-Sleep -Milliseconds 10

        if ([KeyboardHelper]::GetAsyncKeyState(0x1B)) {
            Write-Host '[' -NoNewline
            Write-Host 'STOP' -NoNewline -ForegroundColor Red
            Write-Host '] Program stopped by user'
            Write-Host '[' -NoNewline
            Write-Host 'INFO' -NoNewline -ForegroundColor Blue
            Write-Host '] Closing in 5 seconds...'
            Start-Sleep -Seconds 1
            Write-Host '[' -NoNewline
            Write-Host 'INFO' -NoNewline -ForegroundColor Blue
            Write-Host '] 4...'
            Start-Sleep -Seconds 1
            Write-Host '[' -NoNewline
            Write-Host 'INFO' -NoNewline -ForegroundColor Blue
            Write-Host '] 3...'
            Start-Sleep -Seconds 1
            Write-Host '[' -NoNewline
            Write-Host 'INFO' -NoNewline -ForegroundColor Blue
            Write-Host '] 2...'
            Start-Sleep -Seconds 1
            Write-Host '[' -NoNewline
            Write-Host 'INFO' -NoNewline -ForegroundColor Blue
            Write-Host '] 1...'
            Start-Sleep -Seconds 1
            Write-Host '[' -NoNewline
            Write-Host 'GOODBYE' -NoNewline -ForegroundColor Magenta
            Write-Host '] Thanks for using VSpammer!'
            exit
        }

        if ([KeyboardHelper]::GetAsyncKeyState(0x11) -and [KeyboardHelper]::GetAsyncKeyState(0x50)) {
            $isPaused = -not $isPaused
            if ($isPaused) {
                Write-Host '[' -NoNewline
                Write-Host 'PAUSE' -NoNewline -ForegroundColor Yellow
                Write-Host '] Program paused - Press CTRL+P to resume'
            } else {
                Write-Host '[' -NoNewline
                Write-Host 'RESUME' -NoNewline -ForegroundColor Green
                Write-Host '] Program resumed'
            }
            Start-Sleep -Milliseconds 500
            continue
        }

        if (-not $isPaused) {
            try {
                $msg = $message
                if ($random -eq "y") {
                    $chars = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
                    $randomCode = -join ((0..5) | ForEach-Object { $chars[(Get-Random -Maximum $chars.Length)] })
                    $msg = "$msg #$randomCode"
                }
                if ($ping -eq "y") {
                    $msg = $msg.replace("xxx", "<@$userid>")
                }

                $wshell.SendKeys("$msg{ENTER}")
                Write-Host '[' -NoNewline
                Write-Host 'SUCCESS' -NoNewline -ForegroundColor Green
                Write-Host '] Message sent!'

                if ($limit -gt 0) {
                    Write-Host '[' -NoNewline
                    Write-Host 'LIMIT' -NoNewline -ForegroundColor Yellow
                    Write-Host ('] ' + $count + ' of ' + $limit + ' messages sent.')
                }

                Start-Sleep -Milliseconds ($delay / 2)

                if (-not $isPaused) {
                    Write-Host '[' -NoNewline
                    Write-Host 'NOTICE' -NoNewline -ForegroundColor Cyan
                    Write-Host '] Preparing next message...'
                }

                Start-Sleep -Milliseconds ($delay / 2)

                if ($limit -gt 0 -and $count -ge $limit) {
                    Write-Host '[' -NoNewline
                    Write-Host 'COMPLETE' -NoNewline -ForegroundColor Green
                    Write-Host '] Message limit reached'
                    Write-Host '[' -NoNewline
                    Write-Host 'INFO' -NoNewline -ForegroundColor Blue
                    Write-Host '] Closing in 5 seconds...'
                    Start-Sleep -Seconds 1
                    Write-Host '[' -NoNewline
                    Write-Host 'INFO' -NoNewline -ForegroundColor Blue
                    Write-Host '] 4...'
                    Start-Sleep -Seconds 1
                    Write-Host '[' -NoNewline
                    Write-Host 'INFO' -NoNewline -ForegroundColor Blue
                    Write-Host '] 3...'
                    Start-Sleep -Seconds 1
                    Write-Host '[' -NoNewline
                    Write-Host 'INFO' -NoNewline -ForegroundColor Blue
                    Write-Host '] 2...'
                    Start-Sleep -Seconds 1
                    Write-Host '[' -NoNewline
                    Write-Host 'INFO' -NoNewline -ForegroundColor Blue
                    Write-Host '] 1...'
                    Start-Sleep -Seconds 1
                    Write-Host '[' -NoNewline
                    Write-Host 'GOODBYE' -NoNewline -ForegroundColor Magenta
                    Write-Host '] Thanks for using VSpammer!'
                    exit
                }
                $count++
            }
            catch {
                Write-Host '[' -NoNewline
                Write-Host 'ERROR' -NoNewline -ForegroundColor Red
                Write-Host ('] Message send failed: ' + $_.Exception.Message)
                Start-Sleep -Seconds 1
            }
        }
    }
}
catch {
    Write-Host '[' -NoNewline
    Write-Host 'FATAL ERROR' -NoNewline -ForegroundColor Red
    Write-Host ('] ' + $_.Exception.Message)
    Start-Sleep -Seconds 5
    exit 1
}
