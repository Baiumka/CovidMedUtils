unit AboutUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons;

type
  TfmAbout = class(TForm)
    btnOk: TBitBtn;
    bvl1: TBevel;
    lbl1: TLabel;
    lblVersion: TLabel;
    img1: TImage;
    lblCopyRight: TLabel;
    lbl3: TLabel;
    lbl2: TLabel;
    lblSite: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure lblSiteClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  procedure ShowAboutForm;

implementation

uses ConstUnit, ShellAPI;

{$R *.dfm}

procedure ShowAboutForm;
begin
  with TfmAbout.Create(Application) do
  try
    ShowModal;
  finally
    Free;
  end;


end;

procedure TfmAbout.FormCreate(Sender: TObject);
begin
  lblVersion.Caption   := 'Версия' + AppVersion;
  lblCopyRight.Caption := Char(169) + lblCopyRight.Caption;
end;

procedure TfmAbout.lblSiteClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar(lblSite.Caption),nil,nil, SW_SHOW);
end;

end.
