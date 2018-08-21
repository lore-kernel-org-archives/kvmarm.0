From: Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH v3 7/9] KVM: arm/arm64: Only clean the dcache on
 translation fault
Date: Tue, 21 Aug 2018 16:08:57 +0200
Message-ID: <2686ddfc-935a-18e0-46bd-0cb608ae44e1@suse.de>
References: <20171023161122.15291-1-marc.zyngier@arm.com>
 <20171023161122.15291-8-marc.zyngier@arm.com>
 <bfeee11e-f8bf-78f2-ab61-27e43781e2e3@suse.de>
 <9fa7efdf-1c21-7b07-edb9-0c7d0d91eaed@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B7724A209
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Aug 2018 10:09:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bqChLdwjATl6 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Aug 2018 10:08:59 -0400 (EDT)
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 173E44A1D8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Aug 2018 10:08:59 -0400 (EDT)
In-Reply-To: <9fa7efdf-1c21-7b07-edb9-0c7d0d91eaed@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

T24gMDgvMjEvMjAxOCAwMzo1NyBQTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IE9uIDIxLzA4LzE4
IDE0OjM1LCBBbGV4YW5kZXIgR3JhZiB3cm90ZToKPj4gT24gMTAvMjMvMjAxNyAwNjoxMSBQTSwg
TWFyYyBaeW5naWVyIHdyb3RlOgo+Pj4gVGhlIG9ubHkgY2FzZSB3aGVyZSB3ZSBhY3R1YWxseSBu
ZWVkIHRvIHBlcmZvcm0gYSBkY2FjaGUgbWFpbnRlbmFuY2UKPj4+IGlzIHdoZW4gd2UgbWFwIHRo
ZSBwYWdlIGZvciB0aGUgZmlyc3QgdGltZSwgYW5kIHN1YnNlcXVlbnQgcGVybWlzc2lvbgo+Pj4g
ZmF1bHRzIGRvIG5vdCByZXF1aXJlIGNhY2hlIG1haW50ZW5hbmNlLiBMZXQncyBtYWtlIGl0IGNv
bmRpdGlvbmFsCj4+PiBvbiBub3QgYmVpbmcgYSBwZXJtaXNzaW9uIGZhdWx0IChhbmQgdGh1cyBh
IHRyYW5zbGF0aW9uIGZhdWx0KS4KPj4+Cj4+PiBSZXZpZXdlZC1ieTogQ2hyaXN0b2ZmZXIgRGFs
bCA8Y2hyaXN0b2ZmZXIuZGFsbEBsaW5hcm8ub3JnPgo+Pj4gU2lnbmVkLW9mZi1ieTogTWFyYyBa
eW5naWVyIDxtYXJjLnp5bmdpZXJAYXJtLmNvbT4KPj4gVGhpcyBwYXRjaCB1bmZvcnR1bmF0ZWx5
IGJyZWFrcyBzb21ldGhpbmcgb24gSGkxNjE2IFNvQ3Mgd2hlbiBydW5uaW5nCj4+IDMyYml0IGd1
ZXN0cy4gV2l0aCB0aGlzIHBhdGNoIGFwcGxpZWQgKGFuZCB0aHVzIHdpdGggNC4xOCkgSSBnZXQg
cmFuZG9tCj4+IGlsbGVnYWwgaW5zdHJ1Y3Rpb24gd2FybmluZ3MgZnJvbSAzMmJpdCBjb2RlIGlu
c2lkZSBWTXMuIEkgZG8gbm90IGtub3cKPj4gYXQgdGhpcyBwb2ludCB3aGV0aGVyIHRoaXMgYWZm
ZWN0cyBvdGhlciBDUFVzIGFzIHdlbGwuCj4gQ2FuIHlvdSBwbGVhc2UgZ2l2ZSBhIGZldyBtb3Jl
IGRldGFpbHM/Cj4KPiAtIHdoYXQgYXJlIHRoZSBDUFVzIG9uIHRoaXMgSGkxNjE2PyBBdCBsZWFz
dCBhIC9wcm9jL2NwdWluZm8gd291bGQgaGVscAoKVGhlc2UgYXJlIEE3MnM6Cgpwcm9jZXNzb3LC
oMKgwqAgOiAwCkJvZ29NSVBTwqDCoMKgIDogMTAwLjAwCkZlYXR1cmVzwqDCoMKgIDogZnAgYXNp
bWQgZXZ0c3RybSBhZXMgcG11bGwgc2hhMSBzaGEyIGNyYzMyIGNwdWlkCkNQVSBpbXBsZW1lbnRl
csKgwqDCoCA6IDB4NDEKQ1BVIGFyY2hpdGVjdHVyZTogOApDUFUgdmFyaWFudMKgwqDCoCA6IDB4
MApDUFUgcGFydMKgwqDCoCA6IDB4ZDA4CkNQVSByZXZpc2lvbsKgwqDCoCA6IDIKCj4KPiAtIGFu
IGV4YW1wbGUgb2YgdGhlIGNyYXNoPyBJcyBpdCB3aXRoaW4gdGhlIGRlY29tcHJlc3Nvcj8gQWZ0
ZXI/IFRoaXMKPiB0aGluZ3MgZG8gbWF0dGVyLCBnaXZlbiB0aGUgbnVtYmVyIG9mIGNyYXp5IHRo
aW5ncyB0aGUgMzJiaXQga2VybmVsIGRvZXMKClRoZXkgYXJlIGFsd2F5cyBpbiB1c2VyIHNwYWNl
LiBNeSBjdXJyZW50IHJlcHJvZHVjZXIgaXMgdGhpczoKCiDCoCAkIHdoaWxlIHJwbSAtcWEgPiAv
ZGV2L251bGw7IGRvIDo7IGRvbmUKCklmIEkgcnVuIHRoaXMgaW4gcGFyYWxsZWwgd2l0aCBzb21l
dGhpbmcgdGhhdCBqdXN0IHBvcHVsYXRlcyBSQU0gKGRkIAppZj0vZGV2L252bWUwbjEgb2Y9L2Rl
di9udWxsIGJzPTEwRykgSSBnZXQgYW4gaWxsZWdhbCBpbnN0cnVjdGlvbiBmYXVsdCAKd2l0aGlu
IHNlY29uZHM6CgpzaC00LjQjIHdoaWxlIHJwbSAtcWEgPiAvZGV2L251bGw7IGRvIHRydWU7IGRv
bmUKSWxsZWdhbCBpbnN0cnVjdGlvbiAoY29yZSBkdW1wZWQpCgoKPiAtIGEgaG9zdCBrZXJuZWwg
Y29uZmlndXJhdGlvbj8KCkhvc3Qga2VybmVsIGNvbmZpZ3VyYXRpb24gaXMganVzdCB0aGUgbm9y
bWFsIG9wZW5TVVNFIG9uZToKCmh0dHBzOi8va2VybmVsLm9wZW5zdXNlLm9yZy9jZ2l0L2tlcm5l
bC1zb3VyY2UvcGxhaW4vY29uZmlnL2FybTY0L2RlZmF1bHQ/aD1zdGFibGUKCj4+IElmIGFueW9u
ZSBpcyBpbnRlcmVzdGVkIGluIGEgcmVwcm9kdWNlciwgSSBoYXZlIHNvbWV0aGluZyBoYW5keS4g
QnV0IGZvcgo+PiBub3cgSSBiZWxpZXZlIHdlIHNob3VsZCBqdXN0IHJldmVydCB0aGlzIHBhdGNo
Lgo+IEJlZm9yZSB3ZSByZXZlcnQgYW55dGhpbmcsIEknZCBsaWtlIHRvIHVuZGVyc3RhbmQgd2hh
dCBpcyBoYXBwZW5pbmcuCgpZZWFoLCBJIGRpZG4ndCByZWFsaXplIHRoZSBjb21taXQgaXMgYWxy
ZWFkeSBpbiBzaW5jZSA0LjE2LCBzbyBJIGFncmVlLiAKSSdsbCBiaXNlY3QgYSBiaXQsIGJ1dCBp
dCBtYXkgdGFrZSBhIHdoaWxlLgoKCkFsZXgKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNv
bHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZv
L2t2bWFybQo=
