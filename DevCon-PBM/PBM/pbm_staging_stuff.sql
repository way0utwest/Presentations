CREATE DATABASE pbmresults
;
go
USE PBMResults
GO
CREATE TABLE [dbo].[PolicyHistory_staging](
[PolicyHistoryID] [int] IDENTITY(1,1) NOT NULL,
[EvalServer] [nvarchar](100) NULL,
[EvalDateTime] [datetime] NULL,
[EvalPolicy] [nvarchar](max) NULL,
[EvalResults] [xml] NULL,
CONSTRAINT [PK_PolicyHistory_staging] PRIMARY KEY CLUSTERED
(
[PolicyHistoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
;
GO
ALTER TABLE [dbo].[PolicyHistory_staging] ADD CONSTRAINT [DF_PolicyHistory_EvalDateTime] DEFAULT (getdate()) FOR [EvalDateTime]
;
GO


SELECT 
  PolicyHistoryID ,
         EvalServer ,
         EvalDateTime ,
         EvalPolicy ,
         EvalResults
 FROM dbo.PolicyHistory_staging
;
GO

CREATE VIEW [dbo].[vw_PolicyResults] AS
WITH XMLNAMESPACES ('http://schemas.microsoft.com/sqlserver/DMF/2007/08' AS XMLNS)
SELECT EvalServer, EvalDateTime, EvalPolicy,
ResultNodes.NodeDetails.value('(../XMLNS:TargetQueryExpression)[1]', 'nvarchar(150)') AS EvaluatedObject,
(CASE
WHEN
ResultNodes.NodeDetails.value('(../XMLNS:Result)[1]', 'nvarchar(150)')= 'FALSE' AND
NodeDetails.value('(../XMLNS:Exception)[1]', 'nvarchar(max)') = ''
THEN 0
WHEN ResultNodes.NodeDetails.value('(../XMLNS:Result)[1]', 'nvarchar(150)')= 'FALSE' AND
NodeDetails.value('(../XMLNS:Exception)[1]', 'nvarchar(max)')<> ''
THEN 99
ELSE 1
END) AS PolicyResult
FROM dbo.PolicyHistory_staging CROSS APPLY
EvalResults.nodes('
declare default element namespace "http://schemas.microsoft.com/sqlserver/DMF/2007/08";
//TargetQueryExpression') AS ResultNodes(NodeDetails)
GO



SELECT 
  EvalServer ,
  EvalDateTime ,
  EvalPolicy ,
  EvaluatedObject ,
  PolicyResult
 FROM vw_PolicyResults
 ;
 GO
 