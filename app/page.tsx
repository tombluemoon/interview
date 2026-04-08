import { listCategories, listQuestions } from "@/modules/question-bank/question-bank.service";
import QuestionBankClient from "./QuestionBankClient";

export const dynamic = "force-dynamic";

export default async function Home() {
  const questions = await listQuestions();
  const categories = await listCategories();

  return <QuestionBankClient categories={categories} questions={questions} />;
}
