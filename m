From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [Linaro-uefi] UEFI on KVM fails to start on juno on cortex-a57
 cluster
Date: Wed, 25 Mar 2015 17:14:50 +0100
Message-ID: <CAKv+Gu8j0zWQcxiasCy2eozcLCJuT=FPY0rLeYG0z3Hjwf40=A@mail.gmail.com>
References: <CAAqcGHmFGO8DaU-G0A6geOzDZDmWAtjHN6wOmJQVBjyi6_WVzQ@mail.gmail.com>
 <CAKv+Gu_W0sk6vR+frYYNBoMjWs6mBcxPwXjwzaHv1D0Sh7GtAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 534D049A38
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Mar 2015 12:07:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P0EB4fxsTMkh for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Mar 2015 12:07:53 -0400 (EDT)
Received: from mail-ie0-f174.google.com (mail-ie0-f174.google.com
 [209.85.223.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 50E3249A30
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Mar 2015 12:07:52 -0400 (EDT)
Received: by iecvj10 with SMTP id vj10so26040484iec.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Mar 2015 09:14:50 -0700 (PDT)
In-Reply-To: <CAKv+Gu_W0sk6vR+frYYNBoMjWs6mBcxPwXjwzaHv1D0Sh7GtAw@mail.gmail.com>
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
QGxpbmFyby5vcmc+IHdyb3RlOgo+IE9uIDI1IE1hcmNoIDIwMTUgYXQgMDc6NTksIFJpa3UgVm9p
cGlvIDxyaWt1LnZvaXBpb0BsaW5hcm8ub3JnPiB3cm90ZToKPj4gSGksCj4+Cj4+IEl0IGFwcGVh
cnMgb24ganVubywgSSBjYW4gc3RhcnQga3ZtIHdpdGggVUVGSSBvbmx5IG9uIGNvcnRleC1hNTMg
Y29yZXM6Cj4+Cj4+Cj4+IHRhc2tzZXQgLWMgMCBxZW11LXN5c3RlbS1hYXJjaDY0IC1tIDEwMjQg
LWNwdSBob3N0IC1NIHZpcnQgLWJpb3MKPj4gUUVNVV9FRkkuZmQgLWVuYWJsZS1rdm0gLW5vZ3Jh
cGhpYwo+PiAtPiB3b3JrczoKPj4gVUVGSSBJbnRlcmFjdGl2ZSBTaGVsbCB2Mi4wCj4+IHRhc2tz
ZXQgLWMgMSBxZW11LXN5c3RlbS1hYXJjaDY0IC1tIDEwMjQgLWNwdSBob3N0IC1NIHZpcnQgLWJp
b3MKPj4gUUVNVV9FRkkuZmQgLWVuYWJsZS1rdm0gLW5vZ3JhcGhpYwo+PiAtPiBoYW5ncyBhdCBj
cHUgc3Bpbm5pbmcgMTAwJQo+PiAuLi4KPj4KPgo+IEkgY2FuIHJlcHJvZHVjZSB0aGUgaGFuZywg
Ym90aCB3aXRoIHlvdXIgVUVGSSBiaW5hcnkgYW5kIG15IG93biByZWxlYXNlIGJ1aWxkLgo+IFRo
ZSBkZWJ1ZyBidWlsZCB3b3JrcyBmaW5lLCB1bmZvcnR1bmF0ZWx5Li4uCj4KClRpYW5vY29yZSBi
dWlsdCBmcm9tIG1hc3RlciBhcyBvZiB0b2RheSwgdGhhdCBpcy4KCgo+Cj4+IFFlbXUgYW5kIGtl
cm5lbCBhcmUgbGF0ZXN0IG1haW5saW5lLCBrdm0gZnJvbSBsYXN0IG1vbnRocyDEuWluYXJvCj4+
IHJlbGVhc2UuIEFjY29yZGluZyB0byBjcHVpbmZvIGNvcmVzIDAgYW5kIDMtNSBhcmUgYTUzIGFu
ZCAxLTIgYXJlIGE1Ny4KPj4gRGV0YWlsczoKPj4KPj4gIyB3Z2V0IGh0dHA6Ly9yZWxlYXNlcy5s
aW5hcm8ub3JnLzE1LjAxL2NvbXBvbmVudHMva2VybmVsL3VlZmktbGluYXJvL3JlbGVhc2UvcWVt
dTY0LWludGVsYmRzL1FFTVVfRUZJLmZkCj4+IHVuYW1lIC1hCj4+ICMgTGludXggbGluYXJvLW5h
bm8gNC4wLjAtcmM1LWxpbmFyby1qdW5vICMxIFNNUCBQUkVFTVBUIFR1ZSBNYXIgMjQKPj4gMTA6
NDY6NTMgVVRDIDIwMTUgYWFyY2g2NCBhYXJjaDY0IGFhcmNoNjQgR05VL0xpbnV4Cj4+ICMgcWVt
dS1zeXN0ZW0tYWFyY2g2NCAtLXZlcnNpb24KPj4gUUVNVSBlbXVsYXRvciB2ZXJzaW9uIDIuMi45
MSAoRGViaWFuIDIuMy4wfnJjMS0xODVsaW5hcm8rdXRvcGljKSwKPj4gQ29weXJpZ2h0IChjKSAy
MDAzLTIwMDggRmFicmljZSBCZWxsYXJkCj4+ICMgZ3JlcCAtRSAnKHByb2Nlc3NvcnxwYXJ0KScg
L3Byb2MvY3B1aW5mbwo+PiBwcm9jZXNzb3IgICAgICAgOiAwCj4+IENQVSBwYXJ0ICAgICAgICA6
IDB4ZDAzCj4+IHByb2Nlc3NvciAgICAgICA6IDEKPj4gQ1BVIHBhcnQgICAgICAgIDogMHhkMDcK
Pj4gcHJvY2Vzc29yICAgICAgIDogMgo+PiBDUFUgcGFydCAgICAgICAgOiAweGQwNwo+PiBwcm9j
ZXNzb3IgICAgICAgOiAzCj4+IENQVSBwYXJ0ICAgICAgICA6IDB4ZDAzCj4+IHByb2Nlc3NvciAg
ICAgICA6IDQKPj4gQ1BVIHBhcnQgICAgICAgIDogMHhkMDMKPj4gcHJvY2Vzc29yICAgICAgIDog
NQo+PiBDUFUgcGFydCAgICAgICAgOiAweGQwMwo+Pgo+PiBfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwo+PiBMaW5hcm8tdWVmaSBtYWlsaW5nIGxpc3QKPj4g
TGluYXJvLXVlZmlAbGlzdHMubGluYXJvLm9yZwo+PiBodHRwOi8vbGlzdHMubGluYXJvLm9yZy9t
YWlsbWFuL2xpc3RpbmZvL2xpbmFyby11ZWZpCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNv
bHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZv
L2t2bWFybQo=
