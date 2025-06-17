function handler(event) {
    var request = event.request;
    var headers = request.headers;

    var refererPattern = /^https:\/\/([a-z0-9-]+\.)*extramuseum\.com/i;

    if (!headers.referer || !refererPattern.test(headers.referer.value)) {
        return {
            statusCode: 403,
            statusDescription: 'Forbidden',
            headers: {
                "content-type": { value: "text/plain" },
            },
            body: "403 Forbidden"
        };
    }

    return request;
}