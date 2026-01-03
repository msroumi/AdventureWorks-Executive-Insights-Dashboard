let
    Source = Folder.Files(FolderPath),
    #"Filtered Rows" = Table.SelectRows(Source, each ([Name] = "AdventureWorks_Products.csv")),
    FileContent = #"Filtered Rows"{0}[Content],
    #"Imported CSV" = Csv.Document(FileContent,[Delimiter=",",
    Columns=11, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    #"Promoted Headers" = Table.PromoteHeaders(#"Imported CSV", [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{{"ProductKey", Int64.Type}, {"ProductSubcategoryKey", Int64.Type}, 
    {"ProductSKU", type text}, {"ProductName", type text}, {"ModelName", type text}, {"ProductDescription", type text}, 
    {"ProductColor", type text}, {"ProductSize", type text}, {"ProductStyle", type text}, {"ProductCost", type number}, 
    {"ProductPrice", type number}}),
    #"Merged Queries" = Table.NestedJoin(#"Changed Type", {"ProductSubcategoryKey"}, Dim_ProductSubCategories, {"ProductSubcategoryKey"}, 
    "Dim_ProductSubCategories", JoinKind.LeftOuter),
    #"Expanded Dim_ProductSubCategories" = Table.ExpandTableColumn(#"Merged Queries", "Dim_ProductSubCategories", 
    {"SubcategoryName", "ProductCategoryKey"}, {"SubcategoryName", "ProductCategoryKey"}),
    #"Merged Queries1" = Table.NestedJoin(#"Expanded Dim_ProductSubCategories", {"ProductCategoryKey"}, Dim_ProductCategories, 
    {"ProductCategoryKey"}, "Dim_ProductCategories", JoinKind.LeftOuter),
    #"Expanded Dim_ProductCategories" = Table.ExpandTableColumn(#"Merged Queries1", "Dim_ProductCategories", {"CategoryName"}, 
    {"CategoryName"})
in
    #"Expanded Dim_ProductCategories"