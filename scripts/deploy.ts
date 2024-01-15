import hardhat, { ethers } from "hardhat";

async function sleep(ms:number) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function main() {
   const Airdrop = await ethers.deployContract("Airdrop");
   await Airdrop.waitForDeployment()

   console.log("Airdrop deployed to:", Airdrop.target);

   const Dao = await ethers.deployContract("BTRDAO", [Airdrop.target]);
   await Dao.waitForDeployment()

   console.log("DAO deployed to:", Dao.target)

   await sleep(30 * 1000);

   await hardhat.run("verify:verify", {
     address: Dao.target,
     constructorArguments: [Airdrop.target],
   });

   console.log("Dao contract has been verified")
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
