From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [Linaro-uefi] UEFI on KVM fails to start on juno on cortex-a57
 cluster
Date: Wed, 25 Mar 2015 17:14:03 +0100
Message-ID: <CAKv+Gu_W0sk6vR+frYYNBoMjWs6mBcxPwXjwzaHv1D0Sh7GtAw@mail.gmail.com>
References: <CAAqcGHmFGO8DaU-G0A6geOzDZDmWAtjHN6wOmJQVBjyi6_WVzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FF9149A2C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Mar 2015 12:07:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GXY4stfoUiQS for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Mar 2015 12:07:06 -0400 (EDT)
Received: from mail-ie0-f179.google.com (mail-ie0-f179.google.com
 [209.85.223.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D11C649A2B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Mar 2015 12:07:06 -0400 (EDT)
Received: by iedm5 with SMTP id m5so25874528ied.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Mar 2015 09:14:04 -0700 (PDT)
In-Reply-To: <CAAqcGHmFGO8DaU-G0A6geOzDZDmWAtjHN6wOmJQVBjyi6_WVzQ@mail.gmail.com>
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

T24gMjUgTWFyY2ggMjAxNSBhdCAwNzo1OSwgUmlrdSBWb2lwaW8gPHJpa3Uudm9pcGlvQGxpbmFy
by5vcmc+IHdyb3RlOgo+IEhpLAo+Cj4gSXQgYXBwZWFycyBvbiBqdW5vLCBJIGNhbiBzdGFydCBr
dm0gd2l0aCBVRUZJIG9ubHkgb24gY29ydGV4LWE1MyBjb3JlczoKPgo+Cj4gdGFza3NldCAtYyAw
IHFlbXUtc3lzdGVtLWFhcmNoNjQgLW0gMTAyNCAtY3B1IGhvc3QgLU0gdmlydCAtYmlvcwo+IFFF
TVVfRUZJLmZkIC1lbmFibGUta3ZtIC1ub2dyYXBoaWMKPiAtPiB3b3JrczoKPiBVRUZJIEludGVy
YWN0aXZlIFNoZWxsIHYyLjAKPiB0YXNrc2V0IC1jIDEgcWVtdS1zeXN0ZW0tYWFyY2g2NCAtbSAx
MDI0IC1jcHUgaG9zdCAtTSB2aXJ0IC1iaW9zCj4gUUVNVV9FRkkuZmQgLWVuYWJsZS1rdm0gLW5v
Z3JhcGhpYwo+IC0+IGhhbmdzIGF0IGNwdSBzcGlubmluZyAxMDAlCj4gLi4uCj4KCkkgY2FuIHJl
cHJvZHVjZSB0aGUgaGFuZywgYm90aCB3aXRoIHlvdXIgVUVGSSBiaW5hcnkgYW5kIG15IG93biBy
ZWxlYXNlIGJ1aWxkLgpUaGUgZGVidWcgYnVpbGQgd29ya3MgZmluZSwgdW5mb3J0dW5hdGVseS4u
LgoKCj4gUWVtdSBhbmQga2VybmVsIGFyZSBsYXRlc3QgbWFpbmxpbmUsIGt2bSBmcm9tIGxhc3Qg
bW9udGhzIMS5aW5hcm8KPiByZWxlYXNlLiBBY2NvcmRpbmcgdG8gY3B1aW5mbyBjb3JlcyAwIGFu
ZCAzLTUgYXJlIGE1MyBhbmQgMS0yIGFyZSBhNTcuCj4gRGV0YWlsczoKPgo+ICMgd2dldCBodHRw
Oi8vcmVsZWFzZXMubGluYXJvLm9yZy8xNS4wMS9jb21wb25lbnRzL2tlcm5lbC91ZWZpLWxpbmFy
by9yZWxlYXNlL3FlbXU2NC1pbnRlbGJkcy9RRU1VX0VGSS5mZAo+IHVuYW1lIC1hCj4gIyBMaW51
eCBsaW5hcm8tbmFubyA0LjAuMC1yYzUtbGluYXJvLWp1bm8gIzEgU01QIFBSRUVNUFQgVHVlIE1h
ciAyNAo+IDEwOjQ2OjUzIFVUQyAyMDE1IGFhcmNoNjQgYWFyY2g2NCBhYXJjaDY0IEdOVS9MaW51
eAo+ICMgcWVtdS1zeXN0ZW0tYWFyY2g2NCAtLXZlcnNpb24KPiBRRU1VIGVtdWxhdG9yIHZlcnNp
b24gMi4yLjkxIChEZWJpYW4gMi4zLjB+cmMxLTE4NWxpbmFybyt1dG9waWMpLAo+IENvcHlyaWdo
dCAoYykgMjAwMy0yMDA4IEZhYnJpY2UgQmVsbGFyZAo+ICMgZ3JlcCAtRSAnKHByb2Nlc3Nvcnxw
YXJ0KScgL3Byb2MvY3B1aW5mbwo+IHByb2Nlc3NvciAgICAgICA6IDAKPiBDUFUgcGFydCAgICAg
ICAgOiAweGQwMwo+IHByb2Nlc3NvciAgICAgICA6IDEKPiBDUFUgcGFydCAgICAgICAgOiAweGQw
Nwo+IHByb2Nlc3NvciAgICAgICA6IDIKPiBDUFUgcGFydCAgICAgICAgOiAweGQwNwo+IHByb2Nl
c3NvciAgICAgICA6IDMKPiBDUFUgcGFydCAgICAgICAgOiAweGQwMwo+IHByb2Nlc3NvciAgICAg
ICA6IDQKPiBDUFUgcGFydCAgICAgICAgOiAweGQwMwo+IHByb2Nlc3NvciAgICAgICA6IDUKPiBD
UFUgcGFydCAgICAgICAgOiAweGQwMwo+Cj4gX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18KPiBMaW5hcm8tdWVmaSBtYWlsaW5nIGxpc3QKPiBMaW5hcm8tdWVm
aUBsaXN0cy5saW5hcm8ub3JnCj4gaHR0cDovL2xpc3RzLmxpbmFyby5vcmcvbWFpbG1hbi9saXN0
aW5mby9saW5hcm8tdWVmaQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUK
aHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
