SELECT *
FROM NashvilleProject..NashvilleHousing

-- Standarize Date Format

ALTER TABLE NashvilleProject..NashvilleHousing
ALTER COLUMN SaleDate DATE

SELECT SaleDate
FROM NashvilleProject..NashvilleHousing


-- Populate Property Adress Data

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From NashvilleProject..NashvilleHousing a
Join NashvilleProject..NashvilleHousing b
	On a.ParcelID = b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is NULL

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From NashvilleProject..NashvilleHousing a
Join NashvilleProject..NashvilleHousing b
	On a.ParcelID = b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is NULL


-- Breaking out Adress into Individual columns (Adress, City, State)

-- PropertyAdress

SELECT PropertyAddress,
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1),
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1 , LEN(PropertyAddress))
FROM NashvilleProject..NashvilleHousing

ALTER TABLE NashvilleProject..NashvilleHousing
ADD PropertySplitAdress nvarchar(255)

UPDATE NashvilleProject..NashvilleHousing
SET PropertySplitAdress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleProject..NashvilleHousing
ADD PropertySplitCity nvarchar(255)

UPDATE NashvilleProject..NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1 , LEN(PropertyAddress))

SELECT PropertyAddress, PropertySplitAdress, PropertySplitCity
FROM NashvilleProject..NashvilleHousing

-- OwnerAdress

SELECT OwnerAddress,
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
FROM NashvilleProject..NashvilleHousing


ALTER TABLE NashvilleProject..NashvilleHousing
ADD OwnerSplitAdress nvarchar(255)

UPDATE NashvilleProject..NashvilleHousing
SET OwnerSplitAdress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)


ALTER TABLE NashvilleProject..NashvilleHousing
ADD OwnerSplitCity nvarchar(255)

UPDATE NashvilleProject..NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)


ALTER TABLE NashvilleProject..NashvilleHousing
ADD OwnerSplitState nvarchar(255)

UPDATE NashvilleProject..NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)


SELECT OwnerAddress, OwnerSplitAdress, OwnerSplitCity, OwnerSplitState
FROM NashvilleProject..NashvilleHousing


-- Change Y and N to Yes and No in "SoldAsVacant" Column

SELECT SoldAsVacant,
CASE When SoldAsVacant='N' Then 'No'
	 When SoldAsVacant='Y' Then 'Yes'
	 Else SoldAsVacant
	END
FROM NashvilleProject..NashvilleHousing

UPDATE NashvilleProject..NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant='N' Then 'No'
						When SoldAsVacant='Y' Then 'Yes'
						Else SoldAsVacant
					END

SELECT Distinct(SoldASVacant), COUNT(SoldAsVacant)
FROM NashvilleProject..NashvilleHousing
Group by SoldAsVacant
