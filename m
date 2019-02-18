From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v5 03/26] KVM: arm64: Delete orphaned declaration for
 __fpsimd_enabled()
Date: Mon, 18 Feb 2019 19:52:16 +0000
Message-ID: <1550519559-15915-4-git-send-email-Dave.Martin@arm.com>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E027D4A42E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Feb 2019 14:54:26 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oyf4dE-cxy5Z for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Feb 2019 14:54:26 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD8AF4A42D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Feb 2019 14:54:19 -0500 (EST)
In-Reply-To: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

X19mcHNpbWRfZW5hYmxlZCgpIG5vIGxvbmdlciBleGlzdHMsIGJ1dCBhIGRhbmdsaW5nIGRlY2xh
cmF0aW9uIGhhcwpzdXJ2aXZlZCBpbiBrdm1faHlwLmguCgpUaGlzIHBhdGNoIGdldHMgcmlkIG9m
IGl0LgoKU2lnbmVkLW9mZi1ieTogRGF2ZSBNYXJ0aW4gPERhdmUuTWFydGluQGFybS5jb20+ClJl
dmlld2VkLWJ5OiBBbGV4IEJlbm7DqWUgPGFsZXguYmVubmVlQGxpbmFyby5vcmc+Ci0tLQogYXJj
aC9hcm02NC9pbmNsdWRlL2FzbS9rdm1faHlwLmggfCAxIC0KIDEgZmlsZSBjaGFuZ2VkLCAxIGRl
bGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1faHlwLmgg
Yi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9oeXAuaAppbmRleCBhODBhN2VmLi5iZDdhMDU1
IDEwMDY0NAotLS0gYS9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9oeXAuaAorKysgYi9hcmNo
L2FybTY0L2luY2x1ZGUvYXNtL2t2bV9oeXAuaApAQCAtMTQ4LDcgKzE0OCw2IEBAIHZvaWQgX19k
ZWJ1Z19zd2l0Y2hfdG9faG9zdChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpOwogCiB2b2lkIF9fZnBz
aW1kX3NhdmVfc3RhdGUoc3RydWN0IHVzZXJfZnBzaW1kX3N0YXRlICpmcF9yZWdzKTsKIHZvaWQg
X19mcHNpbWRfcmVzdG9yZV9zdGF0ZShzdHJ1Y3QgdXNlcl9mcHNpbWRfc3RhdGUgKmZwX3JlZ3Mp
OwotYm9vbCBfX2Zwc2ltZF9lbmFibGVkKHZvaWQpOwogCiB2b2lkIGFjdGl2YXRlX3RyYXBzX3Zo
ZV9sb2FkKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7CiB2b2lkIGRlYWN0aXZhdGVfdHJhcHNfdmhl
X3B1dCh2b2lkKTsKLS0gCjIuMS40CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJp
YS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1h
cm0K
