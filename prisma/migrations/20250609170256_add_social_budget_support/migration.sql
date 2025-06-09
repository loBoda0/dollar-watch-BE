/*
  Warnings:

  - You are about to drop the `UserInvestment` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE `UserInvestment` DROP FOREIGN KEY `UserInvestment_instrumentId_fkey`;

-- DropForeignKey
ALTER TABLE `UserInvestment` DROP FOREIGN KEY `UserInvestment_userId_fkey`;

-- AlterTable
ALTER TABLE `ContributionType` ADD COLUMN `budgetTypeId` INTEGER NULL;

-- AlterTable
ALTER TABLE `Transaction` ADD COLUMN `budgetTypeId` INTEGER NULL;

-- DropTable
DROP TABLE `UserInvestment`;

-- CreateTable
CREATE TABLE `BudgetType` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `code` VARCHAR(191) NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `countryCode` VARCHAR(191) NULL,
    `description` VARCHAR(191) NULL,

    UNIQUE INDEX `BudgetType_code_key`(`code`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `GovernmentTransfer` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `userId` INTEGER NOT NULL,
    `budgetTypeId` INTEGER NOT NULL,
    `type` VARCHAR(191) NOT NULL,
    `description` VARCHAR(191) NULL,
    `amount` DECIMAL(15, 2) NOT NULL,
    `date` DATETIME(3) NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `Transaction` ADD CONSTRAINT `Transaction_budgetTypeId_fkey` FOREIGN KEY (`budgetTypeId`) REFERENCES `BudgetType`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `ContributionType` ADD CONSTRAINT `ContributionType_budgetTypeId_fkey` FOREIGN KEY (`budgetTypeId`) REFERENCES `BudgetType`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `GovernmentTransfer` ADD CONSTRAINT `GovernmentTransfer_budgetTypeId_fkey` FOREIGN KEY (`budgetTypeId`) REFERENCES `BudgetType`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `GovernmentTransfer` ADD CONSTRAINT `GovernmentTransfer_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
