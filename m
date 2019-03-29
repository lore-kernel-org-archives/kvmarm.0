From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v7 03/27] KVM: arm64: Delete orphaned declaration for
 __fpsimd_enabled()
Date: Fri, 29 Mar 2019 13:00:28 +0000
Message-ID: <1553864452-15080-4-git-send-email-Dave.Martin@arm.com>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AC324A380
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Mar 2019 09:01:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rANGxrgMjvde for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 Mar 2019 09:01:47 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 548D64A418
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Mar 2019 09:01:47 -0400 (EDT)
In-Reply-To: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

X19mcHNpbWRfZW5hYmxlZCgpIG5vIGxvbmdlciBleGlzdHMsIGJ1dCBhIGRhbmdsaW5nIGRlY2xh
cmF0aW9uIGhhcwpzdXJ2aXZlZCBpbiBrdm1faHlwLmguCgpUaGlzIHBhdGNoIGdldHMgcmlkIG9m
IGl0LgoKU2lnbmVkLW9mZi1ieTogRGF2ZSBNYXJ0aW4gPERhdmUuTWFydGluQGFybS5jb20+ClJl
dmlld2VkLWJ5OiBBbGV4IEJlbm7DqWUgPGFsZXguYmVubmVlQGxpbmFyby5vcmc+ClRlc3RlZC1i
eTogemhhbmcubGVpIDx6aGFuZy5sZWlAanAuZnVqaXRzdS5jb20+Ci0tLQogYXJjaC9hcm02NC9p
bmNsdWRlL2FzbS9rdm1faHlwLmggfCAxIC0KIDEgZmlsZSBjaGFuZ2VkLCAxIGRlbGV0aW9uKC0p
CgpkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1faHlwLmggYi9hcmNoL2Fy
bTY0L2luY2x1ZGUvYXNtL2t2bV9oeXAuaAppbmRleCA0ZGE3NjVmLi5lZjhiODM5IDEwMDY0NAot
LS0gYS9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9oeXAuaAorKysgYi9hcmNoL2FybTY0L2lu
Y2x1ZGUvYXNtL2t2bV9oeXAuaApAQCAtMTQ5LDcgKzE0OSw2IEBAIHZvaWQgX19kZWJ1Z19zd2l0
Y2hfdG9faG9zdChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpOwogCiB2b2lkIF9fZnBzaW1kX3NhdmVf
c3RhdGUoc3RydWN0IHVzZXJfZnBzaW1kX3N0YXRlICpmcF9yZWdzKTsKIHZvaWQgX19mcHNpbWRf
cmVzdG9yZV9zdGF0ZShzdHJ1Y3QgdXNlcl9mcHNpbWRfc3RhdGUgKmZwX3JlZ3MpOwotYm9vbCBf
X2Zwc2ltZF9lbmFibGVkKHZvaWQpOwogCiB2b2lkIGFjdGl2YXRlX3RyYXBzX3ZoZV9sb2FkKHN0
cnVjdCBrdm1fdmNwdSAqdmNwdSk7CiB2b2lkIGRlYWN0aXZhdGVfdHJhcHNfdmhlX3B1dCh2b2lk
KTsKLS0gCjIuMS40CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0
cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
