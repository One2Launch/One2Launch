import { Size } from "@/types";

const baseUrl = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3001'
const URL = `${baseUrl}/sizes`

const getSizes = async (): Promise<Size[]> => {
  const res = await fetch(URL);
  return res.json();
}

export default getSizes;