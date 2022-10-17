Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6A1EC4332F
	for <kvmarm@archiver.kernel.org>; Wed, 19 Oct 2022 06:31:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EEF34B905;
	Wed, 19 Oct 2022 02:31:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vj2LPXoYwRe7; Wed, 19 Oct 2022 02:31:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 02ED84B91D;
	Wed, 19 Oct 2022 02:31:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA2374B256
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Oct 2022 18:57:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M860dkNE7pry for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Oct 2022 18:57:06 -0400 (EDT)
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1D0954A105
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Oct 2022 18:57:06 -0400 (EDT)
Received: from MUA by vps-vb.mhejs.net with esmtps (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94.2)
 (envelope-from <mail@maciej.szmigiero.name>)
 id 1okZ2Z-00024i-Nz; Tue, 18 Oct 2022 00:56:59 +0200
Message-ID: <93529fb7-f558-cc5f-d5bd-7923eb4b492c@maciej.szmigiero.name>
Date: Tue, 18 Oct 2022 00:56:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH 5/6] KVM: selftests: memslot_perf_test: Consolidate memory
 sizes
Content-Language: en-US, pl-PL
To: Gavin Shan <gshan@redhat.com>, Sean Christopherson <seanjc@google.com>
References: <20221014071914.227134-1-gshan@redhat.com>
 <20221014071914.227134-6-gshan@redhat.com>
 <cebafa0d-a2dc-c3f7-64c8-2637a254e3d0@maciej.szmigiero.name>
 <Y03ScGUUCA1KwlLF@google.com>
 <9781c88f-06f9-4d17-8fa6-3cd82a739ccb@redhat.com>
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
In-Reply-To: <9781c88f-06f9-4d17-8fa6-3cd82a739ccb@redhat.com>
X-Mailman-Approved-At: Wed, 19 Oct 2022 02:31:08 -0400
Cc: kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 zhenyzha@redhat.com, shan.gavin@gmail.com, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, shuah@kernel.org, kvmarm@lists.cs.columbia.edu,
 ajones@ventanamicro.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMTguMTAuMjAyMiAwMDo1MSwgR2F2aW4gU2hhbiB3cm90ZToKPiBPbiAxMC8xOC8yMiA2OjA4
IEFNLCBTZWFuIENocmlzdG9waGVyc29uIHdyb3RlOgo+PiBPbiBNb24sIE9jdCAxNywgMjAyMiwg
TWFjaWVqIFMuIFN6bWlnaWVybyB3cm90ZToKPj4+PiArI2RlZmluZSBNRU1fRVhUUkFfU0laRcKg
wqDCoMKgwqDCoMKgIDB4MTAwMDAKPj4+Cj4+PiBBbHNvLCBhbiBleHByZXNzaW9uIGxpa2UgIig2
NCA8PCAxMCkiIGlzIG1vcmUgcmVhZGFibGUgdGhhbiBhICIxIgo+Pj4gd2l0aCBhIHRhaWwgb2Yg
emVyb2VzIChpdCdzIGVhc3kgdG8gYWRkIG9uZSB6ZXJvIHRvbyBtYW55IG9yIGJlIG9uZQo+Pj4g
emVybyBzaG9ydCkuCj4+Cj4+ICsxIHRvIG5vdCBvcGVuIGNvZGluZyByYXcgbnVtYmVycy4KPj4K
Pj4gSSB0aGluayBpdCdzIGhpZ2ggdGltZSBLVk0gc2VsZnRlc3RzIGFkZCAjZGVmaW5lcyBmb3Ig
dGhlIGNvbW1vbiBzaXplcywgZS5nLiBTSVpFXzRLQiwKPj4gMTZLQiwgNjRLLCAyTUIsIDFHQiwg
ZXRjLi4uCj4+Cj4+IEFsdGVybmF0aXZlbHkgKG9yIGluIGFkZGl0aW9uKSwganVzdCAjZGVmaW5l
IDFLQiwgMU1CLCAxR0IsIGFuZCAxVEIsIGFuZCB0aGVuIGRvCj4+IG1hdGggb2ZmIG9mIHRob3Nl
Lgo+Pgo+IAo+IE9rLiBJIHdpbGwgaGF2ZSBvbmUgc2VwYXJhdGUgcGF0Y2ggdG8gZGVmaW5lIHRo
b3NlIHNpemVzIGluIGt2bV91dGlsX2Jhc2UuaCwKPiByaWdodCBhZnRlciAnI2RlZmluZSBOU0VD
X1BFUl9TRUMgMTAwMDAwMDAwMEwnLiBTZWFuLCBjb3VsZCB5b3UgbGV0IG1lIGtub3cKPiBpZiBp
dCBsb29rcyBnb29kIHRvIHlvdT8KPiAKPiAgwqDCoMKgICNkZWZpbmUgS0LCoMKgwqDCoMKgwqDC
oMKgICgxVUwgPDwgMTApCj4gIMKgwqDCoCAjZGVmaW5lIE1CwqDCoMKgwqDCoMKgwqDCoCAoMVVM
IDw8IDIwKQo+ICDCoMKgwqAgI2RlZmluZSBHQsKgwqDCoMKgwqDCoMKgwqAgKDFVTCA8PCAzMCkK
PiAgwqDCoMKgICNkZWZpbmUgVELCoMKgwqDCoMKgwqDCoMKgICgxVUwgPDwgNDApCj4gCj4gIMKg
wqDCoCAvKiBCYXNlIHBhZ2UgYW5kIGh1Z2UgcGFnZSBzaXplICovCj4gIMKgwqDCoCAjZGVmaW5l
IFNJWkVfNEtCwqDCoCAowqAgNCAqIEtCKQo+ICDCoMKgwqAgI2RlZmluZSBTSVpFXzE2S0LCoCAo
IDE2ICogS0IpCj4gIMKgwqDCoCAjZGVmaW5lIFNJWkVfNjRLQsKgICggNjQgKiBLQikKPiAgwqDC
oMKgICNkZWZpbmUgU0laRV8yTULCoMKgICjCoCAyICogTUIpCj4gIMKgwqDCoCAjZGVmaW5lIFNJ
WkVfMzJNQsKgICggMzIgKiBNQikKPiAgwqDCoMKgICNkZWZpbmUgU0laRV81MTJNQiAoNTEyICog
TUIpCj4gIMKgwqDCoCAjZGVmaW5lIFNJWkVfMUdCwqDCoCAowqAgMSAqIEdCKQo+ICDCoMKgwqAg
I2RlZmluZSBTSVpFXzE2R0LCoCAoIDE2ICogR0IpCgpGWUksIFFFTVUgdXNlcyBLaUIsIE1pQiwg
R2lCLCBldGMuLCBzZWUgWzFdLgoKPiBUaGFua3MsCj4gR2F2aW4KPiAKClRoYW5rcywKTWFjaWVq
CgpbMV06IGh0dHBzOi8vZ2l0LnFlbXUub3JnLz9wPXFlbXUuZ2l0O2E9YmxvYjtmPWluY2x1ZGUv
cWVtdS91bml0cy5oO2hiPUhFQUQKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlh
LmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFy
bQo=
