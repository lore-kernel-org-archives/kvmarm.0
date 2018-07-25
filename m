From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [RFC PATCH 13/16] KVM: Allow 2048-bit register access via
 KVM_{GET, SET}_ONE_REG
Date: Wed, 25 Jul 2018 16:58:30 +0100
Message-ID: <874lgntihl.fsf@linaro.org>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
 <1529593060-542-14-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EABF64A0F6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jul 2018 11:58:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BTlxUXbO12ij for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Jul 2018 11:58:32 -0400 (EDT)
Received: from mail-wm0-f65.google.com (mail-wm0-f65.google.com [74.125.82.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C2C1540A50
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jul 2018 11:58:32 -0400 (EDT)
Received: by mail-wm0-f65.google.com with SMTP id o11-v6so6562783wmh.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jul 2018 08:58:32 -0700 (PDT)
In-reply-to: <1529593060-542-14-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

CkRhdmUgTWFydGluIDxEYXZlLk1hcnRpbkBhcm0uY29tPiB3cml0ZXM6Cgo+IFRoZSBBcm0gU1ZF
IGFyY2hpdGVjdHVyZSBkZWZpbmVzIHJlZ2lzdGVycyB0aGF0IGFyZSB1cCB0byAyMDQ4IGJpdHMK
PiBpbiBzaXplICh3aXRoIHNvbWUgcG9zc2liaWxpdHkgb2YgZnVydGhlciBmdXR1cmUgZXhwYW5z
aW9uKS4KPgo+IEluIG9yZGVyIHRvIGF2b2lkIHRoZSBuZWVkIGZvciBhbiBleGNlc3NpdmVseSBs
YXJnZSBudW1iZXIgb2YKPiBpb2N0bHMgd2hlbiBzYXZpbmcgYW5kIHJlc3RvcmluZyBhIHZjcHUn
cyByZWdpc3RlcnMsIHRoaXMgcGF0Y2gKPiBhZGRzIGEgI2RlZmluZSB0byBtYWtlIHN1cHBvcnQg
Zm9yIGluZGl2aWR1YWwgMjA0OC1iaXQgcmVnaXN0ZXJzCj4gdGhyb3VnaCB0aGUgS1ZNX3tHRVQs
U0VUfV9PTkVfUkVHIGlvY3RsIGludGVyZmFjZSBvZmZpY2lhbC4gIFRoaXMKPiB3aWxsIGFsbG93
IGVhY2ggU1ZFIHJlZ2lzdGVyIHRvIGJlIGFjY2Vzc2VkIGluIGEgc2luZ2xlIGNhbGwuCj4KPiBU
aGVyZSBhcmUgc3VmZmljaWVudCBzcGFyZSBiaXRzIGluIHRoZSByZWdpc3RlciBpZCBzaXplIGZp
ZWxkIGZvcgo+IHRoaXMgY2hhbmdlLCBzbyB0aGVyZSBpcyBubyBBQkkgaW1wYWN0IHByb3ZpZGlu
ZyB0aGF0Cj4gS1ZNX0dFVF9SRUdfTElTVCBkb2VzIG5vdCBlbnVtZXJhdGUgYW55IDIwNDgtYml0
IHJlZ2lzdGVyIHVubGVzcwo+IHVzZXJzcGFjZSBleHBsaWNpdGx5IG9wdHMgaW4gdG8gdGhlIHJl
bGV2YW50IGFyY2hpdGVjdHVyZS1zcGVjaWZpYwo+IGZlYXR1cmVzLgoKRG9lcyBpdD8gSXQncyBu
b3QgaW4gdGhpcyBwYXRjaCBhbmQgbG9va2luZyBhdCB0aGUgZmluYWwgdHJlZToKCiAgdW5zaWdu
ZWQgbG9uZyBrdm1fYXJtX251bV9yZWdzKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkKICB7CiAgICAg
ICAgICB1bnNpZ25lZCBsb25nIHJlcyA9IDA7CgogICAgICAgICAgcmVzICs9IG51bV9jb3JlX3Jl
Z3MoKTsKICAgICAgICAgIHJlcyArPSBudW1fc3ZlX3JlZ3ModmNwdSk7CiAgICAgICAgICByZXMg
Kz0ga3ZtX2FybV9udW1fc3lzX3JlZ19kZXNjcyh2Y3B1KTsKICAgICAgICAgIHJlcyArPSBrdm1f
YXJtX2dldF9md19udW1fcmVncyh2Y3B1KTsKICAgICAgICAgIHJlcyArPSBOVU1fVElNRVJfUkVH
UzsKCiAgICAgICAgICByZXR1cm4gcmVzOwogIH0KCgp3aGljaCBsZWFkcyB0bzoKCiAgc3RhdGlj
IGludCBlbnVtZXJhdGVfc3ZlX3JlZ3MoY29uc3Qgc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1NjQg
X191c2VyICoqdWluZCkKICB7CiAgICAgICAgICB1bnNpZ25lZCBpbnQgbiwgaTsKICAgICAgICAg
IGludCBlcnIgPSAwOwogICAgICAgICAgaW50IHRvdGFsID0gMDsKICAgICAgICAgIHVuc2lnbmVk
IGludCBzbGljZXM7CgogICAgICAgICAgaWYgKCF2Y3B1X2hhc19zdmUoJnZjcHUtPmFyY2gpKQog
ICAgICAgICAgICAgICAgICByZXR1cm4gMDsKCldoaWNoIGVudW1lcmF0ZXMgdGhlIFNWRSByZWdz
IGlmIHZjcHVfaGFzX3N2ZSgpIHdoaWNoIEFGQUlDVCBpcyB0cnVlIGlmCnRoZSBob3N0IHN1cHBv
cnRzIGl0LCBub3QgaWYgdGhlIHVzZXIgaGFzIHJlcXVlc3RlZCBpdC4KCkknbGwgaGF2ZSB0byBj
aGVjayB3aGF0IGJ1dCBnaXZlbiB0aGUgaW5kaXJlY3Rpb24gb2Yga3ZtX29uZV9yZWcgSQp3b25k
ZXIgaWYgZXhpc3RpbmcgYmluYXJpZXMgbWlnaHQgZW5kIHVwIHNwYW1taW5nIGEgYmFkbHkgc2l6
ZWQgYXJyYXkKd2hlbiBydW4gb24gYSBuZXcgU1ZFIHN1cHBvcnRpbmcga2VybmVsPwoKPgo+IFNp
Z25lZC1vZmYtYnk6IERhdmUgTWFydGluIDxEYXZlLk1hcnRpbkBhcm0uY29tPgo+IC0tLQo+ICBp
bmNsdWRlL3VhcGkvbGludXgva3ZtLmggfCAxICsKPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0
aW9uKCspCj4KPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS91YXBpL2xpbnV4L2t2bS5oIGIvaW5jbHVk
ZS91YXBpL2xpbnV4L2t2bS5oCj4gaW5kZXggYjYyNzBhMy4uMzQ1YmU4OCAxMDA2NDQKPiAtLS0g
YS9pbmNsdWRlL3VhcGkvbGludXgva3ZtLmgKPiArKysgYi9pbmNsdWRlL3VhcGkvbGludXgva3Zt
LmgKPiBAQCAtMTEwNiw2ICsxMTA2LDcgQEAgc3RydWN0IGt2bV9kaXJ0eV90bGIgewo+ICAjZGVm
aW5lIEtWTV9SRUdfU0laRV9VMjU2CTB4MDA1MDAwMDAwMDAwMDAwMFVMTAo+ICAjZGVmaW5lIEtW
TV9SRUdfU0laRV9VNTEyCTB4MDA2MDAwMDAwMDAwMDAwMFVMTAo+ICAjZGVmaW5lIEtWTV9SRUdf
U0laRV9VMTAyNAkweDAwNzAwMDAwMDAwMDAwMDBVTEwKPiArI2RlZmluZSBLVk1fUkVHX1NJWkVf
VTIwNDgJMHgwMDgwMDAwMDAwMDAwMDAwVUxMCj4KPiAgc3RydWN0IGt2bV9yZWdfbGlzdCB7Cj4g
IAlfX3U2NCBuOyAvKiBudW1iZXIgb2YgcmVncyAqLwoKCi0tCkFsZXggQmVubsOpZQpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBs
aXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJp
YS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
