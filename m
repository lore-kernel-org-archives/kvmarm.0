From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [Linaro-uefi] UEFI on KVM fails to start on juno on cortex-a57
 cluster
Date: Wed, 25 Mar 2015 20:32:13 +0100
Message-ID: <CAKv+Gu9VE8kdq2chs=QKHvyhOoSwBPy2CmJp-ra5kYLiiifVQg@mail.gmail.com>
References: <CAAqcGHmFGO8DaU-G0A6geOzDZDmWAtjHN6wOmJQVBjyi6_WVzQ@mail.gmail.com>
 <CAKv+Gu_W0sk6vR+frYYNBoMjWs6mBcxPwXjwzaHv1D0Sh7GtAw@mail.gmail.com>
 <CAKv+Gu8j0zWQcxiasCy2eozcLCJuT=FPY0rLeYG0z3Hjwf40=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 020C249AA7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Mar 2015 15:25:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pnHlKV7Y5Ql0 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Mar 2015 15:25:16 -0400 (EDT)
Received: from mail-ie0-f173.google.com (mail-ie0-f173.google.com
 [209.85.223.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 178DC49AA5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Mar 2015 15:25:15 -0400 (EDT)
Received: by iedfl3 with SMTP id fl3so34045659ied.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Mar 2015 12:32:13 -0700 (PDT)
In-Reply-To: <CAKv+Gu8j0zWQcxiasCy2eozcLCJuT=FPY0rLeYG0z3Hjwf40=A@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Riku Voipio <riku.voipio@linaro.org>
Cc: Virtualization Team <virtualization@linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Linaro UEFI Mailman List <linaro-uefi@lists.linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

T24gMjUgTWFyY2ggMjAxNSBhdCAxNzoxNCwgQXJkIEJpZXNoZXV2ZWwgPGFyZC5iaWVzaGV1dmVs
QGxpbmFyby5vcmc+IHdyb3RlOgo+IE9uIDI1IE1hcmNoIDIwMTUgYXQgMTc6MTQsIEFyZCBCaWVz
aGV1dmVsIDxhcmQuYmllc2hldXZlbEBsaW5hcm8ub3JnPiB3cm90ZToKPj4gT24gMjUgTWFyY2gg
MjAxNSBhdCAwNzo1OSwgUmlrdSBWb2lwaW8gPHJpa3Uudm9pcGlvQGxpbmFyby5vcmc+IHdyb3Rl
Ogo+Pj4gSGksCj4+Pgo+Pj4gSXQgYXBwZWFycyBvbiBqdW5vLCBJIGNhbiBzdGFydCBrdm0gd2l0
aCBVRUZJIG9ubHkgb24gY29ydGV4LWE1MyBjb3JlczoKPj4+Cj4+Pgo+Pj4gdGFza3NldCAtYyAw
IHFlbXUtc3lzdGVtLWFhcmNoNjQgLW0gMTAyNCAtY3B1IGhvc3QgLU0gdmlydCAtYmlvcwo+Pj4g
UUVNVV9FRkkuZmQgLWVuYWJsZS1rdm0gLW5vZ3JhcGhpYwo+Pj4gLT4gd29ya3M6Cj4+PiBVRUZJ
IEludGVyYWN0aXZlIFNoZWxsIHYyLjAKPj4+IHRhc2tzZXQgLWMgMSBxZW11LXN5c3RlbS1hYXJj
aDY0IC1tIDEwMjQgLWNwdSBob3N0IC1NIHZpcnQgLWJpb3MKPj4+IFFFTVVfRUZJLmZkIC1lbmFi
bGUta3ZtIC1ub2dyYXBoaWMKPj4+IC0+IGhhbmdzIGF0IGNwdSBzcGlubmluZyAxMDAlCj4+PiAu
Li4KPj4+Cj4+Cj4+IEkgY2FuIHJlcHJvZHVjZSB0aGUgaGFuZywgYm90aCB3aXRoIHlvdXIgVUVG
SSBiaW5hcnkgYW5kIG15IG93biByZWxlYXNlIGJ1aWxkLgo+PiBUaGUgZGVidWcgYnVpbGQgd29y
a3MgZmluZSwgdW5mb3J0dW5hdGVseS4uLgo+Pgo+Cj4gVGlhbm9jb3JlIGJ1aWx0IGZyb20gbWFz
dGVyIGFzIG9mIHRvZGF5LCB0aGF0IGlzLgo+CgpPSywgaXQgYXBwZWFycyB0aGF0IHdlIHdlcmUg
bWlzc2luZyBzb21lIGNhY2hlIG1haW50ZW5hbmNlLiBJdCBpcyBub3QKb2J2aW91cyBob3cgdGhh
dCBzaG91bGQgYWZmZWN0IEE1NyBvbmx5LCBidXQgd2l0aCB0aGVzZSBwYXRjaGVzLCBJIGNhbgpu
b3cgcmVsaWFibHkgcnVuIHRoZSByZWxlYXNlIHZlcnNpb24gb24gbXkgU2VhdHRsZSBBNTcKCmh0
dHBzOi8vZ2l0LmxpbmFyby5vcmcvcGVvcGxlL2FyZC5iaWVzaGV1dmVsL3VlZmktbmV4dC5naXQv
c2hvcnRsb2cvcmVmcy9oZWFkcy9xZW11LXhlbi1jYWNoZS1tYWludGVuYW5jZQoKCj4+PiBRZW11
IGFuZCBrZXJuZWwgYXJlIGxhdGVzdCBtYWlubGluZSwga3ZtIGZyb20gbGFzdCBtb250aHMgxLlp
bmFybwo+Pj4gcmVsZWFzZS4gQWNjb3JkaW5nIHRvIGNwdWluZm8gY29yZXMgMCBhbmQgMy01IGFy
ZSBhNTMgYW5kIDEtMiBhcmUgYTU3Lgo+Pj4gRGV0YWlsczoKPj4+Cj4+PiAjIHdnZXQgaHR0cDov
L3JlbGVhc2VzLmxpbmFyby5vcmcvMTUuMDEvY29tcG9uZW50cy9rZXJuZWwvdWVmaS1saW5hcm8v
cmVsZWFzZS9xZW11NjQtaW50ZWxiZHMvUUVNVV9FRkkuZmQKPj4+IHVuYW1lIC1hCj4+PiAjIExp
bnV4IGxpbmFyby1uYW5vIDQuMC4wLXJjNS1saW5hcm8tanVubyAjMSBTTVAgUFJFRU1QVCBUdWUg
TWFyIDI0Cj4+PiAxMDo0Njo1MyBVVEMgMjAxNSBhYXJjaDY0IGFhcmNoNjQgYWFyY2g2NCBHTlUv
TGludXgKPj4+ICMgcWVtdS1zeXN0ZW0tYWFyY2g2NCAtLXZlcnNpb24KPj4+IFFFTVUgZW11bGF0
b3IgdmVyc2lvbiAyLjIuOTEgKERlYmlhbiAyLjMuMH5yYzEtMTg1bGluYXJvK3V0b3BpYyksCj4+
PiBDb3B5cmlnaHQgKGMpIDIwMDMtMjAwOCBGYWJyaWNlIEJlbGxhcmQKPj4+ICMgZ3JlcCAtRSAn
KHByb2Nlc3NvcnxwYXJ0KScgL3Byb2MvY3B1aW5mbwo+Pj4gcHJvY2Vzc29yICAgICAgIDogMAo+
Pj4gQ1BVIHBhcnQgICAgICAgIDogMHhkMDMKPj4+IHByb2Nlc3NvciAgICAgICA6IDEKPj4+IENQ
VSBwYXJ0ICAgICAgICA6IDB4ZDA3Cj4+PiBwcm9jZXNzb3IgICAgICAgOiAyCj4+PiBDUFUgcGFy
dCAgICAgICAgOiAweGQwNwo+Pj4gcHJvY2Vzc29yICAgICAgIDogMwo+Pj4gQ1BVIHBhcnQgICAg
ICAgIDogMHhkMDMKPj4+IHByb2Nlc3NvciAgICAgICA6IDQKPj4+IENQVSBwYXJ0ICAgICAgICA6
IDB4ZDAzCj4+PiBwcm9jZXNzb3IgICAgICAgOiA1Cj4+PiBDUFUgcGFydCAgICAgICAgOiAweGQw
Mwo+Pj4KPj4+IF9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Cj4+PiBMaW5hcm8tdWVmaSBtYWlsaW5nIGxpc3QKPj4+IExpbmFyby11ZWZpQGxpc3RzLmxpbmFy
by5vcmcKPj4+IGh0dHA6Ly9saXN0cy5saW5hcm8ub3JnL21haWxtYW4vbGlzdGluZm8vbGluYXJv
LXVlZmkKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3Zt
YXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlz
dHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
