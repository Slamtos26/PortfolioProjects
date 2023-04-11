/*

Cleaning data in SQLQueries 

*/

Select*
From NashvileHousing

-------------------------------------------------------------------------------------------
--Standardize Date Format

Select SaleDateConverted, CONVERT(Date, SaleDate) as date
From NashvileHousing


Update NashvileHousing

SET SaleDate = CONVERT(Date, SaleDate) 


ALTER TABLE NashvileHousing
Add SaleDateConverted Date

Update NashvileHousing

SET SaleDateConverted = CONVERT(Date, SaleDate) 

------------------------------------------------------------------------------------------------------------

--- Populate property address data 
Select *
From NashvileHousing
---where PropertyAddress is null
Order by ParcelID

Select par.ParcelID, par.PropertyAddress, pro.ParcelID, pro.PropertyAddress, ISNULL(par.PropertyAddress, pro.PropertyAddress)
From NashvileHousing par
join NashvileHousing pro
   ON par.ParcelID = pro.ParcelID

   AND par.[UniqueID ] <> pro.[UniqueID ] 
   where par.PropertyAddress is null

Update par
set PropertyAddress = ISNULL( par.PropertyAddress, pro.PropertyAddress)
From NashvileHousing par
join NashvileHousing pro
   ON par.ParcelID = pro.ParcelID

   AND par.[UniqueID ] <> pro.[UniqueID ] 
   where par.PropertyAddress is null

 --- Breaking Out Address into Individual Columns (Address,City, State)

Select PropertyAddress
From NashvileHousing
---where PropertyAddress is null
---Order by ParcelID
Select 
Substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
, Substring(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress)) as City
from NashvileHousing

Alter Table NashvileHousing
Add PropertySplittingaddress1 Nvarchar(255)

Update NashvileHousing
Set PropertySplittingaddress1 = Substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) 

Alter Table NashvileHousing
Add PropertySlittingCity1 Nvarchar(255);

Update NashvileHousing
set PropertySlittingCity1 = Substring(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress)) 


Select PropertySplittingaddress1, PropertySlittingCity1
From NashvileHousing



-----Spliting owner address

Select OwnerAddress
From NashvileHousing

Select 
PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)
From NashvileHousing


Alter Table NashvileHousing
Add OwnersplitAddress Nvarchar(255)

Update NashvileHousing
Set OwnersplitAddress =  PARSENAME(Replace(OwnerAddress,',','.'),3)

Alter Table NashvileHousing
Add OwnersplitCity Nvarchar(255);

Update NashvileHousing
set OwnersplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2)


Alter Table NashvileHousing
Add Ownersplitstate Nvarchar(255);

Update NashvileHousing
set OwnersplitState = PARSENAME(Replace(OwnerAddress,',','.'),1)

Select *
From NashvileHousing


------- Change Y and N to Yes and No in "Sold as vacant" Field

Select Distinct(SoldAsVacant), count(Soldasvacant)
from NashvileHousing
Group by SoldAsVacant
order by SoldAsVacant


Select SoldAsvacant,
case    
    when SoldAsVacant = 'N' then 'NO'
	when soldAsvacant = 'Y' then 'YES'
	Else SoldAsVacant
END
    

from NashvileHousing

UPDATE NashvileHousing
Set SoldAsvacant = 
case    
    when SoldAsVacant = 'N' then 'NO'
	when soldAsvacant = 'Y' then 'YES'
	Else SoldAsVacant
END
    

from NashvileHousing



----- Remove Duplicates
WITH  RowNumCTE AS (


Select *,
    ROW_NUMBER() OVER (
	PARTITION BY pARCELid,
	             SalePrice,
				 Saledate,
				 LegalReference
				 ORDER BY
				 UniqueID
				 ) row_num

From NashvileHousing
--order by ParcelID
)
sELECT *
from RowNumCTE
where row_num >1
Order by PropertyAddress


---- Delete Unused columns

sELECT *
from NashvileHousing

Alter Table NashvileHousing
DROP COLUMN OwnerAddress, TaxDistrict, propertyAddress

Alter Table NashvileHousing
DROP COLUMN SaleDate