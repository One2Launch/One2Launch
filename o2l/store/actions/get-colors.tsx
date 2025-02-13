import { Color } from "@/types";

const baseUrl = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3001'
const URL = `${baseUrl}/colors`

const getColors = async (): Promise<Color[]> => {
  const res = await fetch(URL);
  return res.json();
}

export default getColors;