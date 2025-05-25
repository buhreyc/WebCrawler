# Web Crawler
**Brey-Michael Ching**  
Coded in Python

**Description:**  
This project implements a secure web crawler that interacts with a simulated social network: Fakebook using raw HTTP/1.1 over TLS (HTTPS). The goal is to crawl the website, follow internal links, manage sessions via cookies, and extract 5 unique secret flags hidden throughout the site. The crawler mimics the behavior of modern web scrapers and without the use of high-level HTTP libraries such as `requests` or `urllib`.

## High-Level Approach
1. **TLS + Socket Setup**:  
   - The crawler uses Python's `socket` and `ssl` modules to establish a secure connection over port 443.

2. **HTTP/1.1 Client Implementation**:  
   - Raw HTTP/1.1 requests are manually constructed for both `GET` and `POST` operations.
   - The crawler handles status codes such as 200, 302, 403, 404, and 503.
   - Special logic is implemented to parse chunked responses and handle redirections.

3. **Login Mechanism**:  
   - Logs in via a POST form with CSRF protection.
   - Extracts and maintains session cookies required for authentication across all further requests.

4. **Crawling and Parsing**:  
   - Begins at the Fakebook homepage and performs a breadth-first crawl across internal links.
   - HTML is parsed using Python's `html.parser` to extract both hyperlinks and flags.
   - The crawler only follows links on the Fakebook domain and avoids logout links to preserve session state.

5. **Flag Detection**:  
   - Flags are detected by searching for:
     ```html
     <h3 class='secret_flag' style="color:red">FLAG: 64charstring</h3>
     ```
   - The script prints exactly five flags to STDOUT and exits.

## Challenges Faced

### 1. Cookie and Session Management
- Handling raw `Set-Cookie` headers and merging them correctly without helper libraries like `requests` was one of the hardest parts. I initially had issues with duplicate `csrftoken` values which broke login sessions mid-crawl.

### 2. Preventing Logout and Redirection Loops
- Accidentally crawling the `/accounts/logout/` link caused my session to break. I fixed this by filtering out any paths matching that pattern during traversal.

### 3. Manual HTTP Parsing
- Parsing raw HTTP responses (headers, cookies, chunked encoding) was tricky. I had to write logic to handle multi-header keys like `Set-Cookie` and to manually reconstruct the body when chunked transfer encoding was used.

## Error Handling & Edge Cases

- **302 Redirects**: Automatically follows redirects using the `Location` header.
- **503 Service Unavailable**: Retries the request up to 3 times before giving up.
- **403/404 Responses**: Skips these URLs and continues crawling.
- **Login Failures**: Ensures CSRF token is extracted and included in the POST login request.
- **Session Drop Prevention**: Avoids crawling `/accounts/logout/` to maintain login session.

## Running the Program

```sh
./crawler <username> <password>
