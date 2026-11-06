# Знімок реального вікна за PID процесу (System.Drawing.CopyFromScreen).
param([int]$ProcessId, [string]$Out)
Add-Type -AssemblyName System.Drawing
Add-Type @"
using System; using System.Runtime.InteropServices;
public class W {
  [StructLayout(LayoutKind.Sequential)] public struct R { public int L, T, Ri, B; }
  [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr h);
  [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr h, int c);
  [DllImport("dwmapi.dll")] public static extern int DwmGetWindowAttribute(IntPtr h, int a, out R r, int s);
  [DllImport("user32.dll")] public static extern bool SetProcessDPIAware();
}
"@
[W]::SetProcessDPIAware() | Out-Null
$h = (Get-Process -Id $ProcessId).MainWindowHandle
[W]::ShowWindow($h, 9) | Out-Null; [W]::SetForegroundWindow($h) | Out-Null; Start-Sleep -Milliseconds 700
$r = New-Object W+R; [W]::DwmGetWindowAttribute($h, 9, [ref]$r, 16) | Out-Null
$w = $r.Ri - $r.L; $hh = $r.B - $r.T
$bmp = New-Object System.Drawing.Bitmap $w, $hh
$g = [System.Drawing.Graphics]::FromImage($bmp); $g.CopyFromScreen($r.L, $r.T, 0, 0, $bmp.Size)
$bmp.Save($Out, [System.Drawing.Imaging.ImageFormat]::Png); "$Out ${w}x$hh"
