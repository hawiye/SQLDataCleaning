---Cleaning Data In SQL Queries


select *
from [dbo].[Nashville Housing Data for Data Cleaning]
order by ParcelId

select a.[ParcelID],a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from[dbo].[Nashville Housing Data for Data Cleaning] a
join[dbo].[Nashville Housing Data for Data Cleaning] b
on a.[ParcelID] = b.[ParcelID]
and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null


Update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from[dbo].[Nashville Housing Data for Data Cleaning] a
join[dbo].[Nashville Housing Data for Data Cleaning] b
on a.[ParcelID] = b.[ParcelID]
and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null

--Breaking out Property Address into Individual Columns( Address, City, State)


select [PropertyAddress]
from [dbo].[Nashville Housing Data for Data Cleaning]
order by ParcelId

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as address

from [dbo].[Nashville Housing Data for Data Cleaning]

alter table [dbo].[Nashville Housing Data for Data Cleaning]
add PropertySplitAddress Nvarchar(255)

update [dbo].[Nashville Housing Data for Data Cleaning]
Set PropertySplitAddress  = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

alter table [dbo].[Nashville Housing Data for Data Cleaning]
add PropertySplitCity Nvarchar(255);

update [dbo].[Nashville Housing Data for Data Cleaning]
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))


----Breaking out Ownery Address into Individual Columns( Address, City, State)


select [OwnerAddress]
from [dbo].[Nashville Housing Data for Data Cleaning]

Select
	PARSENAME(REPLACE([OwnerAddress], ',', '.'),3)
	,PARSENAME(REPLACE([OwnerAddress], ',', '.'),2)
	,PARSENAME(REPLACE([OwnerAddress], ',', '.'),1)
from [dbo].[Nashville Housing Data for Data Cleaning]


alter table [dbo].[Nashville Housing Data for Data Cleaning]
add OwnerSplitAddress Nvarchar(255)

update [dbo].[Nashville Housing Data for Data Cleaning]
Set  OwnerSplitAddress  = 	PARSENAME(REPLACE([OwnerAddress], ',', '.'),3)


alter table [dbo].[Nashville Housing Data for Data Cleaning]
add  OwnerSplitCity Nvarchar(255);

update [dbo].[Nashville Housing Data for Data Cleaning]
Set  OwnerSplitCity = 	,PARSENAME(REPLACE([OwnerAddress], ',', '.'),2)



alter table [dbo].[Nashville Housing Data for Data Cleaning]
add  OwnerSplitState Nvarchar(255);

update [dbo].[Nashville Housing Data for Data Cleaning]
Set  OwnerSplitState = PARSENAME(REPLACE([OwnerAddress], ',', '.'),1)


--REMOVING DUPLICATES

with RowNumCTE as (
select *,
	Row_number() over (
	partition by [ParcelID],
				[PropertyAddress],
				[SalePrice],
				[SaleDate],
				[LegalReference]
				Order by [UniqueID]
				) row_num
from [dbo].[Nashville Housing Data for Data Cleaning])
Select *
from RowNumCTE
where row_num >1
order by [PropertyAddress]


with RowNumCTE as (
select *,
	Row_number() over (
	partition by [ParcelID],
				[PropertyAddress],
				[SalePrice],
				[SaleDate],
				[LegalReference]
				Order by [UniqueID]
				) row_num
from [dbo].[Nashville Housing Data for Data Cleaning])
Delete 
from RowNumCTE
where row_num >1
--order by [PropertyAddress]




--Delete Unused Columns ( Unually from views not from raw data)
select *
from [dbo].[Nashville Housing Data for Data Cleaning]

alter table[dbo].[Nashville Housing Data for Data Cleaning]
drop column [OwnerAddress],[TaxDistrict],[PropertyAddress]