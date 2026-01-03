let
    Source = Folder.Files(FolderPath),
    #"Filtered Rows" = Table.SelectRows(Source, each ([Name] = "AdventureWorks_Returns.csv")),
    FileContent = #"Filtered Rows"{0}[Content],
    #"Imported CSV" = Csv.Document(FileContent,[Delimiter=",", 
    Columns=4, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    #"Promoted Headers" = Table.PromoteHeaders(#"Imported CSV", [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{{"ReturnDate", type date}, {"TerritoryKey", Int64.Type}, 
    {"ProductKey", Int64.Type}, {"ReturnQuantity", Int64.Type}})
in
    #"Changed Type"