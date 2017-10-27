From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v4 05/28] arm64: fpsimd: Simplify uses of {set,
 clear}_ti_thread_flag()
Date: Fri, 27 Oct 2017 11:50:47 +0100
Message-ID: <1509101470-7881-6-git-send-email-Dave.Martin@arm.com>
References: <1509101470-7881-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 233A249D5B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 06:50:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4jjCH+9xlOHH for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Oct 2017 06:50:05 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F1B0D49D52
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 06:50:04 -0400 (EDT)
In-Reply-To: <1509101470-7881-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

VGhlIGV4aXN0aW5nIEZQU0lNRCBjb250ZXh0IHN3aXRjaCBjb2RlIGNvbnRhaW5zIGEgY291cGxl
IG9mCmluc3RhbmNlcyBvZiB7c2V0LGNsZWFyfV90aV90aHJlYWQodGFza190aHJlYWRfaW5mbyh0
YXNrKSkuICBTaW5jZQp0aGVyZSBhcmUgdGhyZWFkIGZsYWcgbWFuaXB1bGF0b3JzIHRoYXQgb3Bl
cmF0ZSBkaXJlY3RseSBvbgp0YXNrX3N0cnVjdCwgdGhpcyB2ZXJib3NpdHkgaXNuJ3Qgc3RyaWN0
bHkgbmVlZGVkLgoKRm9yIGNvbnNpc3RlbmN5LCB0aGlzIHBhdGNoIHNpbXBsaWZpZXMgdGhlIGFm
ZmVjdGVkIGNhbGxzLiAgVGhpcwpzaG91bGQgaGF2ZSBubyBpbXBhY3Qgb24gYmVoYXZpb3VyLgoK
U2lnbmVkLW9mZi1ieTogRGF2ZSBNYXJ0aW4gPERhdmUuTWFydGluQGFybS5jb20+ClJldmlld2Vk
LWJ5OiBBbGV4IEJlbm7DqWUgPGFsZXguYmVubmVlQGxpbmFyby5vcmc+ClJldmlld2VkLWJ5OiBD
YXRhbGluIE1hcmluYXMgPGNhdGFsaW4ubWFyaW5hc0Bhcm0uY29tPgpBY2tlZC1ieTogQXJkIEJp
ZXNoZXV2ZWwgPGFyZC5iaWVzaGV1dmVsQGxpbmFyby5vcmc+Ci0tLQogYXJjaC9hcm02NC9rZXJu
ZWwvZnBzaW1kLmMgfCA2ICsrLS0tLQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwg
NCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2tlcm5lbC9mcHNpbWQuYyBi
L2FyY2gvYXJtNjQva2VybmVsL2Zwc2ltZC5jCmluZGV4IDVkNTQ3ZGUuLjdhODY1YzggMTAwNjQ0
Ci0tLSBhL2FyY2gvYXJtNjQva2VybmVsL2Zwc2ltZC5jCisrKyBiL2FyY2gvYXJtNjQva2VybmVs
L2Zwc2ltZC5jCkBAIC0xNTksMTEgKzE1OSw5IEBAIHZvaWQgZnBzaW1kX3RocmVhZF9zd2l0Y2go
c3RydWN0IHRhc2tfc3RydWN0ICpuZXh0KQogCiAJCWlmIChfX3RoaXNfY3B1X3JlYWQoZnBzaW1k
X2xhc3Rfc3RhdGUpID09IHN0CiAJCSAgICAmJiBzdC0+Y3B1ID09IHNtcF9wcm9jZXNzb3JfaWQo
KSkKLQkJCWNsZWFyX3RpX3RocmVhZF9mbGFnKHRhc2tfdGhyZWFkX2luZm8obmV4dCksCi0JCQkJ
CSAgICAgVElGX0ZPUkVJR05fRlBTVEFURSk7CisJCQljbGVhcl90c2tfdGhyZWFkX2ZsYWcobmV4
dCwgVElGX0ZPUkVJR05fRlBTVEFURSk7CiAJCWVsc2UKLQkJCXNldF90aV90aHJlYWRfZmxhZyh0
YXNrX3RocmVhZF9pbmZvKG5leHQpLAotCQkJCQkgICBUSUZfRk9SRUlHTl9GUFNUQVRFKTsKKwkJ
CXNldF90c2tfdGhyZWFkX2ZsYWcobmV4dCwgVElGX0ZPUkVJR05fRlBTVEFURSk7CiAJfQogfQog
Ci0tIAoyLjEuNAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBz
Oi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
