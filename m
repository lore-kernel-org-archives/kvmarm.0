From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [RFC PATCH 02/16] KVM: arm64: Delete orphaned declaration for
 __fpsimd_enabled()
Date: Fri, 06 Jul 2018 10:08:37 +0100
Message-ID: <87efgg91ey.fsf@linaro.org>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
 <1529593060-542-3-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B10034A0D7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Jul 2018 04:56:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EUjpRQJjXIlx for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Jul 2018 04:56:07 -0400 (EDT)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0BB7349F8C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Jul 2018 04:56:07 -0400 (EDT)
Received: by mail-wr1-f67.google.com with SMTP id q10-v6so3437132wrd.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 06 Jul 2018 02:08:39 -0700 (PDT)
In-reply-to: <1529593060-542-3-git-send-email-Dave.Martin@arm.com>
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

CkRhdmUgTWFydGluIDxEYXZlLk1hcnRpbkBhcm0uY29tPiB3cml0ZXM6Cgo+IF9fZnBzaW1kX2Vu
YWJsZWQoKSBubyBsb25nZXIgZXhpc3RzLCBidXQgYSBkYW5nbGluZyBkZWNsYXJhdGlvbiBoYXMK
PiBzdXJ2aXZlZCBpbiBrdm1faHlwLmguCj4KPiBUaGlzIHBhdGNoIGdldHMgcmlkIG9mIGl0Lgo+
Cj4gU2lnbmVkLW9mZi1ieTogRGF2ZSBNYXJ0aW4gPERhdmUuTWFydGluQGFybS5jb20+CgpSZXZp
ZXdlZC1ieTogQWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5hcm8ub3JnPgoKPiAtLS0KPiAg
YXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1faHlwLmggfCAxIC0KPiAgMSBmaWxlIGNoYW5nZWQs
IDEgZGVsZXRpb24oLSkKPgo+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2
bV9oeXAuaCBiL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2h5cC5oCj4gaW5kZXggMzg0YzM0
My4uOWNiYmQwMyAxMDA2NDQKPiAtLS0gYS9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9oeXAu
aAo+ICsrKyBiL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2h5cC5oCj4gQEAgLTE0Nyw3ICsx
NDcsNiBAQCB2b2lkIF9fZGVidWdfc3dpdGNoX3RvX2hvc3Qoc3RydWN0IGt2bV92Y3B1ICp2Y3B1
KTsKPgo+ICB2b2lkIF9fZnBzaW1kX3NhdmVfc3RhdGUoc3RydWN0IHVzZXJfZnBzaW1kX3N0YXRl
ICpmcF9yZWdzKTsKPiAgdm9pZCBfX2Zwc2ltZF9yZXN0b3JlX3N0YXRlKHN0cnVjdCB1c2VyX2Zw
c2ltZF9zdGF0ZSAqZnBfcmVncyk7Cj4gLWJvb2wgX19mcHNpbWRfZW5hYmxlZCh2b2lkKTsKPgo+
ICB2b2lkIGFjdGl2YXRlX3RyYXBzX3ZoZV9sb2FkKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7Cj4g
IHZvaWQgZGVhY3RpdmF0ZV90cmFwc192aGVfcHV0KHZvaWQpOwoKCi0tCkFsZXggQmVubsOpZQpf
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFp
bGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5j
b2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
