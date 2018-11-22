From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [RFC PATCH v2 21/23] KVM: arm64/sve: allow
 KVM_ARM_SVE_CONFIG_QUERY on vm fd
Date: Thu, 22 Nov 2018 15:29:47 +0000
Message-ID: <878t1li104.fsf@linaro.org>
References: <1538141967-15375-1-git-send-email-Dave.Martin@arm.com>
 <1538141967-15375-22-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AFD964A1DD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Nov 2018 10:29:51 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RQL7TTk3wsgu for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Nov 2018 10:29:50 -0500 (EST)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
 [209.85.128.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 834C64A1D8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Nov 2018 10:29:50 -0500 (EST)
Received: by mail-wm1-f67.google.com with SMTP id j207so2241941wmj.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Nov 2018 07:29:50 -0800 (PST)
In-reply-to: <1538141967-15375-22-git-send-email-Dave.Martin@arm.com>
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

CkRhdmUgTWFydGluIDxEYXZlLk1hcnRpbkBhcm0uY29tPiB3cml0ZXM6Cgo+IFNpbmNlIHVzZXJz
cGFjZSBtYXkgbmVlZCB0byBkZWNpZGUgb24gdGhlIHNldCBvZiB2ZWN0b3IgbGVuZ3RocyBmb3IK
PiB0aGUgZ3Vlc3QgYmVmb3JlIHNldHRpbmcgdXAgYSB2bSwgaXQgaXMgb25lcm91cyB0byByZXF1
aXJlIGEgdmNwdQo+IGZkIHRvIGJlIGF2YWlsYWJsZSBmaXJzdC4gIEtWTV9BUk1fU1ZFX0NPTkZJ
R19RVUVSWSBpcyBub3QKPiB2Y3B1LWRlcGVuZGVudCBhbnl3YXksIHNvIHRoaXMgcGF0Y2ggd2ly
ZXMgdXAgS1ZNX0FSTV9TVkVfQ09ORklHIHRvCj4gYmUgdXNhYmxlIG9uIGEgdm0gZmQgd2hlcmUg
YXBwcm9wcmlhdGUuCj4KPiBTdWJjb21tYW5kcyB0aGF0IGFyZSB2Y3B1LWRlcGVuZGVudCAoY3Vy
cmVudGx5Cj4gS1ZNX0FSTV9TVkVfQ09ORklHX1NFVCwgS1ZNX0FSTV9TVkVfQ09ORklHX0dFVCkg
d2lsbCByZXR1cm4gLUVJTlZBTAo+IGlmIGludm9rZWQgb24gYSB2bSBmZC4KPgo+IFNpZ25lZC1v
ZmYtYnk6IERhdmUgTWFydGluIDxEYXZlLk1hcnRpbkBhcm0uY29tPgoKQXByb3BvcyBjb21tZW50
cyBvbiBsYXN0IHBhdGNoLCB0aGlzIGNvdWxkIGdvIGF3YXkgaWYgd2Ugd2VudCB3aXRoIGp1c3QK
cmVwb3J0aW5nIHRoZSBtYXggVkwgdmlhIHRoZSBTVkUgY2FwYWJpbGl0eSBwcm9iZSB3aGljaCB3
b3JrcyBvbiB0aGUKdm1mZC4KCj4gLS0tCj4gIGFyY2gvYXJtNjQva3ZtL2d1ZXN0LmMgfCAxNyAr
KysrKysrKysrKysrKysrLQo+ICAxIGZpbGUgY2hhbmdlZCwgMTYgaW5zZXJ0aW9ucygrKSwgMSBk
ZWxldGlvbigtKQo+Cj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL2d1ZXN0LmMgYi9hcmNo
L2FybTY0L2t2bS9ndWVzdC5jCj4gaW5kZXggZjA2NmIxNy4uMjMxM2MyMiAxMDA2NDQKPiAtLS0g
YS9hcmNoL2FybTY0L2t2bS9ndWVzdC5jCj4gKysrIGIvYXJjaC9hcm02NC9rdm0vZ3Vlc3QuYwo+
IEBAIC01NzQsNiArNTc0LDkgQEAgc3RhdGljIGludCBrdm1fdmNwdV9zZXRfc3ZlX3ZscyhzdHJ1
Y3Qga3ZtX3ZjcHUgKnZjcHUsIHN0cnVjdCBrdm1fc3ZlX3ZscyAqdmxzLAo+ICAJdW5zaWduZWQg
aW50IHZxLCBtYXhfdnE7Cj4gIAlpbnQgcmV0Owo+Cj4gKwlpZiAoIXZjcHUpCj4gKwkJcmV0dXJu
IC1FSU5WQUw7IC8qIHBlci12Y3B1IG9wZXJhdGlvbiBvbiB2bSBmZCAqLwo+ICsKPiAgCWlmICh2
Y3B1LT5hcmNoLmhhc19ydW5fb25jZSB8fCB2Y3B1X2hhc19zdmUodmNwdSkpCj4gIAkJcmV0dXJu
IC1FQkFERkQ7IC8qIHRvbyBsYXRlLCBvciBhbHJlYWR5IGNvbmZpZ3VyZWQgKi8KPgo+IEBAIC02
NTksNiArNjYyLDkgQEAgc3RhdGljIGludCBrdm1fdmNwdV9xdWVyeV9zdmVfdmxzKHN0cnVjdCBr
dm1fdmNwdSAqdmNwdSwgc3RydWN0IGt2bV9zdmVfdmxzICp2bHMKPiAgc3RhdGljIGludCBrdm1f
dmNwdV9nZXRfc3ZlX3ZscyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHN0cnVjdCBrdm1fc3ZlX3Zs
cyAqdmxzLAo+ICAJCXN0cnVjdCBrdm1fc3ZlX3ZscyBfX3VzZXIgKnVzZXJwKQo+ICB7Cj4gKwlp
ZiAoIXZjcHUpCj4gKwkJcmV0dXJuIC1FSU5WQUw7IC8qIHBlci12Y3B1IG9wZXJhdGlvbiBvbiB2
bSBmZCAqLwo+ICsKPiAgCWlmICghdmNwdV9oYXNfc3ZlKHZjcHUpKQo+ICAJCXJldHVybiAtRUJB
REZEOyAvKiBub3QgY29uZmlndXJlZCB5ZXQgKi8KPgo+IEBAIC02NjgsNiArNjc0LDcgQEAgc3Rh
dGljIGludCBrdm1fdmNwdV9nZXRfc3ZlX3ZscyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHN0cnVj
dCBrdm1fc3ZlX3ZscyAqdmxzLAo+ICAJCQlzdmVfdnFfZnJvbV92bCh2Y3B1LT5hcmNoLnN2ZV9t
YXhfdmwpLCB1c2VycCk7Cj4gIH0KPgo+ICsvKiB2Y3B1IG1heSBiZSBOVUxMIGlmIHRoaXMgaXMg
Y2FsbGVkIHZpYSBhIHZtIGZkICovCj4gIHN0YXRpYyBpbnQga3ZtX3ZjcHVfc3ZlX2NvbmZpZyhz
dHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsCj4gIAkJCSAgICAgICBzdHJ1Y3Qga3ZtX3N2ZV92bHMgX191
c2VyICp1c2VycCkKPiAgewo+IEBAIC03MTcsNyArNzI0LDE1IEBAIGludCBrdm1fYXJtX2FyY2hf
dmNwdV9pb2N0bChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsCj4gIGludCBrdm1fYXJtX2FyY2hfdm1f
aW9jdGwoc3RydWN0IGt2bSAqa3ZtLAo+ICAJCQkgIHVuc2lnbmVkIGludCBpb2N0bCwgdW5zaWdu
ZWQgbG9uZyBhcmcpCj4gIHsKPiAtCXJldHVybiAtRUlOVkFMOwo+ICsJdm9pZCBfX3VzZXIgKnVz
ZXJwID0gKHZvaWQgX191c2VyICopYXJnOwo+ICsKPiArCXN3aXRjaCAoaW9jdGwpIHsKPiArCWNh
c2UgS1ZNX0FSTV9TVkVfQ09ORklHOgo+ICsJCXJldHVybiBrdm1fdmNwdV9zdmVfY29uZmlnKE5V
TEwsIHVzZXJwKTsKPiArCj4gKwlkZWZhdWx0Ogo+ICsJCXJldHVybiAtRUlOVkFMOwo+ICsJfQo+
ICB9Cj4KPiAgaW50IGt2bV9hcmNoX3ZjcHVfaW9jdGxfZ2V0X2ZwdShzdHJ1Y3Qga3ZtX3ZjcHUg
KnZjcHUsIHN0cnVjdCBrdm1fZnB1ICpmcHUpCgoKLS0KQWxleCBCZW5uw6llCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QK
a3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVk
dS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
