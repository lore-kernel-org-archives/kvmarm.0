From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v6 14/27] KVM: Allow 2048-bit register access via ioctl
 interface
Date: Tue, 19 Mar 2019 17:52:05 +0000
Message-ID: <1553017938-710-15-git-send-email-Dave.Martin@arm.com>
References: <1553017938-710-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A9344A3BF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Mar 2019 13:53:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dVVaqsAXwsqB for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Mar 2019 13:53:36 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A4B2C4A4FE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Mar 2019 13:53:36 -0400 (EDT)
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

VGhlIEFybSBTVkUgYXJjaGl0ZWN0dXJlIGRlZmluZXMgcmVnaXN0ZXJzIHRoYXQgYXJlIHVwIHRv
IDIwNDggYml0cwppbiBzaXplICh3aXRoIHNvbWUgcG9zc2liaWxpdHkgb2YgZnVydGhlciBmdXR1
cmUgZXhwYW5zaW9uKS4KCkluIG9yZGVyIHRvIGF2b2lkIHRoZSBuZWVkIGZvciBhbiBleGNlc3Np
dmVseSBsYXJnZSBudW1iZXIgb2YKaW9jdGxzIHdoZW4gc2F2aW5nIGFuZCByZXN0b3JpbmcgYSB2
Y3B1J3MgcmVnaXN0ZXJzLCB0aGlzIHBhdGNoCmFkZHMgYSAjZGVmaW5lIHRvIG1ha2Ugc3VwcG9y
dCBmb3IgaW5kaXZpZHVhbCAyMDQ4LWJpdCByZWdpc3RlcnMKdGhyb3VnaCB0aGUgS1ZNX3tHRVQs
U0VUfV9PTkVfUkVHIGlvY3RsIGludGVyZmFjZSBvZmZpY2lhbC4gIFRoaXMKd2lsbCBhbGxvdyBl
YWNoIFNWRSByZWdpc3RlciB0byBiZSBhY2Nlc3NlZCBpbiBhIHNpbmdsZSBjYWxsLgoKVGhlcmUg
YXJlIHN1ZmZpY2llbnQgc3BhcmUgYml0cyBpbiB0aGUgcmVnaXN0ZXIgaWQgc2l6ZSBmaWVsZCBm
b3IKdGhpcyBjaGFuZ2UsIHNvIHRoZXJlIGlzIG5vIEFCSSBpbXBhY3QsIHByb3ZpZGluZyB0aGF0
CktWTV9HRVRfUkVHX0xJU1QgZG9lcyBub3QgZW51bWVyYXRlIGFueSAyMDQ4LWJpdCByZWdpc3Rl
ciB1bmxlc3MKdXNlcnNwYWNlIGV4cGxpY2l0bHkgb3B0cyBpbiB0byB0aGUgcmVsZXZhbnQgYXJj
aGl0ZWN0dXJlLXNwZWNpZmljCmZlYXR1cmVzLgoKU2lnbmVkLW9mZi1ieTogRGF2ZSBNYXJ0aW4g
PERhdmUuTWFydGluQGFybS5jb20+ClJldmlld2VkLWJ5OiBBbGV4IEJlbm7DqWUgPGFsZXguYmVu
bmVlQGxpbmFyby5vcmc+Ci0tLQogaW5jbHVkZS91YXBpL2xpbnV4L2t2bS5oIHwgMSArCiAxIGZp
bGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykKCmRpZmYgLS1naXQgYS9pbmNsdWRlL3VhcGkvbGlu
dXgva3ZtLmggYi9pbmNsdWRlL3VhcGkvbGludXgva3ZtLmgKaW5kZXggNmQ0ZWE0Yi4uZGM3N2E1
YSAxMDA2NDQKLS0tIGEvaW5jbHVkZS91YXBpL2xpbnV4L2t2bS5oCisrKyBiL2luY2x1ZGUvdWFw
aS9saW51eC9rdm0uaApAQCAtMTE0NSw2ICsxMTQ1LDcgQEAgc3RydWN0IGt2bV9kaXJ0eV90bGIg
ewogI2RlZmluZSBLVk1fUkVHX1NJWkVfVTI1NgkweDAwNTAwMDAwMDAwMDAwMDBVTEwKICNkZWZp
bmUgS1ZNX1JFR19TSVpFX1U1MTIJMHgwMDYwMDAwMDAwMDAwMDAwVUxMCiAjZGVmaW5lIEtWTV9S
RUdfU0laRV9VMTAyNAkweDAwNzAwMDAwMDAwMDAwMDBVTEwKKyNkZWZpbmUgS1ZNX1JFR19TSVpF
X1UyMDQ4CTB4MDA4MDAwMDAwMDAwMDAwMFVMTAogCiBzdHJ1Y3Qga3ZtX3JlZ19saXN0IHsKIAlf
X3U2NCBuOyAvKiBudW1iZXIgb2YgcmVncyAqLwotLSAKMi4xLjQKCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJt
QGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWls
bWFuL2xpc3RpbmZvL2t2bWFybQo=
