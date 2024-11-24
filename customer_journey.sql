-- Common Table Expression (CTE) to identify and tag duplicate records
use PortfolioProject_MarketingAnalytics;

select *
from dbo.customer_journey;


WITH CTE AS (
    SELECT
        JourneyID,
        CustomerID,
        ProductID,
        VisitDate,
        Stage,
        Action,
        -- Calculate the average duration for each VisitDate and replace NULL values, rounded to 2 decimal places
        ROUND(ISNULL(Duration, AVG(Duration) OVER (PARTITION BY VisitDate)), 2) AS Duration,
        ROW_NUMBER() OVER (PARTITION BY JourneyID, CustomerID, ProductID, VisitDate ORDER BY (SELECT NULL)) AS RowNum
    FROM customer_journey
)
-- Select data with duplicates removed, and replace NULLs with the average Duration
SELECT
    JourneyID,
    CustomerID,
    ProductID,
    VisitDate,
    Stage,
    Action,
    Duration,
	RowNum
FROM CTE
WHERE RowNum = 1;
