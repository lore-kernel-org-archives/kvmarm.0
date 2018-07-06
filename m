From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [RFC PATCH 00/16] KVM: arm64: Initial support for SVE guests
Date: Fri, 6 Jul 2018 11:14:59 +0100
Message-ID: <CAFEAcA96dcLPywvJdP+r1F+kJztTvac6QZ2_5_K99B9u5ss2Nw@mail.gmail.com>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
 <87h8lc93jc.fsf@linaro.org> <20180706090534.GD26019@e103592.cambridge.arm.com>
 <87d0w090vv.fsf@linaro.org>
 <CAFEAcA8NQFvHzgCvCQBmq7us4PvqSFK2Le=pMiz5dE4D3WGXdQ@mail.gmail.com>
 <87601s8yhw.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 620FD49E3E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Jul 2018 06:02:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CDWeCee+6sKT for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Jul 2018 06:02:47 -0400 (EDT)
Received: from mail-oi0-f66.google.com (mail-oi0-f66.google.com
 [209.85.218.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 584E74065F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Jul 2018 06:02:47 -0400 (EDT)
Received: by mail-oi0-f66.google.com with SMTP id 13-v6so22505971ois.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 06 Jul 2018 03:15:20 -0700 (PDT)
In-Reply-To: <87601s8yhw.fsf@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, Dave Martin <Dave.Martin@arm.com>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

T24gNiBKdWx5IDIwMTggYXQgMTE6MTEsIEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJv
Lm9yZz4gd3JvdGU6Cj4KPiBQZXRlciBNYXlkZWxsIDxwZXRlci5tYXlkZWxsQGxpbmFyby5vcmc+
IHdyaXRlczoKPgo+PiBPbiA2IEp1bHkgMjAxOCBhdCAxMDoyMCwgQWxleCBCZW5uw6llIDxhbGV4
LmJlbm5lZUBsaW5hcm8ub3JnPiB3cm90ZToKPj4+IEZvciB0aGUgbW9zdCBwYXJ0IGluIFFFTVUg
d2l0aCBLVk0gd2UganVzdCB0cmVhdCB0aGUgbGlzdCBvZiByZWdpc3RlcnMKPj4+IHdlIGdldCBm
cm9tIHRoZSBPUyBhcyBhbiBvcGFxdWUgYmxvYiBvZiB0aGluZ3Mgd2Ugc2F2ZSB0byBtZW1vcnkg
YW5kCj4+PiBwYXNzIGJhY2suCj4+Cj4+IFRoaXMgaXMgc3BlY2lmaWNhbGx5IG5vdCB0aGUgY2Fz
ZSBmb3IgdGhlIFNWRSByZWdpc3RlcnMgLS0gd2UKPj4gd2lsbCBuZWVkIGV4dHJhIGNvZGUgdG8g
aGFuZGxlIHRoZW0uIChUaGUgY3VycmVudCBjb2RlIG9ubHkKPj4gYWxsb3dzIGZvciB0aGUgcG9z
c2liaWxpdHkgb2YgNjQtYml0IHJlZ2lzdGVycywgc28gaWYgd2UnZAo+PiBhbGxvd2VkIHRoZSBr
ZXJuZWwgdG8gaGFuZCBpdCB0aGUgbGFyZ2VyIFNWRSByZWdpc3RlcnMgaXQgd291bGQKPj4ganVz
dCBoYXZlIGZhbGxlbiBvdmVyLiBUaGlzIGlzIHdoeSBRRU1VIG5lZWRzIHRvIHNwZWNpZmljYWxs
eQo+PiBlbmFibGUgU1ZFIHZpYSB0aGUgVkNQVV9JTklUIGNhbGwuKQo+Cj4gQWhoIHJpZ2h0LiBT
byBjdXJyZW50bHkgYm90aCB0aGUgS1ZNX0dFVF9SRUdfTElTVCBhbmQgdGhlIGNvcmUgcmVnaXN0
ZXJzCj4gdXNlIEtWTV9HRVQvU0VUX09ORV9SRUcgd2hpY2ggY2VydGFpbmx5IHdvbid0IGRvIHRo
ZSB0cmljay4gU28gSSBndWVzcwo+IHdlIG5lZWQgYW5vdGhlciBJT0NUTCAob3IgdG8gZW5oYW5j
ZSB0aGUgY3VycmVudCBvbmUpIGFuZCBhIEtWTQo+IGNhcGFiaWxpdHkgYml0IGFzIHdlbGw/CgpJ
dCBpcyBzdGlsbCBHRVQvU0VUX09ORV9SRUcsIGJ1dCB0aGUgc2l6ZSBvZiB0aGUgcmVnaXN0ZXIK
KHdoaWNoIGlzIGVuY29kZWQgaW4gaXRzIElEIG51bWJlcikgaXMgbm90IHNvbWV0aGluZyB0aGUK
Y3VycmVudCBjb2RlIHdpbGwgY29wZSB3aXRoIChzZWUgdGhlIHN3aXRjaGVzIG9uCnJlZ2lkeCAm
IEtWTV9SRUdfU0laRV9NQVNLIGluIHdyaXRlX2t2bXN0YXRlX3RvX2xpc3QoKQphbmQgd3JpdGVf
bGlzdF90b19rdm1zdGF0ZSgpKS4KCnRoYW5rcwotLSBQTU0KX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlz
dHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4v
bGlzdGluZm8va3ZtYXJtCg==
