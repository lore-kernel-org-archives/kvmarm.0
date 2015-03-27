From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [Linaro-uefi] UEFI on KVM fails to start on juno on cortex-a57
 cluster
Date: Fri, 27 Mar 2015 01:02:10 +0100
Message-ID: <CAKv+Gu9djvNecwDGqyCNzdQG6-g=ivavfCGg-jqxrrZ+tnYDOQ@mail.gmail.com>
References: <CAAqcGHmFGO8DaU-G0A6geOzDZDmWAtjHN6wOmJQVBjyi6_WVzQ@mail.gmail.com>
 <CAKv+Gu_W0sk6vR+frYYNBoMjWs6mBcxPwXjwzaHv1D0Sh7GtAw@mail.gmail.com>
 <CAKv+Gu8j0zWQcxiasCy2eozcLCJuT=FPY0rLeYG0z3Hjwf40=A@mail.gmail.com>
 <CAKv+Gu9VE8kdq2chs=QKHvyhOoSwBPy2CmJp-ra5kYLiiifVQg@mail.gmail.com>
 <CAAqcGHnNrnOLxfoTuGGMN4nwDupaaLK5sJ8TATTw33r1NMi0Dg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7109B49E00
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Mar 2015 19:55:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dJJWf57eWwZh for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Mar 2015 19:55:10 -0400 (EDT)
Received: from mail-ie0-f175.google.com (mail-ie0-f175.google.com
 [209.85.223.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2FC4549DD1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Mar 2015 19:55:09 -0400 (EDT)
Received: by iecvj10 with SMTP id vj10so59656125iec.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Mar 2015 17:02:10 -0700 (PDT)
In-Reply-To: <CAAqcGHnNrnOLxfoTuGGMN4nwDupaaLK5sJ8TATTw33r1NMi0Dg@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Riku Voipio <riku.voipio@linaro.org>, Leif Lindholm <leif.lindholm@linaro.org>
Cc: Virtualization Team <virtualization@linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Linaro UEFI Mailman List <linaro-uefi@lists.linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

T24gMjYgTWFyY2ggMjAxNSBhdCAwOTowOSwgUmlrdSBWb2lwaW8gPHJpa3Uudm9pcGlvQGxpbmFy
by5vcmc+IHdyb3RlOgo+IE9uIDI1IE1hcmNoIDIwMTUgYXQgMjE6MzIsIEFyZCBCaWVzaGV1dmVs
IDxhcmQuYmllc2hldXZlbEBsaW5hcm8ub3JnPiB3cm90ZToKPj4gT24gMjUgTWFyY2ggMjAxNSBh
dCAxNzoxNCwgQXJkIEJpZXNoZXV2ZWwgPGFyZC5iaWVzaGV1dmVsQGxpbmFyby5vcmc+IHdyb3Rl
Ogo+Pj4gT24gMjUgTWFyY2ggMjAxNSBhdCAxNzoxNCwgQXJkIEJpZXNoZXV2ZWwgPGFyZC5iaWVz
aGV1dmVsQGxpbmFyby5vcmc+IHdyb3RlOgo+Pj4+IE9uIDI1IE1hcmNoIDIwMTUgYXQgMDc6NTks
IFJpa3UgVm9pcGlvIDxyaWt1LnZvaXBpb0BsaW5hcm8ub3JnPiB3cm90ZToKPj4+Pj4gSGksCj4+
Pj4+Cj4+Pj4+IEl0IGFwcGVhcnMgb24ganVubywgSSBjYW4gc3RhcnQga3ZtIHdpdGggVUVGSSBv
bmx5IG9uIGNvcnRleC1hNTMgY29yZXM6Cj4+Pj4+Cj4+Pj4+Cj4+Pj4+IHRhc2tzZXQgLWMgMCBx
ZW11LXN5c3RlbS1hYXJjaDY0IC1tIDEwMjQgLWNwdSBob3N0IC1NIHZpcnQgLWJpb3MKPj4+Pj4g
UUVNVV9FRkkuZmQgLWVuYWJsZS1rdm0gLW5vZ3JhcGhpYwo+Pj4+PiAtPiB3b3JrczoKPj4+Pj4g
VUVGSSBJbnRlcmFjdGl2ZSBTaGVsbCB2Mi4wCj4+Pj4+IHRhc2tzZXQgLWMgMSBxZW11LXN5c3Rl
bS1hYXJjaDY0IC1tIDEwMjQgLWNwdSBob3N0IC1NIHZpcnQgLWJpb3MKPj4+Pj4gUUVNVV9FRkku
ZmQgLWVuYWJsZS1rdm0gLW5vZ3JhcGhpYwo+Pj4+PiAtPiBoYW5ncyBhdCBjcHUgc3Bpbm5pbmcg
MTAwJQo+Pj4+PiAuLi4KPj4+Pj4KPj4+Pgo+Pj4+IEkgY2FuIHJlcHJvZHVjZSB0aGUgaGFuZywg
Ym90aCB3aXRoIHlvdXIgVUVGSSBiaW5hcnkgYW5kIG15IG93biByZWxlYXNlIGJ1aWxkLgo+Pj4+
IFRoZSBkZWJ1ZyBidWlsZCB3b3JrcyBmaW5lLCB1bmZvcnR1bmF0ZWx5Li4uCj4+Pj4KPj4+Cj4+
PiBUaWFub2NvcmUgYnVpbHQgZnJvbSBtYXN0ZXIgYXMgb2YgdG9kYXksIHRoYXQgaXMuCj4+Pgo+
Pgo+PiBPSywgaXQgYXBwZWFycyB0aGF0IHdlIHdlcmUgbWlzc2luZyBzb21lIGNhY2hlIG1haW50
ZW5hbmNlLiBJdCBpcyBub3QKPj4gb2J2aW91cyBob3cgdGhhdCBzaG91bGQgYWZmZWN0IEE1NyBv
bmx5LCBidXQgd2l0aCB0aGVzZSBwYXRjaGVzLCBJIGNhbgo+PiBub3cgcmVsaWFibHkgcnVuIHRo
ZSByZWxlYXNlIHZlcnNpb24gb24gbXkgU2VhdHRsZSBBNTcKPgo+PiBodHRwczovL2dpdC5saW5h
cm8ub3JnL3Blb3BsZS9hcmQuYmllc2hldXZlbC91ZWZpLW5leHQuZ2l0L3Nob3J0bG9nL3JlZnMv
aGVhZHMvcWVtdS14ZW4tY2FjaGUtbWFpbnRlbmFuY2UKPgo+IFRoYW5rcy4gRG8geW91IGtub3cg
d2hlbiB0aGVyZSB3b3VsZCBiZSBhIG5ldyBidWlsZCBvbiByZWxlYXNlcyBvciBzbmFwc2hvdHM/
Cj4KCkxldCBtZSBjaGVjayB3aXRoIExlaWYuIFdlIGhhdmUgYW5vdGhlciBjYW5kaWRhdGUgcGF0
Y2ggbm93IHRoYXQgaGUKY291bGQgcGVyaGFwcyBhcHBseSBhbmQga2ljayBvZmYgYSBidWlsZD8K
Cgo+Pj4+PiBRZW11IGFuZCBrZXJuZWwgYXJlIGxhdGVzdCBtYWlubGluZSwga3ZtIGZyb20gbGFz
dCBtb250aHMgxLlpbmFybwo+Pj4+PiByZWxlYXNlLiBBY2NvcmRpbmcgdG8gY3B1aW5mbyBjb3Jl
cyAwIGFuZCAzLTUgYXJlIGE1MyBhbmQgMS0yIGFyZSBhNTcuCj4+Pj4+IERldGFpbHM6Cj4+Pj4+
Cj4+Pj4+ICMgd2dldCBodHRwOi8vcmVsZWFzZXMubGluYXJvLm9yZy8xNS4wMS9jb21wb25lbnRz
L2tlcm5lbC91ZWZpLWxpbmFyby9yZWxlYXNlL3FlbXU2NC1pbnRlbGJkcy9RRU1VX0VGSS5mZAo+
Pj4+PiB1bmFtZSAtYQo+Pj4+PiAjIExpbnV4IGxpbmFyby1uYW5vIDQuMC4wLXJjNS1saW5hcm8t
anVubyAjMSBTTVAgUFJFRU1QVCBUdWUgTWFyIDI0Cj4+Pj4+IDEwOjQ2OjUzIFVUQyAyMDE1IGFh
cmNoNjQgYWFyY2g2NCBhYXJjaDY0IEdOVS9MaW51eAo+Pj4+PiAjIHFlbXUtc3lzdGVtLWFhcmNo
NjQgLS12ZXJzaW9uCj4+Pj4+IFFFTVUgZW11bGF0b3IgdmVyc2lvbiAyLjIuOTEgKERlYmlhbiAy
LjMuMH5yYzEtMTg1bGluYXJvK3V0b3BpYyksCj4+Pj4+IENvcHlyaWdodCAoYykgMjAwMy0yMDA4
IEZhYnJpY2UgQmVsbGFyZAo+Pj4+PiAjIGdyZXAgLUUgJyhwcm9jZXNzb3J8cGFydCknIC9wcm9j
L2NwdWluZm8KPj4+Pj4gcHJvY2Vzc29yICAgICAgIDogMAo+Pj4+PiBDUFUgcGFydCAgICAgICAg
OiAweGQwMwo+Pj4+PiBwcm9jZXNzb3IgICAgICAgOiAxCj4+Pj4+IENQVSBwYXJ0ICAgICAgICA6
IDB4ZDA3Cj4+Pj4+IHByb2Nlc3NvciAgICAgICA6IDIKPj4+Pj4gQ1BVIHBhcnQgICAgICAgIDog
MHhkMDcKPj4+Pj4gcHJvY2Vzc29yICAgICAgIDogMwo+Pj4+PiBDUFUgcGFydCAgICAgICAgOiAw
eGQwMwo+Pj4+PiBwcm9jZXNzb3IgICAgICAgOiA0Cj4+Pj4+IENQVSBwYXJ0ICAgICAgICA6IDB4
ZDAzCj4+Pj4+IHByb2Nlc3NvciAgICAgICA6IDUKPj4+Pj4gQ1BVIHBhcnQgICAgICAgIDogMHhk
MDMKPj4+Pj4KPj4+Pj4gX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18KPj4+Pj4gTGluYXJvLXVlZmkgbWFpbGluZyBsaXN0Cj4+Pj4+IExpbmFyby11ZWZpQGxp
c3RzLmxpbmFyby5vcmcKPj4+Pj4gaHR0cDovL2xpc3RzLmxpbmFyby5vcmcvbWFpbG1hbi9saXN0
aW5mby9saW5hcm8tdWVmaQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUK
aHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
