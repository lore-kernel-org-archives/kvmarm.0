From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v7 04/27] KVM: arm64: Refactor kvm_arm_num_regs() for easier
 maintenance
Date: Fri, 29 Mar 2019 13:00:29 +0000
Message-ID: <1553864452-15080-5-git-send-email-Dave.Martin@arm.com>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 747524A44D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Mar 2019 09:01:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zUUkT7aU+rgg for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 Mar 2019 09:01:50 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A80C04A431
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Mar 2019 09:01:49 -0400 (EDT)
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

a3ZtX2FybV9udW1fcmVncygpIGFkZHMgdG9nZXRoZXIgdmFyaW91cyBwYXJ0aWFsIHJlZ2lzdGVy
IGNvdW50cyBpbgphIGZyZWVmb3JtIHN1bSBleHByZXNzaW9uLCB3aGljaCBtYWtlcyBpdCBoYXJk
ZXIgdGhhbiBuZWNlc3NhcnkgdG8KcmVhZCBkaWZmcyB0aGF0IGFkZCwgbW9kaWZ5IG9yIHJlbW92
ZSBhIHNpbmdsZSB0ZXJtIGluIHRoZSBzdW0KKHdoaWNoIGlzIGV4cGVjdGVkIHRvIHRoZSBjb21t
b24gY2FzZSB1bmRlciBtYWludGVuYW5jZSkuCgpUaGlzIHBhdGNoIHJlZmFjdG9ycyB0aGUgY29k
ZSB0byBhZGQgdGhlIHRlcm0gb25lIHBlciBsaW5lLCBmb3IKbWF4aW11bSByZWFkYWJpbGl0eS4K
ClNpZ25lZC1vZmYtYnk6IERhdmUgTWFydGluIDxEYXZlLk1hcnRpbkBhcm0uY29tPgpSZXZpZXdl
ZC1ieTogQWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5hcm8ub3JnPgpUZXN0ZWQtYnk6IHpo
YW5nLmxlaSA8emhhbmcubGVpQGpwLmZ1aml0c3UuY29tPgotLS0KIGFyY2gvYXJtNjQva3ZtL2d1
ZXN0LmMgfCAxMCArKysrKysrKy0tCiAxIGZpbGUgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspLCAy
IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL2d1ZXN0LmMgYi9hcmNo
L2FybTY0L2t2bS9ndWVzdC5jCmluZGV4IGRkNDM2YTUuLjYyNTE0Y2IgMTAwNjQ0Ci0tLSBhL2Fy
Y2gvYXJtNjQva3ZtL2d1ZXN0LmMKKysrIGIvYXJjaC9hcm02NC9rdm0vZ3Vlc3QuYwpAQCAtMjU4
LDggKzI1OCwxNCBAQCBzdGF0aWMgaW50IGdldF90aW1lcl9yZWcoc3RydWN0IGt2bV92Y3B1ICp2
Y3B1LCBjb25zdCBzdHJ1Y3Qga3ZtX29uZV9yZWcgKnJlZykKICAqLwogdW5zaWduZWQgbG9uZyBr
dm1fYXJtX251bV9yZWdzKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkKIHsKLQlyZXR1cm4gbnVtX2Nv
cmVfcmVncygpICsga3ZtX2FybV9udW1fc3lzX3JlZ19kZXNjcyh2Y3B1KQotCQkrIGt2bV9hcm1f
Z2V0X2Z3X251bV9yZWdzKHZjcHUpCSsgTlVNX1RJTUVSX1JFR1M7CisJdW5zaWduZWQgbG9uZyBy
ZXMgPSAwOworCisJcmVzICs9IG51bV9jb3JlX3JlZ3MoKTsKKwlyZXMgKz0ga3ZtX2FybV9udW1f
c3lzX3JlZ19kZXNjcyh2Y3B1KTsKKwlyZXMgKz0ga3ZtX2FybV9nZXRfZndfbnVtX3JlZ3ModmNw
dSk7CisJcmVzICs9IE5VTV9USU1FUl9SRUdTOworCisJcmV0dXJuIHJlczsKIH0KIAogLyoqCi0t
IAoyLjEuNAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
a3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8v
bGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
