program day6;
uses sysutils;

type
    TwoDimIntArray = array of array of integer;

function maxBank(banks: array of integer): integer;
var
    max: integer = 0;
    i: integer;
begin
    maxBank := 0;
    for i := 0 to Length(banks) - 1 do begin
        if banks[i] > max then begin
            max := banks[i];
            maxBank := i;
        end;
    end;
end;

function stateSeenBefore(banks: array of integer; previousStates: TwoDimIntArray): integer;
var
    i: integer;
    j: integer;
begin
    stateSeenBefore := 0;
    (* because for some reason the length of previousStates is seenStates + 1... *)
    for i := 0 to Length(previousStates) - 2 do begin
        for j := 0 to Length(banks) - 1 do begin
            if not (previousStates[i, j] = banks[j]) then
                break;
            if j = Length(banks) - 1 then
                Exit(i);
        end;
    end;
end;

var
    i: integer;
    memoryBanks: array[0..15] of integer;
    input_file: TextFile;
    currentMaxBank: integer;
    currentRedistribution: integer;
    seenStates: TwoDimIntArray;
    cycleCounter: integer = 0;
    prevIndex: integer;
begin
    if ParamCount = 0 then begin
        WriteLn('Invalid Arguments!');
        Halt;
    end;
    if not FileExists(ParamStr(1)) then begin
        WriteLn('File is non-existant!');
        Halt;
    end;
    Assign(input_file, ParamStr(1));
    Reset(input_file);
    for i := 0 to Length(memoryBanks) - 1 do
        Read(input_file, memoryBanks[i]);
    Close(input_file);
    repeat
        setLength(seenStates, Length(seenStates) + 1, Length(memoryBanks));
        seenStates[Length(seenStates) - 1] := memoryBanks;
        cycleCounter := cycleCounter + 1;
        currentMaxBank := maxBank(memoryBanks);
        currentRedistribution := memoryBanks[currentMaxBank];
        memoryBanks[currentMaxBank] := 0;
        i := 1;
        (* thanks pascal... *)
        for currentRedistribution := currentRedistribution downto 1 do begin
            memoryBanks[(currentMaxBank + i) mod Length(memoryBanks)] := memoryBanks[(currentMaxBank + i) mod Length(memoryBanks)] + 1;
            i := i + 1;
        end;
        prevIndex := stateSeenBefore(memoryBanks, seenStates);
    until prevIndex > 0;
    WriteLn('State ', cycleCounter, ' was already seen before!');
    WriteLn('Loop Size: ', cycleCounter - prevIndex);
end.
