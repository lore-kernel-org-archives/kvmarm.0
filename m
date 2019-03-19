From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v6 04/27] KVM: arm64: Refactor kvm_arm_num_regs() for easier
 maintenance
Date: Tue, 19 Mar 2019 17:51:55 +0000
Message-ID: <1553017938-710-5-git-send-email-Dave.Martin@arm.com>
References: <1553017938-710-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 19CA74A3FE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Mar 2019 13:53:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X6MTe+sEnk5M for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Mar 2019 13:53:17 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D4484A47E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Mar 2019 13:53:14 -0400 (EDT)
In-Reply-To: <1553017938-710-1-git-send-email-Dave.Martin@arm.com>
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

a3ZtX2FybV9udW1fcmVncygpIGFkZHMgdG9nZXRoZXIgdmFyaW91cyBwYXJ0aWFsIHJlZ2lzdGVy
IGNvdW50cyBpbgphIGZyZWVmb3JtIHN1bSBleHByZXNzaW9uLCB3aGljaCBtYWtlcyBpdCBoYXJk
ZXIgdGhhbiBuZWNlc3NhcnkgdG8KcmVhZCBkaWZmcyB0aGF0IGFkZCwgbW9kaWZ5IG9yIHJlbW92
ZSBhIHNpbmdsZSB0ZXJtIGluIHRoZSBzdW0KKHdoaWNoIGlzIGV4cGVjdGVkIHRvIHRoZSBjb21t
b24gY2FzZSB1bmRlciBtYWludGVuYW5jZSkuCgpUaGlzIHBhdGNoIHJlZmFjdG9ycyB0aGUgY29k
ZSB0byBhZGQgdGhlIHRlcm0gb25lIHBlciBsaW5lLCBmb3IKbWF4aW11bSByZWFkYWJpbGl0eS4K
ClNpZ25lZC1vZmYtYnk6IERhdmUgTWFydGluIDxEYXZlLk1hcnRpbkBhcm0uY29tPgpSZXZpZXdl
ZC1ieTogQWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5hcm8ub3JnPgotLS0KIGFyY2gvYXJt
NjQva3ZtL2d1ZXN0LmMgfCAxMCArKysrKysrKy0tCiAxIGZpbGUgY2hhbmdlZCwgOCBpbnNlcnRp
b25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL2d1ZXN0
LmMgYi9hcmNoL2FybTY0L2t2bS9ndWVzdC5jCmluZGV4IGRkNDM2YTUuLjYyNTE0Y2IgMTAwNjQ0
Ci0tLSBhL2FyY2gvYXJtNjQva3ZtL2d1ZXN0LmMKKysrIGIvYXJjaC9hcm02NC9rdm0vZ3Vlc3Qu
YwpAQCAtMjU4LDggKzI1OCwxNCBAQCBzdGF0aWMgaW50IGdldF90aW1lcl9yZWcoc3RydWN0IGt2
bV92Y3B1ICp2Y3B1LCBjb25zdCBzdHJ1Y3Qga3ZtX29uZV9yZWcgKnJlZykKICAqLwogdW5zaWdu
ZWQgbG9uZyBrdm1fYXJtX251bV9yZWdzKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkKIHsKLQlyZXR1
cm4gbnVtX2NvcmVfcmVncygpICsga3ZtX2FybV9udW1fc3lzX3JlZ19kZXNjcyh2Y3B1KQotCQkr
IGt2bV9hcm1fZ2V0X2Z3X251bV9yZWdzKHZjcHUpCSsgTlVNX1RJTUVSX1JFR1M7CisJdW5zaWdu
ZWQgbG9uZyByZXMgPSAwOworCisJcmVzICs9IG51bV9jb3JlX3JlZ3MoKTsKKwlyZXMgKz0ga3Zt
X2FybV9udW1fc3lzX3JlZ19kZXNjcyh2Y3B1KTsKKwlyZXMgKz0ga3ZtX2FybV9nZXRfZndfbnVt
X3JlZ3ModmNwdSk7CisJcmVzICs9IE5VTV9USU1FUl9SRUdTOworCisJcmV0dXJuIHJlczsKIH0K
IAogLyoqCi0tIAoyLjEuNAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1
Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
