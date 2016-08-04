From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 4/8] KVM: Move kvm_setup_default/empty_irq_routing declaration
 in arch specific header
Date: Thu,  4 Aug 2016 13:40:32 +0200
Message-ID: <1470310836-10371-5-git-send-email-christoffer.dall@linaro.org>
References: <1470310836-10371-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E1DD449B6B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Aug 2016 07:33:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hyzA3T7vMP80 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Aug 2016 07:33:58 -0400 (EDT)
Received: from mail-lf0-f46.google.com (mail-lf0-f46.google.com
 [209.85.215.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 905A449B60
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Aug 2016 07:33:57 -0400 (EDT)
Received: by mail-lf0-f46.google.com with SMTP id b199so180620264lfe.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Aug 2016 04:40:50 -0700 (PDT)
In-Reply-To: <1470310836-10371-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

RnJvbTogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPgoKa3ZtX3NldHVwX2RlZmF1
bHRfaXJxX3JvdXRpbmcgYW5kIGt2bV9zZXR1cF9lbXB0eV9pcnFfcm91dGluZyBhcmUKbm90IHVz
ZWQgYnkgZ2VuZXJpYyBjb2RlLiBTbyBsZXQncyBtb3ZlIHRoZSBkZWNsYXJhdGlvbnMgaW4geDg2
IGlycS5oCmhlYWRlciBpbnN0ZWFkIG9mIGt2bV9ob3N0LmguCgpTaWduZWQtb2ZmLWJ5OiBFcmlj
IEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+ClN1Z2dlc3RlZC1ieTogQW5kcmUgUHJ6eXdh
cmEgPGFuZHJlLnByenl3YXJhQGFybS5jb20+CkFja2VkLWJ5OiBSYWRpbSBLcsSNbcOhxZkgPHJr
cmNtYXJAcmVkaGF0LmNvbT4KU2lnbmVkLW9mZi1ieTogTWFyYyBaeW5naWVyIDxtYXJjLnp5bmdp
ZXJAYXJtLmNvbT4KLS0tCiBhcmNoL3g4Ni9rdm0vaXJxLmggICAgICAgfCAzICsrKwogaW5jbHVk
ZS9saW51eC9rdm1faG9zdC5oIHwgMiAtLQogMiBmaWxlcyBjaGFuZ2VkLCAzIGluc2VydGlvbnMo
KyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL2lycS5oIGIvYXJj
aC94ODYva3ZtL2lycS5oCmluZGV4IDYxZWJkYzEuLjAzNTczMWUgMTAwNjQ0Ci0tLSBhL2FyY2gv
eDg2L2t2bS9pcnEuaAorKysgYi9hcmNoL3g4Ni9rdm0vaXJxLmgKQEAgLTEyMCw0ICsxMjAsNyBA
QCB2b2lkIF9fa3ZtX21pZ3JhdGVfdGltZXJzKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7CiAKIGlu
dCBhcGljX2hhc19wZW5kaW5nX3RpbWVyKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7CiAKK2ludCBr
dm1fc2V0dXBfZGVmYXVsdF9pcnFfcm91dGluZyhzdHJ1Y3Qga3ZtICprdm0pOworaW50IGt2bV9z
ZXR1cF9lbXB0eV9pcnFfcm91dGluZyhzdHJ1Y3Qga3ZtICprdm0pOworCiAjZW5kaWYKZGlmZiAt
LWdpdCBhL2luY2x1ZGUvbGludXgva3ZtX2hvc3QuaCBiL2luY2x1ZGUvbGludXgva3ZtX2hvc3Qu
aAppbmRleCBhMTU4MjhmLi5hN2ViNWM0IDEwMDY0NAotLS0gYS9pbmNsdWRlL2xpbnV4L2t2bV9o
b3N0LmgKKysrIGIvaW5jbHVkZS9saW51eC9rdm1faG9zdC5oCkBAIC0xMDUyLDggKzEwNTIsNiBA
QCBzdGF0aWMgaW5saW5lIGludCBtbXVfbm90aWZpZXJfcmV0cnkoc3RydWN0IGt2bSAqa3ZtLCB1
bnNpZ25lZCBsb25nIG1tdV9zZXEpCiAjZGVmaW5lIEtWTV9NQVhfSVJRX1JPVVRFUyAxMDI0CiAj
ZW5kaWYKIAotaW50IGt2bV9zZXR1cF9kZWZhdWx0X2lycV9yb3V0aW5nKHN0cnVjdCBrdm0gKmt2
bSk7Ci1pbnQga3ZtX3NldHVwX2VtcHR5X2lycV9yb3V0aW5nKHN0cnVjdCBrdm0gKmt2bSk7CiBp
bnQga3ZtX3NldF9pcnFfcm91dGluZyhzdHJ1Y3Qga3ZtICprdm0sCiAJCQljb25zdCBzdHJ1Y3Qg
a3ZtX2lycV9yb3V0aW5nX2VudHJ5ICplbnRyaWVzLAogCQkJdW5zaWduZWQgbnIsCi0tIAoxLjku
MQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJt
IG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMu
Y3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
