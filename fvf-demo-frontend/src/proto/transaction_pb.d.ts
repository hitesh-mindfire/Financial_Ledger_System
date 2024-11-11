import * as jspb from 'google-protobuf'

import * as google_protobuf_timestamp_pb from 'google-protobuf/google/protobuf/timestamp_pb'; // proto import: "google/protobuf/timestamp.proto"


export class Decimal2 extends jspb.Message {
  getValue(): string;
  setValue(value: string): Decimal2;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): Decimal2.AsObject;
  static toObject(includeInstance: boolean, msg: Decimal2): Decimal2.AsObject;
  static serializeBinaryToWriter(message: Decimal2, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): Decimal2;
  static deserializeBinaryFromReader(message: Decimal2, reader: jspb.BinaryReader): Decimal2;
}

export namespace Decimal2 {
  export type AsObject = {
    value: string,
  }
}

export class Transaction extends jspb.Message {
  getId(): string;
  setId(value: string): Transaction;

  getCardId(): string;
  setCardId(value: string): Transaction;

  getAmount(): string;
  setAmount(value: string): Transaction;

  getCurrency(): string;
  setCurrency(value: string): Transaction;

  getType(): string;
  setType(value: string): Transaction;

  getStatus(): string;
  setStatus(value: string): Transaction;

  getReferenceNumber(): string;
  setReferenceNumber(value: string): Transaction;

  getCreatedAt(): google_protobuf_timestamp_pb.Timestamp | undefined;
  setCreatedAt(value?: google_protobuf_timestamp_pb.Timestamp): Transaction;
  hasCreatedAt(): boolean;
  clearCreatedAt(): Transaction;

  getUpdatedAt(): google_protobuf_timestamp_pb.Timestamp | undefined;
  setUpdatedAt(value?: google_protobuf_timestamp_pb.Timestamp): Transaction;
  hasUpdatedAt(): boolean;
  clearUpdatedAt(): Transaction;

  getSettledAt(): google_protobuf_timestamp_pb.Timestamp | undefined;
  setSettledAt(value?: google_protobuf_timestamp_pb.Timestamp): Transaction;
  hasSettledAt(): boolean;
  clearSettledAt(): Transaction;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): Transaction.AsObject;
  static toObject(includeInstance: boolean, msg: Transaction): Transaction.AsObject;
  static serializeBinaryToWriter(message: Transaction, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): Transaction;
  static deserializeBinaryFromReader(message: Transaction, reader: jspb.BinaryReader): Transaction;
}

export namespace Transaction {
  export type AsObject = {
    id: string,
    cardId: string,
    amount: string,
    currency: string,
    type: string,
    status: string,
    referenceNumber: string,
    createdAt?: google_protobuf_timestamp_pb.Timestamp.AsObject,
    updatedAt?: google_protobuf_timestamp_pb.Timestamp.AsObject,
    settledAt?: google_protobuf_timestamp_pb.Timestamp.AsObject,
  }
}

export class TransactionUpdateResponse extends jspb.Message {
  getId(): string;
  setId(value: string): TransactionUpdateResponse;

  getCardId(): string;
  setCardId(value: string): TransactionUpdateResponse;

  getAmount(): string;
  setAmount(value: string): TransactionUpdateResponse;

  getCurrency(): string;
  setCurrency(value: string): TransactionUpdateResponse;

  getType(): string;
  setType(value: string): TransactionUpdateResponse;

  getStatus(): string;
  setStatus(value: string): TransactionUpdateResponse;

  getReferenceNumber(): string;
  setReferenceNumber(value: string): TransactionUpdateResponse;

  getCreatedAt(): string;
  setCreatedAt(value: string): TransactionUpdateResponse;

  getUpdatedAt(): string;
  setUpdatedAt(value: string): TransactionUpdateResponse;

  getSettledAt(): string;
  setSettledAt(value: string): TransactionUpdateResponse;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): TransactionUpdateResponse.AsObject;
  static toObject(includeInstance: boolean, msg: TransactionUpdateResponse): TransactionUpdateResponse.AsObject;
  static serializeBinaryToWriter(message: TransactionUpdateResponse, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): TransactionUpdateResponse;
  static deserializeBinaryFromReader(message: TransactionUpdateResponse, reader: jspb.BinaryReader): TransactionUpdateResponse;
}

export namespace TransactionUpdateResponse {
  export type AsObject = {
    id: string,
    cardId: string,
    amount: string,
    currency: string,
    type: string,
    status: string,
    referenceNumber: string,
    createdAt: string,
    updatedAt: string,
    settledAt: string,
  }
}

export class CreateTxnRequest extends jspb.Message {
  getCardId(): string;
  setCardId(value: string): CreateTxnRequest;

  getMerchantId(): string;
  setMerchantId(value: string): CreateTxnRequest;

  getAmount(): string;
  setAmount(value: string): CreateTxnRequest;

  getCurrency(): string;
  setCurrency(value: string): CreateTxnRequest;

  getType(): string;
  setType(value: string): CreateTxnRequest;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): CreateTxnRequest.AsObject;
  static toObject(includeInstance: boolean, msg: CreateTxnRequest): CreateTxnRequest.AsObject;
  static serializeBinaryToWriter(message: CreateTxnRequest, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): CreateTxnRequest;
  static deserializeBinaryFromReader(message: CreateTxnRequest, reader: jspb.BinaryReader): CreateTxnRequest;
}

export namespace CreateTxnRequest {
  export type AsObject = {
    cardId: string,
    merchantId: string,
    amount: string,
    currency: string,
    type: string,
  }
}

export class UpdateStatusRequest extends jspb.Message {
  getTransactionId(): string;
  setTransactionId(value: string): UpdateStatusRequest;

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
    transactionId: string,
    newStatus: string,
  }
}

export class GetTxnRequest extends jspb.Message {
  getTransactionId(): string;
  setTransactionId(value: string): GetTxnRequest;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): GetTxnRequest.AsObject;
  static toObject(includeInstance: boolean, msg: GetTxnRequest): GetTxnRequest.AsObject;
  static serializeBinaryToWriter(message: GetTxnRequest, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): GetTxnRequest;
  static deserializeBinaryFromReader(message: GetTxnRequest, reader: jspb.BinaryReader): GetTxnRequest;
}

export namespace GetTxnRequest {
  export type AsObject = {
    transactionId: string,
  }
}

export class TxnFilter extends jspb.Message {
  getCardId(): string;
  setCardId(value: string): TxnFilter;

  getStatus(): string;
  setStatus(value: string): TxnFilter;

  getStartDate(): google_protobuf_timestamp_pb.Timestamp | undefined;
  setStartDate(value?: google_protobuf_timestamp_pb.Timestamp): TxnFilter;
  hasStartDate(): boolean;
  clearStartDate(): TxnFilter;

  getEndDate(): google_protobuf_timestamp_pb.Timestamp | undefined;
  setEndDate(value?: google_protobuf_timestamp_pb.Timestamp): TxnFilter;
  hasEndDate(): boolean;
  clearEndDate(): TxnFilter;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): TxnFilter.AsObject;
  static toObject(includeInstance: boolean, msg: TxnFilter): TxnFilter.AsObject;
  static serializeBinaryToWriter(message: TxnFilter, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): TxnFilter;
  static deserializeBinaryFromReader(message: TxnFilter, reader: jspb.BinaryReader): TxnFilter;
}

export namespace TxnFilter {
  export type AsObject = {
    cardId: string,
    status: string,
    startDate?: google_protobuf_timestamp_pb.Timestamp.AsObject,
    endDate?: google_protobuf_timestamp_pb.Timestamp.AsObject,
  }
}

export class TxnList extends jspb.Message {
  getTransactionsList(): Array<Transaction>;
  setTransactionsList(value: Array<Transaction>): TxnList;
  clearTransactionsList(): TxnList;
  addTransactions(value?: Transaction, index?: number): Transaction;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): TxnList.AsObject;
  static toObject(includeInstance: boolean, msg: TxnList): TxnList.AsObject;
  static serializeBinaryToWriter(message: TxnList, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): TxnList;
  static deserializeBinaryFromReader(message: TxnList, reader: jspb.BinaryReader): TxnList;
}

export namespace TxnList {
  export type AsObject = {
    transactionsList: Array<Transaction.AsObject>,
  }
}

export class TxnList1 extends jspb.Message {
  getTransactionsList(): Array<TransactionUpdateResponse>;
  setTransactionsList(value: Array<TransactionUpdateResponse>): TxnList1;
  clearTransactionsList(): TxnList1;
  addTransactions(value?: TransactionUpdateResponse, index?: number): TransactionUpdateResponse;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): TxnList1.AsObject;
  static toObject(includeInstance: boolean, msg: TxnList1): TxnList1.AsObject;
  static serializeBinaryToWriter(message: TxnList1, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): TxnList1;
  static deserializeBinaryFromReader(message: TxnList1, reader: jspb.BinaryReader): TxnList1;
}

export namespace TxnList1 {
  export type AsObject = {
    transactionsList: Array<TransactionUpdateResponse.AsObject>,
  }
}

