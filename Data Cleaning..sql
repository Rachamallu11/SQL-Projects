
/*

Data cleaning in SQL

*/

use portfolioproject;

select * from portfolioproject.`nashville housing data for data cleaning`;

-- Standardize Date formate  -------------

Select saleDateConverted, CONVERT(Date,SaleDate)
From `nashville housing data for data cleaning`


Update `nashville housing data for data cleaning`
SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE `nashville housing data for data cleaning`
Add SaleDateConverted Date;

Update`nashville housing data for data cleaning`
SET SaleDateConverted = CONVERT(Date,SaleDate)

--------------------------------------------------------------------------------------------------------------------
-- populate property Address data ----

select *
from portfolioproject.`nashville housing data for data cleaning`
where PropertyAddress is null

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from portfolioproject.`nashville housing data for data cleaning` a
 join portfolioproject.`nashville housing data for data cleaning` b
 on a.ParcelID = b.ParcelID
 and a.UniqueID <> b.UniqueID
 where a.PropertyAddress is null
 
 Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From `nashville housing data for data cleaning` a
JOIN `nashville housing data for data cleaning` b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null;


 --------------------------------------------------------------------------------------------------------------
 -- Breaking out the 'Address' into Individual columns (Address, City, State)
 
 select PropertyAddress
from portfolioproject.`nashville housing data for data cleaning`;

select 
substring('PropertyAddress', 1, charindex(',',PropertyAddress) -1) as Address
, substring('PropertyAddress',charindex(',',PropertyAddress) +1 ,length(PropertyAddress)) as Address
from portfolioproject.`nashville housing data for data cleaning`;

alter Table `nashville housing data for data cleaning`
add Propertysplittaddress varchar(55);

update `nashville housing data for data cleaning`
set PropertyAddress = substring('PropertyAddress', 1, charindex(',',PropertyAddress) -1);

alter Table `nashville housing data for data cleaning`
add Propertysplittcity varchar(55);

update `nashville housing data for data cleaning`
set PropertyAddress = substring('PropertyAddress',charindex(',',PropertyAddress) +1 ,length(PropertyAddress));

select * from `nashville housing data for data cleaning`;

select OwnerAddress from `nashville housing data for data cleaning`;

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From`nashville housing data for data cleaning`;



ALTER TABLE `nashville housing data for data cleaning`
Add OwnerSplitAddress Nvarchar(255);

Update`nashville housing data for data cleaning`
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3);


ALTER TABLE `nashville housing data for data cleaning`
Add OwnerSplitCity Nvarchar(255);

Update`nashville housing data for data cleaning`
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2);



ALTER TABLE `nashville housing data for data cleaning`
Add OwnerSplitState Nvarchar(255);

Update `nashville housing data for data cleaning`
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1);



Select *
From `nashville housing data for data cleaning`;
-----------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From `nashville housing data for data cleaning`
Group by SoldAsVacant
order by 2;

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
 from `nashville housing data for data cleaning`;
 
 Update `nashville housing data for data cleaning`
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END;
 -----------------------------------------------------------------------------------------------------------
 
 
-- Remove Duplicates -----------------------
with ROwnumCTE as(
select *, 
row_number() over (
	partition by ParcelID,
                 PropertyAddress,
                 SaleDate,
                 SalePrice,
                 LegalReference
              ORDER BY
              UniqueID) as row_num
  from `nashville housing data for data cleaning`          
)
select * from ROwnumCTE where row_num>1 
-- order by PropertyAddress

----------------------------------------------------
-- remove unused columns ---------


    



