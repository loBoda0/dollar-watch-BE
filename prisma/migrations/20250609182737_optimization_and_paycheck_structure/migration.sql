/*
  Warnings:

  - You are about to drop the column `forPeriod` on the `Paycheck` table. All the data in the column will be lost.
  - You are about to drop the column `mealAllowance` on the `Paycheck` table. All the data in the column will be lost.
  - You are about to drop the column `taxCodeId` on the `Paycheck` table. All the data in the column will be lost.
  - You are about to drop the `ContributionType` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `IncomeItem` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `PaycheckContribution` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `SalaryTaxCode` table. If the table is not empty, all the data it contains will be lost.
  - Added the required column `periodEnd` to the `Paycheck` table without a default value. This is not possible if the table is not empty.
  - Added the required column `periodStart` to the `Paycheck` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE `ContributionType` DROP FOREIGN KEY `ContributionType_budgetTypeId_fkey`;

-- DropForeignKey
ALTER TABLE `ContributionType` DROP FOREIGN KEY `ContributionType_taxCodeId_fkey`;

-- DropForeignKey
ALTER TABLE `IncomeItem` DROP FOREIGN KEY `IncomeItem_paycheckId_fkey`;

-- DropForeignKey
ALTER TABLE `Paycheck` DROP FOREIGN KEY `Paycheck_taxCodeId_fkey`;

-- DropForeignKey
ALTER TABLE `PaycheckContribution` DROP FOREIGN KEY `PaycheckContribution_contributionTypeId_fkey`;

-- DropForeignKey
ALTER TABLE `PaycheckContribution` DROP FOREIGN KEY `PaycheckContribution_paycheckId_fkey`;

-- DropIndex
DROP INDEX `Paycheck_taxCodeId_fkey` ON `Paycheck`;

-- AlterTable
ALTER TABLE `BudgetType` ADD COLUMN `categoryId` INTEGER NULL;

-- AlterTable
ALTER TABLE `Dividend` ADD COLUMN `currency` VARCHAR(191) NOT NULL DEFAULT 'EUR';

-- AlterTable
ALTER TABLE `GovernmentTransfer` ADD COLUMN `metadata` JSON NULL;

-- AlterTable
ALTER TABLE `InvestmentTransaction` ADD COLUMN `currency` VARCHAR(191) NOT NULL DEFAULT 'EUR';

-- AlterTable
ALTER TABLE `Paycheck` DROP COLUMN `forPeriod`,
    DROP COLUMN `mealAllowance`,
    DROP COLUMN `taxCodeId`,
    ADD COLUMN `currency` VARCHAR(191) NOT NULL DEFAULT 'EUR',
    ADD COLUMN `periodEnd` DATETIME(3) NOT NULL,
    ADD COLUMN `periodStart` DATETIME(3) NOT NULL;

-- AlterTable
ALTER TABLE `Transaction` ADD COLUMN `currency` VARCHAR(191) NOT NULL DEFAULT 'EUR',
    ADD COLUMN `metadata` JSON NULL;

-- DropTable
DROP TABLE `ContributionType`;

-- DropTable
DROP TABLE `IncomeItem`;

-- DropTable
DROP TABLE `PaycheckContribution`;

-- DropTable
DROP TABLE `SalaryTaxCode`;

-- CreateTable
CREATE TABLE `PaycheckEntry` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `paycheckId` INTEGER NOT NULL,
    `amount` DECIMAL(15, 2) NOT NULL,
    `type` ENUM('INCOME', 'CONTRIBUTION', 'ALLOWANCE') NOT NULL,
    `budgetTypeId` INTEGER NOT NULL,
    `metadata` JSON NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `PaycheckEntry_paycheckId_idx`(`paycheckId`),
    INDEX `PaycheckEntry_type_idx`(`type`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `BudgetCategory` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `code` VARCHAR(191) NOT NULL,
    `name` VARCHAR(191) NOT NULL,

    UNIQUE INDEX `BudgetCategory_code_key`(`code`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateIndex
CREATE INDEX `GovernmentTransfer_date_idx` ON `GovernmentTransfer`(`date`);

-- CreateIndex
CREATE INDEX `Paycheck_periodStart_periodEnd_idx` ON `Paycheck`(`periodStart`, `periodEnd`);

-- CreateIndex
CREATE INDEX `Transaction_date_idx` ON `Transaction`(`date`);

-- AddForeignKey
ALTER TABLE `PaycheckEntry` ADD CONSTRAINT `PaycheckEntry_paycheckId_fkey` FOREIGN KEY (`paycheckId`) REFERENCES `Paycheck`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `PaycheckEntry` ADD CONSTRAINT `PaycheckEntry_budgetTypeId_fkey` FOREIGN KEY (`budgetTypeId`) REFERENCES `BudgetType`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `BudgetType` ADD CONSTRAINT `BudgetType_categoryId_fkey` FOREIGN KEY (`categoryId`) REFERENCES `BudgetCategory`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- RedefineIndex
CREATE INDEX `GovernmentTransfer_userId_idx` ON `GovernmentTransfer`(`userId`);

-- RedefineIndex
CREATE INDEX `Paycheck_userId_idx` ON `Paycheck`(`userId`);

-- RedefineIndex
CREATE INDEX `Transaction_userId_idx` ON `Transaction`(`userId`);
