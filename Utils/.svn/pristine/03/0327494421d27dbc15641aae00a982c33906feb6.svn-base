unit Md5Unit;

interface
  function MD5(const Source : string) : string;

implementation

uses IdHashMessageDigest, idHash;

function MD5(const Source : string) : string;
var idmd5 : TIdHashMessageDigest5;
begin
   idmd5 := TIdHashMessageDigest5.Create;
   try
     result := idmd5.AsHex(idmd5.HashValue(Source));
   finally
     idmd5.Free;
   end;
end;
end.
