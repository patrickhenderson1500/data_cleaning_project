-- viewing data

  select *
  from master..NashvilleHousing

  -- converting long date to YYYY-MM-DD format

  select SaleDate
  from master..NashvilleHousing

  ALTER TABLE NashvilleHousing
  ALTER COLUMN SaleDate DATE

-- populating null PropertyAddress values

  select ParcelID, PropertyAddress
  from master..NashvilleHousing
  order by ParcelID

  select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) -- duplicate ParcelID = same PropertyAddress
  from master..NashvilleHousing a
  JOIN master..NashvilleHousing b
  on a.ParcelID = b.ParcelID
  AND a.[UniqueID] != b.[UniqueID] -- UniqueID never repeated itself
  where a.PropertyAddress is null

  Update a
  SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
  from master..NashvilleHousing a
  JOIN master..NashvilleHousing b
  on a.ParcelID = b.ParcelID
  AND a.[UniqueID] != b.[UniqueID]
  where a.PropertyAddress is null

 -- splitting addresses into individual columns

  select
  SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
  SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as SplitAddress
  from master..NashvilleHousing

  ALTER TABLE NashvilleHousing
  Add PropertySplitAddress Nvarchar(255);

  Update NashvilleHousing
  SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

  ALTER TABLE NashvilleHousing
  Add PropertySplitCity Nvarchar(255);

  Update NashvilleHousing
  SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

 select OwnerAddress
 from master..NashvilleHousing

 -- easier way to split addresses into individual columns

 select
 PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
 PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
 PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
 from master..NashvilleHousing

 
  ALTER TABLE NashvilleHousing
  Add OwnerSplitAddress Nvarchar(255);

  Update NashvilleHousing
  SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)          

  ALTER TABLE NashvilleHousing
  Add OwnerSplitCity Nvarchar(255);

  Update NashvilleHousing
  SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

  ALTER TABLE NashvilleHousing
  Add OwnerSplitState Nvarchar(255);

  Update NashvilleHousing
  SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

-- changing 'Y' and 'N' strings into 'Yes' and 'No' strings in SoldAsVacant column

  select DISTINCT(SoldAsVacant)
  from master..NashvilleHousing

  select SoldAsVacant,
  CASE when SoldAsVacant = 'Y' THEN 'Yes'
  when SoldAsVacant = 'N' THEN 'No'
  ELSE SoldAsVacant
  END
  from master..NashvilleHousing

  Update NashvilleHousing
  SET SoldAsVacant =  CASE when SoldAsVacant = 'Y' THEN 'Yes'
  when SoldAsVacant = 'N' THEN 'No'
  ELSE SoldAsVacant
  END

  -- deleting unused columns

  ALTER TABLE NashvilleHousing
  DROP COLUMN OwnerAddress, PropertyAddress










 







