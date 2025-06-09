import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

async function main() {
  await prisma.budgetType.createMany({
    data: [
      { code: '4010', name: 'Pension Insurance', countryCode: 'SI', description: 'Pokojninsko in invalidsko zavarovanje' },
      { code: '4011', name: 'Health Insurance', countryCode: 'SI', description: 'Obvezno zdravstveno zavarovanje' },
      { code: '401101', name: 'Injury Insurance', countryCode: 'SI', description: 'Poškodbe pri delu in poklicne bolezni' },
      { code: '4012', name: 'Employment Insurance', countryCode: 'SI', description: 'Prispevek za zaposlovanje' },
    ],
    skipDuplicates: true, // prevent re-inserts
  })
}

main()
  .then(() => {
    console.log('✅ Seed complete')
    return prisma.$disconnect()
  })
  .catch((e) => {
    console.error('❌ Seed error:', e)
    return prisma.$disconnect().finally(() => process.exit(1))
  })
