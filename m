From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [RFC PATCH 07/16] arm64/sve: Enable SVE state tracking for
 non-task contexts
Date: Wed, 25 Jul 2018 14:58:29 +0100
Message-ID: <87a7qfto1m.fsf@linaro.org>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
 <1529593060-542-8-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CBF9540672
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jul 2018 09:58:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8srdZfvyLt+Q for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Jul 2018 09:58:32 -0400 (EDT)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EA610404D9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jul 2018 09:58:31 -0400 (EDT)
Received: by mail-wr1-f67.google.com with SMTP id h10-v6so7527804wre.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jul 2018 06:58:31 -0700 (PDT)
In-reply-to: <1529593060-542-8-git-send-email-Dave.Martin@arm.com>
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

CkRhdmUgTWFydGluIDxEYXZlLk1hcnRpbkBhcm0uY29tPiB3cml0ZXM6Cgo+IFRoZSBjdXJyZW50
IEZQU0lNRC9TVkUgY29udGV4dCBoYW5kbGluZyBzdXBwb3J0IGZvciBub24tdGFzayAoaS5lLiwK
PiBLVk0gdmNwdSkgY29udGV4dHMgZG9lcyBub3QgdGFrZSBTVkUgaW50byBhY2NvdW50LiAgVGhp
cyBtZWFucyB0aGF0Cj4gb25seSB0YXNrIGNvbnRleHRzIGNhbiBzYWZlbHkgdXNlIFNWRSBhdCBw
cmVzZW50Lgo+Cj4gSW4gcHJlcGFyYXRpb24gZm9yIGVuYWJsaW5nIEtWTSBndWVzdHMgdG8gdXNl
IFNWRSwgaXQgaXMgbmVjZXNzYXJ5Cj4gdG8ga2VlcCB0cmFjayBvZiBTVkUgc3RhdGUgZm9yIG5v
bi10YXNrIGNvbnRleHRzIHRvby4KPgo+IFRoaXMgcGF0Y2ggYWRkcyB0aGUgbmVjZXNzYXJ5IHN1
cHBvcnQsIHJlbW92aW5nIGFzc3VtcHRpb25zIGZyb20KPiB0aGUgY29udGV4dCBzd2l0Y2ggY29k
ZSBhYm91dCB0aGUgbG9jYXRpb24gb2YgdGhlIFNWRSBjb250ZXh0Cj4gc3RvcmFnZS4KPgo+IFdo
ZW4gYmluZGluZyBhIHZjcHUgY29udGV4dCwgaXRzIHZlY3RvciBsZW5ndGggaXMgYXJiaXRyYXJp
bHkKPiBzcGVjaWZpZWQgYXMgc3ZlX21heF92bCBmb3Igbm93LiAgSW4gYW55IGNhc2UsIGJlY2F1
c2UgVElGX1NWRSBpcwo+IHByZXNlbnRseSBjbGVhcmVkIGF0IHZjcHUgY29udGV4dCBiaW5kIHRp
bWUsIHRoZSBzcGVjaWZpZWQgdmVjdG9yCj4gbGVuZ3RoIHdpbGwgbm90IGJlIHVzZWQgZm9yIGFu
eXRoaW5nIHlldC4gIEluIGxhdGVyIHBhdGNoZXMgVElGX1NWRQo+IHdpbGwgYmUgc2V0IGhlcmUg
YXMgYXBwcm9wcmlhdGUsIGFuZCB0aGUgYXBwcm9wcmlhdGUgbWF4aW11bSB2ZWN0b3IKPiBsZW5n
dGggZm9yIHRoZSB2Y3B1IHdpbGwgYmUgcGFzc2VkIHdoZW4gYmluZGluZy4KPHNuaXA+Cj4gLS0t
IGEvYXJjaC9hcm02NC9rZXJuZWwvZnBzaW1kLmMKPiArKysgYi9hcmNoL2FybTY0L2tlcm5lbC9m
cHNpbWQuYwo+IEBAIC0xMjEsNiArMTIxLDggQEAKPiAgICovCj4gIHN0cnVjdCBmcHNpbWRfbGFz
dF9zdGF0ZV9zdHJ1Y3Qgewo+ICAJc3RydWN0IHVzZXJfZnBzaW1kX3N0YXRlICpzdDsKPiArCXZv
aWQgKnN2ZV9zdGF0ZTsKPiArCXVuc2lnbmVkIGludCBzdmVfdmw7Cj4gIH07Cgo+IC0Jc3RydWN0
IHVzZXJfZnBzaW1kX3N0YXRlICpzdCA9IF9fdGhpc19jcHVfcmVhZChmcHNpbWRfbGFzdF9zdGF0
ZS5zdCk7Cj4gKwlzdHJ1Y3QgZnBzaW1kX2xhc3Rfc3RhdGVfc3RydWN0IGNvbnN0ICpsYXN0ID0K
PiArCQl0aGlzX2NwdV9wdHIoJmZwc2ltZF9sYXN0X3N0YXRlKTsKPHNuaXA+Cj4gQEAgLTEwNzQs
NiArMTA4Miw4IEBAIHZvaWQgZnBzaW1kX2JpbmRfc3RhdGVfdG9fY3B1KHN0cnVjdCB1c2VyX2Zw
c2ltZF9zdGF0ZSAqc3QpCj4gIAlXQVJOX09OKCFpbl9zb2Z0aXJxKCkgJiYgIWlycXNfZGlzYWJs
ZWQoKSk7Cj4KPiAgCWxhc3QtPnN0ID0gc3Q7Cj4gKwlsYXN0LT5zdmVfc3RhdGUgPSBzdmVfc3Rh
dGU7Cj4gKwlsYXN0LT5zdmVfdmwgPSBzdmVfdmw7Cj4gIH0KCkknbSBzdWZmZXJpbmcgYSBsaXR0
bGUgY29nbml0aXZlIGRpc3NvbmFuY2Ugd2l0aCB0aGUgdXNlIG9mIGxhc3QgaGVyZQpiZWNhdXNl
IGlzbid0IGl0IHJlYWxseSB0aGUgc3RhdGUgYXMgaXQgaXMgbm93IC0gYXMgd2UgYmluZCB0byB0
aGUgY3B1PwoKQW55d2F5IG5vdCBzdXBlciByZWxldmFudCB0byB0aGlzIHBhdGNoIGFzIHRoZSBu
YW1lIGhhcyBhbHJlYWR5IGJlZW4KY2hvc2VuIHNvOgoKUmV2aWV3ZWQtYnk6IEFsZXggQmVubsOp
ZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4KCi0tCkFsZXggQmVubsOpZQpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2
bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUv
bWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
