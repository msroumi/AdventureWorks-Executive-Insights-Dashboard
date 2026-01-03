let
    Source = Folder.Files(FolderPath),
    #"Filtered Rows" = Table.SelectRows(Source, each Text.StartsWith([Name], "AdventureWorks_Sales") and Text.EndsWith([Name], ".csv")),
    #"Filtered Hidden Files1" = Table.SelectRows(#"Filtered Rows", each [Attributes]?[Hidden]? <> true),
    #"Invoke Custom Function1" = Table.AddColumn(#"Filtered Hidden Files1", "Transform File", each #"Transform File"([Content])),
    #"Renamed Columns1" = Table.RenameColumns(#"Invoke Custom Function1", {"Name", "Source.Name"}),
    #"Removed Other Columns1" = Table.SelectColumns(#"Renamed Columns1", {"Source.Name", "Transform File"}),
    #"Expanded Table Column1" = Table.ExpandTableColumn(#"Removed Other Columns1", "Transform File", 
    Table.ColumnNames(#"Transform File"(#"Sample File"))),
    #"Changed Type" = Table.TransformColumnTypes(#"Expanded Table Column1",{{"Source.Name", type text}, {"OrderDate", type date}, 
    {"StockDate", type date}, {"OrderNumber", type text}, {"ProductKey", Int64.Type}, {"CustomerKey", Int64.Type}, 
    {"TerritoryKey", Int64.Type}, {"OrderLineItem", Int64.Type}, {"OrderQuantity", Int64.Type}})
in
    #"Changed Type"