From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [RFC PATCH 09/16] KVM: arm64: Allow ID registers to by
 dynamically read-as-zero
Date: Wed, 25 Jul 2018 16:46:55 +0100
Message-ID: <876013tj0w.fsf@linaro.org>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
 <1529593060-542-10-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C2BDE4A0F6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jul 2018 11:46:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3z0PNnKqq8u8 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Jul 2018 11:46:58 -0400 (EDT)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C7B4040A50
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jul 2018 11:46:57 -0400 (EDT)
Received: by mail-wr1-f65.google.com with SMTP id v14-v6so7900172wro.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jul 2018 08:46:57 -0700 (PDT)
In-reply-to: <1529593060-542-10-git-send-email-Dave.Martin@arm.com>
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

CkRhdmUgTWFydGluIDxEYXZlLk1hcnRpbkBhcm0uY29tPiB3cml0ZXM6Cgo+IFdoZW4gYSBmZWF0
dXJlLWRlcGVuZGVudCBJRCByZWdpc3RlciBpcyBoaWRkZW4gZnJvbSB0aGUgZ3Vlc3QsIGl0Cj4g
bmVlZHMgdG8gZXhoaWJpdCByZWFkLWFzLXplcm8gYmVoYXZpb3VyIGFzIGRlZmluZWQgYnkgdGhl
IEFybQo+IGFyY2hpdGVjdHVyZSwgcmF0aGVyIHRoYW4gYXBwZWFyaW5nIHRvIGJlIGVudGlyZWx5
IGFic2VudC4KPgo+IFRoaXMgcGF0Y2ggdXBkYXRlcyB0aGUgSUQgcmVnaXN0ZXIgZW11bGF0aW9u
IGxvZ2ljIHRvIG1ha2UgdXNlIG9mCj4gdGhlIG5ldyBjaGVja19wcmVzZW50KCkgbWV0aG9kIHRv
IGRldGVybWluZSB3aGV0aGVyIHRoZSByZWdpc3Rlcgo+IHNob3VsZCByZWFkIGFzIHplcm8gaW5z
dGVhZCBvZiB5aWVsZGluZyB0aGUgaG9zdCdzIHNhbml0aXNlZAo+IHZhbHVlLiAgQmVjYXVzZSBj
dXJyZW50bHkgYSBmYWxzZSByZXN1bHQgZnJvbSB0aGlzIG1ldGhvZCB0cnVuY2F0ZXMKPiB0aGUg
dHJhcCBjYWxsIGNoYWluIGJlZm9yZSB0aGUgc3lzcmVnJ3MgZW11bGF0ZSBtZXRob2QoKSBpcyBj
YWxsZWQsCj4gYSBmbGFnIGlzIGFkZGVkIHRvIGRpc3Rpbmd1aXNoIHRoaXMgc3BlY2lhbCBjYXNl
LCBhbmQgaGVscGVycyBhcmUKPiByZWZhY3RvcmVkIGFwcHJvcHJpYXRlbHkuCj4KPiBUaGlzIGlu
dmxvdmVzIHNvbWUgdHJpdmlhbCB1cGRhdGVzIHRvIHBhc3MgdGhlIHZjcHUgcG9pbnRlciBkb3du
Cj4gaW50byB0aGUgSUQgcmVnaXN0ZXIgZW11bGF0aW9uL2FjY2VzcyBmdW5jdGlvbnMuCj4KPiBB
IG5ldyBJRF9TQU5JVElTRURfSUYoKSBtYWNybyBpcyBkZWZpbmVkIGZvciBkZWNsYXJpbmcKPiBj
b25kaXRpb25hbGx5IHZpc2libGUgSUQgcmVnaXN0ZXJzLgo+Cj4gU2lnbmVkLW9mZi1ieTogRGF2
ZSBNYXJ0aW4gPERhdmUuTWFydGluQGFybS5jb20+Cj4gLS0tCjxzbmlwPgo+IEBAIC0yMzM3LDcg
KzIzNTIsNyBAQCBpbnQga3ZtX2FybV9zeXNfcmVnX3NldF9yZWcoc3RydWN0IGt2bV92Y3B1ICp2
Y3B1LCBjb25zdCBzdHJ1Y3Qga3ZtX29uZV9yZWcgKnJlZwo+ICAJaWYgKCFyKQo+ICAJCXJldHVy
biBzZXRfaW52YXJpYW50X3N5c19yZWcocmVnLT5pZCwgdWFkZHIpOwo+Cj4gLQlpZiAoIXN5c19y
ZWdfcHJlc2VudCh2Y3B1LCByKSkKPiArCWlmICghc3lzX3JlZ19wcmVzZW50X29yX3Jheih2Y3B1
LCByKSkKPiAgCQlyZXR1cm4gLUVOT0VOVDsKCkl0J3MgYWxsIHZlcnkgd2VsbCBiZWluZyByYXos
IGJ1dCBzaG91bGRuJ3QgeW91IGNhdGNoIHRoaXMgZnVydGhlciBkb3duCmFuZCBub3QgYXR0ZW1w
dCB0byB3cml0ZSB0aGUgcmVnaXN0ZXIgdGhhdCBkb2Vzbid0IGV4aXN0PwoKPgo+ICAJaWYgKHIt
PnNldF91c2VyKQo+IEBAIC0yNDA4LDcgKzI0MjMsNyBAQCBzdGF0aWMgaW50IHdhbGtfb25lX3N5
c19yZWcoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LAo+ICAJaWYgKCEocmQtPnJlZyB8fCByZC0+Z2V0
X3VzZXIpKQo+ICAJCXJldHVybiAwOwo+Cj4gLQlpZiAoIXN5c19yZWdfcHJlc2VudCh2Y3B1LCBy
ZCkpCj4gKwlpZiAoIXN5c19yZWdfcHJlc2VudF9vcl9yYXoodmNwdSwgcmQpKQo+ICAJCXJldHVy
biAwOwo+Cj4gIAlpZiAoIWNvcHlfcmVnX3RvX3VzZXIocmQsIHVpbmQpKQo+IGRpZmYgLS1naXQg
YS9hcmNoL2FybTY0L2t2bS9zeXNfcmVncy5oIGIvYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuaAo+
IGluZGV4IGRmYmIzNDIuLjMwNDkyOGYgMTAwNjQ0Cj4gLS0tIGEvYXJjaC9hcm02NC9rdm0vc3lz
X3JlZ3MuaAo+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmgKPiBAQCAtNjYsMTQgKzY2
LDI1IEBAIHN0cnVjdCBzeXNfcmVnX2Rlc2Mgewo+ICAJCQljb25zdCBzdHJ1Y3Qga3ZtX29uZV9y
ZWcgKnJlZywgdm9pZCBfX3VzZXIgKnVhZGRyKTsKPiAgCWJvb2wgKCpjaGVja19wcmVzZW50KShj
b25zdCBzdHJ1Y3Qga3ZtX3ZjcHUgKnZwY3UsCj4gIAkJCSAgICAgIGNvbnN0IHN0cnVjdCBzeXNf
cmVnX2Rlc2MgKnJkKTsKPiArCj4gKwkvKiBPUiBvZiBTUl8qIGZsYWdzICovCj4gKwl1bnNpZ25l
ZCBpbnQgZmxhZ3M7Cj4gIH07Cj4KPiArI2RlZmluZSBTUl9SQVpfSUZfQUJTRU5UCSgxIDw8IDAp
Cj4gKwo+ICBzdGF0aWMgaW5saW5lIGJvb2wgc3lzX3JlZ19wcmVzZW50KGNvbnN0IHN0cnVjdCBr
dm1fdmNwdSAqdmNwdSwKPiAgCQkJCSAgIGNvbnN0IHN0cnVjdCBzeXNfcmVnX2Rlc2MgKnJkKQo+
ICB7Cj4gIAlyZXR1cm4gbGlrZWx5KCFyZC0+Y2hlY2tfcHJlc2VudCkgfHwgcmQtPmNoZWNrX3By
ZXNlbnQodmNwdSwgcmQpOwo+ICB9Cj4KPiArc3RhdGljIGlubGluZSBib29sIHN5c19yZWdfcHJl
c2VudF9vcl9yYXooY29uc3Qgc3RydWN0IGt2bV92Y3B1ICp2Y3B1LAo+ICsJCQkJCSAgY29uc3Qg
c3RydWN0IHN5c19yZWdfZGVzYyAqcmQpCj4gK3sKPiArCXJldHVybiBzeXNfcmVnX3ByZXNlbnQo
dmNwdSwgcmQpIHx8IChyZC0+ZmxhZ3MgJiBTUl9SQVpfSUZfQUJTRU5UKTsKPiArfQo+ICsKPiAg
c3RhdGljIGlubGluZSB2b2lkIHByaW50X3N5c19yZWdfaW5zdHIoY29uc3Qgc3RydWN0IHN5c19y
ZWdfcGFyYW1zICpwKQo+ICB7Cj4gIAkvKiBMb29rLCB3ZSBldmVuIGZvcm1hdHRlZCBpdCBmb3Ig
eW91IHRvIHBhc3RlIGludG8gdGhlIHRhYmxlISAqLwoKCi0tCkFsZXggQmVubsOpZQpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBs
aXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJp
YS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
