// Code generated by protoc-gen-go-grpc. DO NOT EDIT.
// versions:
// - protoc-gen-go-grpc v1.5.1
// - protoc             v5.28.3
// source: proto/card.proto

package card_proto

import (
	context "context"
	grpc "google.golang.org/grpc"
	codes "google.golang.org/grpc/codes"
	status "google.golang.org/grpc/status"
)

// This is a compile-time assertion to ensure that this generated file
// is compatible with the grpc package it is being compiled against.
// Requires gRPC-Go v1.64.0 or later.
const _ = grpc.SupportPackageIsVersion9

const (
	CardService_IssueCard_FullMethodName            = "/proto.CardService/IssueCard"
	CardService_AuthorizeTransaction_FullMethodName = "/proto.CardService/AuthorizeTransaction"
	CardService_UpdateLimit_FullMethodName          = "/proto.CardService/UpdateLimit"
	CardService_GetBalance_FullMethodName           = "/proto.CardService/GetBalance"
)

// CardServiceClient is the client API for CardService service.
//
// For semantics around ctx use and closing/ending streaming RPCs, please refer to https://pkg.go.dev/google.golang.org/grpc/?tab=doc#ClientConn.NewStream.
type CardServiceClient interface {
	IssueCard(ctx context.Context, in *IssueCardRequest, opts ...grpc.CallOption) (*Card, error)
	AuthorizeTransaction(ctx context.Context, in *AuthRequest, opts ...grpc.CallOption) (*AuthResponse, error)
	UpdateLimit(ctx context.Context, in *UpdateLimitRequest, opts ...grpc.CallOption) (*Card, error)
	GetBalance(ctx context.Context, in *GetBalanceRequest, opts ...grpc.CallOption) (*Balance, error)
}

type cardServiceClient struct {
	cc grpc.ClientConnInterface
}

func NewCardServiceClient(cc grpc.ClientConnInterface) CardServiceClient {
	return &cardServiceClient{cc}
}

func (c *cardServiceClient) IssueCard(ctx context.Context, in *IssueCardRequest, opts ...grpc.CallOption) (*Card, error) {
	cOpts := append([]grpc.CallOption{grpc.StaticMethod()}, opts...)
	out := new(Card)
	err := c.cc.Invoke(ctx, CardService_IssueCard_FullMethodName, in, out, cOpts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *cardServiceClient) AuthorizeTransaction(ctx context.Context, in *AuthRequest, opts ...grpc.CallOption) (*AuthResponse, error) {
	cOpts := append([]grpc.CallOption{grpc.StaticMethod()}, opts...)
	out := new(AuthResponse)
	err := c.cc.Invoke(ctx, CardService_AuthorizeTransaction_FullMethodName, in, out, cOpts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *cardServiceClient) UpdateLimit(ctx context.Context, in *UpdateLimitRequest, opts ...grpc.CallOption) (*Card, error) {
	cOpts := append([]grpc.CallOption{grpc.StaticMethod()}, opts...)
	out := new(Card)
	err := c.cc.Invoke(ctx, CardService_UpdateLimit_FullMethodName, in, out, cOpts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *cardServiceClient) GetBalance(ctx context.Context, in *GetBalanceRequest, opts ...grpc.CallOption) (*Balance, error) {
	cOpts := append([]grpc.CallOption{grpc.StaticMethod()}, opts...)
	out := new(Balance)
	err := c.cc.Invoke(ctx, CardService_GetBalance_FullMethodName, in, out, cOpts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

// CardServiceServer is the server API for CardService service.
// All implementations must embed UnimplementedCardServiceServer
// for forward compatibility.
type CardServiceServer interface {
	IssueCard(context.Context, *IssueCardRequest) (*Card, error)
	AuthorizeTransaction(context.Context, *AuthRequest) (*AuthResponse, error)
	UpdateLimit(context.Context, *UpdateLimitRequest) (*Card, error)
	GetBalance(context.Context, *GetBalanceRequest) (*Balance, error)
	mustEmbedUnimplementedCardServiceServer()
}

// UnimplementedCardServiceServer must be embedded to have
// forward compatible implementations.
//
// NOTE: this should be embedded by value instead of pointer to avoid a nil
// pointer dereference when methods are called.
type UnimplementedCardServiceServer struct{}

func (UnimplementedCardServiceServer) IssueCard(context.Context, *IssueCardRequest) (*Card, error) {
	return nil, status.Errorf(codes.Unimplemented, "method IssueCard not implemented")
}
func (UnimplementedCardServiceServer) AuthorizeTransaction(context.Context, *AuthRequest) (*AuthResponse, error) {
	return nil, status.Errorf(codes.Unimplemented, "method AuthorizeTransaction not implemented")
}
func (UnimplementedCardServiceServer) UpdateLimit(context.Context, *UpdateLimitRequest) (*Card, error) {
	return nil, status.Errorf(codes.Unimplemented, "method UpdateLimit not implemented")
}
func (UnimplementedCardServiceServer) GetBalance(context.Context, *GetBalanceRequest) (*Balance, error) {
	return nil, status.Errorf(codes.Unimplemented, "method GetBalance not implemented")
}
func (UnimplementedCardServiceServer) mustEmbedUnimplementedCardServiceServer() {}
func (UnimplementedCardServiceServer) testEmbeddedByValue()                     {}

// UnsafeCardServiceServer may be embedded to opt out of forward compatibility for this service.
// Use of this interface is not recommended, as added methods to CardServiceServer will
// result in compilation errors.
type UnsafeCardServiceServer interface {
	mustEmbedUnimplementedCardServiceServer()
}

func RegisterCardServiceServer(s grpc.ServiceRegistrar, srv CardServiceServer) {
	// If the following call pancis, it indicates UnimplementedCardServiceServer was
	// embedded by pointer and is nil.  This will cause panics if an
	// unimplemented method is ever invoked, so we test this at initialization
	// time to prevent it from happening at runtime later due to I/O.
	if t, ok := srv.(interface{ testEmbeddedByValue() }); ok {
		t.testEmbeddedByValue()
	}
	s.RegisterService(&CardService_ServiceDesc, srv)
}

func _CardService_IssueCard_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(IssueCardRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(CardServiceServer).IssueCard(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: CardService_IssueCard_FullMethodName,
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(CardServiceServer).IssueCard(ctx, req.(*IssueCardRequest))
	}
	return interceptor(ctx, in, info, handler)
}

func _CardService_AuthorizeTransaction_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(AuthRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(CardServiceServer).AuthorizeTransaction(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: CardService_AuthorizeTransaction_FullMethodName,
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(CardServiceServer).AuthorizeTransaction(ctx, req.(*AuthRequest))
	}
	return interceptor(ctx, in, info, handler)
}

func _CardService_UpdateLimit_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(UpdateLimitRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(CardServiceServer).UpdateLimit(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: CardService_UpdateLimit_FullMethodName,
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(CardServiceServer).UpdateLimit(ctx, req.(*UpdateLimitRequest))
	}
	return interceptor(ctx, in, info, handler)
}

func _CardService_GetBalance_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(GetBalanceRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(CardServiceServer).GetBalance(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: CardService_GetBalance_FullMethodName,
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(CardServiceServer).GetBalance(ctx, req.(*GetBalanceRequest))
	}
	return interceptor(ctx, in, info, handler)
}

// CardService_ServiceDesc is the grpc.ServiceDesc for CardService service.
// It's only intended for direct use with grpc.RegisterService,
// and not to be introspected or modified (even as a copy)
var CardService_ServiceDesc = grpc.ServiceDesc{
	ServiceName: "proto.CardService",
	HandlerType: (*CardServiceServer)(nil),
	Methods: []grpc.MethodDesc{
		{
			MethodName: "IssueCard",
			Handler:    _CardService_IssueCard_Handler,
		},
		{
			MethodName: "AuthorizeTransaction",
			Handler:    _CardService_AuthorizeTransaction_Handler,
		},
		{
			MethodName: "UpdateLimit",
			Handler:    _CardService_UpdateLimit_Handler,
		},
		{
			MethodName: "GetBalance",
			Handler:    _CardService_GetBalance_Handler,
		},
	},
	Streams:  []grpc.StreamDesc{},
	Metadata: "proto/card.proto",
}
