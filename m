From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [RFC v2 PATCH 2/7] KVM: Track the pid of the VM process
Date: Mon,  5 Sep 2016 17:31:32 +0100
Message-ID: <1473093097-30932-3-git-send-email-punit.agrawal@arm.com>
References: <1473093097-30932-1-git-send-email-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 38A8D49B3F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Sep 2016 12:23:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7v8kRds6Nsdz for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Sep 2016 12:23:54 -0400 (EDT)
Received: from cam-smtp0.cambridge.arm.com (fw-tnat.cambridge.arm.com
 [217.140.96.140])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 63E5D49B32
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Sep 2016 12:23:53 -0400 (EDT)
In-Reply-To: <1473093097-30932-1-git-send-email-punit.agrawal@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

VXNlcnNwYWNlIHRvb2xzIHN1Y2ggYXMgcGVyZiBjYW4gYmUgdXNlZCB0byBwcm9maWxlIGluZGl2
aWR1YWwKcHJvY2Vzc2VzLgoKVHJhY2sgdGhlIFBJRCBvZiB0aGUgdmlydHVhbCBtYWNoaW5lIHBy
b2Nlc3MgdG8gbWF0Y2ggcHJvZmlsaW5nIHJlcXVlc3RzCnRhcmdldGVkIGF0IGl0LiBUaGlzIGNh
biBiZSB1c2VkIHRvIHRha2UgYXBwcm9wcmlhdGUgYWN0aW9uIHRvIGVuYWJsZQp0aGUgcmVxdWVz
dGVkIHByb2ZpbGluZyBvcGVyYXRpb25zIGZvciB0aGUgVk1zIG9mIGludGVyZXN0LgoKU2lnbmVk
LW9mZi1ieTogUHVuaXQgQWdyYXdhbCA8cHVuaXQuYWdyYXdhbEBhcm0uY29tPgpDYzogUGFvbG8g
Qm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT4KQ2M6ICJSYWRpbSBLcsSNbcOhxZkiIDxya3Jj
bWFyQHJlZGhhdC5jb20+CkNjOiBDaHJpc3RvZmZlciBEYWxsIDxjaHJpc3RvZmZlci5kYWxsQGxp
bmFyby5vcmc+CkNjOiBNYXJjIFp5bmdpZXIgPG1hcmMuenluZ2llckBhcm0uY29tPgotLS0KIGlu
Y2x1ZGUvbGludXgva3ZtX2hvc3QuaCB8IDEgKwogdmlydC9rdm0va3ZtX21haW4uYyAgICAgIHwg
MiArKwogMiBmaWxlcyBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9pbmNs
dWRlL2xpbnV4L2t2bV9ob3N0LmggYi9pbmNsdWRlL2xpbnV4L2t2bV9ob3N0LmgKaW5kZXggOWMy
OGI0ZC4uN2M0MmM5NCAxMDA2NDQKLS0tIGEvaW5jbHVkZS9saW51eC9rdm1faG9zdC5oCisrKyBi
L2luY2x1ZGUvbGludXgva3ZtX2hvc3QuaApAQCAtMzc0LDYgKzM3NCw3IEBAIHN0cnVjdCBrdm1f
bWVtc2xvdHMgewogc3RydWN0IGt2bSB7CiAJc3BpbmxvY2tfdCBtbXVfbG9jazsKIAlzdHJ1Y3Qg
bXV0ZXggc2xvdHNfbG9jazsKKwlzdHJ1Y3QgcGlkICpwaWQ7CiAJc3RydWN0IG1tX3N0cnVjdCAq
bW07IC8qIHVzZXJzcGFjZSB0aWVkIHRvIHRoaXMgdm0gKi8KIAlzdHJ1Y3Qga3ZtX21lbXNsb3Rz
ICptZW1zbG90c1tLVk1fQUREUkVTU19TUEFDRV9OVU1dOwogCXN0cnVjdCBzcmN1X3N0cnVjdCBz
cmN1OwpkaWZmIC0tZ2l0IGEvdmlydC9rdm0va3ZtX21haW4uYyBiL3ZpcnQva3ZtL2t2bV9tYWlu
LmMKaW5kZXggMTk1MDc4Mi4uYWIyNTM1YSAxMDA2NDQKLS0tIGEvdmlydC9rdm0va3ZtX21haW4u
YworKysgYi92aXJ0L2t2bS9rdm1fbWFpbi5jCkBAIC02MTMsNiArNjEzLDcgQEAgc3RhdGljIHN0
cnVjdCBrdm0gKmt2bV9jcmVhdGVfdm0odW5zaWduZWQgbG9uZyB0eXBlKQogCXNwaW5fbG9ja19p
bml0KCZrdm0tPm1tdV9sb2NrKTsKIAlhdG9taWNfaW5jKCZjdXJyZW50LT5tbS0+bW1fY291bnQp
OwogCWt2bS0+bW0gPSBjdXJyZW50LT5tbTsKKwlrdm0tPnBpZCA9IGdldF90YXNrX3BpZChjdXJy
ZW50LCBQSURUWVBFX1BJRCk7CiAJa3ZtX2V2ZW50ZmRfaW5pdChrdm0pOwogCW11dGV4X2luaXQo
Jmt2bS0+bG9jayk7CiAJbXV0ZXhfaW5pdCgma3ZtLT5pcnFfbG9jayk7CkBAIC03MTIsNiArNzEz
LDcgQEAgc3RhdGljIHZvaWQga3ZtX2Rlc3Ryb3lfdm0oc3RydWN0IGt2bSAqa3ZtKQogCWludCBp
OwogCXN0cnVjdCBtbV9zdHJ1Y3QgKm1tID0ga3ZtLT5tbTsKIAorCXB1dF9waWQoa3ZtLT5waWQp
OwogCWt2bV9kZXN0cm95X3ZtX2RlYnVnZnMoa3ZtKTsKIAlrdm1fYXJjaF9zeW5jX2V2ZW50cyhr
dm0pOwogCXNwaW5fbG9jaygma3ZtX2xvY2spOwotLSAKMi44LjEKCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJt
QGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWls
bWFuL2xpc3RpbmZvL2t2bWFybQo=
