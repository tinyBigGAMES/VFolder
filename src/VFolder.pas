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

/// <summary>
///   Virtual Folder Library for Delphi.
/// </summary>
/// <remarks>
///   This unit provides an API for working with virtual folder files (VFF),
///   allowing you to package folders and files into a single file that can
///   be accessed at runtime as if it were a physical file system.
/// </remarks>
/// <author>Generated and maintained as part of the vfolder project.</author>
/// <version>1.0</version>
/// <see cref="TVFolder" />
unit VFolder;

{$Z4}
{$A8}

{$IFNDEF WIN64}
  {$MESSAGE Error 'Unsupported platform'}
{$ENDIF}

interface

type
  /// <summary>
  ///   Callback procedure used to report progress during the virtual folder build process.
  /// </summary>
  /// <param name="AFilename">
  ///   A <c>PWideChar</c> string representing the name of the file currently being processed.
  /// </param>
  /// <param name="APercentage">
  ///   An <c>Integer</c> indicating the estimated percentage of completion (0–100).
  /// </param>
  /// <param name="ANewFile">
  ///   A <c>Boolean</c> value indicating whether the callback is reporting a new file (<c>True</c>) or an update to an existing one (<c>False</c>).
  /// </param>
  /// <param name="AUserData">
  ///   A <c>Pointer</c> to user-defined data passed to <see cref="vfBuild" /> when the callback was registered.
  /// </param>
  /// <remarks>
  ///   - This callback is called one or more times during the execution of <see cref="vfBuild" />.
  ///   - Use this callback to provide feedback to the user (e.g., progress bars, logs, or status updates).
  ///   - The filename may include relative or absolute paths, depending on the builder's traversal state.
  /// </remarks>
  TvfBuildProgressCallback = procedure(
    const AFilename: PWideChar;
    const APercentage: Integer;
    const ANewFile: Boolean;
    const AUserData: Pointer
  );

  /// <summary>
  ///   Opaque handle representing an instance of a virtual folder.
  /// </summary>
  /// <remarks>
  ///   - This pointer is used in all vfolder API calls to manage and interact with a loaded or created virtual folder.
  ///   - The actual structure is hidden from the user, enforcing encapsulation and ensuring future compatibility.
  ///   - Always create instances via <see cref="vfNew" /> and free them with <see cref="vfFree" />.
  /// </remarks>
  TVFolder = Pointer;

var
  /// <summary>
  ///   Creates a new instance of a <c>TVFolder</c>.
  /// </summary>
  /// <returns>
  ///   A newly allocated <c>TVFolder</c> instance ready for use.
  /// </returns>
  /// <remarks>
  ///   - The returned <c>TVFolder</c> must be released using <see cref="vfFree" /> to avoid memory leaks.
  ///   - This function initializes internal structures required to manage virtual folders.
  /// </remarks>
  vfNew: function(): TVFolder;

  /// <summary>
  ///   Frees the memory associated with a <c>TVFolder</c> instance.
  /// </summary>
  /// <param name="AVFolder">
  ///   A variable reference to the <c>TVFolder</c> instance to be freed. The variable will be set to <c>nil</c> after the call.
  /// </param>
  /// <remarks>
  ///   - This procedure releases all resources allocated by the <c>TVFolder</c>.
  ///   - After calling this function, the passed-in variable will be reset to <c>nil</c> to prevent accidental reuse.
  /// </remarks>
  vfFree: procedure(var AVFolder: TVFolder);

  /// <summary>
  ///   Retrieves the default file extension used by a <c>TVFolder</c> instance.
  /// </summary>
  /// <param name="AVFolder">
  ///   The <c>TVFolder</c> instance for which to get the default file extension.
  /// </param>
  /// <returns>
  ///   A <c>PWideChar</c> pointer to a null-terminated Unicode string containing the default extension (e.g., <c>"vff"</c>).
  /// </returns>
  /// <remarks>
  ///   - The default extension is typically <c>"vff"</c>, representing a virtual folder file.
  ///   - The returned pointer is valid for the lifetime of the <c>TVFolder</c> instance and should not be freed manually.
  ///   - This function is useful when generating filenames for saving or exporting virtual folders.
  /// </remarks>
  vfGetDefaultFileExtension: function(const AVFolder: TVFolder): PWideChar;

  /// <summary>
  ///   Opens a virtual folder file and loads its contents into the specified <c>TVFolder</c> instance.
  /// </summary>
  /// <param name="AVFolder">
  ///   The <c>TVFolder</c> instance into which the virtual folder file will be loaded.
  /// </param>
  /// <param name="AFilename">
  ///   A <c>PWideChar</c> string containing the full path to the virtual folder file to open.
  /// </param>
  /// <returns>
  ///   <c>True</c> if the file was successfully opened and loaded; otherwise, <c>False</c>.
  /// </returns>
  /// <remarks>
  ///   - This function initializes the <c>TVFolder</c> with the contents of the specified file.
  ///   - If the file is invalid or cannot be read, the function returns <c>False</c>.
  ///   - Once opened, the folder can be queried and accessed using other vfolder functions.
  /// </remarks>
  vfOpen: function(const AVFolder: TVFolder; const AFilename: PWideChar): Boolean;

  /// <summary>
  ///   Checks whether a <c>TVFolder</c> instance currently has a virtual folder file opened.
  /// </summary>
  /// <param name="AVFolder">
  ///   The <c>TVFolder</c> instance to check.
  /// </param>
  /// <returns>
  ///   <c>True</c> if a virtual folder file is currently open in the instance; otherwise, <c>False</c>.
  /// </returns>
  /// <remarks>
  ///   - Use this function to verify the state of a <c>TVFolder</c> before attempting to access its contents.
  ///   - A return value of <c>False</c> indicates that no file has been loaded or that the folder was closed.
  /// </remarks>
  vfIsOpen: function(const AVFolder: TVFolder): Boolean;

  /// <summary>
  ///   Retrieves the virtual base path currently set for the specified <c>TVFolder</c> instance.
  /// </summary>
  /// <param name="AVFolder">
  ///   The <c>TVFolder</c> instance for which to retrieve the virtual base path.
  /// </param>
  /// <returns>
  ///   A <c>PWideChar</c> pointer to a null-terminated Unicode string containing the virtual base path.
  /// </returns>
  /// <remarks>
  ///   - The virtual base path represents the root path within the virtual folder hierarchy.
  ///   - This path affects how relative paths inside the virtual folder are resolved.
  ///   - The returned pointer remains valid as long as the <c>TVFolder</c> instance is open.
  /// </remarks>
  vfGetVirtualBasePath: function(const AVFolder: TVFolder): PWideChar;

  /// <summary>
  ///   Sets the virtual base path for a <c>TVFolder</c> instance.
  /// </summary>
  /// <param name="AVFolder">
  ///   The <c>TVFolder</c> instance to update.
  /// </param>
  /// <param name="APath">
  ///   A <c>PWideChar</c> string specifying the desired base path inside the virtual folder.
  /// </param>
  /// <returns>
  ///   <c>True</c> if the base path was successfully set; otherwise, <c>False</c>.
  /// </returns>
  /// <remarks>
  ///   - The base path determines the root context for file lookups within the virtual folder.
  ///   - Setting this path can be useful for aligning virtual folder structure with application expectations.
  ///   - Ensure the path exists within the virtual folder or future file resolutions may fail.
  /// </remarks>
  vfSetVirtualBasePath: function(const AVFolder: TVFolder; const APath: PWideChar): Boolean;

  /// <summary>
  ///   Sets the virtual base path of a <c>TVFolder</c> instance to the folder containing the executable.
  /// </summary>
  /// <param name="AVFolder">
  ///   The <c>TVFolder</c> instance to modify.
  /// </param>
  /// <returns>
  ///   <c>True</c> if the base path was successfully set to the executable directory; otherwise, <c>False</c>.
  /// </returns>
  /// <remarks>
  ///   - This is a convenient shortcut for aligning the virtual base path with the running application's location.
  ///   - Commonly used when the virtual folder is expected to mirror or overlay the executable's directory structure.
  ///   - May fail if the executable path cannot be determined at runtime.
  /// </remarks>
  vfSetVirtualBasePathToEXE: function(const AVFolder: TVFolder): Boolean;

  /// <summary>
  ///   Retrieves the total number of files stored in the virtual folder.
  /// </summary>
  /// <param name="AVFolder">
  ///   The <c>TVFolder</c> instance to query.
  /// </param>
  /// <returns>
  ///   An <c>Int64</c> value representing the number of files in the virtual folder.
  /// </returns>
  /// <remarks>
  ///   - This function returns the total count of files that are currently available in the loaded virtual folder.
  ///   - Use this count to iterate through files using <see cref="vfGetEntry" />.
  /// </remarks>
  vfGetFileCount: function(const AVFolder: TVFolder): Int64;

  /// <summary>
  ///   Retrieves information about a specific file entry in the virtual folder by index.
  /// </summary>
  /// <param name="AVFolder">
  ///   The <c>TVFolder</c> instance to query.
  /// </param>
  /// <param name="AIndex">
  ///   The zero-based index of the file entry to retrieve.
  /// </param>
  /// <param name="AName">
  ///   A pointer to a <c>PWideChar</c> variable that will receive the file name (null-terminated Unicode string).
  /// </param>
  /// <param name="ASize">
  ///   A pointer to an <c>Int64</c> variable that will receive the file size in bytes.
  /// </param>
  /// <returns>
  ///   <c>True</c> if the entry was successfully retrieved; otherwise, <c>False</c>.
  /// </returns>
  /// <remarks>
  ///   - Use <see cref="vfGetFileCount" /> to determine the number of entries before calling this function.
  ///   - Both <c>AName</c> and <c>ASize</c> must be valid pointers; they will be populated with the entry’s metadata.
  ///   - The file name returned is valid as long as the <c>TVFolder</c> remains open.
  /// </remarks>
  vfGetEntry: function(const AVFolder: TVFolder; const AIndex: Int64; AName: PPWideChar; ASize: PInt64): Boolean;

  /// <summary>
  ///   Closes the currently opened virtual folder file in the specified <c>TVFolder</c> instance.
  /// </summary>
  /// <param name="AVFolder">
  ///   The <c>TVFolder</c> instance to close.
  /// </param>
  /// <remarks>
  ///   - This procedure releases all resources associated with the open virtual folder.
  ///   - After calling <c>vfClose</c>, the folder instance is no longer valid for file access until reopened.
  ///   - Does not free the <c>TVFolder</c> itself; use <see cref="vfFree" /> for complete cleanup.
  /// </remarks>
  vfClose: procedure(const AVFolder: TVFolder);

  /// <summary>
  ///   Checks whether a file with the specified name exists in the virtual folder.
  /// </summary>
  /// <param name="AVFolder">
  ///   The <c>TVFolder</c> instance to search.
  /// </param>
  /// <param name="AFilename">
  ///   A <c>PWideChar</c> string specifying the virtual path of the file to check.
  /// </param>
  /// <returns>
  ///   <c>True</c> if the file exists in the virtual folder; otherwise, <c>False</c>.
  /// </returns>
  /// <remarks>
  ///   - File name comparisons are case-insensitive and relative to the virtual base path.
  ///   - Use this function before attempting to read a file to ensure it is present in the folder.
  /// </remarks>
  vfFileExist: function(const AVFolder: TVFolder; const AFilename: PWideChar): Boolean;

  /// <summary>
  ///   Opens a virtual file and makes it accessible on the operating system's filesystem as if it physically existed.
  /// </summary>
  /// <param name="AVFolder">
  ///   The <c>TVFolder</c> instance containing the virtual file.
  /// </param>
  /// <param name="AFilename">
  ///   A <c>PWideChar</c> string specifying the virtual file path to open.
  /// </param>
  /// <param name="AVirtualFilename">
  ///   A pointer to a <c>PWideChar</c> variable that will receive the path to the temporary file accessible on the OS filesystem.
  /// </param>
  /// <param name="ASize">
  ///   A pointer to an <c>Int64</c> variable that will receive the size of the file in bytes.
  /// </param>
  /// <returns>
  ///   <c>True</c> if the file was successfully opened and mapped to the OS filesystem; otherwise, <c>False</c>.
  /// </returns>
  /// <remarks>
  ///   - The specified virtual file is extracted to a temporary location and becomes accessible using standard file APIs.
  ///   - The returned path is valid for the lifetime of the open file or until explicitly closed.
  ///   - Useful for interoperability with components or libraries that require a physical file path.
  /// </remarks>
  vfOpenFile: function(const AVFolder: TVFolder; const AFilename: PWideChar; AVirtualFilename: PPWideChar; ASize: PInt64): Boolean;

  /// <summary>
  ///   Checks whether a virtual file has already been opened and made accessible on the filesystem.
  /// </summary>
  /// <param name="AVFolder">
  ///   The <c>TVFolder</c> instance to check.
  /// </param>
  /// <param name="AFilename">
  ///   A <c>PWideChar</c> string specifying the virtual file path to check.
  /// </param>
  /// <returns>
  ///   <c>True</c> if the specified file is currently open and accessible on the OS filesystem; otherwise, <c>False</c>.
  /// </returns>
  /// <remarks>
  ///   - Use this function to avoid re-opening a virtual file that is already mapped to the filesystem.
  ///   - A return value of <c>True</c> indicates that a temporary file path already exists for the virtual file.
  /// </remarks>
  vfIsFileOpen: function(const AVFolder: TVFolder; const AFilename: PWideChar): Boolean;

  /// <summary>
  ///   Closes a previously opened virtual file and removes its temporary representation from the filesystem.
  /// </summary>
  /// <param name="AVFolder">
  ///   The <c>TVFolder</c> instance containing the file.
  /// </param>
  /// <param name="AFilename">
  ///   A <c>PWideChar</c> string specifying the virtual file path to close.
  /// </param>
  /// <returns>
  ///   <c>True</c> if the file was successfully closed and cleaned up; otherwise, <c>False</c>.
  /// </returns>
  /// <remarks>
  ///   - This function removes the temporary file created by <see cref="vfOpenFile" /> from the OS filesystem.
  ///   - After closing, the file is no longer accessible by standard file APIs.
  ///   - If the file was not open, the function returns <c>False</c>.
  /// </remarks>
  vfCloseFile: function(const AVFolder: TVFolder; const AFilename: PWideChar): Boolean;

  /// <summary>
  ///   Opens all files in the virtual folder and makes them accessible on the OS filesystem.
  /// </summary>
  /// <param name="AVFolder">
  ///   The <c>TVFolder</c> instance whose contents are to be opened.
  /// </param>
  /// <param name="ACount">
  ///   A pointer to an <c>Int64</c> variable that will receive the number of files successfully opened.
  /// </param>
  /// <returns>
  ///   <c>True</c> if all files were opened and made accessible; otherwise, <c>False</c>.
  /// </returns>
  /// <remarks>
  ///   - This function extracts all files in the virtual folder to temporary files on the filesystem.
  ///   - Use with caution if the folder contains a large number of files or large files.
  ///   - The number of successfully opened files is returned via the <c>ACount</c> parameter.
  /// </remarks>
  vfOpenAllFiles: function(const AVFolder: TVFolder; ACount: PInt64=nil): Boolean;
  /// <summary>
  ///   Retrieves the full path to the temporary file on the OS filesystem corresponding to a virtual file.
  /// </summary>
  /// <param name="AVFolder">
  ///   The <c>TVFolder</c> instance containing the virtual file.
  /// </param>
  /// <param name="AFilename">
  ///   A <c>PWideChar</c> string specifying the virtual path of the file.
  /// </param>
  /// <returns>
  ///   A <c>PWideChar</c> pointer to the full path of the file on the OS filesystem, or <c>nil</c> if the file is not open.
  /// </returns>
  /// <remarks>
  ///   - This function returns the location of the physical file created by <see cref="vfOpenFile" /> or <see cref="vfOpenAllFiles" />.
  ///   - The returned pointer is valid as long as the file remains open.
  ///   - Use this function to pass a virtual file's path to APIs that require a physical file on disk.
  /// </remarks>
  vfGetVirtualFilename: function(const AVFolder: TVFolder; const AFilename: PWideChar): PWideChar;

  /// <summary>
  ///   Closes all virtual files that were previously opened and removes their temporary representations from the filesystem.
  /// </summary>
  /// <param name="AVFolder">
  ///   The <c>TVFolder</c> instance whose files should be closed.
  /// </param>
  /// <param name="ACount">
  ///   A pointer to an <c>Int64</c> variable that will receive the number of files successfully closed.
  /// </param>
  /// <remarks>
  ///   - This procedure cleans up all temporary files created by <see cref="vfOpenFile" /> and <see cref="vfOpenAllFiles" />.
  ///   - After calling this, none of the virtual files will remain accessible through the OS filesystem.
  ///   - The <c>ACount</c> parameter returns how many files were closed and removed.
  /// </remarks>
  vfCloseAllFiles: procedure(const AVFolder: TVFolder; ACount: PInt64=nil);

  /// <summary>
  ///   Adds a virtual folder path to the current process's search path.
  /// </summary>
  /// <param name="AVFolder">
  ///   The <c>TVFolder</c> instance containing the path to add.
  /// </param>
  /// <param name="APath">
  ///   A <c>PWideChar</c> string specifying the virtual path to add to the process's search path.
  /// </param>
  /// <returns>
  ///   <c>True</c> if the path was successfully added; otherwise, <c>False</c>.
  /// </returns>
  /// <remarks>
  ///   - This function allows virtual folder paths to be discovered by system-level APIs that search the process's path.
  ///   - Common use cases include dynamically loading DLLs or accessing resources from virtual folders without specifying full paths.
  ///   - Paths added this way are scoped to the current process and do not affect global system paths.
  /// </remarks>
  vfAddPathToProcessPath: function(const AVFolder: TVFolder; const APath: PWideChar): Boolean;

  /// <summary>
  ///   Removes a previously added virtual folder path from the current process's search path.
  /// </summary>
  /// <param name="AVFolder">
  ///   The <c>TVFolder</c> instance containing the path to remove.
  /// </param>
  /// <param name="APath">
  ///   A <c>PWideChar</c> string specifying the virtual path to remove from the process's search path.
  /// </param>
  /// <returns>
  ///   <c>True</c> if the path was successfully removed; otherwise, <c>False</c>.
  /// </returns>
  /// <remarks>
  ///   - Use this function to undo changes made by <see cref="vfAddPathToProcessPath" />.
  ///   - Once removed, the process will no longer search the specified path when resolving DLLs or other resources.
  ///   - It is safe to call this even if the path was not previously added, in which case it will return <c>False</c>.
  /// </remarks>
  vfRemovePathFromProcessPath: function(const AVFolder: TVFolder; const APath: PWideChar): Boolean;

  /// <summary>
  ///   Builds a virtual folder file from a real folder and its contents, including all subfolders and files.
  /// </summary>
  /// <param name="AFolderPath">
  ///   A <c>PWideChar</c> string specifying the full path to the source folder on disk to be packaged.
  /// </param>
  /// <param name="AFilename">
  ///   A <c>PWideChar</c> string specifying the full path to the output virtual file to create (e.g., <c>output.vff</c>).
  /// </param>
  /// <param name="AProgressCallback">
  ///   An optional callback of type <c>TvfBuildProgressCallback</c> that receives progress notifications during the build process.
  /// </param>
  /// <param name="AUserData">
  ///   An optional user-defined pointer passed to the progress callback during each invocation.
  /// </param>
  /// <returns>
  ///   <c>True</c> if the virtual folder was successfully built and saved; otherwise, <c>False</c>.
  /// </returns>
  /// <remarks>
  ///   - This function recursively scans the specified folder and packs all files and subdirectories into a single virtual folder file.
  ///   - The resulting file can later be opened using <see cref="vfOpen" /> and accessed as if it were a real file system structure.
  ///   - The progress callback is useful for providing user feedback or logging build stages during lengthy operations.
  ///   - The generated virtual file is portable and optimized for runtime access using the vfolder API.
  /// </remarks>
  vfBuild: function(const AFolderPath, AFilename: PWideChar; const AProgressCallback: TvfBuildProgressCallback = nil; const AUserData: Pointer = nil): Boolean;

implementation

{$REGION ' Uses '}
uses
  WinApi.Windows,
  System.SysUtils,
  System.Classes,
  System.Math;
{$ENDREGION}

{$REGION ' Loader '}

//------------------------------------------------------------------------------
// PE Structure Pointer Type Definitions
// These types define pointers to standard Windows PE file structures.
// They are used to navigate and interpret the PE file data loaded into memory.
// Reference: winnt.h in the Windows SDK.
//------------------------------------------------------------------------------
type
  PIMAGE_NT_HEADERS      = ^IMAGE_NT_HEADERS;
  PIMAGE_FILE_HEADER     = ^IMAGE_FILE_HEADER;
  PIMAGE_OPTIONAL_HEADER = ^IMAGE_OPTIONAL_HEADER;
  PIMAGE_SECTION_HEADER  = ^IMAGE_SECTION_HEADER;
  PIMAGE_DATA_DIRECTORY  = ^IMAGE_DATA_DIRECTORY;

//------------------------------------------------------------------------------
// Large Array Type Definitions (Helper Types)
// These define pointers to large arrays of WORD and Cardinal (DWORD).
// They are primarily used for typecasting when accessing PE structures
// like relocation tables or export tables, where the exact size might not
// be known at compile time, but we need pointer access to elements.
// The large upper bounds are likely placeholders and not indicative of
// expected actual usage size.
//------------------------------------------------------------------------------
type
  TDWORDArray = array[0..9999999] of Cardinal; // Array of 32-bit unsigned integers
  PDWORDArray = ^TDWORDArray;                 // Pointer to TDWORDArray
  TWORDArray  = array[0..99999999] of WORD;     // Array of 16-bit unsigned integers
  PWORDArray  = ^TWORDArray;                   // Pointer to TWORDArray

//------------------------------------------------------------------------------
// IMAGE_DOS_HEADER Structure Definition
// Defines the MS-DOS header structure found at the beginning of every PE file.
// The most important field for PE loading is 'e_lfanew', which points to
// the 'IMAGE_NT_HEADERS'.
//------------------------------------------------------------------------------
type
  IMAGE_DOS_HEADER = packed record     // DOS .EXE header
    e_magic: WORD;                     // Magic number (Should be 'MZ')
    e_cblp: WORD;                      // Bytes on last page of file
    e_cp: WORD;                        // Pages in file
    e_crlc: WORD;                      // Relocations
    e_cparhdr: WORD;                   // Size of header in paragraphs
    e_minalloc: WORD;                  // Minimum extra paragraphs needed
    e_maxalloc: WORD;                  // Maximum extra paragraphs needed
    e_ss: WORD;                        // Initial (relative) SS value
    e_sp: WORD;                        // Initial SP value
    e_csum: WORD;                      // Checksum
    e_ip: WORD;                        // Initial IP value
    e_cs: WORD;                        // Initial (relative) CS value
    e_lfarlc: WORD;                    // File address of relocation table
    e_ovno: WORD;                      // Overlay number
    e_res: array[0..3] of WORD;        // Reserved words
    e_oemid: WORD;                     // OEM identifier (for e_oeminfo)
    e_oeminfo: WORD;                   // OEM information; e_oemid specific
    e_res2: array[0..9] of WORD;       // Reserved words
    e_lfanew: Cardinal;                // File address of new exe header (PE header offset)
  end;

  PIMAGE_DOS_HEADER = ^IMAGE_DOS_HEADER; // Pointer to IMAGE_DOS_HEADER

//------------------------------------------------------------------------------
// IMAGE_BASE_RELOCATION Structure Definition
// Defines the header for a block of base relocations in the PE file.
// Relocations are necessary when the PE file cannot be loaded at its
// preferred base address ('ImageBase' in Optional Header).
// Each block contains a list of offsets (following this structure)
// that need patching relative to the 'VirtualAddress'.
//------------------------------------------------------------------------------
type
  IMAGE_BASE_RELOCATION = packed record
    VirtualAddress: Cardinal; // RVA (Relative Virtual Address) of the page to be fixed up.
    SizeOfBlock: Cardinal;    // Total size of this relocation block, including this header and all relocation entries.
  end;
  PIMAGE_BASE_RELOCATION = ^IMAGE_BASE_RELOCATION; // Pointer to IMAGE_BASE_RELOCATION

//------------------------------------------------------------------------------
// PIMAGE_EXPORT_DIRECTORY Type Definition
// Pointer to the IMAGE_EXPORT_DIRECTORY structure (defined in Winapi.Windows).
// This structure contains information about functions exported by the PE file.
// It's used by `Internal_GetProcAddress` to find exported functions by name.
//------------------------------------------------------------------------------
type
  PIMAGE_EXPORT_DIRECTORY = ^IMAGE_EXPORT_DIRECTORY; // Pointer to IMAGE_EXPORT_DIRECTORY (defined in Windows unit)

//------------------------------------------------------------------------------
// DLLMAIN Function Type Definition
// Defines the signature of the standard entry point function for a DLL.
// This function is called by the loader (or in this case, `Internal_Load` and
// `Internal_Unload`) when the DLL is loaded/unloaded or threads attach/detach.
//------------------------------------------------------------------------------
type
  DLLMAIN = function(hinstDLL: Pointer; fdwReason: Cardinal; lpvReserved: Pointer): Integer; stdcall;
  PDLLMAIN = ^DLLMAIN; // Pointer to a DLLMAIN function

//---------------------------------------------------------------------------
// Internal_CopyMemory
// Purpose: Copies a block of memory from a source location to a destination.
//          This acts as a wrapper around the standard 'memcpy' function,
//          retrieving its address dynamically from ntdll.dll.
// Note: Uses a local variable `MemCpy` which is re-fetched on every call if nil check passes.
//       (Original code checked `nil = @MemCpy` which always evaluates based on the address,
//       not the content, so GetProcAddress is called every time unless optimized out).
// Parameters:
//   Destination: Pointer to the starting address of the destination block.
//   Source     : Pointer to the starting address of the source block.
//   Count      : Number of bytes to copy. Original type was UInt64, kept as NativeUInt for compatibility.
//---------------------------------------------------------------------------
type
  TMemCpy = procedure(ADestination: Pointer; ASource: Pointer; ACount: NativeUInt);cdecl; // Function pointer type for memcpy
  PMemCpy = ^TMemCpy; // Pointer to the function pointer type

procedure Internal_CopyMemory(ADestination: Pointer; ASource: Pointer; ACount: NativeUInt); //was UInt64
var
  LMemCpy: TMemCpy; // Local variable to hold the function pointer
begin
  // Get address of 'memcpy' from ntdll.dll
    LMemCpy := TMemCpy(GetProcAddress(GetModuleHandleA('ntdll.dll'), 'memcpy')); // Fetch address every time for safety based on original code structure

  // Call the obtained memcpy function pointer
  LMemCpy(ADestination, ASource, ACount);
end;

//---------------------------------------------------------------------------
// Internal_ZeroMemory
// Purpose: Fills a block of memory with zeros.
//          Acts as a wrapper around 'RtlZeroMemory' from kernel32.dll,
//          retrieving its address dynamically on each call.
// Note: Similar to Internal_CopyMemory, uses a local variable and fetches
//       the address on each call due to the `if (nil = @ZeroMem)` check logic.
// Parameters:
//   What : Pointer to the starting address of the memory block to zero out.
//   Count: Number of bytes to fill with zero. Original type was UInt64, kept as NativeUInt.
//---------------------------------------------------------------------------
type
  TZeroMem = procedure(AWhat: Pointer; ACount: NativeUInt); stdcall; // Function pointer type for RtlZeroMemory

procedure Internal_ZeroMemory(AWhat: Pointer; ACount: NativeUInt); //was UInt64
var
  LZeroMem: TZeroMem; // Local variable to hold the function pointer
begin
  // Get address of 'RtlZeroMemory' from kernel32.dll
  LZeroMem := TZeroMem(GetProcAddress(GetModuleHandleA('kernel32.dll'), 'RtlZeroMemory'));

  // Call the obtained RtlZeroMemory function pointer
  LZeroMem(AWhat, ACount);
end;

//---------------------------------------------------------------------------
// Pointer Arithmetic Helper Functions
// Provide ways to perform arithmetic operations on pointers using NativeUInt
// for 32/64-bit compatibility.
//---------------------------------------------------------------------------

/// <summary>
/// Adds a Cardinal offset to a Pointer. Casts Pointer and Cardinal to NativeUInt.
/// </summary>
/// <param name="source">The base pointer.</param>
/// <param name="value">The Cardinal offset to add.</param>
/// <returns>A new Pointer offset by the given value.</returns>
function AddToPointer(ASource: Pointer; AValue: Cardinal) : Pointer;overload;
begin
  // Cast pointer to NativeUInt, cast Cardinal value to NativeUInt, add, cast result back to Pointer.
  Result := Pointer(NativeUInt(ASource) + NativeUInt(AValue)); // Int64 cast removed, assuming NativeUInt is sufficient and correct for Delphi pointer math
end;

/// <summary>
/// Adds a NativeUInt offset to a Pointer.
/// </summary>
/// <param name="source">The base pointer.</param>
/// <param name="value">The NativeUInt offset to add.</param>
/// <returns>A new Pointer offset by the given value.</returns>
function AddToPointer(ASource: Pointer; AValue: NativeUInt) : Pointer; overload;
begin
  // Cast pointer to NativeUInt, add NativeUInt value, cast result back to Pointer.
  Result := Pointer(NativeUInt(ASource) + AValue);
end;

/// <summary>
/// Calculates the difference (in bytes) between two Pointers.
/// </summary>
/// <param name="source">The first pointer (minuend).</param>
/// <param name="value">The second pointer (subtrahend).</param>
/// <returns>The difference between the pointers as a NativeUInt.</returns>
function DecPointer(ASource: Pointer; AValue: Pointer) : NativeUInt;
begin
  // Cast both pointers to NativeUInt and subtract.
  Result := NativeUInt(ASource) - NativeUInt(AValue);
end;

/// <summary>
/// Subtracts a NativeUInt offset from a Pointer and returns the result as NativeUInt.
/// Calculates `Pointer_Address - Offset`.
/// </summary>
/// <param name="source">The base pointer.</param>
/// <param name="value">The NativeUInt offset to subtract.</param>
/// <returns>The resulting memory address as a NativeUInt.</returns>
function DecPointerInt(ASource: Pointer; AValue: NativeUInt) : NativeUInt;
begin
  // Cast pointer to NativeUInt and subtract the NativeUInt offset.
  Result := NativeUInt(ASource) - NativeUInt(AValue);
end;

/// <summary>
/// Returns the minimum of two Integer values.
/// </summary>
function min(a: Integer; b: Integer): Integer;
begin
  if (a<b) then
    Result := a
  else
    Result := b;
end;

//------------------------------------------------------------------------------
// Internal_Load
// Purpose: Loads a PE image (DLL/EXE) from the memory buffer pointed to by pData.
//          Performs memory allocation, section mapping, base relocations,
//          import resolution, and calls the entry point.
// Parameters:
//   pData: A pointer to the raw PE file data in memory.
// Returns:
//   A Pointer to the base address where the PE image has been loaded in the
//   current process's virtual memory. Returns nil on failure (error handling is minimal).
//------------------------------------------------------------------------------
function Internal_Load(AData: Pointer) : Pointer;
var
  LPtr: Pointer;                              // General purpose pointer, used sequentially for DOS Header -> NT Headers -> Sections
  LImageNTHeaders: PIMAGE_NT_HEADERS;         // Pointer to the NT Headers structure
  LSectionIndex: Integer;                     // Loop counter for processing sections
  LImageBaseDelta: Size_t;                    // Difference between actual load address and preferred ImageBase. Size_t is platform dependent (usually NativeUInt).
  LRelocationInfoSize: UInt;                  // Size of the base relocation data directory (UInt is typically Cardinal/DWORD)
  LImageBaseRelocations,                      // Pointer to the start of the relocation data
  LReloc: PIMAGE_BASE_RELOCATION;             // Pointer to the current relocation block header being processed
  LImports,                                   // Pointer to the start of the import directory table
  LImport: PIMAGE_IMPORT_DESCRIPTOR;          // Pointer to the current import descriptor being processed
  LDllMain: DLLMAIN;                          // Pointer to the module's entry point function (if any)
  LImageBase: Pointer;                        // Base address of the allocated memory for the loaded image

  LImageSectionHeader: PIMAGE_SECTION_HEADER; // Pointer to the current section header being processed
  LVirtualSectionSize: Integer;               // The virtual size of the current section
  LRawSectionSize: Integer;                   // The size of the raw data for the current section
  LSectionBase: Pointer;                      // Pointer to the base address of the current section in allocated memory

  LRelocCount: Integer;                       // Number of relocations in the current block
  LRelocInfo: PWORD;                          // Pointer to the current relocation entry (WORD containing type/offset)
  LRelocIndex: Integer;                       // Loop counter for relocations within a block

  LMagic: PNativeUInt;                        // Pointer to the memory location that needs relocation patching (Original name 'magic')

  LLibName: LPSTR;                            // Name of the DLL to import functions from (LPSTR is PAnsiChar)
  LLib: HMODULE;                              // Handle to the loaded dependency DLL
  LPRVAImport: PNativeUInt;                   // Pointer to the IAT/ILT entry to read/patch. (Original comment: UInt, not PNativeUInt!) - Code uses PNativeUInt.
  LFunctionName: LPSTR;                       // Name or Ordinal (as LPSTR) of the function to import
begin
  // Initialize pPtr with the start of the raw PE data
  LPtr := AData;

  // 1. Locate NT Headers
  // Use e_lfanew field from DOS header to find the offset to NT headers.
  // Note the Int64 cast, which might be unnecessary if pData is properly aligned and offsets fit NativeInt.
  LPtr := Pointer(Int64(LPtr) + Int64(PIMAGE_DOS_HEADER(LPtr).e_lfanew));
  LImageNTHeaders := PIMAGE_NT_HEADERS(LPtr); // Cast the calculated address to NT Headers pointer

  // 2. Allocate Memory for the Image
  // Allocate virtual memory block. Attempt at preferred ImageBase (nil),
  // fallback to any address if needed (handled by OS).
  // Size from OptionalHeader.SizeOfImage. Permissions EXECUTE_READWRITE.
  LImageBase := VirtualAlloc(nil, LImageNTHeaders^.OptionalHeader.SizeOfImage, MEM_COMMIT, PAGE_EXECUTE_READWRITE);
  // NOTE: Original code doesn't check if VirtualAlloc returns nil (failure). Add check if robustness needed.

  // 3. Copy PE Headers
  // Copy DOS header, NT headers, section headers from raw data (pData) to allocated memory (pImageBase).
  Internal_CopyMemory(LImageBase, AData, LImageNTHeaders^.OptionalHeader.SizeOfHeaders);

  // 4. Map Sections into Memory
  // Advance pPtr to point to the first section header (after NT Headers structure).
  // SizeOfOptionalHeader determines the offset.
  LPtr := AddToPointer(LPtr,sizeof(LImageNTHeaders.Signature) + sizeof(LImageNTHeaders.FileHeader) + LImageNTHeaders.FileHeader.SizeOfOptionalHeader);

  // Loop through each section header
  for LSectionIndex := 0 to LImageNTHeaders.FileHeader.NumberOfSections-1 do
  begin
    // Calculate address of the current section header
    LImageSectionHeader := PIMAGE_SECTION_HEADER(AddToPointer(LPtr,LSectionIndex*sizeof(IMAGE_SECTION_HEADER)));

    // Get virtual size and raw data size for the section
    // Original comment: PhysicalAddress new code - referring to Misc field union? Using VirtualSize.
    LVirtualSectionSize := LImageSectionHeader.Misc.VirtualSize;
    LRawSectionSize := LImageSectionHeader.SizeOfRawData;

    // Calculate the target address for this section within the allocated memory block
    LSectionBase := AddToPointer(LImageBase,LImageSectionHeader.VirtualAddress);

    // Zero out the memory allocated for the section's virtual size
    Internal_ZeroMemory(LSectionBase, LVirtualSectionSize);

    // Copy the raw section data from input buffer (pData) to the allocated memory (pSectionBase).
    // Use 'min' to avoid writing past virtual size or reading past raw data size.
    Internal_CopyMemory(LSectionBase,
      AddToPointer(AData,LImageSectionHeader.PointerToRawData),
      min(LVirtualSectionSize, LRawSectionSize));
  end; // End section mapping loop

  // 5. Process Base Relocations
  // Calculate the difference (delta) between actual load address (pImageBase) and preferred (ImageBase).
  // Note: Using DecPointerInt returns NativeUInt, cast to Size_t (platform-dependent int).
  LImageBaseDelta := DecPointerInt(LImageBase,LImageNTHeaders.OptionalHeader.ImageBase);

  // Get the size and starting address of the relocation data.
  LRelocationInfoSize := LImageNTHeaders.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_BASERELOC].Size;
  LImageBaseRelocations := PIMAGE_BASE_RELOCATION(AddToPointer(LImageBase,
    LImageNTHeaders.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_BASERELOC].VirtualAddress));

  LReloc := LImageBaseRelocations; // Initialize pointer to the first relocation block

  // Iterate through relocation blocks as long as we are within the relocation data size.
  while DecPointer(LReloc,LImageBaseRelocations) < LRelocationInfoSize do
  begin
    // Calculate number of relocation entries (WORDs) in this block.
    LRelocCount := (LReloc.SizeOfBlock - sizeof(IMAGE_BASE_RELOCATION)) Div sizeof(WORD);

    // Get pointer to the first relocation entry (WORD TypeOffset) following the block header.
    LRelocInfo := PWORD(AddToPointer(LReloc,sizeof(IMAGE_BASE_RELOCATION)));

    // Iterate through each relocation entry in the current block.
    for LRelocIndex := 0 to LRelocCount-1 do
    begin
      // Check the relocation type (high 4 bits of the WORD).
      // If type is not 0 (IMAGE_REL_BASED_ABSOLUTE), apply relocation.
      // Original code checks `(pwRelocInfo^ and $f000) <> 0`. This handles common types
      // like HIGHLOW (3) and DIR64 (A) but isn't strictly type-specific.
      if (LRelocInfo^ and $f000) <> 0 then
      begin
        // Calculate the address in memory that needs patching.
        // Base + Block RVA + Offset (low 12 bits of WORD).
        LMagic := PNativeUInt(AddToPointer(LImageBase,LReloc.VirtualAddress+(LRelocInfo^ and $0fff)));

        // Apply the delta: Add the difference between actual and preferred base addresses.
        // Direct pointer arithmetic on the target location.
        LMagic^ := NativeUInt(LMagic^ + LImageBaseDelta);
        // Original C++ comment equivalent: *(char* *)((char*)pImageBase + pReloc->VirtualAddress + (pwRelocInfo^ and $0fff)) += intImageBaseDelta;
      end;

      Inc(LRelocInfo); // Move to the next relocation entry (WORD)
    end; // End loop for entries in current block

    // Move pReloc pointer to the next relocation block header.
    // pwRelocInfo now points just past the last entry of the current block.
    LReloc := PIMAGE_BASE_RELOCATION(LRelocInfo);
  end; // End loop for relocation blocks

  // 6. Process Import Table
  // Locate the Import Directory Table.
  LImports := PIMAGE_IMPORT_DESCRIPTOR(AddToPointer(LImageBase,
    LImageNTHeaders.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT].VirtualAddress));

  LImport := LImports; // Initialize pointer to the first import descriptor

  // Iterate through import descriptors until the Name RVA is 0 (null terminator).
  while 0 <> LImport.Name do
  begin
    // Get the name of the DLL to import from the descriptor's Name RVA.
    LLibName := LPSTR(AddToPointer(LImageBase,LImport.Name));

    // Load the required DLL.
    LLib := LoadLibraryA(LLibName);
    // NOTE: Original code doesn't check if hLib is 0 (load failure). Add check if needed.

    // Determine the table to iterate for function lookups (ILT or IAT).
    // Original logic: Uses TimeDateStamp == 0 to choose FirstThunk (IAT), otherwise Characteristics (OriginalFirstThunk/ILT).
    // Standard practice often uses OriginalFirstThunk (ILT) for lookup and patches FirstThunk (IAT).
    // Documenting the code as written.
    if 0 = LImport.TimeDateStamp then
      // If TimeDateStamp is 0, iterate the IAT (FirstThunk).
      LPRVAImport := AddToPointer(LImageBase,LImport.FirstThunk)
    else
      // Otherwise, iterate the ILT (OriginalFirstThunk, stored in Characteristics field pre-binding).
      LPRVAImport := AddToPointer(LImageBase,LImport.Characteristics); //new code comment implies this field choice is newer

    // Iterate through the ILT/IAT entries (list is null-terminated).
    // lpPRVA_Import points to the RVA/Ordinal entry.
    while LPRVAImport^ <> 0 do
    begin
      // Check if import is by Ordinal (high bit set).
      // Note: Uses IMAGE_ORDINAL_FLAG32 specifically. Should ideally use IMAGE_ORDINAL_FLAG.
      if (PDWORD(LPRVAImport)^ and IMAGE_ORDINAL_FLAG32) <> 0 then
      begin
        // Import by Ordinal: Ordinal is in the low 16 bits.
        // Cast ordinal directly to LPSTR for GetProcAddress.
        LFunctionName := LPSTR(PDWORD(LPRVAImport)^ and $ffff);
      end
      else
      begin
        // Import by Name: Entry is an RVA to IMAGE_IMPORT_BY_NAME structure.
        // Get address of the structure, then the Name field within it.
        // Note: `PUInt(lpPRVA_Import)^` dereferences the pointer to get the RVA.
        LFunctionName := LPSTR(@PIMAGE_IMPORT_BY_NAME(AddToPointer(LImageBase, PUInt(LPRVAImport)^)).Name[0]);
      end;

      // Get the actual address of the imported function using GetProcAddress.
      // Note: GetProcAddress returns FARPROC which needs casting. Result stored back into IAT entry.
      // It seems lpPRVA_Import itself is being modified, which implies it points to the IAT entry directly.
      // This suggests the `if 0 = pImport.TimeDateStamp` logic might be reversed or the variable use is subtle.
      // Assuming lpPRVA_Import points to the IAT entry that needs patching.
      LPRVAImport^ := NativeUInt(GetProcAddress(LLib, LFunctionName));

      Inc(LPRVAImport); // Move to the next IAT entry.
    end; // End loop for functions in current DLL

    Inc(LImport); // Move to the next import descriptor.
  end; // End loop for imported DLLs

  // 7. Flush Instruction Cache
  // Ensures CPU sees the newly written/patched code in memory.
  FlushInstructionCache(GetCurrentProcess(), LImageBase, LImageNTHeaders.OptionalHeader.SizeOfImage);

  // 8. Call Entry Point (DllMain)
  // Check if an entry point exists (AddressOfEntryPoint RVA is non-zero).
  if 0 <> LImageNTHeaders.OptionalHeader.AddressOfEntryPoint then
  begin
    // Calculate the absolute address of the entry point function.
    LDllMain := DLLMAIN(AddToPointer(LImageBase,LImageNTHeaders.OptionalHeader.AddressOfEntryPoint));

    // Check if the function pointer seems valid (check address, not content).
    // The `nil <> @pDllMain` check compares the *address* of the local variable `pDllMain`.
    // This is always true if pDllMain is a stack variable. Assume intent was `Assigned(pDllMain)`.
    if nil <> @LDllMain then
    // if Assigned(pDllMain) then // Use this check instead if the original is a typo
    begin
      // Call DllMain with DLL_PROCESS_ATTACH.
      LDllMain(Pointer(LImageBase), DLL_PROCESS_ATTACH, nil);
      // Call DllMain immediately with DLL_THREAD_ATTACH.
      // NOTE: This is generally incorrect usage. Thread attach/detach calls
      // should typically be made by the OS loader for new/exiting threads *after*
      // process attach is complete. Documenting the code as written.
      LDllMain(Pointer(LImageBase), DLL_THREAD_ATTACH, nil);
    end;
  end;

  // 9. Success: Return the base address of the loaded image.
  Result := Pointer(LImageBase);
end;

//------------------------------------------------------------------------------
// Internal_GetProcAddress
// Purpose: Finds the address of an exported function within a module that was
//          previously loaded into memory using `Internal_Load`. Mimics standard
//          `GetProcAddress` but operates on the manually loaded module data.
// Parameters:
//   hModule   : The base pointer of the manually loaded module (returned by `Internal_Load`).
//   lpProcName: The null-terminated ANSI string containing the name of the function to find.
//               Note: Does not support lookup by ordinal via this parameter.
// Returns:
//   A Pointer to the exported function's entry point. Returns nil if not found or on error.
//------------------------------------------------------------------------------
function Internal_GetProcAddress(hModule: Pointer; lpProcName: PAnsiChar) : Pointer;
var
  LImageNTHeaders: PIMAGE_NT_HEADERS;       // Pointer to the NT Headers
  LExports: PIMAGE_EXPORT_DIRECTORY;        // Pointer to the Export Directory structure
  LExportedSymbolIndex: Cardinal;           // Loop counter for exported names
  LPtr: Pointer;                            // Pointer used to navigate from module base to NT Headers
  LVirtualAddressOfName: Cardinal;          // RVA of the current function name string being checked
  LName: PAnsiChar;                         // Pointer to the current function name string in memory
  LIndex: WORD;                             // Index into the AddressOfFunctions table (obtained from NameOrdinals table)
  LVirtualAddressOfAddressOfProc: Cardinal; // RVA of the found function's entry point
begin
  Result := nil; // Initialize result to nil (not found)

  // Basic validation of input parameters
  if nil <> hModule then // Check if module handle is valid
  begin
    // 1. Locate NT Headers
    LPtr := hModule; // Start at module base
    // Calculate address of NT Headers using e_lfanew from DOS header. Int64 cast used.
    LPtr := Pointer(Int64(LPtr) + Int64(PIMAGE_DOS_HEADER(LPtr).e_lfanew));
    LImageNTHeaders := PIMAGE_NT_HEADERS(LPtr);
    // NOTE: Add signature checks (DOS, NT) for robustness if needed.

    // 2. Locate Export Directory Table
    // Get pointer to the export directory using the RVA from the data directory.
    LExports := PIMAGE_EXPORT_DIRECTORY(AddToPointer(hModule,
      LImageNTHeaders.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_EXPORT].VirtualAddress));
    // NOTE: Add check if VirtualAddress is 0 (no export table) if needed.

    // 3. Search for the function by name
    // Iterate through the array of exported function names (AddressOfNames).
    for LExportedSymbolIndex := 0 to LExports.NumberOfNames-1 do
    begin
      // Get the RVA of the name string for the current index. Uses PDWORDArray cast for indexing.
      LVirtualAddressOfName := PDWORDArray(AddToPointer(hModule,LExports.AddressOfNames))[LExportedSymbolIndex];

      // Calculate the actual address of the name string.
      LName := LPSTR(AddToPointer(hModule,LVirtualAddressOfName));

      // Compare the current exported name with the requested name (case-sensitive).
      // Use lstrcmpiA for case-insensitive if that's desired (standard GetProcAddress is case-sensitive technically, but LoadLibrary often handles case).
      if lstrcmpA(LName, lpProcName) = 0 then // Function name found!
      begin
        // 4. Get the function's address RVA
        // Find the ordinal associated with this name from the AddressOfNameOrdinals table.
        // This ordinal acts as the INDEX into the AddressOfFunctions table.
        // Uses PWORDArray cast for indexing.
        LIndex := PWORDArray(AddToPointer(hModule,LExports.AddressOfNameOrdinals))[LExportedSymbolIndex]; //new code comment implies this was changed

        // Use the index (wIndex) to get the RVA of the function's entry point from AddressOfFunctions table.
        // Uses PDWORDArray cast for indexing.
        LVirtualAddressOfAddressOfProc := PDWORDArray(AddToPointer(hModule,LExports.AddressOfFunctions))[LIndex];

        // 5. Calculate the absolute address
        // Add the function's RVA to the module's base address.
        Result := AddToPointer(hModule,LVirtualAddressOfAddressOfProc);
        Exit; // Function found, exit the loop and function.
        // NOTE: This does not handle forwarded exports (where dwVirtualAddressOfAddressOfProc points inside the export dir).
      end;
    end;
  end;

  // Function name not found or hModule was nil. Result remains nil.
end;

//------------------------------------------------------------------------------
// Internal_Unload
// Purpose: Unloads a module previously loaded by `Internal_Load`. Calls the
//          module's entry point with detach reasons and frees allocated memory.
// Parameters:
//   hModule: The base pointer of the manually loaded module (returned by `Internal_Load`).
//------------------------------------------------------------------------------
procedure Internal_Unload(hModule: Pointer);
var
  LImageBase: Pointer;                // Variable to hold the module base address (same as hModule parameter)
  LPtr: Pointer;                      // Pointer used to navigate from module base to NT Headers
  LImageNTHeaders: PIMAGE_NT_HEADERS; // Pointer to the NT Headers
  LDllMain: DLLMAIN;                  // Pointer to the module's entry point function
begin
  // Check if the module handle is valid
  if nil <> hModule then
  begin
    LImageBase := hModule; // Store the base address

    // 1. Locate NT Headers to find the entry point
    LPtr := Pointer(hModule); // Start at module base

    // Calculate address of NT Headers using e_lfanew. Int64 cast used.
    LPtr := Pointer(Int64(LPtr) + Int64(PIMAGE_DOS_HEADER(LPtr).e_lfanew));
    LImageNTHeaders := PIMAGE_NT_HEADERS(LPtr);

    // NOTE: Add signature checks for robustness if needed.
    // 2. Calculate Entry Point Address
    LDllMain := DLLMAIN(AddToPointer(LImageBase,LImageNTHeaders.OptionalHeader.AddressOfEntryPoint));

    // Check if the entry point address seems valid (using address-of check).
    // `nil <> @pDllMain` check compares the *address* of the local variable.
    // Assume intent was `Assigned(pDllMain)` and AddressOfEntryPoint > 0.
    if nil <> @LDllMain then
    // if (pImageNTHeaders.OptionalHeader.AddressOfEntryPoint <> 0) and Assigned(pDllMain) then // Safer check
    begin
      // 3. Call Entry Point with Detach Reasons
      // Call DllMain for thread detach first.
      // NOTE: Manually calling DLL_THREAD_DETACH is complex and may not behave as expected compared to OS handling.
      LDllMain(LImageBase, DLL_THREAD_DETACH, nil);

      // Call DllMain for process detach.
      LDllMain(LImageBase, DLL_PROCESS_DETACH, nil);
    end;

    // 4. Free the Allocated Memory
    // Release the virtual memory block allocated during Internal_Load.
    // Size must be 0, dwFreeType must be MEM_RELEASE.
    VirtualFree(hModule, 0, MEM_RELEASE);
  end;
end;

function  vfLoadLibrary(const AData: Pointer): THandle;
begin
  Result := THandle(Internal_Load(AData));
end;

function  vfGetProcAddress(const AHandle: THandle; const AProcName: PAnsiChar): Pointer;
begin
  Result := Internal_GetProcAddress(Pointer(AHandle), AProcName);
end;

procedure vfFreeLibrary(const AHandle: THandle);
begin
  Internal_Unload(Pointer(AHandle));
end;
{$ENDREGION}

{$REGION ' Deps DLL '}

{$R VFolder.res}

var
  DepsDLLHandle: THandle = 0;

function LoadDepsDLL(out AError: string): Boolean;
var
  LResStream: TResourceStream;

  function a999347516b44c90a19fef638e22f430(): string;
  const
    CValue = '62a0743234694c9d99e900143ed7c9c4';
  begin
    Result := CValue;
  end;

  procedure SetError(const AText: string; const AArgs: array of const);
  begin
    AError := Format(AText, AArgs);
  end;

begin
  Result := False;
  AError := '';

  // load deps DLL
  if DepsDLLHandle <> 0 then Exit;
  try
    if not Boolean((FindResource(HInstance, PWideChar(a999347516b44c90a19fef638e22f430()), RT_RCDATA) <> 0)) then
    begin
      SetError('Failed to find Deps DLL resource', []);
      Exit;
    end;

    LResStream := TResourceStream.Create(HInstance, a999347516b44c90a19fef638e22f430(), RT_RCDATA);
    try
      DepsDLLHandle := vfLoadLibrary(LResStream.Memory);

      if DepsDLLHandle = 0 then
      begin
        SetError('Failed to load extracted Deps DLL', []);
        Exit;
      end;

      vfNew := vfGetProcAddress(DepsDLLHandle, 'vfNew');
      vfFree := vfGetProcAddress(DepsDLLHandle, 'vfFree');
      vfGetDefaultFileExtension := vfGetProcAddress(DepsDLLHandle, 'vfGetDefaultFileExtension');
      vfOpen := vfGetProcAddress(DepsDLLHandle, 'vfOpen');
      vfIsOpen := vfGetProcAddress(DepsDLLHandle, 'vfIsOpen');
      vfGetVirtualBasePath := vfGetProcAddress(DepsDLLHandle, 'vfGetVirtualBasePath');
      vfSetVirtualBasePath := vfGetProcAddress(DepsDLLHandle, 'vfSetVirtualBasePath');
      vfSetVirtualBasePathToEXE := vfGetProcAddress(DepsDLLHandle, 'vfSetVirtualBasePathToEXE');
      vfGetFileCount := vfGetProcAddress(DepsDLLHandle, 'vfGetFileCount');
      vfGetEntry := vfGetProcAddress(DepsDLLHandle, 'vfGetEntry');
      vfClose := vfGetProcAddress(DepsDLLHandle, 'vfClose');
      vfFileExist := vfGetProcAddress(DepsDLLHandle, 'vfFileExist');
      vfOpenFile := vfGetProcAddress(DepsDLLHandle, 'vfOpenFile');
      vfIsFileOpen := vfGetProcAddress(DepsDLLHandle, 'vfIsFileOpen');
      vfCloseFile := vfGetProcAddress(DepsDLLHandle, 'vfCloseFile');
      vfOpenAllFiles := vfGetProcAddress(DepsDLLHandle, 'vfOpenAllFiles');
      vfGetVirtualFilename := vfGetProcAddress(DepsDLLHandle, 'vfGetVirtualFilename');
      vfCloseAllFiles := vfGetProcAddress(DepsDLLHandle, 'vfCloseAllFiles');
      vfAddPathToProcessPath := vfGetProcAddress(DepsDLLHandle, 'vfAddPathToProcessPath');
      vfRemovePathFromProcessPath := vfGetProcAddress(DepsDLLHandle, 'vfRemovePathFromProcessPath');
      vfBuild := vfGetProcAddress(DepsDLLHandle, 'vfBuild');

      Result := True;
    finally
      LResStream.Free();
    end;

  except
    on E: Exception do
      SetError('Unexpected error: %s', [E.Message]);
  end;
end;

procedure UnloadDepsDLL();
begin
  // unload deps DLL
  if DepsDLLHandle <> 0 then
  begin
    vfFreeLibrary(DepsDLLHandle);
    DepsDLLHandle := 0;
  end;
end;

initialization
var
  LError: string;

  ReportMemoryLeaksOnShutdown := True;
  SetExceptionMask(GetExceptionMask + [exOverflow, exInvalidOp]);
  SetConsoleCP(CP_UTF8);
  SetConsoleOutputCP(CP_UTF8);

  SetExceptionMask(GetExceptionMask + [exOverflow, exInvalidOp]);

  if not LoadDepsDLL(LError) then
  begin
    MessageBox(0, PWideChar(LError), 'Critical Initialization Error', MB_ICONERROR);
    Halt(1); // Exit the application with a non-zero exit code to indicate failure
  end;

finalization
  try
    UnloadDepsDLL();
  except
    on E: Exception do
    begin
      MessageBox(0, PChar(E.Message), 'Critical Shutdown Error', MB_ICONERROR);
    end;
  end;

{$ENDREGION}

end.
