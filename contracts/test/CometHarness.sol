// SPDX-License-Identifier: XXX ADD VALID LICENSE
pragma solidity ^0.8.11;

import "../Comet.sol";

contract CometHarness is Comet {
    uint public nowOverride;

    constructor(Configuration memory config) Comet(config) {}

    // XXX move the rest of these out?
    function baseIndexScale() external pure returns (uint64) {
        return BASE_INDEX_SCALE;
    }

    function maxAssets() external pure returns (uint8) {
        return MAX_ASSETS;
    }

    // XXX the getNow in base isn't being overridden by this...
    //  need a separate harness with same override probably
    //   in which case it should prob move out of core into base
    //    and initialize_storage should be a baseDo?
    function getNow() override internal view returns (uint40) {
        return nowOverride > 0 ? uint40(nowOverride) : super.getNow();
    }

    function getNowHarness() public view returns (uint40) {
        return getNow();
    }

    function setNow(uint now_) external {
        nowOverride = now_;
    }

    // XXX back to Comet.sol?
    function totalsBasic() public view returns (TotalsBasic memory) {
        return TotalsBasic({
            baseSupplyIndex: baseSupplyIndex,
            baseBorrowIndex: baseBorrowIndex,
            trackingSupplyIndex: trackingSupplyIndex,
            trackingBorrowIndex: trackingBorrowIndex,
            totalSupplyBase: totalSupplyBase,
            totalBorrowBase: totalBorrowBase,
            lastAccrualTime: lastAccrualTime,
            pauseFlags: pauseFlags
        });
    }

    function setTotalsBasic(TotalsBasic memory totals) external {
        baseSupplyIndex = totals.baseSupplyIndex;
        baseBorrowIndex = totals.baseBorrowIndex;
        trackingSupplyIndex = totals.trackingSupplyIndex;
        trackingBorrowIndex = totals.trackingBorrowIndex;
        totalSupplyBase = totals.totalSupplyBase;
        totalBorrowBase = totals.totalBorrowBase;
        lastAccrualTime = totals.lastAccrualTime;
    }

    function setTotalsCollateral(address asset, TotalsCollateral memory totals) external {
        totalsCollateral[asset] = totals;
    }

    function setBasePrincipal(address account, int104 principal) external {
        userBasic[account].principal = principal;
    }

    // XXX
    /* function setCollateralBalance(address account, address asset, uint128 balance) external { */
    /*     uint128 oldBalance = userCollateral[account][asset].balance; */
    /*     userCollateral[account][asset].balance = balance; */
    /*     updateAssetsIn(account, asset, oldBalance, balance); */
    /* } */

    /* function updateAssetsInExternal( */
    /*     address account, */
    /*     address asset, */
    /*     uint128 initialUserBalance, */
    /*     uint128 finalUserBalance */
    /* ) external { */
    /*     updateAssetsIn(account, asset, initialUserBalance, finalUserBalance); */
    /* } */

    /* function getAssetList(address account) external view returns (address[] memory result) { */
    /*     uint16 assetsIn = userBasic[account].assetsIn; */

    /*     uint8 count = 0; */
    /*     for (uint8 i = 0; i < numAssets; i++) { */
    /*         if (isInAsset(assetsIn, i)) { */
    /*             count++; */
    /*         } */
    /*     } */

    /*     result = new address[](count); */

    /*     uint j = 0; */
    /*     for (uint8 i = 0; i < numAssets; i++) { */
    /*         if (isInAsset(assetsIn, i)) { */
    /*             result[j] = getAssetInfo(i).asset; */
    /*             j++; */
    /*         } */
    /*     } */

    /*     return result; */
    /* } */

    function isSupplyPaused() external view returns (bool) {
        return isSupplyPausedInternal();
    }

    function isTransferPaused() external view returns (bool) {
        return isTransferPausedInternal();
    }

    function isWithdrawPaused() external view returns (bool) {
        return isWithdrawPausedInternal();
    }

    function isAbsorbPaused() external view returns (bool) {
        return isAbsorbPausedInternal();
    }

    function isBuyPaused() external view returns (bool) {
        return isBuyPausedInternal();
    }

    /* /\** */
    /*  * @notice Calculate the amount of borrow liquidity for account */
    /*  * @param account The address to check liquidity for */
    /*  * @return The common price quantity of borrow liquidity */
    /*  *\/ */
    /* function getBorrowLiquidity(address account) external view returns (int) { */
    /*     uint16 assetsIn = userBasic[account].assetsIn; */

    /*     int liquidity = signedMulPrice( */
    /*         presentValue(userBasic[account].principal), */
    /*         getPrice(baseTokenPriceFeed), */
    /*         baseScale */
    /*     ); */

    /*     for (uint8 i = 0; i < numAssets; i++) { */
    /*         if (isInAsset(assetsIn, i)) { */
    /*             AssetInfo memory asset = getAssetInfo(i); */
    /*             uint newAmount = mulPrice( */
    /*                 userCollateral[account][asset.asset].balance, */
    /*                 getPrice(asset.priceFeed), */
    /*                 safe64(asset.scale) */
    /*             ); */
    /*             liquidity += signed256(mulFactor( */
    /*                 newAmount, */
    /*                 asset.borrowCollateralFactor */
    /*             )); */
    /*         } */
    /*     } */

    /*     return liquidity; */
    /* } */

    /* /\** */
    /*  * @notice Calculate the amount of liquidation margin for account */
    /*  * @param account The address to check margin for */
    /*  * @return The common price quantity of liquidation margin */
    /*  *\/ */
    /* function getLiquidationMargin(address account) external view returns (int) { */
    /*     uint16 assetsIn = userBasic[account].assetsIn; */

    /*     int liquidity = signedMulPrice( */
    /*         presentValue(userBasic[account].principal), */
    /*         getPrice(baseTokenPriceFeed), */
    /*         baseScale */
    /*     ); */

    /*     for (uint8 i = 0; i < numAssets; i++) { */
    /*         if (isInAsset(assetsIn, i)) { */
    /*             AssetInfo memory asset = getAssetInfo(i); */
    /*             uint newAmount = mulPrice( */
    /*                 userCollateral[account][asset.asset].balance, */
    /*                 getPrice(asset.priceFeed), */
    /*                 asset.scale */
    /*             ); */
    /*             liquidity += signed256(mulFactor( */
    /*                 newAmount, */
    /*                 asset.liquidateCollateralFactor */
    /*             )); */
    /*         } */
    /*     } */

    /*     return liquidity; */
    /* } */
}