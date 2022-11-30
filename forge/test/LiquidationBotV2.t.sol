// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../contracts/Comet.sol";
import "../../contracts/CometConfiguration.sol";
import "../../contracts/liquidator/LiquidatorV2.sol";
// import "../CometInterface.sol";

contract LiquidationBotV2Test is Test {
    // Comet public comet;
    LiquidatorV2 public liquidator;
    address[] public assets;
    uint256[] public assetBaseAmounts;
    address[] public swapTargets;
    bytes[] public swapTransactions;

    function setUp() public {
        liquidator = new LiquidatorV2(
            CometInterface(0xc3d688B66703497DAA19211EEdff47f25384cdc3), // comet
            address(0x1F98431c8aD98523631AE4a59f267346ea31F984), // uniswap v3 factory
            address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2) // weth9
        );

        assets.push(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599);
        assetBaseAmounts.push(1986431370054);
        swapTargets.push(0x1111111254EEB25477B68fb85Ed929f73A960582);

        bytes memory tx = "0x12aa3caf00000000000000000000000053222470cdcfb8081c0e3a50fd106f0d69e63f200000000000000000000000002260fac5e5542a773aa44fbcfedf7c193bc2c599000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb4800000000000000000000000053222470cdcfb8081c0e3a50fd106f0d69e63f200000000000000000000000005a13d329a193ca3b1fe2d7b459097eddba14c28f00000000000000000000000000000000000000000000000000000002cb417801000000000000000000000000000000000000000000000000000001d2408326620000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000014000000000000000000000000000000000000000000000000000000000000001600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000082f0000000000000000000000000000000000000008110007e300079900077f00a0c9e75c480000000000000000080200000000000000000000000000000000000000000000000000075100012d00a0c9e75c48000000000000000030020000000000000000000000000000000000000000000000000000ff0000b051002109f78b46a789125598f5ad2b7f243751c2934d2260fac5e5542a773aa44fbcfedf7c193bc2c59900048dae7333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003bc6d47d40000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000002a00000000000000000000000000000000000000000000000000000005973a2766cee63c1e50199ac8ca7087fa4a2a1fb6357269965a2014abc352260fac5e5542a773aa44fbcfedf7c193bc2c59900a007e5c0d20000000000000000000000000000000000000000000006000001de0001d800a0c9e75c4800000000000004ff220c0000000000000000000000000000000000000001aa0000da00009e00004f02a00000000000000000000000000000000000000000000000105cc13ffb2d182ea1ee63c1e501cbcdf9626bc03e24f779434178a73a0b4bad62ed2260fac5e5542a773aa44fbcfedf7c193bc2c59902a000000000000000000000000000000000000000000000002e78ff1d22fed44fc9ee63c1e5014585fe77225b41b697c938b018e2ac67ac5a20c02260fac5e5542a773aa44fbcfedf7c193bc2c5994101c02aaa39b223fe8d0a0e5c4f27ead9083c756cc200042e1a7d4d00000000000000000000000000000000000000000000000000000000000000005100d51a44d3fae010294c616388b506acda1bfaae462260fac5e5542a773aa44fbcfedf7c193bc2c5990044394747c50000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000057665592f3cae0d1a000000000000000000000000000000000000000000000000000000000000000100206b4be0b900a0c9e75c4800000000150e0101000d0000000000000000000000000003f40003a50003560002db00026000024600a007e5c0d20000000000000000000000000000000000000002220001720000b600009c4160c5424b857f758e906013f3555dad202e4bdb456700443df0212400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010020d6bdbf785e74c9036fb86bd7ecdcb084a0673efc32ea31cb4120c011a73ee8576fb46f5e1c5751ca3b9fe0af2a6f002444b3e92373455448000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000735553440000000000000000000000000000000000000000000000000000000031494e434800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005120a5407eae9ba41422680e2e00537571bcc53efbfd57ab1ec28d129707052df4df418d58a2d46d5f5100443df0212400000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000014041c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2d0e30db00c20c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2397ff1542f962076d0bfe58ea045ffa2d347aca06ae4071198002dc6c0397ff1542f962076d0bfe58ea045ffa2d347aca00000000000000000000000000000000000000000000000000000000776b99ffcc02aaa39b223fe8d0a0e5c4f27ead9083c756cc20c20c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2b4e16d0168e52d35cacd2c6185b44281ec28c9dc6ae4071198002dc6c0b4e16d0168e52d35cacd2c6185b44281ec28c9dc0000000000000000000000000000000000000000000000000000000776b950a1c02aaa39b223fe8d0a0e5c4f27ead9083c756cc202a00000000000000000000000000000000000000000000000000000006874937bbdee63c1e5008ad599c3a0ff1de082011efddc58f1908eb6e6d8c02aaa39b223fe8d0a0e5c4f27ead9083c756cc202a00000000000000000000000000000000000000000000000000000009cb3e65e1eee63c1e50088e6a0c2ddd26feeb64f039a2c41296fcb3f5640c02aaa39b223fe8d0a0e5c4f27ead9083c756cc20020d6bdbf78a0b86991c6218b36c1d19d4a2e9eb0ce3606eb4800a0f2fa6b66a0b86991c6218b36c1d19d4a2e9eb0ce3606eb48000000000000000000000000000000000000000000000000000001d6f62c8e35000000000000000000000000004c59c880a06c4eca27a0b86991c6218b36c1d19d4a2e9eb0ce3606eb481111111254eeb25477b68fb85ed929f73a9605820000000000000000000000000000000000cfee7c08";
        swapTransactions.push(tx);
    }

    // function testOne() public {
    //     uint256 a = 41;
    //     uint256 b = 42;
    //     assertEq(a, b);
    // }

    function testTwo() public {
        address[] memory liquidatableAccounts;

        liquidator.absorbAndArbitrage(
            liquidatableAccounts, // liquidatableAccounts,
            assets, // assets,
            assetBaseAmounts, // assetBaseAmounts,
            swapTargets, // swapTargets,
            swapTransactions // swapTransactions
        );
    }

}