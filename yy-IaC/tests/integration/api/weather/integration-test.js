import http from "k6/http";
import { check } from "k6";

export default function () {
    const url =
        "https://app-nstankov-bg-random-dotnet-crm-poc-pr-2.cloud.okteto.net/api/weather";
    const response = http.get(url);

    check(response, {
        "status is 200": (r) => r.status === 200,
        "response has data": (r) => r.json().length > 0,
    });
}
