//
// Simple server that accepts kube-audit data via webhook
//
const http = require("http");
const port = 3000;

const requestHandler = (request, response) => {
  const { headers, method, url } = request;
  let body = [];
  request
    .on("error", err => {
      console.error(err);
    })
    .on("data", chunk => {
      body.push(chunk);
    })
    .on("end", () => {
      body = Buffer.concat(body).toString();
      // At this point, we have the headers, method, url and body, and can now
      // do whatever we need to in order to respond to this request.
      data = JSON.parse(body);
      for (var i = 0; i < data.items.length; i++) {
        console.log(JSON.stringify(data.items[i]));
      }
      response.end("processed " + data.items.length + " lines");
    });
};

const server = http.createServer(requestHandler);

server.listen(port, err => {
  if (err) {
    return console.log("something bad happened", err);
  }

  console.log(`server is listening on ${port}`);
});
