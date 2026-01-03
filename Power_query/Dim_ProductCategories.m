let
    Source = Folder.Files(FolderPath),
    #"Filtered Rows" = Table.SelectRows(Source, each ([Name] = "AdventureWorks_Product_Categories.csv")),
    FileContent = #"Filtered Rows"{0}[Content],
    #"Imported CSV" = Csv.Document(FileContent,[Delimiter=",", 
    Columns=2, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    #"Promoted Headers" = Table.PromoteHeaders(#"Imported CSV", [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{{"ProductCategoryKey", Int64.Type}, {"CategoryName", type text}})
in
    #"Changed Type"