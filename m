From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 13/27] arm/arm64: KVM: add a common vgic_queue_irq_to_lr fn
Date: Thu,  2 Apr 2015 11:05:17 +0100
Message-ID: <1427969131-8445-14-git-send-email-marc.zyngier@arm.com>
References: <1427969131-8445-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 444E44ADE7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Apr 2015 06:19:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0i3H0dPZUwx2 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Apr 2015 06:19:35 -0400 (EDT)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5C2344ADDC
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Apr 2015 06:19:35 -0400 (EDT)
In-Reply-To: <1427969131-8445-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

RnJvbTogQWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5hcm8ub3JnPgoKVGhpcyBoZWxwcyBy
ZS1mYWN0b3IgYXdheSBzb21lIG9mIHRoZSByZXBldGl0aXZlIGNvZGUgYW5kIG1ha2VzIHRoZSBj
b2RlCmZsb3cgbW9yZSBuaWNlbHkuCgpTaWduZWQtb2ZmLWJ5OiBBbGV4IEJlbm7DqWUgPGFsZXgu
YmVubmVlQGxpbmFyby5vcmc+ClNpZ25lZC1vZmYtYnk6IENocmlzdG9mZmVyIERhbGwgPGNocmlz
dG9mZmVyLmRhbGxAbGluYXJvLm9yZz4KLS0tCiB2aXJ0L2t2bS9hcm0vdmdpYy5jIHwgMjQgKysr
KysrKysrKysrKysrKystLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMTcgaW5zZXJ0aW9ucygrKSwg
NyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS92aXJ0L2t2bS9hcm0vdmdpYy5jIGIvdmlydC9r
dm0vYXJtL3ZnaWMuYwppbmRleCBjMDAwZTk3Li42OTdjZTE3IDEwMDY0NAotLS0gYS92aXJ0L2t2
bS9hcm0vdmdpYy5jCisrKyBiL3ZpcnQva3ZtL2FybS92Z2ljLmMKQEAgLTk1MCw2ICs5NTAsMjAg
QEAgc3RhdGljIHZvaWQgdmdpY19yZXRpcmVfZGlzYWJsZWRfaXJxcyhzdHJ1Y3Qga3ZtX3ZjcHUg
KnZjcHUpCiAJfQogfQogCitzdGF0aWMgdm9pZCB2Z2ljX3F1ZXVlX2lycV90b19scihzdHJ1Y3Qg
a3ZtX3ZjcHUgKnZjcHUsIGludCBpcnEsCisJCQkJIGludCBscl9uciwgc3RydWN0IHZnaWNfbHIg
dmxyKQoreworCWlmICh2Z2ljX2Rpc3RfaXJxX2lzX3BlbmRpbmcodmNwdSwgaXJxKSkgeworCQl2
bHIuc3RhdGUgfD0gTFJfU1RBVEVfUEVORElORzsKKwkJa3ZtX2RlYnVnKCJTZXQgcGVuZGluZzog
MHgleFxuIiwgdmxyLnN0YXRlKTsKKwl9CisKKwlpZiAoIXZnaWNfaXJxX2lzX2VkZ2UodmNwdSwg
aXJxKSkKKwkJdmxyLnN0YXRlIHw9IExSX0VPSV9JTlQ7CisKKwl2Z2ljX3NldF9scih2Y3B1LCBs
cl9uciwgdmxyKTsKK30KKwogLyoKICAqIFF1ZXVlIGFuIGludGVycnVwdCB0byBhIENQVSB2aXJ0
dWFsIGludGVyZmFjZS4gUmV0dXJuIHRydWUgb24gc3VjY2VzcywKICAqIG9yIGZhbHNlIGlmIGl0
IHdhc24ndCBwb3NzaWJsZSB0byBxdWV1ZSBpdC4KQEAgLTk3Nyw4ICs5OTEsNyBAQCBib29sIHZn
aWNfcXVldWVfaXJxKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdTggc2dpX3NvdXJjZV9pZCwgaW50
IGlycSkKIAkJaWYgKHZsci5zb3VyY2UgPT0gc2dpX3NvdXJjZV9pZCkgewogCQkJa3ZtX2RlYnVn
KCJMUiVkIHBpZ2d5YmFjayBmb3IgSVJRJWRcbiIsIGxyLCB2bHIuaXJxKTsKIAkJCUJVR19PTigh
dGVzdF9iaXQobHIsIHZnaWNfY3B1LT5scl91c2VkKSk7Ci0JCQl2bHIuc3RhdGUgfD0gTFJfU1RB
VEVfUEVORElORzsKLQkJCXZnaWNfc2V0X2xyKHZjcHUsIGxyLCB2bHIpOworCQkJdmdpY19xdWV1
ZV9pcnFfdG9fbHIodmNwdSwgaXJxLCBsciwgdmxyKTsKIAkJCXJldHVybiB0cnVlOwogCQl9CiAJ
fQpAQCAtOTk1LDExICsxMDA4LDggQEAgYm9vbCB2Z2ljX3F1ZXVlX2lycShzdHJ1Y3Qga3ZtX3Zj
cHUgKnZjcHUsIHU4IHNnaV9zb3VyY2VfaWQsIGludCBpcnEpCiAKIAl2bHIuaXJxID0gaXJxOwog
CXZsci5zb3VyY2UgPSBzZ2lfc291cmNlX2lkOwotCXZsci5zdGF0ZSA9IExSX1NUQVRFX1BFTkRJ
Tkc7Ci0JaWYgKCF2Z2ljX2lycV9pc19lZGdlKHZjcHUsIGlycSkpCi0JCXZsci5zdGF0ZSB8PSBM
Ul9FT0lfSU5UOwotCi0JdmdpY19zZXRfbHIodmNwdSwgbHIsIHZscik7CisJdmxyLnN0YXRlID0g
MDsKKwl2Z2ljX3F1ZXVlX2lycV90b19scih2Y3B1LCBpcnEsIGxyLCB2bHIpOwogCiAJcmV0dXJu
IHRydWU7CiB9Ci0tIAoyLjEuNAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEu
ZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJt
Cg==
