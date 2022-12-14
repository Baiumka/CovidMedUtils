{@********************************************************}
{    Copyright (c) 1999-2006 Zeos Development Group       }
{                                                         }
{ License Agreement:                                      }
{                                                         }
{ This library is distributed in the hope that it will be }
{ useful, but WITHOUT ANY WARRANTY; without even the      }
{ implied warranty of MERCHANTABILITY or FITNESS FOR      }
{ A PARTICULAR PURPOSE.  See the GNU Lesser General       }
{ Public License for more details.                        }
{                                                         }
{ The source code of the ZEOS Libraries and packages are  }
{ distributed under the Library GNU General Public        }
{ License (see the file COPYING / COPYING.ZEOS)           }
{ with the following  modification:                       }
{ As a special exception, the copyright holders of this   }
{ library give you permission to link this library with   }
{ independent modules to produce an executable,           }
{ regardless of the license terms of these independent    }
{ modules, and to copy and distribute the resulting       }
{ executable under terms of your choice, provided that    }
{ you also meet, for each linked independent module,      }
{ the terms and conditions of the license of that module. }
{ An independent module is a module which is not derived  }
{ from or based on this library. If you modify this       }
{ library, you may extend this exception to your version  }
{ of the library, but you are not obligated to do so.     }
{ If you do not wish to do so, delete this exception      }
{ statement from your version.                            }
{                                                         }
{                                                         }
{ The project web site is located on:                     }
{   http://zeos.firmos.at  (FORUM)                        }
{   http://zeosbugs.firmos.at (BUGTRACKER)                }
{   svn://zeos.firmos.at/zeos/trunk (SVN Repository)      }
{                                                         }
{   http://www.sourceforge.net/projects/zeoslib.          }
{   http://www.zeoslib.sourceforge.net                    }
{                                                         }
{                                                         }
{                                                         }
{                                 Zeos Development Group. }
{********************************************************@}

// Compilation directives for Lazarus
{$IFDEF FPC}
  {$MODE DELPHI}
  {$INTERFACES COM}
  {$DEFINE VER130BELOW}
  {$DEFINE VER140BELOW}
  // We assume 2 levels is sufficient.
  // The higher the third number in a version, the better... (we hope)
  {$IFDEF VER2_5}
    {$DEFINE FPC2_5UP}
    {$DEFINE FPC2_4UP}
    {$DEFINE FPC2_3UP}
    {$DEFINE FPC2_2UP}
    {$DEFINE FPC2_1UP}
  {$ENDIF}
  {$IFDEF VER2_4}
    {$DEFINE FPC2_4UP}
    {$DEFINE FPC2_3UP}
    {$DEFINE FPC2_2UP}
    {$DEFINE FPC2_1UP}
  {$ENDIF}
  {$IFDEF VER2_3}
    {$DEFINE FPC2_3UP}
    {$DEFINE FPC2_2UP}
    {$DEFINE FPC2_1UP}
  {$ENDIF}

  {$IFDEF VER2_2}
    {$DEFINE FPC2_2UP}
    {$DEFINE FPC2_1UP}
  {$ENDIF}

  {$IFDEF VER2_1}
    {$DEFINE FPC2_1UP}
  {$ENDIF}

  {$IFDEF VER2}
    {$DEFINE FPC2_UP}
  {$ENDIF}
{$ENDIF}


// Compilation directives for Delphi4
{$IFDEF VER120}
{$DEFINE VER125BELOW}
{$DEFINE VER130BELOW}
{$DEFINE VER130KBELOW}
{$DEFINE VER140BELOW}
{$ENDIF}

// Compilation directives for Delphi 5
{$IFDEF VER130}
{$DEFINE VER130BELOW}
{$DEFINE VER140BELOW}
{$ENDIF}

// Compilation directives for Delphi 6
{$IFDEF VER140}
{$DEFINE VER140BELOW}
{$ENDIF}

// Compilation directives for Delphi 7
{$IFDEF VER150}
  {$DEFINE VER150BELOW}
{$ENDIF}

// Compilation directives for Delphi 8
{$IFDEF VER160}
  {$DEFINE VER160BELOW}
{$ENDIF}

// Compilation directives for Delphi 9 (DELPHI 2005)
{$IFDEF VER170}
  {$DEFINE VER170BELOW}
  {$DEFINE BDS}
  {$DEFINE BDS3}
  {$DEFINE BDS3_UP}
  {$DEFINE COMPILER9}
  {$DEFINE COMPILER9_UP}
  {$DEFINE DELPHI9}
  {$DEFINE DELPHI9_UP}
{$ENDIF}

// Compilation directives for BDS 2006 (Delphi 2006, BCB 2006)
{$IFDEF VER180}
  {$DEFINE VER180BELOW}
  {$DEFINE BDS}
  {$DEFINE BDS4}
  {$DEFINE BDS4_UP}
  {$DEFINE COMPILER10}
  {$DEFINE COMPILER10_UP}
  {$IFDEF BCB}
    {$DEFINE BCB10}
    {$DEFINE BCB10_UP}
  {$ELSE}
    {$DEFINE DELPHI10}
    {$DEFINE DELPHI10_UP}
  {$ENDIF}
{$ENDIF}

{$IFDEF FREEBSD}
  {$DEFINE UNIX}
{$ENDIF}

{$IFDEF LINUX}
  {$DEFINE UNIX}
{$ENDIF}

// Debug/release compiler options
{$D+}

{$IFOPT D-}
{$DEFINE BINARY_RELEASE}
{$ENDIF}

{$IFDEF BINARY_RELEASE}
// Settings for Release mode
{$C-}
{$I-}
{$R-}
{$L-}
{$Q-}
{$IFNDEF FPC}
{$O+}
{$W-}
{$ENDIF}

{$ELSE}

// Settings for Debug mode
{.$C+}
{.$I+}
{.$R+}
{.$L+}
{.$Q+}
{.$IFNDEF FPC}
{.$O-}
{.$W+}
{.$ENDIF}

{$ENDIF}

// Disables checking code.
// Use Range checking option to turn on/off optimization
{$IFOPT R-}
{$DEFINE DISABLE_CHECKING}
{$ENDIF}

{$DEFINE ZEOS_DISABLE_MYSQL}
{.$DEFINE ZEOS_DISABLE_POSTGRESQL}
{$DEFINE ZEOS_DISABLE_DBLIB}
{$DEFINE ZEOS_DISABLE_ADO}
{$DEFINE ZEOS_DISABLE_INTERBASE}
{$DEFINE ZEOS_DISABLE_SQLITE}
{$DEFINE ZEOS_DISABLE_ORACLE}
{$DEFINE ZEOS_DISABLE_ASA}


// Enables MySQL support in TZConnection/TZDataset
{$IFNDEF ZEOS_DISABLE_MYSQL}
{$DEFINE ENABLE_MYSQL}
// Enables Mysql 3.x and 4.0 support
// These versions are deprecated and will not be supported in future versions of zeoslib.
{.$DEFINE ENABLE_MYSQL_DEPRECATED}
{$ENDIF}

// Enables PostgreSQL support in TZConnection/TZDataset
{$IFNDEF ZEOS_DISABLE_POSTGRESQL}
{$DEFINE ENABLE_POSTGRESQL}
{$ENDIF}

// Enables Sybase/MSSQL support in TZConnection/TZDataset
{$IFNDEF ZEOS_DISABLE_DBLIB}
{$DEFINE ENABLE_DBLIB}
{$ENDIF}

// Enables ADO support in TZConnection/TZDataset
{$IFNDEF ZEOS_DISABLE_ADO}
{$IFNDEF FPC}
 {$IFNDEF UNIX}
  {$DEFINE ENABLE_ADO}
 {$ENDIF}
{$ENDIF}
{$ENDIF}

// Enables Interbase/Firebird support in TZConnection/TZDataset
{$IFNDEF ZEOS_DISABLE_INTERBASE}
{$DEFINE ENABLE_INTERBASE}
{$ENDIF}

// Enables SQLite support in TZConnection/TZDataset
{$IFNDEF ZEOS_DISABLE_SQLITE}
{$DEFINE ENABLE_SQLITE}
{$ENDIF}

// Enables Oracle support in TZConnection/TZDataset
{$IFNDEF ZEOS_DISABLE_ORACLE}
{$DEFINE ENABLE_ORACLE}
{$ENDIF}

// Enables ASA support in TZConnection/TZDataset
{$IFNDEF ZEOS_DISABLE_ASA}
{$DEFINE ENABLE_ASA}
{$ENDIF}

// Supported language. Now available languages:
// ENGLISH, GERMAN, PORTUGUESE, DUTCH, SPANISH, ROMANA, INDONESIAN, RUSSIAN, CZECH, POLISH
{$DEFINE ENGLISH}

// Prevents loading default libmysql.dll
{.$DEFINE MYSQL_STRICT_DLL_LOADING}

// Prevents loading default firebird.dll
{.$DEFINE FIREBIRD_STRICT_DLL_LOADING}

// Prevents loading default libpq.dll
{.$DEFINE POSTGRESQL_STRICT_DLL_LOADING}

//Allows to see SQL exceptions as strings
{$DEFINE INTERBASE_EXTENDED_MESSAGES}

// Loads libcrypt.so before Firebird client library.
// It fixes error "Undefined symbol: crypt".
{$DEFINE INTERBASE_CRYPT}

// Excludes old ZeosDBO from the performance tests
{$DEFINE EXCLUDE_OLD_ZEOS_TEST}

// Excludes DBExpress from the performance tests
{$DEFINE EXCLUDE_DBX_TEST}

// Excludes IBX from the performance tests
{$DEFINE EXCLUDE_IBX_TEST}

// Excludes BDE from the performance tests
{$DEFINE EXCLUDE_BDE_TEST}

// Registers property editors for the components.
{$DEFINE WITH_PROPERTY_EDITOR}

// Turn on IProviderSupport interface
{$IFNDEF FPC}
{$IFNDEF VER125BELOW}
{$DEFINE WITH_IPROVIDER}
{$ENDIF}
{$ENDIF}

// Turn on multithreading
{$DEFINE MULTI_THREADED}

// In Version 6.1.5 there are several bugs with the TZSQLMetadata-Component
// For Version 6.5.0 you should uncomment the following line
{$DEFINE USE_METADATA}

// A large database may have many tables, colums and/or procedures!!!
// Therefore there is the ability to show a warning
// before retrieving a list of these database objects
// {$DEFINE SHOW_WARNING}

// Use libfbclient.so under linux
// and not libfbembed.so when Firebird 1.5.2 is used under linux
{$DEFINE USELIBFBCLIENTSO}

// Use SynEdit for the SQL Editors.
// Uncomment it when you will use SynEdit instead of a MemoEdit.
// The SynEdit component must be installed on your system.
// You can get SynEdit at http://synedit.sourceforge.net/
//{$DEFINE USE_SYNEDIT}

// Compile test applications with a graphical user interface (GUI)
// Comment this definition if you want to compile console test applications
{.$DEFINE TESTGUI}

//PATCH TO DO NO METADATALOADING / UNTESTED HIGH RISK
{.$DEFINE FOSNOMETA}
