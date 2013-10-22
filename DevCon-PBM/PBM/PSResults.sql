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