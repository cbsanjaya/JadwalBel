unit DbUtils;

interface

uses
  System.SysUtils,
  Aurelius.Drivers.Interfaces,
  Aurelius.Engine.DatabaseManager,
  Aurelius.Engine.ObjectManager,
  Entities;

procedure UpdateDatabase(ACon: IDBConnection);

procedure CreateDummyData(ACon: IDBConnection);

implementation

procedure CreateScheduleData(AManager: TObjectManager);
var
  LSchedule: TSchedule;
begin
  LSchedule := TSchedule.Create('Minggu');
  AManager.Save(LSchedule);

  LSchedule := TSchedule.Create('Senin');
  AManager.Save(LSchedule);

  LSchedule := TSchedule.Create('Selasa');
  AManager.Save(LSchedule);

  LSchedule := TSchedule.Create('Rabu');
  AManager.Save(LSchedule);

  LSchedule := TSchedule.Create('Kamis');
  AManager.Save(LSchedule);

  LSchedule := TSchedule.Create('Jumat');
  AManager.Save(LSchedule);

  LSchedule := TSchedule.Create('Sabtu');
  AManager.Save(LSchedule);
end;

procedure CreateBells(AManager: TObjectManager);
var
  LBell: TBell;
begin
  LBell := TBell.Create('Bel Normal Selasa Rabu Kamis');
  LBell.Details.Add(TBellDetail.Create('Persiapan Upacara', EncodeTime(6,40,0,0), './sounds/1.mp3'));
  LBell.Details.Add(TBellDetail.Create('musik asmaul husna', EncodeTime(6,41,0,0), './sounds/1.mp3'));
  LBell.Details.Add(TBellDetail.Create('Bunyi Bel', EncodeTime(6,42,0,0), './sounds/1.mp3'));
  LBell.Details.Add(TBellDetail.Create('Persiapan Masuk Kelas', EncodeTime(6,43,0,0), './sounds/1.mp3'));
  LBell.Details.Add(TBellDetail.Create('Persiapan Jam Pertama', EncodeTime(6,44,0,0), './sounds/1.mp3'));
  LBell.Details.Add(TBellDetail.Create('Persiapan Jam Ke 2', EncodeTime(6,45,0,0), './sounds/1.mp3'));
  LBell.Details.Add(TBellDetail.Create('Persiapan Jam Ke 3', EncodeTime(6,46,0,0), './sounds/1.mp3'));
  LBell.Details.Add(TBellDetail.Create('Persiapan Jam Ke 4', EncodeTime(6,47,0,0), './sounds/1.mp3'));
  LBell.Details.Add(TBellDetail.Create('Persiapan Istirahat', EncodeTime(6,48,0,0), './sounds/1.mp3'));
  LBell.Details.Add(TBellDetail.Create('Persiapan Jam Ke 7', EncodeTime(6,49,0,0), './sounds/1.mp3'));
  LBell.Details.Add(TBellDetail.Create('Persiapan Jam Ke 8', EncodeTime(6,50,0,0), './sounds/1.mp3'));
  LBell.Details.Add(TBellDetail.Create('Persiapan Jam Ke 9', EncodeTime(6,51,0,0), './sounds/1.mp3'));
  LBell.Details.Add(TBellDetail.Create('Persiapan Sholat Dhuhur', EncodeTime(6,52,0,0), './sounds/1.mp3'));
  LBell.Details.Add(TBellDetail.Create('Persiapan Pulang', EncodeTime(6,53,0,0), './sounds/1.mp3'));
  AManager.Save(LBell);
end;

procedure UpdateDatabase(ACon: IDBConnection);
var
  DB: TDatabaseManager;
  Manager: TObjectManager;
  Trans: IDBTransaction;
begin
  DB := TDatabaseManager.Create(ACon);
  try
    DB.UpdateDatabase;
  finally
    DB.Free;
  end;

  Manager := TObjectManager.Create(ACon);
  try
    if Manager.Find<TSchedule>.Take(1).UniqueResult = nil then
    begin
      Trans := ACon.BeginTransaction;
      try
        CreateScheduleData(Manager);
        Trans.Commit;
      except
        Trans.Rollback;
        raise;
      end;
    end;
  finally
    Manager.Free;
  end;
end;

procedure CreateDummyData(ACon: IDBConnection);
var
  Manager: TObjectManager;
  Trans: IDBTransaction;
begin
  Manager := TObjectManager.Create(ACon);
  try
    Trans := ACon.BeginTransaction;
    try
      CreateBells(Manager);
      Trans.Commit;
    except
      Trans.Rollback;
      raise;
    end;
  finally
    Manager.Free;
  end;
end;

end.

