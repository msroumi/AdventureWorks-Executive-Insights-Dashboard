let
    Source = Folder.Files(FolderPath),
    #"Filtered Rows" = Table.SelectRows(Source, each ([Name] = "AdventureWorks_Product_Subcategories.csv")),
    FileContent = #"Filtered Rows"{0}[Content],
    #"Imported CSV" = Csv.Document(FileContent,[Delimiter=",", 
    Columns=3, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    #"Promoted Headers" = Table.PromoteHeaders(#"Imported CSV", [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{{"ProductSubcategoryKey", Int64.Type}, {"SubcategoryName", type text}, 
    {"ProductCategoryKey", Int64.Type}})
in
    #"Changed Type"