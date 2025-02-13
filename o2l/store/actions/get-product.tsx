import { Product } from "@/types";

const baseUrl = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3001'
const URL = `${baseUrl}/products`

const getProduct = async (id: string): Promise<Product> => {
  const res = await fetch(`${URL}/${id}`);
  return res.json();
}

export default getProduct;