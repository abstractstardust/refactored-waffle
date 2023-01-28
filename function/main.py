import datetime
import socket
import ssl
import json


def ssl_cert_check_handler():
    # bad hosts
    # hostname = "expired.badssl.com"
    # hostname = "wrong.host.badssl.com"
    # hostname = "self-signed.badssl.com"
    # hostname = "untrusted-root.badssl.com"
    # hostname = "revoked.badssl.com"

    # good hosts
    hostname = "https-everywhere.badssl.com"

    ssl_date_fmt = r'%b %d %H:%M:%S %Y %Z'

    context = ssl.create_default_context()
    conn = context.wrap_socket(
        socket.socket(socket.AF_INET),
        server_hostname=hostname,
    )

    # 3 second timeout because Lambda has runtime limitations
    conn.settimeout(3.0)

    try:
        # connect to a server
        conn.connect((hostname, 443))
    except Exception as HostConnectionError:
        res = {
            "domain": hostname,
            "is_valid": (False, HostConnectionError.args[1])
        }
    else:
        try:
            ssl_info = conn.getpeercert()

            expires = datetime.datetime.strptime(
                ssl_info['notAfter'], ssl_date_fmt)
            valid = expires > datetime.datetime.utcnow()
            time_until_expiration = expires - datetime.datetime.utcnow()

            res = {
                "domain": hostname,
                "is_valid": valid,
                "expires": expires.isoformat(),
                "days until expiration": time_until_expiration.days,
            }
        except Exception as GetPeerCertError:
            return ("ERROR: ", GetPeerCertError)

    print(json.dumps(res, indent=2))
    return json.dumps(res)


ssl_cert_check_handler()
