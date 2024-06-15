-- Standardizing Date Format

SELECT SaleDateConverted, CONVERT(Date,SaleDate)
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = Convert(Date,SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = Convert(Date,SaleDate)


-- Populate Property Address Area

SELECT *
FROM NashvilleHousing
-- WHERE PropertyAddress IS NULL 
Order by ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress) 
FROM NashvilleHousing a -- Joined these tables to itself to say parcel ID is the same but it is NOT
JOIN NashvilleHousing b     -- the same ROW
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ] -- This says a's Unique ID is NOT the same as b's UID
WHERE a.PropertyAddress is NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress) 
FROM NashvilleHousing a  
JOIN NashvilleHousing b     
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ] 

-- Breaking out Address into Individual Columns (Address, City, State) Splitting columns

SELECT PropertyAddress
FROM NashvilleHousing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address --  - 1 Removes delimiter searched for from results.
,	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1  , LEN(PropertyAddress)) -- + 1 starting from after comma

FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) 


ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1  , LEN(PropertyAddress)) 


SELECT OwnerAddress
FROM NashvilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) -- PARSENAME only works with '.' so changed every comma to a dot so parse works.
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM NashvilleHousing -- 3 IS ADDRESS 2 IS CITY 1 IS STATE. 


ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) 


ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
-- PARSENAME BEST ONE TO USE.



-------------------------------------------------------------------------------------------------------------------------
-- CHANGE Y AND N to Yes and NO in 'Sold as Vacant' Field (Find and Replace)
-- CASE STATEMENT

SELECT Distinct(SoldASVacant), COUNT(SoldASVacant)
FROM NashvilleHousing
GROUP BY SoldASVacant
ORDER BY 2 DESC


SELECT SoldAsVacant
,	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
FROM NashvilleHousing


UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END


----------------------------------------------------------------------------------------------------
-- REMOVING DUPLICATES 
WITH RowNumCTE AS(
SELECT *, 
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
		PropertyAddress,
		SalePrice,
		SaleDate,
		LegalReference
		ORDER BY
			UniqueID
			) row_num

FROM NashvilleHousing
-- ORDER BY ParcelID
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
-- Order BY PropertyAddress



SELECT * 
FROM NashvilleHousing


-----------------------------------------------------------------------

-- DELETING UNUSED COLUMNS

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress 

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate

