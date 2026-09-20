'use client';
import {useEffect} from 'react';
export default function Visit(){useEffect(()=>{fetch('/api/visit',{method:'POST',headers:{'Content-Type':'application/json'},body:'{}'}).catch(()=>{});},[]);return null;}
