import {
  BadRequestException,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class AppService {
  constructor(private readonly configService: ConfigService) {}

  getHello(name, key): { msg: string; id: string } {
    if (key !== this.configService.get<string>('API_KEY'))
      throw new UnauthorizedException('Invalid API KEY!');

    if (name.length === 0) throw new BadRequestException('passa um nome ae');

    return {
      msg: `Eae : ${name}`,
      id: uuidv4(),
    };
  }
}
