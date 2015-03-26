From: Riku Voipio <riku.voipio@linaro.org>
Subject: Re: [Linaro-uefi] UEFI on KVM fails to start on juno on cortex-a57
 cluster
Date: Thu, 26 Mar 2015 10:09:47 +0200
Message-ID: <CAAqcGHnNrnOLxfoTuGGMN4nwDupaaLK5sJ8TATTw33r1NMi0Dg@mail.gmail.com>
References: <CAAqcGHmFGO8DaU-G0A6geOzDZDmWAtjHN6wOmJQVBjyi6_WVzQ@mail.gmail.com>
 <CAKv+Gu_W0sk6vR+frYYNBoMjWs6mBcxPwXjwzaHv1D0Sh7GtAw@mail.gmail.com>
 <CAKv+Gu8j0zWQcxiasCy2eozcLCJuT=FPY0rLeYG0z3Hjwf40=A@mail.gmail.com>
 <CAKv+Gu9VE8kdq2chs=QKHvyhOoSwBPy2CmJp-ra5kYLiiifVQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 47D6549B7C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Mar 2015 04:02:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jUHAWizTQrcc for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Mar 2015 04:02:49 -0400 (EDT)
Received: from mail-wg0-f50.google.com (mail-wg0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C640A49B79
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Mar 2015 04:02:49 -0400 (EDT)
Received: by wgbcc7 with SMTP id cc7so54578710wgb.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Mar 2015 01:09:47 -0700 (PDT)
In-Reply-To: <CAKv+Gu9VE8kdq2chs=QKHvyhOoSwBPy2CmJp-ra5kYLiiifVQg@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Virtualization Team <virtualization@linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Linaro UEFI Mailman List <linaro-uefi@lists.linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

T24gMjUgTWFyY2ggMjAxNSBhdCAyMTozMiwgQXJkIEJpZXNoZXV2ZWwgPGFyZC5iaWVzaGV1dmVs
QGxpbmFyby5vcmc+IHdyb3RlOgo+IE9uIDI1IE1hcmNoIDIwMTUgYXQgMTc6MTQsIEFyZCBCaWVz
aGV1dmVsIDxhcmQuYmllc2hldXZlbEBsaW5hcm8ub3JnPiB3cm90ZToKPj4gT24gMjUgTWFyY2gg
MjAxNSBhdCAxNzoxNCwgQXJkIEJpZXNoZXV2ZWwgPGFyZC5iaWVzaGV1dmVsQGxpbmFyby5vcmc+
IHdyb3RlOgo+Pj4gT24gMjUgTWFyY2ggMjAxNSBhdCAwNzo1OSwgUmlrdSBWb2lwaW8gPHJpa3Uu
dm9pcGlvQGxpbmFyby5vcmc+IHdyb3RlOgo+Pj4+IEhpLAo+Pj4+Cj4+Pj4gSXQgYXBwZWFycyBv
biBqdW5vLCBJIGNhbiBzdGFydCBrdm0gd2l0aCBVRUZJIG9ubHkgb24gY29ydGV4LWE1MyBjb3Jl
czoKPj4+Pgo+Pj4+Cj4+Pj4gdGFza3NldCAtYyAwIHFlbXUtc3lzdGVtLWFhcmNoNjQgLW0gMTAy
NCAtY3B1IGhvc3QgLU0gdmlydCAtYmlvcwo+Pj4+IFFFTVVfRUZJLmZkIC1lbmFibGUta3ZtIC1u
b2dyYXBoaWMKPj4+PiAtPiB3b3JrczoKPj4+PiBVRUZJIEludGVyYWN0aXZlIFNoZWxsIHYyLjAK
Pj4+PiB0YXNrc2V0IC1jIDEgcWVtdS1zeXN0ZW0tYWFyY2g2NCAtbSAxMDI0IC1jcHUgaG9zdCAt
TSB2aXJ0IC1iaW9zCj4+Pj4gUUVNVV9FRkkuZmQgLWVuYWJsZS1rdm0gLW5vZ3JhcGhpYwo+Pj4+
IC0+IGhhbmdzIGF0IGNwdSBzcGlubmluZyAxMDAlCj4+Pj4gLi4uCj4+Pj4KPj4+Cj4+PiBJIGNh
biByZXByb2R1Y2UgdGhlIGhhbmcsIGJvdGggd2l0aCB5b3VyIFVFRkkgYmluYXJ5IGFuZCBteSBv
d24gcmVsZWFzZSBidWlsZC4KPj4+IFRoZSBkZWJ1ZyBidWlsZCB3b3JrcyBmaW5lLCB1bmZvcnR1
bmF0ZWx5Li4uCj4+Pgo+Pgo+PiBUaWFub2NvcmUgYnVpbHQgZnJvbSBtYXN0ZXIgYXMgb2YgdG9k
YXksIHRoYXQgaXMuCj4+Cj4KPiBPSywgaXQgYXBwZWFycyB0aGF0IHdlIHdlcmUgbWlzc2luZyBz
b21lIGNhY2hlIG1haW50ZW5hbmNlLiBJdCBpcyBub3QKPiBvYnZpb3VzIGhvdyB0aGF0IHNob3Vs
ZCBhZmZlY3QgQTU3IG9ubHksIGJ1dCB3aXRoIHRoZXNlIHBhdGNoZXMsIEkgY2FuCj4gbm93IHJl
bGlhYmx5IHJ1biB0aGUgcmVsZWFzZSB2ZXJzaW9uIG9uIG15IFNlYXR0bGUgQTU3Cgo+IGh0dHBz
Oi8vZ2l0LmxpbmFyby5vcmcvcGVvcGxlL2FyZC5iaWVzaGV1dmVsL3VlZmktbmV4dC5naXQvc2hv
cnRsb2cvcmVmcy9oZWFkcy9xZW11LXhlbi1jYWNoZS1tYWludGVuYW5jZQoKVGhhbmtzLiBEbyB5
b3Uga25vdyB3aGVuIHRoZXJlIHdvdWxkIGJlIGEgbmV3IGJ1aWxkIG9uIHJlbGVhc2VzIG9yIHNu
YXBzaG90cz8KClJpa3UKCj4+Pj4gUWVtdSBhbmQga2VybmVsIGFyZSBsYXRlc3QgbWFpbmxpbmUs
IGt2bSBmcm9tIGxhc3QgbW9udGhzIMS5aW5hcm8KPj4+PiByZWxlYXNlLiBBY2NvcmRpbmcgdG8g
Y3B1aW5mbyBjb3JlcyAwIGFuZCAzLTUgYXJlIGE1MyBhbmQgMS0yIGFyZSBhNTcuCj4+Pj4gRGV0
YWlsczoKPj4+Pgo+Pj4+ICMgd2dldCBodHRwOi8vcmVsZWFzZXMubGluYXJvLm9yZy8xNS4wMS9j
b21wb25lbnRzL2tlcm5lbC91ZWZpLWxpbmFyby9yZWxlYXNlL3FlbXU2NC1pbnRlbGJkcy9RRU1V
X0VGSS5mZAo+Pj4+IHVuYW1lIC1hCj4+Pj4gIyBMaW51eCBsaW5hcm8tbmFubyA0LjAuMC1yYzUt
bGluYXJvLWp1bm8gIzEgU01QIFBSRUVNUFQgVHVlIE1hciAyNAo+Pj4+IDEwOjQ2OjUzIFVUQyAy
MDE1IGFhcmNoNjQgYWFyY2g2NCBhYXJjaDY0IEdOVS9MaW51eAo+Pj4+ICMgcWVtdS1zeXN0ZW0t
YWFyY2g2NCAtLXZlcnNpb24KPj4+PiBRRU1VIGVtdWxhdG9yIHZlcnNpb24gMi4yLjkxIChEZWJp
YW4gMi4zLjB+cmMxLTE4NWxpbmFybyt1dG9waWMpLAo+Pj4+IENvcHlyaWdodCAoYykgMjAwMy0y
MDA4IEZhYnJpY2UgQmVsbGFyZAo+Pj4+ICMgZ3JlcCAtRSAnKHByb2Nlc3NvcnxwYXJ0KScgL3By
b2MvY3B1aW5mbwo+Pj4+IHByb2Nlc3NvciAgICAgICA6IDAKPj4+PiBDUFUgcGFydCAgICAgICAg
OiAweGQwMwo+Pj4+IHByb2Nlc3NvciAgICAgICA6IDEKPj4+PiBDUFUgcGFydCAgICAgICAgOiAw
eGQwNwo+Pj4+IHByb2Nlc3NvciAgICAgICA6IDIKPj4+PiBDUFUgcGFydCAgICAgICAgOiAweGQw
Nwo+Pj4+IHByb2Nlc3NvciAgICAgICA6IDMKPj4+PiBDUFUgcGFydCAgICAgICAgOiAweGQwMwo+
Pj4+IHByb2Nlc3NvciAgICAgICA6IDQKPj4+PiBDUFUgcGFydCAgICAgICAgOiAweGQwMwo+Pj4+
IHByb2Nlc3NvciAgICAgICA6IDUKPj4+PiBDUFUgcGFydCAgICAgICAgOiAweGQwMwo+Pj4+Cj4+
Pj4gX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KPj4+PiBM
aW5hcm8tdWVmaSBtYWlsaW5nIGxpc3QKPj4+PiBMaW5hcm8tdWVmaUBsaXN0cy5saW5hcm8ub3Jn
Cj4+Pj4gaHR0cDovL2xpc3RzLmxpbmFyby5vcmcvbWFpbG1hbi9saXN0aW5mby9saW5hcm8tdWVm
aQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0g
bWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5j
cy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
