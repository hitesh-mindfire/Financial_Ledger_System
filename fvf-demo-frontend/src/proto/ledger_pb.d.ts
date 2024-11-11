import * as jspb from 'google-protobuf'

import * as google_protobuf_timestamp_pb from 'google-protobuf/google/protobuf/timestamp_pb'; // proto import: "google/protobuf/timestamp.proto"


export class CreateLedgerEntryRequest extends jspb.Message {
  getAccountId(): string;
  setAccountId(value: string): CreateLedgerEntryRequest;

  getEntryType(): string;
  setEntryType(value: string): CreateLedgerEntryRequest;

  getAmount(): string;
  setAmount(value: string): CreateLedgerEntryRequest;

  getBalanceAfter(): string;
  setBalanceAfter(value: string): CreateLedgerEntryRequest;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): CreateLedgerEntryRequest.AsObject;
  static toObject(includeInstance: boolean, msg: CreateLedgerEntryRequest): CreateLedgerEntryRequest.AsObject;
  static serializeBinaryToWriter(message: CreateLedgerEntryRequest, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): CreateLedgerEntryRequest;
  static deserializeBinaryFromReader(message: CreateLedgerEntryRequest, reader: jspb.BinaryReader): CreateLedgerEntryRequest;
}

export namespace CreateLedgerEntryRequest {
  export type AsObject = {
    accountId: string,
    entryType: string,
    amount: string,
    balanceAfter: string,
  }
}

export class LedgerEntry extends jspb.Message {
  getId(): string;
  setId(value: string): LedgerEntry;

  getTransactionId(): string;
  setTransactionId(value: string): LedgerEntry;

  getAccountId(): string;
  setAccountId(value: string): LedgerEntry;

  getEntryType(): string;
  setEntryType(value: string): LedgerEntry;

  getAmount(): string;
  setAmount(value: string): LedgerEntry;

  getBalanceAfter(): string;
  setBalanceAfter(value: string): LedgerEntry;

  getStatus(): string;
  setStatus(value: string): LedgerEntry;

  getCreatedAt(): google_protobuf_timestamp_pb.Timestamp | undefined;
  setCreatedAt(value?: google_protobuf_timestamp_pb.Timestamp): LedgerEntry;
  hasCreatedAt(): boolean;
  clearCreatedAt(): LedgerEntry;

  getUpdatedAt(): google_protobuf_timestamp_pb.Timestamp | undefined;
  setUpdatedAt(value?: google_protobuf_timestamp_pb.Timestamp): LedgerEntry;
  hasUpdatedAt(): boolean;
  clearUpdatedAt(): LedgerEntry;

  getVersion(): number;
  setVersion(value: number): LedgerEntry;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): LedgerEntry.AsObject;
  static toObject(includeInstance: boolean, msg: LedgerEntry): LedgerEntry.AsObject;
  static serializeBinaryToWriter(message: LedgerEntry, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): LedgerEntry;
  static deserializeBinaryFromReader(message: LedgerEntry, reader: jspb.BinaryReader): LedgerEntry;
}

export namespace LedgerEntry {
  export type AsObject = {
    id: string,
    transactionId: string,
    accountId: string,
    entryType: string,
    amount: string,
    balanceAfter: string,
    status: string,
    createdAt?: google_protobuf_timestamp_pb.Timestamp.AsObject,
    updatedAt?: google_protobuf_timestamp_pb.Timestamp.AsObject,
    version: number,
  }
}

export class UpdateStatusRequest extends jspb.Message {
  getEntryId(): string;
  setEntryId(value: string): UpdateStatusRequest;

  getNewStatus(): string;
  setNewStatus(value: string): UpdateStatusRequest;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): UpdateStatusRequest.AsObject;
  static toObject(includeInstance: boolean, msg: UpdateStatusRequest): UpdateStatusRequest.AsObject;
  static serializeBinaryToWriter(message: UpdateStatusRequest, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): UpdateStatusRequest;
  static deserializeBinaryFromReader(message: UpdateStatusRequest, reader: jspb.BinaryReader): UpdateStatusRequest;
}

export namespace UpdateStatusRequest {
  export type AsObject = {
    entryId: string,
    newStatus: string,
  }
}

export class GetLedgerRequest extends jspb.Message {
  getEntryId(): string;
  setEntryId(value: string): GetLedgerRequest;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): GetLedgerRequest.AsObject;
  static toObject(includeInstance: boolean, msg: GetLedgerRequest): GetLedgerRequest.AsObject;
  static serializeBinaryToWriter(message: GetLedgerRequest, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): GetLedgerRequest;
  static deserializeBinaryFromReader(message: GetLedgerRequest, reader: jspb.BinaryReader): GetLedgerRequest;
}

export namespace GetLedgerRequest {
  export type AsObject = {
    entryId: string,
  }
}

export class LedgerFilter extends jspb.Message {
  getAccountId(): string;
  setAccountId(value: string): LedgerFilter;

  getStatus(): string;
  setStatus(value: string): LedgerFilter;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): LedgerFilter.AsObject;
  static toObject(includeInstance: boolean, msg: LedgerFilter): LedgerFilter.AsObject;
  static serializeBinaryToWriter(message: LedgerFilter, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): LedgerFilter;
  static deserializeBinaryFromReader(message: LedgerFilter, reader: jspb.BinaryReader): LedgerFilter;
}

export namespace LedgerFilter {
  export type AsObject = {
    accountId: string,
    status: string,
  }
}

export class LedgerEntryResponse extends jspb.Message {
  getEntry(): LedgerEntry | undefined;
  setEntry(value?: LedgerEntry): LedgerEntryResponse;
  hasEntry(): boolean;
  clearEntry(): LedgerEntryResponse;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): LedgerEntryResponse.AsObject;
  static toObject(includeInstance: boolean, msg: LedgerEntryResponse): LedgerEntryResponse.AsObject;
  static serializeBinaryToWriter(message: LedgerEntryResponse, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): LedgerEntryResponse;
  static deserializeBinaryFromReader(message: LedgerEntryResponse, reader: jspb.BinaryReader): LedgerEntryResponse;
}

export namespace LedgerEntryResponse {
  export type AsObject = {
    entry?: LedgerEntry.AsObject,
  }
}

export class LedgerList extends jspb.Message {
  getEntriesList(): Array<LedgerEntry>;
  setEntriesList(value: Array<LedgerEntry>): LedgerList;
  clearEntriesList(): LedgerList;
  addEntries(value?: LedgerEntry, index?: number): LedgerEntry;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): LedgerList.AsObject;
  static toObject(includeInstance: boolean, msg: LedgerList): LedgerList.AsObject;
  static serializeBinaryToWriter(message: LedgerList, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): LedgerList;
  static deserializeBinaryFromReader(message: LedgerList, reader: jspb.BinaryReader): LedgerList;
}

export namespace LedgerList {
  export type AsObject = {
    entriesList: Array<LedgerEntry.AsObject>,
  }
}

