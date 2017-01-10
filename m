From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [PATCH v3 2/9] KVM: Track the pid of the VM process
Date: Tue, 10 Jan 2017 11:38:49 +0000
Message-ID: <20170110113856.7183-3-punit.agrawal@arm.com>
References: <20170110113856.7183-1-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E1870405DA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jan 2017 06:38:04 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U0NwtGdCMhtn for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Jan 2017 06:38:04 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 20761405B9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jan 2017 06:38:04 -0500 (EST)
In-Reply-To: <20170110113856.7183-1-punit.agrawal@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
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
dWRlL2xpbnV4L2t2bV9ob3N0LmggYi9pbmNsdWRlL2xpbnV4L2t2bV9ob3N0LmgKaW5kZXggMWM1
MTkwZGFiMmMxLi5jNjY2OTI2NTI5Y2EgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgva3ZtX2hv
c3QuaAorKysgYi9pbmNsdWRlL2xpbnV4L2t2bV9ob3N0LmgKQEAgLTM3NCw2ICszNzQsNyBAQCBz
dHJ1Y3Qga3ZtX21lbXNsb3RzIHsKIHN0cnVjdCBrdm0gewogCXNwaW5sb2NrX3QgbW11X2xvY2s7
CiAJc3RydWN0IG11dGV4IHNsb3RzX2xvY2s7CisJc3RydWN0IHBpZCAqcGlkOwogCXN0cnVjdCBt
bV9zdHJ1Y3QgKm1tOyAvKiB1c2Vyc3BhY2UgdGllZCB0byB0aGlzIHZtICovCiAJc3RydWN0IGt2
bV9tZW1zbG90cyAqbWVtc2xvdHNbS1ZNX0FERFJFU1NfU1BBQ0VfTlVNXTsKIAlzdHJ1Y3Qgc3Jj
dV9zdHJ1Y3Qgc3JjdTsKZGlmZiAtLWdpdCBhL3ZpcnQva3ZtL2t2bV9tYWluLmMgYi92aXJ0L2t2
bS9rdm1fbWFpbi5jCmluZGV4IDQ4MjYxMmI0ZTQ5Ni4uNTlkOGE4NGRhMjI3IDEwMDY0NAotLS0g
YS92aXJ0L2t2bS9rdm1fbWFpbi5jCisrKyBiL3ZpcnQva3ZtL2t2bV9tYWluLmMKQEAgLTYxOCw2
ICs2MTgsNyBAQCBzdGF0aWMgc3RydWN0IGt2bSAqa3ZtX2NyZWF0ZV92bSh1bnNpZ25lZCBsb25n
IHR5cGUpCiAJc3Bpbl9sb2NrX2luaXQoJmt2bS0+bW11X2xvY2spOwogCWF0b21pY19pbmMoJmN1
cnJlbnQtPm1tLT5tbV9jb3VudCk7CiAJa3ZtLT5tbSA9IGN1cnJlbnQtPm1tOworCWt2bS0+cGlk
ID0gZ2V0X3Rhc2tfcGlkKGN1cnJlbnQtPmdyb3VwX2xlYWRlciwgUElEVFlQRV9QSUQpOwogCWt2
bV9ldmVudGZkX2luaXQoa3ZtKTsKIAltdXRleF9pbml0KCZrdm0tPmxvY2spOwogCW11dGV4X2lu
aXQoJmt2bS0+aXJxX2xvY2spOwpAQCAtNzE3LDYgKzcxOCw3IEBAIHN0YXRpYyB2b2lkIGt2bV9k
ZXN0cm95X3ZtKHN0cnVjdCBrdm0gKmt2bSkKIAlpbnQgaTsKIAlzdHJ1Y3QgbW1fc3RydWN0ICpt
bSA9IGt2bS0+bW07CiAKKwlwdXRfcGlkKGt2bS0+cGlkKTsKIAlrdm1fZGVzdHJveV92bV9kZWJ1
Z2ZzKGt2bSk7CiAJa3ZtX2FyY2hfc3luY19ldmVudHMoa3ZtKTsKIAlzcGluX2xvY2soJmt2bV9s
b2NrKTsKLS0gCjIuMTEuMAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1
Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
