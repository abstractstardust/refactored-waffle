import datetime
import socket
import ssl
import json


def ssl_cert_check_handler(event, context):
    domain = event["pathParameters"]["domain"]

    ssl_date_fmt = r'%b %d %H:%M:%S %Y %Z'

    context = ssl.create_default_context()
    conn = context.wrap_socket(
        socket.socket(socket.AF_INET),
        server_hostname=domain,
    )

    # 3 second timeout because Lambda has runtime limitations
    conn.settimeout(3.0)

    res = {}

    try:
        # connect to a server
        conn.connect((domain, 443))
    except Exception as HostConnectionError:
        res['domain'] = domain
        res['is_valid'] = False
        res['issue'] = HostConnectionError.args[1]
    else:
        try:
            ssl_info = conn.getpeercert()

            expires = datetime.datetime.strptime(
                ssl_info['notAfter'], ssl_date_fmt)
            valid = expires > datetime.datetime.utcnow()
            time_until_expiration = expires - datetime.datetime.utcnow()

            res['domain'] = domain
            res['is_valid'] = valid
            res['expires'] = expires.isoformat()
            res['days until expiration'] = time_until_expiration.days

        except Exception as GetPeerCertError:
            return ("ERROR: ", GetPeerCertError)

    return {'statusCode': 200, 'headers': {'Content-Type': 'application/json'
                                           }, 'body': json.dumps(res)}
