const hre = require("hardhat");

async function main() {
  const HyperBlockLabs = await hre.ethers.getContractFactory("HyperBlockLabs");
  const hyperBlockLabs = await HyperBlockLabs.deploy();

  await hyperBlockLabs.deployed();

  console.log("HyperBlockLabs deployed to:", hyperBlockLabs.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
