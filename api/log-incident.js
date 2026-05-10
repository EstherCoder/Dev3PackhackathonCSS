// api/log-incident.js
import {
  Connection,
  Keypair,
  Transaction,
  TransactionInstruction,
  PublicKey,
  sendAndConfirmTransaction,
} from "@solana/web3.js";

// Solana's official Memo Program address — this is public, not a secret
const MEMO_PROGRAM_ID = new PublicKey(
  "MemoSq4gqABAXKb96qnH8TysNcWxMyWCqXgDLGmfcHr"
);

export default async function handler(req, res) {
  // Only allow POST requests
  if (req.method !== "POST") {
    return res.status(405).json({ error: "Method not allowed" });
  }

  try {
    const { incidentId, latitude, longitude, type } = req.body;

    if (!incidentId) {
      return res.status(400).json({ error: "incidentId is required" });
    }

    // Load your wallet from the environment variable (set in Step 5)
    // This is the [12,45,189,...] array you copied from your keypair file
    const secretKeyArray = JSON.parse(process.env.SOLANA_PRIVATE_KEY);
    const wallet = Keypair.fromSecretKey(Uint8Array.from(secretKeyArray));

    // Connect to Solana devnet
    const connection = new Connection(
      "https://api.devnet.solana.com",
      "confirmed"
    );

    // Build the memo string — this is what gets stored permanently on-chain
    const memoText = `CAMPUS-SHIELD|type:${type || "SOS"}|id:${incidentId}|lat:${latitude}|lng:${longitude}|ts:${Date.now()}`;

    // Build the transaction with a Memo instruction
    const transaction = new Transaction().add(
      new TransactionInstruction({
        keys: [
          {
            pubkey: wallet.publicKey,
            isSigner: true,
            isWritable: false,
          },
        ],
        programId: MEMO_PROGRAM_ID,
        data: Buffer.from(memoText, "utf-8"),
      })
    );

    // Sign and send the transaction — this returns a real signature hash
    const signature = await sendAndConfirmTransaction(
      connection,
      transaction,
      [wallet],
      { commitment: "confirmed" }
    );

    // Return the signature and a link to view it on Solana Explorer
    return res.status(200).json({
      signature,
      explorerUrl: `https://explorer.solana.com/tx/${signature}?cluster=devnet`,
    });

  } catch (error) {
    console.error("Solana transaction failed:", error);
    return res.status(500).json({ error: error.message });
  }
}