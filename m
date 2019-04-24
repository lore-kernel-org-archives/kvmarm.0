From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v7 11/27] KVM: arm64: Support runtime sysreg visibility
 filtering
Date: Wed, 24 Apr 2019 09:39:31 +0000
Message-ID: <87h8anwxm4.fsf@zen.linaroharston>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
 <1553864452-15080-12-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DAA124A47E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Apr 2019 05:39:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qns4vadE-3TP for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Apr 2019 05:39:34 -0400 (EDT)
Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com
 [209.85.221.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D7AC94A476
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Apr 2019 05:39:33 -0400 (EDT)
Received: by mail-wr1-f68.google.com with SMTP id c5so15301742wrs.11
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Apr 2019 02:39:33 -0700 (PDT)
In-reply-to: <1553864452-15080-12-git-send-email-Dave.Martin@arm.com>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

CkRhdmUgTWFydGluIDxEYXZlLk1hcnRpbkBhcm0uY29tPiB3cml0ZXM6Cgo+IFNvbWUgb3B0aW9u
YWwgZmVhdHVyZXMgb2YgdGhlIEFybSBhcmNoaXRlY3R1cmUgYWRkIG5ldyBzeXN0ZW0KPiByZWdp
c3RlcnMgdGhhdCBhcmUgbm90IHByZXNlbnQgaW4gdGhlIGJhc2UgYXJjaGl0ZWN0dXJlLgo+Cj4g
V2hlcmUgdGhlc2UgZmVhdHVyZXMgYXJlIG9wdGlvbmFsIGZvciB0aGUgZ3Vlc3QsIHRoZSB2aXNp
YmlsaXR5IG9mCj4gdGhlc2UgcmVnaXN0ZXJzIG1heSBuZWVkIHRvIGRlcGVuZCBvbiBzb21lIHJ1
bnRpbWUgY29uZmlndXJhdGlvbiwKPiBzdWNoIGFzIGEgZmxhZyBwYXNzZWQgdG8gS1ZNX0FSTV9W
Q1BVX0lOSVQuCgpUaGlzIGNvbWJpbmVkIHdpdGguLi4KPiAtLS0gYS9hcmNoL2FybTY0L2t2bS9z
eXNfcmVncy5oCj4gKysrIGIvYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuaAo+IEBAIC02NCw4ICs2
NCwxNSBAQCBzdHJ1Y3Qgc3lzX3JlZ19kZXNjIHsKPiAgCQkJY29uc3Qgc3RydWN0IGt2bV9vbmVf
cmVnICpyZWcsIHZvaWQgX191c2VyICp1YWRkcik7Cj4gIAlpbnQgKCpzZXRfdXNlcikoc3RydWN0
IGt2bV92Y3B1ICp2Y3B1LCBjb25zdCBzdHJ1Y3Qgc3lzX3JlZ19kZXNjICpyZCwKPiAgCQkJY29u
c3Qgc3RydWN0IGt2bV9vbmVfcmVnICpyZWcsIHZvaWQgX191c2VyICp1YWRkcik7Cj4gKwo+ICsJ
LyogUmV0dXJuIG1hc2sgb2YgUkVHXyogcnVudGltZSB2aXNpYmlsaXR5IG92ZXJyaWRlcyAqLwo+
ICsJdW5zaWduZWQgaW50ICgqdmlzaWJpbGl0eSkoY29uc3Qgc3RydWN0IGt2bV92Y3B1ICp2Y3B1
LAo+ICsJCQkJICAgY29uc3Qgc3RydWN0IHN5c19yZWdfZGVzYyAqcmQpOwo+ICB9OwoKdGhpcyBt
YWtlcyBtZSB3b25kZXIgd2hhdCBzb3J0IG9mIG1hY2hpbmVzIHdpbGwgc2VlIGRpZmZlcmVudCBy
ZWdpc3Rlcgp2aXNpYmlsaXR5IGRlcGVuZGluZyBvbiB3aGljaCB2Y3B1IHlvdSBhcmUgcnVubmlu
ZyBvbj8KCk90aGVyd2lzZSBpcyBsb29rcyBnb29kIHRvIG1lOgoKUmV2aWV3ZWQtYnk6IEFsZXgg
QmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4KCi0tCkFsZXggQmVubsOpZQpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBs
aXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJp
YS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
