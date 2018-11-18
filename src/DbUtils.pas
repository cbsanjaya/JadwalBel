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
  LBell.Details.Add(TBellDetail.Create('Persiapan Upacara', '06:40:00', './sounds/1.mp3'));
  LBell.Details.Add(TBellDetail.Create('musik asmaul husna', '06:41:00', './sounds/1.mp3'));
  LBell.Details.Add(TBellDetail.Create('Bunyi Bel', '06:42:00', './sounds/1.mp3'));
  LBell.Details.Add(TBellDetail.Create('Persiapan Masuk Kelas', '06:43:00', './sounds/1.mp3'));
  LBell.Details.Add(TBellDetail.Create('Persiapan Jam Pertama', '06:44:00', './sounds/1.mp3'));
  LBell.Details.Add(TBellDetail.Create('Persiapan Jam Ke 2', '06:45:00', './sounds/1.mp3'));
  LBell.Details.Add(TBellDetail.Create('Persiapan Jam Ke 3', '06:46:00', './sounds/1.mp3'));
  LBell.Details.Add(TBellDetail.Create('Persiapan Jam Ke 4', '06:47:00', './sounds/1.mp3'));
  LBell.Details.Add(TBellDetail.Create('Persiapan Istirahat', '06:48:00', './sounds/1.mp3'));
  LBell.Details.Add(TBellDetail.Create('Persiapan Jam Ke 7', '06:49:00', './sounds/1.mp3'));
  LBell.Details.Add(TBellDetail.Create('Persiapan Jam Ke 8', '06:50:00', './sounds/1.mp3'));
  LBell.Details.Add(TBellDetail.Create('Persiapan Jam Ke 9', '06:51:00', './sounds/1.mp3'));
  LBell.Details.Add(TBellDetail.Create('Persiapan Sholat Dhuhur', '06:52:00', './sounds/1.mp3'));
  LBell.Details.Add(TBellDetail.Create('Persiapan Pulang', '06:53:00', './sounds/1.mp3'));

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

