import { JWT } from "npm:google-auth-library@9";
import { createClient } from "npm:@supabase/supabase-js@2";

interface Expense {
  id: string;
  user_id: string;
  expense_type: string;
  amount: string;
}

interface WebhookPayload {
  type: "INSERT";
  table: string;
  record: Expense;
  schema: "sugar";
  old_record: null | Expense;
}

const supabase = createClient(
  "https://hcttbvnryoqdwfvmbbnn.supabase.co",
  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhjdHRidm5yeW9xZHdmdm1iYm5uIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTcyNzUyMjUxOSwiZXhwIjoyMDQzMDk4NTE5fQ.sy4NWQcCV-Oqv9uCnmzS0nUZ2UCb4sgutyt6_QDTeZ8",
  { db: { schema: "sugar" } },
);

Deno.serve(async (req) => {
  const payload = await req.json();
  console.log("payload", payload);
  const { data: userData } = await supabase.from("user_data").select(
    "partner_id, user_type",
  )
    .eq(
      "user_id",
      payload.record.user_id,
    ).single();

  console.log("data", userData);

  if (!userData!.partner_id) {
    return new Response(JSON.stringify(userData), {
      headers: { "content-type": "application/json" },
    });
  }
  const { data: partnerData } = await supabase.from("user_data").select(
    "fcm_token",
  )
    .eq("user_id", userData!.partner_id).single();

  const fcmToken = partnerData!.fcm_token as string;
  const { default: serviceAccount } = await import(
    "../service-account.json",
    { with: { type: "json" } }
  );

  const accessToken = await getAccessToken({
    clientEmail: serviceAccount.client_email,
    privateKey: serviceAccount.private_key,
  });

  const item = payload.record.expense_type
    .replace(/_/g, " ")
    .toLowerCase()
    .replace(/\b\w/g, (char: string) => char.toUpperCase());
  const res = await fetch(
    `https://fcm.googleapis.com/v1/projects/${serviceAccount.project_id}/messages:send`,
    {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${accessToken}`,
      },
      body: JSON.stringify({
        message: {
          token: fcmToken,
          notification: {
            title: `Your ${
              userData!.user_type.toLowerCase()
            } has added an expense`,
            body: `They spent PHP ${payload.record.amount} on ${item}`,
          },
        },
      }),
    },
  );

  const resData = await res.json();
  if (res.status < 200 || 299 < res.status) {
    throw resData;
  }

  return new Response(JSON.stringify(partnerData), {
    headers: { "content-type": "application/json" },
  });
});

const getAccessToken = (
  { clientEmail, privateKey }: { clientEmail: string; privateKey: string },
): Promise<string> => {
  return new Promise((resolve, reject) => {
    const jwtClient = new JWT({
      email: clientEmail,
      key: privateKey,
      scopes: ["https://www.googleapis.com/auth/firebase.messaging"],
    });
    jwtClient.authorize((err, tokens) => {
      if (err) {
        reject(err);
        return;
      }
      resolve(tokens!.access_token!);
    });
  });
};
