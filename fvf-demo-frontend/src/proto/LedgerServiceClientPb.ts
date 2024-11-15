/**
 * @fileoverview gRPC-Web generated client stub for ledgerpb
 * @enhanceable
 * @public
 */

// Code generated by protoc-gen-grpc-web. DO NOT EDIT.
// versions:
// 	protoc-gen-grpc-web v1.5.0
// 	protoc              v5.28.3
// source: proto/ledger.proto


/* eslint-disable */
// @ts-nocheck


import * as grpcWeb from 'grpc-web';

import * as proto_ledger_pb from './ledger_pb'; // proto import: "proto/ledger.proto"


export class LedgerServiceClient {
  client_: grpcWeb.AbstractClientBase;
  hostname_: string;
  credentials_: null | { [index: string]: string; };
  options_: null | { [index: string]: any; };

  constructor (hostname: string,
               credentials?: null | { [index: string]: string; },
               options?: null | { [index: string]: any; }) {
    if (!options) options = {};
    if (!credentials) credentials = {};
    options['format'] = 'text';

    this.client_ = new grpcWeb.GrpcWebClientBase(options);
    this.hostname_ = hostname.replace(/\/+$/, '');
    this.credentials_ = credentials;
    this.options_ = options;
  }

  methodDescriptorCreateLedgerEntry = new grpcWeb.MethodDescriptor(
    '/ledgerpb.LedgerService/CreateLedgerEntry',
    grpcWeb.MethodType.UNARY,
    proto_ledger_pb.CreateLedgerEntryRequest,
    proto_ledger_pb.LedgerEntry,
    (request: proto_ledger_pb.CreateLedgerEntryRequest) => {
      return request.serializeBinary();
    },
    proto_ledger_pb.LedgerEntry.deserializeBinary
  );

  createLedgerEntry(
    request: proto_ledger_pb.CreateLedgerEntryRequest,
    metadata?: grpcWeb.Metadata | null): Promise<proto_ledger_pb.LedgerEntry>;

  createLedgerEntry(
    request: proto_ledger_pb.CreateLedgerEntryRequest,
    metadata: grpcWeb.Metadata | null,
    callback: (err: grpcWeb.RpcError,
               response: proto_ledger_pb.LedgerEntry) => void): grpcWeb.ClientReadableStream<proto_ledger_pb.LedgerEntry>;

  createLedgerEntry(
    request: proto_ledger_pb.CreateLedgerEntryRequest,
    metadata?: grpcWeb.Metadata | null,
    callback?: (err: grpcWeb.RpcError,
               response: proto_ledger_pb.LedgerEntry) => void) {
    if (callback !== undefined) {
      return this.client_.rpcCall(
        this.hostname_ +
          '/ledgerpb.LedgerService/CreateLedgerEntry',
        request,
        metadata || {},
        this.methodDescriptorCreateLedgerEntry,
        callback);
    }
    return this.client_.unaryCall(
    this.hostname_ +
      '/ledgerpb.LedgerService/CreateLedgerEntry',
    request,
    metadata || {},
    this.methodDescriptorCreateLedgerEntry);
  }

  methodDescriptorUpdateStatus = new grpcWeb.MethodDescriptor(
    '/ledgerpb.LedgerService/UpdateStatus',
    grpcWeb.MethodType.UNARY,
    proto_ledger_pb.UpdateStatusRequest,
    proto_ledger_pb.LedgerEntry,
    (request: proto_ledger_pb.UpdateStatusRequest) => {
      return request.serializeBinary();
    },
    proto_ledger_pb.LedgerEntry.deserializeBinary
  );

  updateStatus(
    request: proto_ledger_pb.UpdateStatusRequest,
    metadata?: grpcWeb.Metadata | null): Promise<proto_ledger_pb.LedgerEntry>;

  updateStatus(
    request: proto_ledger_pb.UpdateStatusRequest,
    metadata: grpcWeb.Metadata | null,
    callback: (err: grpcWeb.RpcError,
               response: proto_ledger_pb.LedgerEntry) => void): grpcWeb.ClientReadableStream<proto_ledger_pb.LedgerEntry>;

  updateStatus(
    request: proto_ledger_pb.UpdateStatusRequest,
    metadata?: grpcWeb.Metadata | null,
    callback?: (err: grpcWeb.RpcError,
               response: proto_ledger_pb.LedgerEntry) => void) {
    if (callback !== undefined) {
      return this.client_.rpcCall(
        this.hostname_ +
          '/ledgerpb.LedgerService/UpdateStatus',
        request,
        metadata || {},
        this.methodDescriptorUpdateStatus,
        callback);
    }
    return this.client_.unaryCall(
    this.hostname_ +
      '/ledgerpb.LedgerService/UpdateStatus',
    request,
    metadata || {},
    this.methodDescriptorUpdateStatus);
  }

  methodDescriptorGetLedgerEntry = new grpcWeb.MethodDescriptor(
    '/ledgerpb.LedgerService/GetLedgerEntry',
    grpcWeb.MethodType.UNARY,
    proto_ledger_pb.GetLedgerRequest,
    proto_ledger_pb.LedgerEntry,
    (request: proto_ledger_pb.GetLedgerRequest) => {
      return request.serializeBinary();
    },
    proto_ledger_pb.LedgerEntry.deserializeBinary
  );

  getLedgerEntry(
    request: proto_ledger_pb.GetLedgerRequest,
    metadata?: grpcWeb.Metadata | null): Promise<proto_ledger_pb.LedgerEntry>;

  getLedgerEntry(
    request: proto_ledger_pb.GetLedgerRequest,
    metadata: grpcWeb.Metadata | null,
    callback: (err: grpcWeb.RpcError,
               response: proto_ledger_pb.LedgerEntry) => void): grpcWeb.ClientReadableStream<proto_ledger_pb.LedgerEntry>;

  getLedgerEntry(
    request: proto_ledger_pb.GetLedgerRequest,
    metadata?: grpcWeb.Metadata | null,
    callback?: (err: grpcWeb.RpcError,
               response: proto_ledger_pb.LedgerEntry) => void) {
    if (callback !== undefined) {
      return this.client_.rpcCall(
        this.hostname_ +
          '/ledgerpb.LedgerService/GetLedgerEntry',
        request,
        metadata || {},
        this.methodDescriptorGetLedgerEntry,
        callback);
    }
    return this.client_.unaryCall(
    this.hostname_ +
      '/ledgerpb.LedgerService/GetLedgerEntry',
    request,
    metadata || {},
    this.methodDescriptorGetLedgerEntry);
  }

  methodDescriptorListLedgerEntries = new grpcWeb.MethodDescriptor(
    '/ledgerpb.LedgerService/ListLedgerEntries',
    grpcWeb.MethodType.UNARY,
    proto_ledger_pb.LedgerFilter,
    proto_ledger_pb.LedgerList,
    (request: proto_ledger_pb.LedgerFilter) => {
      return request.serializeBinary();
    },
    proto_ledger_pb.LedgerList.deserializeBinary
  );

  listLedgerEntries(
    request: proto_ledger_pb.LedgerFilter,
    metadata?: grpcWeb.Metadata | null): Promise<proto_ledger_pb.LedgerList>;

  listLedgerEntries(
    request: proto_ledger_pb.LedgerFilter,
    metadata: grpcWeb.Metadata | null,
    callback: (err: grpcWeb.RpcError,
               response: proto_ledger_pb.LedgerList) => void): grpcWeb.ClientReadableStream<proto_ledger_pb.LedgerList>;

  listLedgerEntries(
    request: proto_ledger_pb.LedgerFilter,
    metadata?: grpcWeb.Metadata | null,
    callback?: (err: grpcWeb.RpcError,
               response: proto_ledger_pb.LedgerList) => void) {
    if (callback !== undefined) {
      return this.client_.rpcCall(
        this.hostname_ +
          '/ledgerpb.LedgerService/ListLedgerEntries',
        request,
        metadata || {},
        this.methodDescriptorListLedgerEntries,
        callback);
    }
    return this.client_.unaryCall(
    this.hostname_ +
      '/ledgerpb.LedgerService/ListLedgerEntries',
    request,
    metadata || {},
    this.methodDescriptorListLedgerEntries);
  }

}

