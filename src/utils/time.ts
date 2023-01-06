export function nowTimeString() {
  return new Date().toLocaleString().replaceAll('/', '-')
}