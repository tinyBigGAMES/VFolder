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

program Testbed;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  VFolder in '..\..\src\VFolder.pas',
  UTestbed in 'UTestbed.pas';

begin
  try
    RunTests();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
