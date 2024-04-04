async function main() {
  const tokenAddress = "0x1531BC5dE10618c511349f8007C08966E45Ce8ef"; 
  const tokenPrice = ethers.utils.parseEther("0.01");
  const saleDuration = 5 * 7 * 24 * 60 * 60;
  const maxTokensPerWallet = 50000;
  const wallet = process.env.WALLET;

  const Token = await hre.ethers.getContractFactory("TokenSale");
  const token = await Token.deploy(
    tokenAddress,
    tokenPrice,
    saleDuration,
    maxTokensPerWallet,
    wallet
  );

  await token.deployed();
  console.log("TokenSale deployed to:", token.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
