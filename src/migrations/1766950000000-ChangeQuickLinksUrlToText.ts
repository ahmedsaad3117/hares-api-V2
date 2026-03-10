import { MigrationInterface, QueryRunner } from "typeorm";

export class ChangeQuickLinksUrlToText1766950000000
  implements MigrationInterface
{
  public async up(queryRunner: QueryRunner): Promise<void> {
    // First fill any null values with empty string
    await queryRunner.query(
      `UPDATE "quick_links" SET "url" = '' WHERE "url" IS NULL`,
    );
    // Change url column from varchar(500) to text to support very long URLs
    await queryRunner.query(
      `ALTER TABLE "quick_links" ALTER COLUMN "url" TYPE text`,
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    // Revert back to varchar(500) — note: this may truncate existing long URLs
    await queryRunner.query(
      `ALTER TABLE "quick_links" ALTER COLUMN "url" TYPE character varying(500)`,
    );
  }
}
