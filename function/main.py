import datetime
import socket
import ssl

def ssl_cert_check_handler(event, context):
    hostname = "fearless.tech"

    ssl_date_fmt = r'%b %d %H:%M:%S %Y %Z'

    context = ssl.create_default_context()
    conn = context.wrap_socket(
        socket.socket(socket.AF_INET),
        server_hostname=hostname,
    )
    # 3 second timeout because Lambda has runtime limitations
    conn.settimeout(3.0)

    conn.connect((hostname, 443))
    ssl_info = conn.getpeercert()
    expires = datetime.datetime.strptime(ssl_info['notAfter'], ssl_date_fmt)

    return expires > datetime.datetime.utcnow()