{===============================================================================
  __   _____    _    _
  \ \ / / __|__| |__| |___ _ _ ™
   \ V /| _/ _ \ / _` / -_) '_|
    \_/ |_|\___/_\__,_\___|_|
    Virtual folders made real

 Copyright © 2025-present tinyBigGAMES™ LLC
 All Rights Reserved.

 https://github.com/tinyBigGAMES/VFolder

 See LICENSE file for license information
===============================================================================}

unit UTestbed;

interface

uses
  WinApi.Windows,
  System.SysUtils,
  System.IOUtils,
  VFolder;

procedure RunTests();

implementation

(*=============================================================================
  Pause: Console Pause Utility
  This procedure provides a simple way to pause execution and wait for user
  input, commonly used in command-line tools or test runners. It prompts the
  user to press ENTER before continuing, allowing time to read any output.

  Behavior:
  - Outputs a blank line to visually separate from previous output.
  - Displays a message prompting the user to press ENTER.
  - Waits for the user to press ENTER using ReadLn.
  - Outputs another blank line after input to keep spacing clean.

  Use Cases:
  - Useful at the end of console apps to prevent auto-closing.
  - Helpful during debugging or step-by-step CLI processes.

  Parameters:
  - None.

  Steps performed:
  - Write a blank line.
  - Prompt the user.
  - Wait for ENTER.
  - Write another blank line.

  NOTE: This is a UI/UX enhancement for console-based applications.
==============================================================================*)
procedure Pause();
begin
  WriteLn;                          // Insert visual break before prompt
  Write('Press ENTER to continue...'); // Prompt user for input
  ReadLn;                           // Wait for user to press ENTER
  WriteLn;                          // Insert visual break after input
end;


(*=============================================================================
  BuildProgressCallback: Live Build Progress Display
  This procedure is intended to be used as a progress callback during file-based
  build or processing operations. It provides live console feedback indicating
  which file is being processed and the current progress percentage.

  Behavior:
  - Accepts filename, percentage completion, and flags indicating new file start.
  - Optionally inserts a newline when a new file begins.
  - Prints an in-place updating line showing current file and progress.

  Parameters:
  - filename:   A wide string pointer representing the file being processed.
  - percentage: Integer progress value (typically from 0 to 100).
  - newFile:    Boolean flag indicating whether this is a new file.
  - userData:   Optional user-defined pointer (unused here but available).

  Steps performed:
  - If newFile is True, print a line break to separate from the previous file.
  - Use Format and carriage return (#13) to overwrite the current console line.
  - Display the filename and percentage progress.

  NOTE: The carriage return character (#13) causes the line to update in place,
        creating a smooth visual indication of progress in the console output.
==============================================================================*)
procedure BuildProgressCallback(const filename: PWideChar; const percentage: Integer; const newFile: Boolean; const userData: Pointer);
begin
  if newFile then
    WriteLn; // Separate output when starting a new file

  // Print progress line in-place, overwriting the current console line
  Write(Format(#13'%s(%d%s)...', [filename, percentage, '%']));
end;

(*=============================================================================
  Test01: Basic vfolder Build Test
  This procedure performs a simple test of the `vfBuild` function, attempting to
  build a virtual folder from a source and output directory named "res". It then
  prints the result to the console indicating success or failure.

  Behavior:
  - Calls `vfBuild` with "res" as both the source and destination.
  - If the build succeeds, outputs "Success!".
  - If the build fails, outputs "Failed!".
  - In both cases, a blank line is written before the result message.

  Parameters:
  - None.

  Steps performed:
  - Invoke vfBuild with fixed source and output paths.
  - Print newline for visual separation.
  - Display appropriate result message based on return value.

  NOTE: This is a basic smoke test intended for manual validation of vfolder
        functionality. The paths used should exist and be writable.
==============================================================================*)
procedure Test01();
begin
  if vfBuild('res', 'res') then
    begin
      WriteLn;                // Visual separator
      WriteLn('Success!');    // Build succeeded
    end
  else
    begin
      WriteLn;                // Visual separator
      WriteLn('Failed!');     // Build failed
    end;
end;

(*=============================================================================
  Test02: vfolder Build Test with Progress Callback
  This procedure tests the `vfBuild` function with a progress reporting callback,
  allowing real-time feedback during the build process. It builds the virtual
  folder from the "res" directory and reports progress through `BuildProgressCallback`.

  Behavior:
  - Calls `vfBuild` with source and output paths set to "res".
  - Supplies `BuildProgressCallback` to receive file-by-file progress updates.
  - If the build succeeds, prints "Success!" to the console.
  - If it fails, prints "Failed!" instead.
  - A blank line is printed before the result message in both cases.

  Parameters:
  - None.

  Steps performed:
  - Invoke `vfBuild` with the progress callback and no user data.
  - Monitor return value to determine build success.
  - Display result message accordingly.

  NOTE: This test is useful for verifying callback functionality and observing
        live feedback during the virtual folder build process.
==============================================================================*)
procedure Test02();
begin
  if vfBuild('res', 'res', buildProgressCallback, nil) then
    begin
      WriteLn;                // Visual separator
      WriteLn('Success!');    // Build succeeded
    end
  else
    begin
      WriteLn;                // Visual separator
      WriteLn('Failed!');     // Build failed
    end;
end;

(*=============================================================================
  Test03: vfolder File Enumeration and Extraction Test
  This procedure tests the ability to open an existing virtual folder archive,
  enumerate its contents, and extract a specific file to the local filesystem.
  It assumes the file "res.vff" was created by `Test01` or `Test02`.

  Behavior:
  - Checks if "res.vff" exists; aborts with a message box if not.
  - Deletes any existing "image.png" file to ensure a clean extract.
  - Opens the virtual folder and enumerates all entries.
  - Prints each entry's name and size to the console.
  - Attempts to extract the file "path1\bluestone.png" to "image.png".
  - Reports success or failure of the extraction.

  Constants:
  - CVFilderFilename: Name of the virtual folder file ("res.vff").
  - CImageFilename:   Destination file for extracted image ("image.png").

  Variables:
  - LVFolder: vfolder handle instance.
  - LCount:   Total number of files in the archive.
  - LName:    Pointer to current file name.
  - LSize:    Size of current file in bytes.
  - I:        Loop index for enumeration.

  Steps performed:
  - Abort early if the required virtual file is missing.
  - Clean up the previous extracted image if present.
  - Allocate and initialize a vfolder instance.
  - Open the archive and retrieve file count.
  - Iterate and display each file's name and size.
  - Open all files in memory.
  - Attempt to copy a specific internal file to the output image path.
  - Report extraction status.
  - Ensure all resources are properly closed and released.

  NOTE: This test is essential for verifying the integrity of archive access,
        enumeration, and selective extraction features of the vfolder library.
==============================================================================*)
procedure Test03();
const
  CVFilderFilename = 'res.vff';
  CImageFilename = 'image.png';
var
  LVFolder: TVFolder;
  LCount: Int64;
  LName: PWideChar;
  LSize: Int64;
  I: Int64;
begin
  // Ensure the virtual archive exists before proceeding
  if not TFile.Exists(CVFilderFilename) then
  begin
    MessageBox(0, '"res.vff" was not found. Run Test01 or Test02 first.', 'Fatal Error', MB_ICONERROR);
    Exit;
  end;

  // Remove existing image output to ensure clean test
  if TFile.Exists(CImageFilename) then
  begin
    TFile.Delete(CImageFilename);
  end;

  // Allocate a new vfolder handle
  LVFolder := vfNew();
  try
    if not Assigned(LVFolder) then Exit;

    // Attempt to open the virtual folder file
    if not vfOpen(LVFolder, CVFilderFilename) then Exit;
    try
      // Get number of files in the archive
      LCount := vfGetFileCount(LVFolder);

      // Enumerate and display all file entries
      for I := 0 to LCount - 1 do
      begin
        if vfGetEntry(LVFolder, I, @LName, @LSize) then
        begin
          Writeln('"', LName, '" (', LSize, ')');
        end;
      end;

      Writeln('Count: ', LCount);  // Display total count

      // Load all files into memory for access
      vfOpenAllFiles(LVFolder, nil);
      try
        // Attempt to extract a specific file by virtual path
        TFile.Copy(vfGetVirtualFilename(LVFolder, 'path1\bluestone.png'), 'image.png', True);

        // Report extraction result
        if TFile.Exists(CImageFilename) then
          WriteLn(Format('Extracted "%s"', [CImageFilename]))
        else
          Writeln(Format('Failed to extract "%s"', [CImageFilename]));

      finally
        vfCloseAllFiles(LVFolder, nil); // Close memory-mapped files
      end;
    finally
      vfClose(LVFolder); // Close the archive
    end;
  finally
    vfFree(LVFolder); // Free the vfolder handle
  end;
end;

(*=============================================================================
  RunTests: Manual Test Dispatcher
  This procedure provides a simple mechanism for running one of several
  predefined test cases based on a hardcoded selection. It serves as an entry
  point to test individual vfolder operations manually.

  Behavior:
  - Sets a fixed test number (`LNum`) to determine which test to run.
  - Uses a `case` statement to dispatch execution to `Test01`, `Test02`, or `Test03`.
  - After the selected test finishes, it pauses execution to allow review of output.

  Variables:
  - LNum: Integer value representing the test to execute.

  Steps performed:
  - Assign a test number to `LNum`.
  - Match and invoke the corresponding test procedure.
  - Call `Pause` to wait for user input before exiting.

  NOTE: To run a different test, change the value of `LNum`. This approach is
        helpful during development for isolating specific test logic.
==============================================================================*)
procedure RunTests();
var
  LNum: Integer;
begin
  LNum := 03;  // Change this value to run a different test (e.g., 01, 02, 03)

  case LNum of
    01: Test01();  // Test build without callback
    02: Test02();  // Test build with progress callback
    03: Test03();  // Test archive read, list, and extract
  end;

  Pause();         // Wait for user to press ENTER before closing
end;

end.
