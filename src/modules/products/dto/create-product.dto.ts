import {
  IsString,
  IsNotEmpty,
  IsOptional,
  IsBoolean,
  Length,
  IsInt,
} from "class-validator";

export class CreateProductDto {
  @IsInt()
  @IsOptional()
  institutionId?: number;

  @IsInt()
  @IsOptional()
  branchId?: number;

  @IsString()
  @IsNotEmpty()
  @Length(1, 255)
  name: string;

  @IsString()
  @IsOptional()
  description?: string;

  @IsBoolean()
  @IsOptional()
  isActive?: boolean;

  @IsOptional()
  isVisibleToBranches?: boolean;
}
