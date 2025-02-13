import { Category } from "@/types";

const baseUrl = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3001'
const URL = `${baseUrl}/categories`

const getCategories = async (): Promise<Category[]> => {
  const res = await fetch(URL);
  return res.json();
}

export default getCategories;