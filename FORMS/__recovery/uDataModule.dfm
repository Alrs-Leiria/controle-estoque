object dmData: TdmData
  OnCreate = DataModuleCreate
  Height = 255
  Width = 465
  PixelsPerInch = 120
  object FDConnection: TFDConnection
    Params.Strings = (
      'User_Name=root'
      
        'Database=C:\Users\Anlury\Documents\Projetos\Extensao II TADS\BAN' +
        'CO\gerenciador'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 104
    Top = 56
  end
end
