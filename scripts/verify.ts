import hardhat, { ethers } from "hardhat";

async function sleep(ms: number) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function main() {

  await sleep(30 * 1000);

  await hardhat.run("verify:verify", {
    address: "0x626D57676cd025c68d62fce5396584687B83a4f3",
    constructorArguments: [],
  });

  //console.log("Dao contract has been verified");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
