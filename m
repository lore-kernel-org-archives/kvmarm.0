From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v3 05/28] arm64: fpsimd: Simplify uses of {set,
 clear}_ti_thread_flag()
Date: Tue, 10 Oct 2017 19:38:22 +0100
Message-ID: <1507660725-7986-6-git-send-email-Dave.Martin@arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A13C49D63
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Oct 2017 14:38:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lESrGodBJ-uB for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Oct 2017 14:38:27 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4832449D8D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Oct 2017 14:38:26 -0400 (EDT)
In-Reply-To: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
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
Cc: linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

VGhlIGV4aXN0aW5nIEZQU0lNRCBjb250ZXh0IHN3aXRjaCBjb2RlIGNvbnRhaW5zIGEgY291cGxl
IG9mCmluc3RhbmNlcyBvZiB7c2V0LGNsZWFyfV90aV90aHJlYWQodGFza190aHJlYWRfaW5mbyh0
YXNrKSkuICBTaW5jZQp0aGVyZSBhcmUgdGhyZWFkIGZsYWcgbWFuaXB1bGF0b3JzIHRoYXQgb3Bl
cmF0ZSBkaXJlY3RseSBvbgp0YXNrX3N0cnVjdCwgdGhpcyB2ZXJib3NpdHkgaXNuJ3Qgc3RyaWN0
bHkgbmVlZGVkLgoKRm9yIGNvbnNpc3RlbmN5LCB0aGlzIHBhdGNoIHNpbXBsaWZpZXMgdGhlIGFm
ZmVjdGVkIGNhbGxzLiAgVGhpcwpzaG91bGQgaGF2ZSBubyBpbXBhY3Qgb24gYmVoYXZpb3VyLgoK
U2lnbmVkLW9mZi1ieTogRGF2ZSBNYXJ0aW4gPERhdmUuTWFydGluQGFybS5jb20+ClJldmlld2Vk
LWJ5OiBBbGV4IEJlbm7DqWUgPGFsZXguYmVubmVlQGxpbmFyby5vcmc+CkFja2VkLWJ5OiBBcmQg
Qmllc2hldXZlbCA8YXJkLmJpZXNoZXV2ZWxAbGluYXJvLm9yZz4KLS0tCiBhcmNoL2FybTY0L2tl
cm5lbC9mcHNpbWQuYyB8IDYgKystLS0tCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCsp
LCA0IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva2VybmVsL2Zwc2ltZC5j
IGIvYXJjaC9hcm02NC9rZXJuZWwvZnBzaW1kLmMKaW5kZXggNWQ1NDdkZS4uN2E4NjVjOCAxMDA2
NDQKLS0tIGEvYXJjaC9hcm02NC9rZXJuZWwvZnBzaW1kLmMKKysrIGIvYXJjaC9hcm02NC9rZXJu
ZWwvZnBzaW1kLmMKQEAgLTE1OSwxMSArMTU5LDkgQEAgdm9pZCBmcHNpbWRfdGhyZWFkX3N3aXRj
aChzdHJ1Y3QgdGFza19zdHJ1Y3QgKm5leHQpCiAKIAkJaWYgKF9fdGhpc19jcHVfcmVhZChmcHNp
bWRfbGFzdF9zdGF0ZSkgPT0gc3QKIAkJICAgICYmIHN0LT5jcHUgPT0gc21wX3Byb2Nlc3Nvcl9p
ZCgpKQotCQkJY2xlYXJfdGlfdGhyZWFkX2ZsYWcodGFza190aHJlYWRfaW5mbyhuZXh0KSwKLQkJ
CQkJICAgICBUSUZfRk9SRUlHTl9GUFNUQVRFKTsKKwkJCWNsZWFyX3Rza190aHJlYWRfZmxhZyhu
ZXh0LCBUSUZfRk9SRUlHTl9GUFNUQVRFKTsKIAkJZWxzZQotCQkJc2V0X3RpX3RocmVhZF9mbGFn
KHRhc2tfdGhyZWFkX2luZm8obmV4dCksCi0JCQkJCSAgIFRJRl9GT1JFSUdOX0ZQU1RBVEUpOwor
CQkJc2V0X3Rza190aHJlYWRfZmxhZyhuZXh0LCBUSUZfRk9SRUlHTl9GUFNUQVRFKTsKIAl9CiB9
CiAKLS0gCjIuMS40CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0
cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
