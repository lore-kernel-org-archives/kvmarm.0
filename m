From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v7 26/27] KVM: Document errors for KVM_GET_ONE_REG and
 KVM_SET_ONE_REG
Date: Fri, 29 Mar 2019 13:00:51 +0000
Message-ID: <1553864452-15080-27-git-send-email-Dave.Martin@arm.com>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 10A704A441
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Mar 2019 09:02:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 43GpEDUy1Niy for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 Mar 2019 09:02:38 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE8264A460
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Mar 2019 09:02:38 -0400 (EDT)
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

S1ZNX0dFVF9PTkVfUkVHIGFuZCBLVk1fU0VUX09ORV9SRUcgcmV0dXJuIHNvbWUgZXJyb3IgY29k
ZXMgdGhhdAphcmUgbm90IGRvY3VtZW50ZWQgKGJ1dCBob3BlZnVsbHkgbm90IHN1cnByaXNpbmcg
ZWl0aGVyKS4gIFRvIGdpdmUKYW4gaW5kaWNhdGlvbiBvZiB3aGF0IHRoZXNlIG1heSBtZWFuLCB0
aGlzIHBhdGNoIGFkZHMgYnJpZWYKZG9jdW1lbnRhdGlvbi4KClNpZ25lZC1vZmYtYnk6IERhdmUg
TWFydGluIDxEYXZlLk1hcnRpbkBhcm0uY29tPgotLS0KIERvY3VtZW50YXRpb24vdmlydHVhbC9r
dm0vYXBpLnR4dCB8IDYgKysrKysrCiAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspCgpk
aWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi92aXJ0dWFsL2t2bS9hcGkudHh0IGIvRG9jdW1lbnRh
dGlvbi92aXJ0dWFsL2t2bS9hcGkudHh0CmluZGV4IDJkNGY3Y2UuLmNkOTIwZGQgMTAwNjQ0Ci0t
LSBhL0RvY3VtZW50YXRpb24vdmlydHVhbC9rdm0vYXBpLnR4dAorKysgYi9Eb2N1bWVudGF0aW9u
L3ZpcnR1YWwva3ZtL2FwaS50eHQKQEAgLTE4NzEsNiArMTg3MSw5IEBAIEFyY2hpdGVjdHVyZXM6
IGFsbAogVHlwZTogdmNwdSBpb2N0bAogUGFyYW1ldGVyczogc3RydWN0IGt2bV9vbmVfcmVnIChp
bikKIFJldHVybnM6IDAgb24gc3VjY2VzcywgbmVnYXRpdmUgdmFsdWUgb24gZmFpbHVyZQorRXJy
b3JzOgorIMKgRU5PRU5UOiDCoMKgbm8gc3VjaCByZWdpc3RlcgorIMKgRUlOVkFMOiDCoMKgb3Ro
ZXIgZXJyb3JzLCBzdWNoIGFzIGJhZCBzaXplIGVuY29kaW5nIGZvciBhIGtub3duIHJlZ2lzdGVy
CiAKIHN0cnVjdCBrdm1fb25lX3JlZyB7CiAgICAgICAgX191NjQgaWQ7CkBAIC0yMTkyLDYgKzIx
OTUsOSBAQCBBcmNoaXRlY3R1cmVzOiBhbGwKIFR5cGU6IHZjcHUgaW9jdGwKIFBhcmFtZXRlcnM6
IHN0cnVjdCBrdm1fb25lX3JlZyAoaW4gYW5kIG91dCkKIFJldHVybnM6IDAgb24gc3VjY2Vzcywg
bmVnYXRpdmUgdmFsdWUgb24gZmFpbHVyZQorRXJyb3JzOgorIMKgRU5PRU5UOiDCoMKgbm8gc3Vj
aCByZWdpc3RlcgorIMKgRUlOVkFMOiDCoMKgb3RoZXIgZXJyb3JzLCBzdWNoIGFzIGJhZCBzaXpl
IGVuY29kaW5nIGZvciBhIGtub3duIHJlZ2lzdGVyCiAKIFRoaXMgaW9jdGwgYWxsb3dzIHRvIHJl
Y2VpdmUgdGhlIHZhbHVlIG9mIGEgc2luZ2xlIHJlZ2lzdGVyIGltcGxlbWVudGVkCiBpbiBhIHZj
cHUuIFRoZSByZWdpc3RlciB0byByZWFkIGlzIGluZGljYXRlZCBieSB0aGUgImlkIiBmaWVsZCBv
ZiB0aGUKLS0gCjIuMS40CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUK
aHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
