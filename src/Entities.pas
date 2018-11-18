unit Entities;

interface

uses
  Generics.Collections,
  Aurelius.Mapping.Attributes,
  Aurelius.Types.Proxy,
  Aurelius.Types.Nullable;

type
  [Entity, Automapping]
  TBellDetail = class
  private
    FId: Integer;
    FName: string;
    FTime: string;
    FSound: string;
  public
    constructor Create(const AName: string; ATime: string; ASound:string); overload;
    property Id: Integer read FId write FId;
    property Name: string read FName write FName;
    property Time: string read FTime write FTime;
    property Sound: string read FSound write FSound;
  end;

  [Entity, Automapping]
  TBell = class
  private
    FId: Integer;
    FName: string;
    [ManyValuedAssociation([TAssociationProp.Lazy], CascadeTypeAllRemoveOrphan)]
    FDetails: Proxy<TList<TBellDetail>>;
    function GetDetails: TList<TBellDetail>;
  public
    constructor Create; overload;
    constructor Create(const AName: string); overload;
    destructor Destroy; override;
    property Id: Integer read FId write FId;
    property Name: string read FName write FName;
    property Details: TList<TBellDetail> read GetDetails;
  end;


  [Entity, Automapping]
  TSchedule = class
  private
    FId: Integer;
    FDay: string;
    FBell: Nullable<TBell>;
  public
    constructor Create(const ADay: string); overload;
    constructor Create(const ADay: string; ABell: TBell); overload;
    property Id: Integer read FId write FId;
    property Day: string read FDay write FDay;
    property Bell: Nullable<TBell> read FBell write FBell;
  end;

  [Entity, Automapping]
  [UniqueKey('Date')]
  TAbnormal = class
  private
    FId: Integer;
    FName: string;
    FDate: TDate;
    FBell: TBell;
  public
    property Id: Integer read FId write FId;
    property Name: string read FName write FName;
    property Date: TDate read FDate write FDate;
    property Bell: TBell read FBell write FBell;
  end;

implementation

{ TSchedule }

constructor TSchedule.Create(const ADay: string);
begin
  FDay := ADay;
end;

constructor TSchedule.Create(const ADay: string; ABell: TBell);
begin
  FDay := ADay;
  FBell := ABell;
end;

{ TBell }

constructor TBell.Create;
begin
  FDetails.SetInitialValue(TList<TBellDetail>.Create);
end;

constructor TBell.Create(const AName: string);
begin
  Create;
  FName := AName;
end;

destructor TBell.Destroy;
begin
  FDetails.DestroyValue;
  inherited;
end;

function TBell.GetDetails: TList<TBellDetail>;
begin
  Result := FDetails.Value;
end;

{ TBellDetail }

constructor TBellDetail.Create(const AName: string; 
  ATime: string;  ASound: string);
begin
  FName := AName;
  FTime := ATime;
  FSound := ASound;
end;

initialization
  RegisterEntity(TBell);
  RegisterEntity(TBellDetail);
  RegisterEntity(TSchedule);
  RegisterEntity(TAbnormal);

end.
