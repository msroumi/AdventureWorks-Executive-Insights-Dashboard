let
    Source = Folder.Files(FolderPath),
    #"Filtered Rows" = Table.SelectRows(Source, each ([Name] = "AdventureWorks_Customers.csv")),
    FileContent = #"Filtered Rows"{0}[Content],
    #"Imported CSV" = Csv.Document(FileContent,[Delimiter=",", Columns=13, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    #"Promoted Headers" = Table.PromoteHeaders(#"Imported CSV", [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{{"CustomerKey", Int64.Type}, {"Prefix", type text}, 
    {"FirstName", type text}, {"LastName", type text}, {"BirthDate", type date}, {"MaritalStatus", type text}, {"Gender", type text}, 
    {"EmailAddress", type text}, {"AnnualIncome", Currency.Type}, {"TotalChildren", Int64.Type}, {"EducationLevel", type text}, 
    {"Occupation", type text}, {"HomeOwner", type text}})
in
    #"Changed Type"