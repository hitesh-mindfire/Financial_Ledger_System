import React,{useState} from "react";
import Transaction from "./components/Transaction";
import DataCard from "./components/DataCard";

const App: React.FC = () => {
  const [transactionKey, setTransactionKey] = useState(0);

  const handleTransactionsUpdated = () => {
    setTransactionKey(prev => prev + 1);
  };
  return (
    <div className="flex-1 space-y-4 p-4 md:p-8 justify-center items-center w-auto">
      <DataCard onTransactionsUpdated={handleTransactionsUpdated} />
      <Transaction key={transactionKey} />
    </div>
  );
};

export default App;

