import * as jspb from 'google-protobuf'

import * as google_protobuf_timestamp_pb from 'google-protobuf/google/protobuf/timestamp_pb'; // proto import: "google/protobuf/timestamp.proto"
import * as google_protobuf_empty_pb from 'google-protobuf/google/protobuf/empty_pb'; // proto import: "google/protobuf/empty.proto"


export class NotificationRequest extends jspb.Message {
  getUserId(): string;
  setUserId(value: string): NotificationRequest;

  getTitle(): string;
  setTitle(value: string): NotificationRequest;

  getMessage(): string;
  setMessage(value: string): NotificationRequest;

  getType(): string;
  setType(value: string): NotificationRequest;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): NotificationRequest.AsObject;
  static toObject(includeInstance: boolean, msg: NotificationRequest): NotificationRequest.AsObject;
  static serializeBinaryToWriter(message: NotificationRequest, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): NotificationRequest;
  static deserializeBinaryFromReader(message: NotificationRequest, reader: jspb.BinaryReader): NotificationRequest;
}

export namespace NotificationRequest {
  export type AsObject = {
    userId: string,
    title: string,
    message: string,
    type: string,
  }
}

export class Notification extends jspb.Message {
  getId(): string;
  setId(value: string): Notification;

  getUserId(): string;
  setUserId(value: string): Notification;

  getTitle(): string;
  setTitle(value: string): Notification;

  getMessage(): string;
  setMessage(value: string): Notification;

  getType(): string;
  setType(value: string): Notification;

  getStatus(): string;
  setStatus(value: string): Notification;

  getCreatedAt(): google_protobuf_timestamp_pb.Timestamp | undefined;
  setCreatedAt(value?: google_protobuf_timestamp_pb.Timestamp): Notification;
  hasCreatedAt(): boolean;
  clearCreatedAt(): Notification;

  getReadAt(): google_protobuf_timestamp_pb.Timestamp | undefined;
  setReadAt(value?: google_protobuf_timestamp_pb.Timestamp): Notification;
  hasReadAt(): boolean;
  clearReadAt(): Notification;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): Notification.AsObject;
  static toObject(includeInstance: boolean, msg: Notification): Notification.AsObject;
  static serializeBinaryToWriter(message: Notification, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): Notification;
  static deserializeBinaryFromReader(message: Notification, reader: jspb.BinaryReader): Notification;
}

export namespace Notification {
  export type AsObject = {
    id: string,
    userId: string,
    title: string,
    message: string,
    type: string,
    status: string,
    createdAt?: google_protobuf_timestamp_pb.Timestamp.AsObject,
    readAt?: google_protobuf_timestamp_pb.Timestamp.AsObject,
  }
}

export class NotificationList extends jspb.Message {
  getNotificationsList(): Array<Notification>;
  setNotificationsList(value: Array<Notification>): NotificationList;
  clearNotificationsList(): NotificationList;
  addNotifications(value?: Notification, index?: number): Notification;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): NotificationList.AsObject;
  static toObject(includeInstance: boolean, msg: NotificationList): NotificationList.AsObject;
  static serializeBinaryToWriter(message: NotificationList, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): NotificationList;
  static deserializeBinaryFromReader(message: NotificationList, reader: jspb.BinaryReader): NotificationList;
}

export namespace NotificationList {
  export type AsObject = {
    notificationsList: Array<Notification.AsObject>,
  }
}

export class WebSocketMessage extends jspb.Message {
  getType(): string;
  setType(value: string): WebSocketMessage;

  getPayload(): Payload | undefined;
  setPayload(value?: Payload): WebSocketMessage;
  hasPayload(): boolean;
  clearPayload(): WebSocketMessage;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): WebSocketMessage.AsObject;
  static toObject(includeInstance: boolean, msg: WebSocketMessage): WebSocketMessage.AsObject;
  static serializeBinaryToWriter(message: WebSocketMessage, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): WebSocketMessage;
  static deserializeBinaryFromReader(message: WebSocketMessage, reader: jspb.BinaryReader): WebSocketMessage;
}

export namespace WebSocketMessage {
  export type AsObject = {
    type: string,
    payload?: Payload.AsObject,
  }
}

export class Payload extends jspb.Message {
  getId(): string;
  setId(value: string): Payload;

  getTimestamp(): google_protobuf_timestamp_pb.Timestamp | undefined;
  setTimestamp(value?: google_protobuf_timestamp_pb.Timestamp): Payload;
  hasTimestamp(): boolean;
  clearTimestamp(): Payload;

  getData(): string;
  setData(value: string): Payload;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): Payload.AsObject;
  static toObject(includeInstance: boolean, msg: Payload): Payload.AsObject;
  static serializeBinaryToWriter(message: Payload, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): Payload;
  static deserializeBinaryFromReader(message: Payload, reader: jspb.BinaryReader): Payload;
}

export namespace Payload {
  export type AsObject = {
    id: string,
    timestamp?: google_protobuf_timestamp_pb.Timestamp.AsObject,
    data: string,
  }
}

export class GetUserNotificationsRequest extends jspb.Message {
  getUserId(): string;
  setUserId(value: string): GetUserNotificationsRequest;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): GetUserNotificationsRequest.AsObject;
  static toObject(includeInstance: boolean, msg: GetUserNotificationsRequest): GetUserNotificationsRequest.AsObject;
  static serializeBinaryToWriter(message: GetUserNotificationsRequest, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): GetUserNotificationsRequest;
  static deserializeBinaryFromReader(message: GetUserNotificationsRequest, reader: jspb.BinaryReader): GetUserNotificationsRequest;
}

export namespace GetUserNotificationsRequest {
  export type AsObject = {
    userId: string,
  }
}

export class MarkAsReadRequest extends jspb.Message {
  getNotificationId(): string;
  setNotificationId(value: string): MarkAsReadRequest;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): MarkAsReadRequest.AsObject;
  static toObject(includeInstance: boolean, msg: MarkAsReadRequest): MarkAsReadRequest.AsObject;
  static serializeBinaryToWriter(message: MarkAsReadRequest, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): MarkAsReadRequest;
  static deserializeBinaryFromReader(message: MarkAsReadRequest, reader: jspb.BinaryReader): MarkAsReadRequest;
}

export namespace MarkAsReadRequest {
  export type AsObject = {
    notificationId: string,
  }
}

export class SubscribeToUserEventsRequest extends jspb.Message {
  getUserId(): string;
  setUserId(value: string): SubscribeToUserEventsRequest;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): SubscribeToUserEventsRequest.AsObject;
  static toObject(includeInstance: boolean, msg: SubscribeToUserEventsRequest): SubscribeToUserEventsRequest.AsObject;
  static serializeBinaryToWriter(message: SubscribeToUserEventsRequest, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): SubscribeToUserEventsRequest;
  static deserializeBinaryFromReader(message: SubscribeToUserEventsRequest, reader: jspb.BinaryReader): SubscribeToUserEventsRequest;
}

export namespace SubscribeToUserEventsRequest {
  export type AsObject = {
    userId: string,
  }
}

