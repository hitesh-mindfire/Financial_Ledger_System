import * as jspb from 'google-protobuf'

import * as google_protobuf_timestamp_pb from 'google-protobuf/google/protobuf/timestamp_pb'; // proto import: "google/protobuf/timestamp.proto"


export class Decimal1 extends jspb.Message {
  getValue(): string;
  setValue(value: string): Decimal1;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): Decimal1.AsObject;
  static toObject(includeInstance: boolean, msg: Decimal1): Decimal1.AsObject;
  static serializeBinaryToWriter(message: Decimal1, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): Decimal1;
  static deserializeBinaryFromReader(message: Decimal1, reader: jspb.BinaryReader): Decimal1;
}

export namespace Decimal1 {
  export type AsObject = {
    value: string,
  }
}

export class Merchant extends jspb.Message {
  getId(): string;
  setId(value: string): Merchant;

  getName(): string;
  setName(value: string): Merchant;

  getCategory(): string;
  setCategory(value: string): Merchant;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): Merchant.AsObject;
  static toObject(includeInstance: boolean, msg: Merchant): Merchant.AsObject;
  static serializeBinaryToWriter(message: Merchant, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): Merchant;
  static deserializeBinaryFromReader(message: Merchant, reader: jspb.BinaryReader): Merchant;
}

export namespace Merchant {
  export type AsObject = {
    id: string,
    name: string,
    category: string,
  }
}

export class Card extends jspb.Message {
  getId(): string;
  setId(value: string): Card;

  getUserId(): string;
  setUserId(value: string): Card;

  getStatus(): string;
  setStatus(value: string): Card;

  getCreditLimit(): string;
  setCreditLimit(value: string): Card;

  getCardNumber(): string;
  setCardNumber(value: string): Card;

  getAvailableBalance(): string;
  setAvailableBalance(value: string): Card;

  getIssuedAt(): google_protobuf_timestamp_pb.Timestamp | undefined;
  setIssuedAt(value?: google_protobuf_timestamp_pb.Timestamp): Card;
  hasIssuedAt(): boolean;
  clearIssuedAt(): Card;

  getExpiryDate(): string;
  setExpiryDate(value: string): Card;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): Card.AsObject;
  static toObject(includeInstance: boolean, msg: Card): Card.AsObject;
  static serializeBinaryToWriter(message: Card, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): Card;
  static deserializeBinaryFromReader(message: Card, reader: jspb.BinaryReader): Card;
}

export namespace Card {
  export type AsObject = {
    id: string,
    userId: string,
    status: string,
    creditLimit: string,
    cardNumber: string,
    availableBalance: string,
    issuedAt?: google_protobuf_timestamp_pb.Timestamp.AsObject,
    expiryDate: string,
  }
}

export class CardResponse extends jspb.Message {
  getId(): string;
  setId(value: string): CardResponse;

  getUserId(): string;
  setUserId(value: string): CardResponse;

  getStatus(): string;
  setStatus(value: string): CardResponse;

  getCreditLimit(): string;
  setCreditLimit(value: string): CardResponse;

  getCardNumber(): string;
  setCardNumber(value: string): CardResponse;

  getAvailableBalance(): string;
  setAvailableBalance(value: string): CardResponse;

  getIssuedAt(): google_protobuf_timestamp_pb.Timestamp | undefined;
  setIssuedAt(value?: google_protobuf_timestamp_pb.Timestamp): CardResponse;
  hasIssuedAt(): boolean;
  clearIssuedAt(): CardResponse;

  getExpiryDate(): string;
  setExpiryDate(value: string): CardResponse;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): CardResponse.AsObject;
  static toObject(includeInstance: boolean, msg: CardResponse): CardResponse.AsObject;
  static serializeBinaryToWriter(message: CardResponse, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): CardResponse;
  static deserializeBinaryFromReader(message: CardResponse, reader: jspb.BinaryReader): CardResponse;
}

export namespace CardResponse {
  export type AsObject = {
    id: string,
    userId: string,
    status: string,
    creditLimit: string,
    cardNumber: string,
    availableBalance: string,
    issuedAt?: google_protobuf_timestamp_pb.Timestamp.AsObject,
    expiryDate: string,
  }
}

export class IssueCardRequest extends jspb.Message {
  getUserId(): string;
  setUserId(value: string): IssueCardRequest;

  getCreditLimit(): string;
  setCreditLimit(value: string): IssueCardRequest;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): IssueCardRequest.AsObject;
  static toObject(includeInstance: boolean, msg: IssueCardRequest): IssueCardRequest.AsObject;
  static serializeBinaryToWriter(message: IssueCardRequest, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): IssueCardRequest;
  static deserializeBinaryFromReader(message: IssueCardRequest, reader: jspb.BinaryReader): IssueCardRequest;
}

export namespace IssueCardRequest {
  export type AsObject = {
    userId: string,
    creditLimit: string,
  }
}

export class AuthRequest extends jspb.Message {
  getCardId(): string;
  setCardId(value: string): AuthRequest;

  getAmount(): string;
  setAmount(value: string): AuthRequest;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): AuthRequest.AsObject;
  static toObject(includeInstance: boolean, msg: AuthRequest): AuthRequest.AsObject;
  static serializeBinaryToWriter(message: AuthRequest, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): AuthRequest;
  static deserializeBinaryFromReader(message: AuthRequest, reader: jspb.BinaryReader): AuthRequest;
}

export namespace AuthRequest {
  export type AsObject = {
    cardId: string,
    amount: string,
  }
}

export class AuthResponse extends jspb.Message {
  getAuthorized(): boolean;
  setAuthorized(value: boolean): AuthResponse;

  getTransactionId(): string;
  setTransactionId(value: string): AuthResponse;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): AuthResponse.AsObject;
  static toObject(includeInstance: boolean, msg: AuthResponse): AuthResponse.AsObject;
  static serializeBinaryToWriter(message: AuthResponse, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): AuthResponse;
  static deserializeBinaryFromReader(message: AuthResponse, reader: jspb.BinaryReader): AuthResponse;
}

export namespace AuthResponse {
  export type AsObject = {
    authorized: boolean,
    transactionId: string,
  }
}

export class UpdateLimitRequest extends jspb.Message {
  getCardId(): string;
  setCardId(value: string): UpdateLimitRequest;

  getNewLimit(): string;
  setNewLimit(value: string): UpdateLimitRequest;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): UpdateLimitRequest.AsObject;
  static toObject(includeInstance: boolean, msg: UpdateLimitRequest): UpdateLimitRequest.AsObject;
  static serializeBinaryToWriter(message: UpdateLimitRequest, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): UpdateLimitRequest;
  static deserializeBinaryFromReader(message: UpdateLimitRequest, reader: jspb.BinaryReader): UpdateLimitRequest;
}

export namespace UpdateLimitRequest {
  export type AsObject = {
    cardId: string,
    newLimit: string,
  }
}

export class GetBalanceRequest extends jspb.Message {
  getCardId(): string;
  setCardId(value: string): GetBalanceRequest;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): GetBalanceRequest.AsObject;
  static toObject(includeInstance: boolean, msg: GetBalanceRequest): GetBalanceRequest.AsObject;
  static serializeBinaryToWriter(message: GetBalanceRequest, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): GetBalanceRequest;
  static deserializeBinaryFromReader(message: GetBalanceRequest, reader: jspb.BinaryReader): GetBalanceRequest;
}

export namespace GetBalanceRequest {
  export type AsObject = {
    cardId: string,
  }
}

export class Balance extends jspb.Message {
  getCardId(): string;
  setCardId(value: string): Balance;

  getCurrentBalance(): string;
  setCurrentBalance(value: string): Balance;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): Balance.AsObject;
  static toObject(includeInstance: boolean, msg: Balance): Balance.AsObject;
  static serializeBinaryToWriter(message: Balance, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): Balance;
  static deserializeBinaryFromReader(message: Balance, reader: jspb.BinaryReader): Balance;
}

export namespace Balance {
  export type AsObject = {
    cardId: string,
    currentBalance: string,
  }
}

export class CardEvents extends jspb.Message {
  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): CardEvents.AsObject;
  static toObject(includeInstance: boolean, msg: CardEvents): CardEvents.AsObject;
  static serializeBinaryToWriter(message: CardEvents, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): CardEvents;
  static deserializeBinaryFromReader(message: CardEvents, reader: jspb.BinaryReader): CardEvents;
}

export namespace CardEvents {
  export type AsObject = {
  }

  export class Issued extends jspb.Message {
    getCardId(): string;
    setCardId(value: string): Issued;

    getUserId(): string;
    setUserId(value: string): Issued;

    getCreditLimit(): string;
    setCreditLimit(value: string): Issued;

    getIssuedAt(): google_protobuf_timestamp_pb.Timestamp | undefined;
    setIssuedAt(value?: google_protobuf_timestamp_pb.Timestamp): Issued;
    hasIssuedAt(): boolean;
    clearIssuedAt(): Issued;

    serializeBinary(): Uint8Array;
    toObject(includeInstance?: boolean): Issued.AsObject;
    static toObject(includeInstance: boolean, msg: Issued): Issued.AsObject;
    static serializeBinaryToWriter(message: Issued, writer: jspb.BinaryWriter): void;
    static deserializeBinary(bytes: Uint8Array): Issued;
    static deserializeBinaryFromReader(message: Issued, reader: jspb.BinaryReader): Issued;
  }

  export namespace Issued {
    export type AsObject = {
      cardId: string,
      userId: string,
      creditLimit: string,
      issuedAt?: google_protobuf_timestamp_pb.Timestamp.AsObject,
    }
  }


  export class TransactionAuthorized extends jspb.Message {
    getCardId(): string;
    setCardId(value: string): TransactionAuthorized;

    getTransactionId(): string;
    setTransactionId(value: string): TransactionAuthorized;

    getAmount(): string;
    setAmount(value: string): TransactionAuthorized;

    getMerchant(): Merchant | undefined;
    setMerchant(value?: Merchant): TransactionAuthorized;
    hasMerchant(): boolean;
    clearMerchant(): TransactionAuthorized;

    getAuthorizedAt(): google_protobuf_timestamp_pb.Timestamp | undefined;
    setAuthorizedAt(value?: google_protobuf_timestamp_pb.Timestamp): TransactionAuthorized;
    hasAuthorizedAt(): boolean;
    clearAuthorizedAt(): TransactionAuthorized;

    serializeBinary(): Uint8Array;
    toObject(includeInstance?: boolean): TransactionAuthorized.AsObject;
    static toObject(includeInstance: boolean, msg: TransactionAuthorized): TransactionAuthorized.AsObject;
    static serializeBinaryToWriter(message: TransactionAuthorized, writer: jspb.BinaryWriter): void;
    static deserializeBinary(bytes: Uint8Array): TransactionAuthorized;
    static deserializeBinaryFromReader(message: TransactionAuthorized, reader: jspb.BinaryReader): TransactionAuthorized;
  }

  export namespace TransactionAuthorized {
    export type AsObject = {
      cardId: string,
      transactionId: string,
      amount: string,
      merchant?: Merchant.AsObject,
      authorizedAt?: google_protobuf_timestamp_pb.Timestamp.AsObject,
    }
  }

}

