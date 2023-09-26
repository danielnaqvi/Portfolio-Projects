/*

Cleaning Data in SQL Queries

*/

-- Change Sale Date (Standardize)

Select SaleDateConverted, CONVERT(Date,SaleDate)
From Housing.dbo.housing

UPDATE Housing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE Housing
ADD SaleDateConverted Date;

UPDATE Housing
SET SaleDateConverted = CONVERT(Date,SaleDate)



-- Populate Property Addresses

Select *
From Housing.dbo.housing
WHERE PropertyAddress IS NULL
ORDER BY ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From Housing.dbo.housing A
JOIN Housing.dbo.housing B
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From Housing.dbo.housing A
JOIN Housing.dbo.housing B
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]



-- Breaking out Addresses into Individual Columns With SUBSTRING

Select PropertyAddress
From Housing.dbo.housing
--WHERE PropertyAddress IS NULL
--ORDER BY ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS Address
From Housing.dbo.housing

ALTER TABLE Housing
ADD PropertySplitAddress NVARCHAR(255)

UPDATE Housing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE Housing
ADD PropertySplitCity NVARCHAR(255)

UPDATE Housing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))



-- Breaking out Addresses into Individual Columns With PARSENAME

SELECT OwnerAddress 
FROM Housing.dbo.Housing

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
FROM Housing.dbo.Housing



ALTER TABLE Housing
ADD OwnerSplitAddress NVARCHAR(255)

UPDATE Housing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE Housing
ADD OwnerSplitCity NVARCHAR(255)

UPDATE Housing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE Housing
ADD OwnerSplitState NVARCHAR(255)

UPDATE Housing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


SELECT * 
FROM Housing.dbo.Housing



-- Change Y and N to Yes and No in 'Sold as Vacant'

SELECT DISTINCT(SoldAsVacant), Count(SoldAsVacant)
FROM Housing.dbo.Housing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
FROM Housing.dbo.Housing

UPDATE Housing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END



-- Remove Duplicates

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID, 
	PropertyAddress, 
	SalePrice, 
	SaleDate, 
	LegalReference
	ORDER BY
		UniqueID
		) Row_num

FROM Housing.dbo.Housing
)
SELECT *
FROM RowNumCTE
WHERE Row_num > 1
ORDER BY PropertyAddress



-- Delete Unused Columns

SELECT * 
FROM Housing.dbo.Housing

ALTER TABLE Housing.dbo.Housing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, PropertySplitState

ALTER TABLE Housing.dbo.Housing
DROP COLUMN SaleDate

