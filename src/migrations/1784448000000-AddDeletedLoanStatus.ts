import { MigrationInterface, QueryRunner } from "typeorm";

export class AddDeletedLoanStatus1784448000000
  implements MigrationInterface
{
  public async up(queryRunner: QueryRunner): Promise<void> {
    const enumType = await queryRunner.query(`
      SELECT 1
      FROM pg_type
      WHERE typname = 'loans_status_enum'
      LIMIT 1
    `);

    if (enumType.length > 0) {
      await queryRunner.query(
        `ALTER TYPE "public"."loans_status_enum" ADD VALUE IF NOT EXISTS 'Deleted'`,
      );
      return;
    }

    // Compatibility for databases created from database/schema.sql, where the
    // status column is VARCHAR with a check constraint instead of a PG enum.
    await queryRunner.query(
      `ALTER TABLE "loans" DROP CONSTRAINT IF EXISTS "chk_status"`,
    );
    await queryRunner.query(`
      ALTER TABLE "loans"
      ADD CONSTRAINT "chk_status"
      CHECK ("status" IN ('Active', 'Paid', 'Late', 'Finished', 'Deleted'))
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    // A rollback cannot keep the new value, so map retained audit records to
    // Finished before restoring the previous enum/check constraint.
    await queryRunner.query(
      `UPDATE "loans" SET "status" = 'Finished' WHERE "status" = 'Deleted'`,
    );

    const enumType = await queryRunner.query(`
      SELECT 1
      FROM pg_type
      WHERE typname = 'loans_status_enum'
      LIMIT 1
    `);

    if (enumType.length > 0) {
      await queryRunner.query(
        `ALTER TABLE "loans" ALTER COLUMN "status" DROP DEFAULT`,
      );
      await queryRunner.query(
        `ALTER TABLE "loans" ALTER COLUMN "status" TYPE text USING "status"::text`,
      );
      await queryRunner.query(`DROP TYPE "public"."loans_status_enum"`);
      await queryRunner.query(`
        CREATE TYPE "public"."loans_status_enum"
        AS ENUM ('Active', 'Paid', 'Late', 'Finished')
      `);
      await queryRunner.query(`
        ALTER TABLE "loans"
        ALTER COLUMN "status" TYPE "public"."loans_status_enum"
        USING "status"::"public"."loans_status_enum"
      `);
      await queryRunner.query(`
        ALTER TABLE "loans"
        ALTER COLUMN "status" SET DEFAULT 'Active'
      `);
      return;
    }

    await queryRunner.query(
      `ALTER TABLE "loans" DROP CONSTRAINT IF EXISTS "chk_status"`,
    );
    await queryRunner.query(`
      ALTER TABLE "loans"
      ADD CONSTRAINT "chk_status"
      CHECK ("status" IN ('Active', 'Paid', 'Late', 'Finished'))
    `);
  }
}
