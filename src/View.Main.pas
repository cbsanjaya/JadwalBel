unit View.Main;

interface

uses
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
  System.DateUtils, Vcl.ComCtrls;

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
    FManager: TObjectManager;
    FBell: TBell;
    procedure CheckSchedule(ANow: TDateTime);
    procedure ShowTime(ANow: TDateTime);
  public
    { Public declarations }
  end;

var
  FormUtama: TFormUtama;

implementation

{$R *.dfm}

uses ConnectionModule, DbUtils;

procedure TFormUtama.CheckSchedule(ANow: TDateTime);
var
  Details : TList<TBellDetail>;
  Detail : TBellDetail;
  Item: TListItem;
begin
  if FBell = nil then
  begin
    FBell := FManager.Find<TBell>.UniqueResult;
    Details := FBell.Details;
    LvBells.Items.Clear;
    for Detail in Details do
    begin
      Item := LvBells.Items.Add;
      Item.Caption := Detail.Name;
      Item.SubItems.Add(FormatDateTime('hh:nn:ss', Detail.Time));
      Item.SubItems.Add(Detail.Sound)
    end;
  end;

  Details := FBell.Details;
  for Detail in Details do
  begin
    if FormatDateTime('hh:nn:ss', ANow) = FormatDateTime('hh:nn:ss', Detail.Time) then
    begin
      LabelNext.Caption := '';
      exit;
    end;

    if LabelNext.Caption = '' then
    begin
      if FormatDateTime('hh:nn:ss', Detail.Time) > FormatDateTime('hh:nn:ss', ANow) then
      begin
        LabelNext.Caption := Format('Selanjutnya %s pada pukul %s',
          [Detail.Name, FormatDateTime('hh:nn:ss', Detail.Time)]);
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
end;

procedure TFormUtama.FormDestroy(Sender: TObject);
begin
  FManager.Free;
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

//  if SecondOf(LNow) = 0 then
    CheckSchedule(LNow);
end;

end.
