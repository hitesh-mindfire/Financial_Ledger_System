import React, { useEffect, useState } from 'react';
import { TransactionServiceClient } from '../proto/TransactionServiceClientPb';
import { TxnFilter, TxnList1, TransactionUpdateResponse } from '../proto/transaction_pb';
import * as grpcWeb from 'grpc-web';
import { Card, CardContent, CardHeader, CardTitle } from './ui/Card';

// interface TransactionListProps {
//   transactionsUpdated: boolean;
// }

const TransactionList: React.FC = () => {
  const [transactions, setTransactions] = useState<TransactionUpdateResponse.AsObject[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  const client = new TransactionServiceClient('http://localhost:8080');
  const fetchTransactions = async () => {
    const cardData = JSON.parse(localStorage.getItem('cardData') || 'null');

    if (!cardData || !cardData.id) {
      setError('No transactions available');
      setLoading(false);
      return;
    }

    try {
      const response = await listTransactions(cardData.id);
      setTransactions(response.getTransactionsList().map((txn) => txn.toObject()));
    } catch (err) {
      setError('Failed to load transactions');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchTransactions();
  }, []); // Only run on mount

  const listTransactions = async (cardId: string): Promise<TxnList1> => {
    return new Promise((resolve, reject) => {
      const txnFilter = new TxnFilter();
      txnFilter.setCardId(cardId);

      client.listTransactions(txnFilter, {}, (err: grpcWeb.RpcError, response: TxnList1) => {
        if (err) {
          reject(err);
        } else {
          resolve(response);
        }
      });
    });
  };


  const getStatusColor = (status: string): string => {
    switch (status.toLowerCase()) {
      case 'completed':
        return 'text-green-600';
      case 'pending':
        return 'text-yellow-600';
      case 'success':
        return 'text-blue-600';
      default:
        return 'text-gray-600';
    }
  };

  const getAmountColor = (type: string): string => {
    return type === 'CREDIT' ? 'text-green-600' : 'text-red-600';
  };

  if (loading) return <div>Loading...</div>;
  if (error) return     <div className="grid gap-4 grid-cols-1 md:grid-cols-1 lg:grid-cols-1 mt-5 mb-5">
  <Card className="col-span-4">
    <CardHeader>
      <CardTitle className="text-indigo-950">Transaction History</CardTitle>
    </CardHeader>
    <CardContent className="pl-2">
      <div className="overflow-x-auto">
        <table className="min-w-full">
          <thead>
            <tr className="border-b">
              <th className="py-3 px-4 text-left text-sm font-medium text-gray-600 w-32">Date</th>
              <th className="py-3 px-4 text-left text-sm font-medium text-gray-600 w-1/2">Card Id</th>
              <th className="py-3 px-4 text-left text-sm font-medium text-gray-600 w-32">Amount</th>
              <th className="py-3 px-4 text-left text-sm font-medium text-gray-600 w-32">Type</th>
              <th className="py-3 px-4 text-left text-sm font-medium text-gray-600 w-32">Status</th>
            </tr>
          </thead>
          <tbody>
              <tr>
                <td colSpan={5} className="py-4 px-4 text-center text-sm text-gray-500">
                  No transactions available
                </td>
              </tr>
        
          </tbody>
        </table>
      </div>
    </CardContent>
  </Card>
</div>;

  return (
    <div className="grid gap-4 grid-cols-1 md:grid-cols-1 lg:grid-cols-1 mt-5 mb-5">
      <Card className="col-span-4">
        <CardHeader>
          <CardTitle className="text-indigo-950">Transaction History</CardTitle>
        </CardHeader>
        <CardContent className="pl-2">
          <div className="overflow-x-auto">
            <table className="min-w-full">
              <thead>
                <tr className="border-b">
                  <th className="py-3 px-4 text-left text-sm font-medium text-gray-600 w-32">Date</th>
                  <th className="py-3 px-4 text-left text-sm font-medium text-gray-600 w-1/2">Card Id</th>
                  <th className="py-3 px-4 text-left text-sm font-medium text-gray-600 w-32">Amount</th>
                  <th className="py-3 px-4 text-left text-sm font-medium text-gray-600 w-32">Type</th>
                  <th className="py-3 px-4 text-left text-sm font-medium text-gray-600 w-32">Status</th>
                </tr>
              </thead>
              <tbody>
                {transactions.length > 0 ? (
                  transactions.map((txn) => (
                    <tr key={txn.id} className="border-b hover:bg-gray-50">
                      <td className="py-4 px-4 text-sm text-gray-700">
                        {new Date(txn.createdAt).toLocaleDateString()}
                      </td>
                      <td className="py-4 px-4 text-sm text-gray-700">{txn.cardId}</td>
                      <td className={`py-4 px-4 text-sm font-medium ${getAmountColor(txn.type)}`}>
                        {txn.amount}
                      </td>
                      <td className="py-4 px-4 text-sm font-medium ">
                        {txn.type}
                      </td>
                      <td className={`py-4 px-4 text-sm font-medium ${getStatusColor(txn.status)}`}>
                        {txn.status}
                      </td>
                    </tr>
                  ))
                ) : (
                  <tr>
                    <td colSpan={5} className="py-4 px-4 text-center text-sm text-gray-500">
                      No transactions available
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        </CardContent>
      </Card>
    </div>
  );
};

export default TransactionList;
