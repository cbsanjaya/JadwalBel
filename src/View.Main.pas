unit View.Main;

interface

uses
  {$IFDEF DEBUG}
  Log.Sql,
  {$ENDIF}
  Generics.Collections,
  Aurelius.Drivers.Interfaces,
  Aurelius.Engine.ObjectManager,
  Entities,
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  System.DateUtils,
  Vcl.ComCtrls,
  Winapi.MMSystem;

type
  TFormUtama = class(TForm)
    TmCheck: TTimer;
    LabelTime: TLabel;
    LabelDate: TLabel;
    LvBells: TListView;
    LabelNext: TLabel;
    procedure TmCheckTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    {$IFDEF DEBUG}
    LogSql : TSqlLog;
    {$ENDIF}
    FManager: TObjectManager;
    FBell: TBell;
    function SearchBell(ANow: TDateTime): TBell;
    procedure CheckSchedule(ANow: TDateTime);
    procedure ShowTime(ANow: TDateTime);
  public
    { Public declarations }
  end;

var
  FormUtama: TFormUtama;

implementation

{$R *.dfm}

uses
  ConnectionModule,
  DbUtils;

procedure TFormUtama.CheckSchedule(ANow: TDateTime);
var
  Details : TList<TBellDetail>;
  Detail : TBellDetail;
  Item: TListItem;
begin
  if FBell = nil then
  begin
    FBell := SearchBell(ANow);
    if FBell = nil then
      Exit;

    Details := FBell.Details;
    LvBells.Items.Clear;
    for Detail in Details do
    begin
      Item := LvBells.Items.Add;
      Item.Caption := Detail.Name;
      Item.SubItems.Add(Detail.Time);
      Item.SubItems.Add(Detail.Sound)
    end;
  end;

  Details := FBell.Details;
  for Detail in Details do
  begin
    if FormatDateTime('hh:nn:ss', ANow) = Detail.Time then
    begin
      LabelNext.Caption := '';
      if FileExists(Detail.Sound) then
        sndPlaySound(PChar(Detail.Sound), SND_SYNC);
      exit;
    end;

    if LabelNext.Caption = '' then
    begin
      if Detail.Time > FormatDateTime('hh:nn:ss', ANow) then
      begin
        LabelNext.Caption := Format('Selanjutnya %s pada pukul %s',
          [Detail.Name, Detail.Time]);
        exit;
      end;
    end;
  end;
end;

procedure TFormUtama.FormCreate(Sender: TObject);
var
  Con: IDBConnection;
begin
  Con := TConnection.CreateConnection;
  DbUtils.UpdateDatabase(Con);
//  DbUtils.CreateDummyData(Con);
  FManager := TObjectManager.Create(Con);
  {$IFDEF DEBUG}
  LogSql := TSqlLog.Create;
  {$ENDIF}
end;

procedure TFormUtama.FormDestroy(Sender: TObject);
begin
  FManager.Free;

  {$IFDEF DEBUG}
  LogSql.Free;
  {$ENDIF}
end;

function TFormUtama.SearchBell(ANow: TDateTime): TBell;
var
  LSchedule: TSchedule;
begin
  Result := nil;
  LSchedule := FManager.Find<TSchedule>(DayOfWeek(ANow));
  if LSchedule.Bell.HasValue then
    Result := LSchedule.Bell.Value;
end;

procedure TFormUtama.ShowTime(ANow: TDateTime);
var
  Days: array[1..7] of string;
  LToday, LDate, LTime: string;
begin
  Days[1] := 'Minggu';
  Days[2] := 'Senin';
  Days[3] := 'Selasa';
  Days[4] := 'Rabu';
  Days[5] := 'Kamis';
  Days[6] := 'Jumat';
  Days[7] := 'Sabtu';

  LToday := Days[DayOfWeek(ANow)];
  LDate := FormatDateTime('dd mmmm yyyy', ANow);
  LTime := FormatDateTime('hh:nn:ss', ANow);

  LabelDate.Caption := Format('%s, %s', [LToday, LDate]);
  LabelTime.Caption := LTime;
end;

procedure TFormUtama.TmCheckTimer(Sender: TObject);
var
  LNow: TDateTime;
begin
  LNow:= Now;

  ShowTime(LNow);

  CheckSchedule(LNow);
end;

end.
