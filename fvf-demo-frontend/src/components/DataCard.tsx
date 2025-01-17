import { useState, useEffect } from "react";
import { Card, CardHeader, CardContent, CardTitle } from "./ui/Card";
import * as grpcWeb from "grpc-web";
import { CardServiceClient } from "../proto/CardServiceClientPb";
import {
  Card as CardProto,
  IssueCardRequest,
  CardResponse,
  GetBalanceRequest,
} from "../proto/card_pb";
import {
  Dialog,
  DialogTrigger,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from "./ui/DIalog";
import { TransactionServiceClient } from "../proto/TransactionServiceClientPb";
import { CreateTxnRequest } from "../proto/transaction_pb";
import { TxnFilter, TxnList1 } from "../proto/transaction_pb";

// Instantiate the gRPC client
const cardService = new CardServiceClient("http://localhost:8080", null, null);
const transactionService = new TransactionServiceClient(
  "http://localhost:8080"
);

// Interface for CardTemplate props
interface CardTemplateProps {
  isTemplate: boolean;
}

// Interface for the main DataCard component props (if needed to extend in future)
interface DataCardProps {
  onTransactionsUpdated: () => void;
}

const DataCard: React.FC<DataCardProps> = ({ onTransactionsUpdated }) => {
  const [isCardIssued, setIsCardIssued] = useState<boolean>(false);
  const [cardData, setCardData] = useState<CardProto.AsObject | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [amount, setAmount] = useState<number>(0);
  const [debitTotal, setDebitTotal] = useState<number>(0);
  const [balance, setBalance] = useState<string | null>("0");
  const [loading, setLoading] = useState<boolean>(true);
  const [isCreditDialogOpen, setIsCreditDialogOpen] = useState<boolean>(false);
  const [isDebitDialogOpen, setIsDebitDialogOpen] = useState<boolean>(false);

  // Load the initial state from localStorage if it exists
  useEffect(() => {
    const storedCardData = localStorage.getItem("cardData");
    const storedCardIssued = localStorage.getItem("isCardIssued");

    if (storedCardData && storedCardIssued) {
      setCardData(JSON.parse(storedCardData));
      setIsCardIssued(JSON.parse(storedCardIssued));
    }
    fetchBalance();
    fetchDebitTotal();
  }, []);

  const fetchBalance = () => {
    const storedCardData = localStorage.getItem("cardData");
    if (!storedCardData) {
      setLoading(false);
      return;
    }
    const cardData = JSON.parse(storedCardData);
    const request = new GetBalanceRequest();
    request.setCardId(cardData.id);

    cardService.getBalance(request, {}, (err, response) => {
      if (err) {
        setError("Failed to fetch balance");
        setLoading(false);
      } else {
        const currentBalance = response?.getCurrentBalance();
        setBalance(currentBalance);
        setLoading(false);
      }
    });
  };

  const handleIssueCard = () => {
    // Create the request object
    const request = new IssueCardRequest();
    request.setUserId("newUser");
    request.setCreditLimit("10000");

    // Make the gRPC request to issue a card
    cardService.issueCard(
      request,
      {},
      (err: grpcWeb.RpcError | null, response: CardResponse | null) => {
        if (err) {
          setError(`Error: ${err.message}`);
          console.log(err, "abc");
          return;
        }

        if (response) {
          const cardData = response.toObject();
          console.log(cardData);
          setCardData(cardData);
          setIsCardIssued(true);
          setError(null); // Clear any previous errors

          // Store the updated card data and card issued state in localStorage
          localStorage.setItem("cardData", JSON.stringify(cardData));
          localStorage.setItem("isCardIssued", JSON.stringify(true));
          fetchBalance();
          onTransactionsUpdated();
        }
      }
    );
  };
  // Extract seconds and nanos from the string
  const regex = /seconds:(\d+) nanos:(\d+)/;
  const match = cardData?.expiryDate.match(/seconds:(\d+)\s+nanos:(\d+)/);
  let formattedDate = "MM/YY"; // Default value

  if (match) {
    const seconds = parseInt(match[1], 10); // Extracted seconds
    const nanos = parseInt(match[2], 10); // Extracted nanos (not used in this example)

    // Convert seconds to milliseconds
    const expiryDateMillis = seconds * 1000;

    // Create a JavaScript Date object
    const date = new Date(expiryDateMillis);
    const timestamp = new Date(seconds * 1000 + nanos / 1e6); // Convert to milliseconds

    formattedDate = timestamp
      .toLocaleDateString("en-GB", { month: "2-digit", year: "2-digit" })
      .replace("/", "/");
  }

  const handleTransaction = (transactionType: "CREDIT" | "DEBIT") => {
    if (!cardData) {
      setError("Card data is missing.");
      return;
    }

    const request = new CreateTxnRequest();
    request.setCardId(cardData.id);
    request.setMerchantId("merchant1"); // Hardcoded merchant ID as requested
    request.setAmount(amount.toString());
    request.setCurrency("INR");
    request.setType(transactionType);

    transactionService.createTransaction(request, {}, (err, response) => {
      if (!!err) {
        // Show an alert for the error and close the modal
        alert(`Error: ${err.message}`);

        // Map the error message to a user-friendly one if needed
        setError(err.message);
      } else {
        setError("");
        alert(
          `${
            transactionType.charAt(0).toUpperCase() + transactionType.slice(1)
          } transaction successful!`
        );
        fetchBalance();
        fetchDebitTotal();
      }

      onTransactionsUpdated();

      if (transactionType === "CREDIT") {
        setIsCreditDialogOpen(false);
      } else if (transactionType === "DEBIT") {
        setIsDebitDialogOpen(false);
      }
    });
  };

  const fetchDebitTotal = async () => {
    const storedCardData = localStorage.getItem("cardData");
    if (!storedCardData) {
      // console.error("No card data found in local storage.");
      setDebitTotal(0);
      return;
    }

    const cardData = JSON.parse(storedCardData);
    const txnFilter = new TxnFilter();
    txnFilter.setCardId(cardData.id);
    txnFilter.setStatus("success");

    transactionService.listTransactions(
      txnFilter,
      {},
      (err: grpcWeb.RpcError, response: TxnList1) => {
        if (err) {
          console.error("Failed to fetch transactions", err);
          return;
        }

        const transactions = response.getTransactionsList();
        const debitAmount = transactions
          .filter((txn) => txn.getType() === "DEBIT")
          .reduce((sum, txn) => sum + parseFloat(txn.getAmount()), 0);
        setDebitTotal(debitAmount);
      }
    );
  };
  const CardTemplate: React.FC<CardTemplateProps> = ({ isTemplate }) => (
    <Card
      className={`md:row-span-2 ${
        isTemplate
          ? "bg-gradient-to-br from-gray-400 to-gray-600"
          : "bg-gradient-to-br from-indigo-600 to-purple-700"
      } text-white cursor-pointer hover:shadow-xl transition-shadow relative overflow-hidden`}
    >
      {isTemplate && (
        <div className="absolute inset-0 flex items-center justify-center bg-black/30">
          <button
            onClick={handleIssueCard}
            className="bg-white text-indigo-600 px-6 py-3 rounded-lg font-semibold hover:bg-indigo-50 transition-colors flex items-center space-x-2"
            type="button"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              className="h-5 w-5"
              viewBox="0 0 20 20"
              fill="currentColor"
            >
              <path
                fillRule="evenodd"
                d="M10 5a1 1 0 011 1v3h3a1 1 0 110 2h-3v3a1 1 0 11-2 0v-3H6a1 1 0 110-2h3V6a1 1 0 011-1z"
                clipRule="evenodd"
              />
            </svg>
            <span>Issue New Card</span>
          </button>
        </div>
      )}
      <CardContent className="p-6 h-full flex flex-col justify-between min-h-[280px]">
        <div>
          <div className="flex justify-between items-center mb-8">
            <div className="w-12 h-8 bg-gradient-to-br from-yellow-400 to-yellow-200 rounded-md"></div>
            <svg
              xmlns="http://www.w3.org/2000/svg"
              className="h-8 w-8 opacity-75"
              viewBox="0 0 24 24"
              fill="currentColor"
            >
              <path d="M20 4H4c-1.103 0-2 .897-2 2v12c0 1.103.897 2 2 2h16c1.103 0 2-.897 2-2V6c0-1.103-.897-2-2-2zM4 6h16v2H4V6zm16 12H4v-7h16v7z" />
            </svg>
          </div>
          <div className="text-xl tracking-[4px] mb-8 font-mono">
            {isTemplate
              ? "XXXX XXXX XXXX XXXX"
              : cardData?.cardNumber || "4532 •••• •••• 1234"}
          </div>
        </div>
        <div className="flex justify-between">
          <div>
            <div className="text-xs opacity-75 mb-1">EXPIRES</div>
            <div className="font-medium mb-4">
              {isTemplate ? "MM/YY" : formattedDate || "12/25"}
            </div>
          </div>
          <div>
            <div className="text-xs opacity-75 mb-1">CVV</div>
            <div className="font-medium">
              {isTemplate ? "XXX" : cardData?.cvv || "123"}
            </div>
          </div>
        </div>
      </CardContent>
    </Card>
  );

  return (
    <div className="space-y-4">
      <div className="grid gap-4 md:grid-cols-3">
        <CardTemplate isTemplate={!isCardIssued} />

        {/* Balance Card */}
        <Card className="cursor-pointer hover:shadow-md transition-shadow">
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium text-indigo-950">
              Balance
            </CardTitle>
            <svg
              xmlns="http://www.w3.org/2000/svg"
              width="24"
              height="24"
              viewBox="0 0 24 24"
            >
              <path d="M21 4H3a1 1 0 0 0-1 1v14a1 1 0 0 0 1 1h18a1 1 0 0 0 1-1V5a1 1 0 0 0-1-1zm-1 11a3 3 0 0 0-3 3H7a3 3 0 0 0-3-3V9a3 3 0 0 0 3-3h10a3 3 0 0 0 3 3v6z"></path>
              <path d="M12 8c-2.206 0-4 1.794-4 4s1.794 4 4 4 4-1.794 4-4-1.794-4-4-4zm0 6c-1.103 0-2-.897-2-2s.897-2 2-2 2 .897 2 2-.897 2-2 2z"></path>
            </svg>
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{balance}</div>
            <div className="flex mt-4 space-x-2">
              <Dialog
                open={isCreditDialogOpen}
                onOpenChange={setIsCreditDialogOpen}
              >
                <DialogTrigger asChild>
                  <button
                    className="bg-green-600 text-white px-3 py-1 rounded-lg hover:bg-green-700"
                    type="button"
                    disabled={!isCardIssued}
                  >
                    Credit
                  </button>
                </DialogTrigger>
                <DialogContent>
                  <DialogHeader>
                    <DialogTitle>Credit Transaction</DialogTitle>
                    <DialogDescription asChild>
                      <div>
                        <input
                          type="number"
                          placeholder="Amount"
                          onChange={(e) => setAmount(Number(e.target.value))}
                          className="px-6 py-3 rounded-lg font-semibold flex items-center space-x-2 mb-3"
                        />
                      </div>
                      <button
                        onClick={() => handleTransaction("CREDIT")}
                        className=" bg-indigo-600 px-6 py-3 rounded-lg font-semibold flex items-center space-x-2"
                        type="button"
                      >
                        Confirm Payment
                      </button>
                    </DialogDescription>
                  </DialogHeader>
                </DialogContent>
              </Dialog>
              <Dialog
                open={isDebitDialogOpen}
                onOpenChange={setIsDebitDialogOpen}
              >
                <DialogTrigger asChild>
                  <button
                    className="bg-red-600 text-white px-3 py-1 rounded-lg hover:bg-red-700"
                    type="button"
                    disabled={!isCardIssued}
                  >
                    Debit
                  </button>
                </DialogTrigger>
                <DialogContent>
                  <DialogHeader>
                    <DialogTitle>Debit Transaction</DialogTitle>
                    <DialogDescription asChild>
                      <div>
                        <input
                          type="number"
                          placeholder="Amount"
                          className=" px-6 py-3 rounded-lg font-semibold flex items-center space-x-2  mb-3"
                          onChange={(e) => setAmount(Number(e.target.value))}
                        />
                      </div>
                      <button
                        onClick={() => handleTransaction("DEBIT")}
                        className=" bg-indigo-600 px-6 py-3 rounded-lg font-semibold flex items-center space-x-2"
                      >
                        Confirm Payment
                      </button>
                    </DialogDescription>
                  </DialogHeader>
                </DialogContent>
              </Dialog>
            </div>
          </CardContent>
        </Card>

        {/* Status Card */}
        <Card className="cursor-pointer hover:shadow-md transition-shadow">
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium text-indigo-950">
              Status
            </CardTitle>
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              strokeLinecap="round"
              strokeLinejoin="round"
              strokeWidth="2"
              className="h-4 w-4 text-muted-foreground"
            >
              <path d="M22 12h-4l-3 9L9 3l-3 9H2" />
            </svg>
          </CardHeader>
          <CardContent>
            <div className="flex items-center space-x-2">
              <div
                className={`h-3 w-3 rounded-full ${
                  isCardIssued ? "bg-green-500 animate-pulse" : "bg-gray-300"
                }`}
              />
              <div className="text-sm">
                {isCardIssued ? "Active" : "Inactive"}
              </div>
            </div>
          </CardContent>
        </Card>
        {/* Credited Amount Card */}
        <Card className="cursor-pointer hover:shadow-md transition-shadow">
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium text-indigo-950">
              Credit Limit
            </CardTitle>
            <svg
              xmlns="http://www.w3.org/2000/svg"
              width="24"
              height="24"
              viewBox="0 0 24 24"
              className="h-4 w-4 text-muted-foreground"
            >
              <path d="M20 3H5C3.346 3 2 4.346 2 6v12c0 1.654 1.346 3 3 3h15c1.103 0 2-.897 2-2V5c0-1.103-.897-2-2-2zM5 19c-.552 0-1-.449-1-1V6c0-.551.448-1 1-1h15v3h-6c-1.103 0-2 .897-2 2v4c0 1.103.897 2 2 2h6.001v3H5zm15-9v4h-6v-4h6z"></path>
            </svg>
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">
              {cardData?.creditLimit || "0"}
            </div>
          </CardContent>
        </Card>

        {/* Debited Amount Card */}
        <Card className="cursor-pointer hover:shadow-md transition-shadow">
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium text-indigo-950">
              Debited Amount
            </CardTitle>
            <svg
              xmlns="http://www.w3.org/2000/svg"
              width="24"
              height="24"
              viewBox="0 0 24 24"
              className="h-4 w-4 text-muted-foreground"
            >
              <path d="M12 15c-1.84 0-2-.86-2-1H8c0 .92.66 2.55 3 2.92V18h2v-1.08c2-.34 3-1.63 3-2.92 0-1.12-.52-3-4-3-2 0-2-.63-2-1s.7-1 2-1 1.39.64 1.4 1h2A3 3 0 0 0 13 7.12V6h-2v1.09C9 7.42 8 8.71 8 10c0 1.12.52 3 4 3 2 0 2 .68 2 1s-.62 1-2 1z"></path>
              <path d="M5 2H2v2h2v17a1 1 0 0 0 1 1h14a1 1 0 0 0 1-1V4h2V2H5zm13 18H6V4h12z"></path>
            </svg>
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{debitTotal}</div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
};

export default DataCard;
