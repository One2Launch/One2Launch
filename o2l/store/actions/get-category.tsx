import { Category } from "@/types";

const baseUrl = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3001'
const URL = `${baseUrl}/categories`

const getCategory = async (id: string): Promise<Category> => {
  const res = await fetch(`${URL}/${id}`);
  return res.json();
}

export default getCategory;