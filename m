From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v3 2/5] arm/arm64: KVM: add a common vgic_queue_irq_to_lr fn
Date: Fri, 13 Mar 2015 17:02:53 +0000
Message-ID: <1426266176-14933-3-git-send-email-alex.bennee@linaro.org>
References: <1426266176-14933-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 36A2F48CAB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Mar 2015 12:56:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QrSPA3A8TJR6 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Mar 2015 12:56:27 -0400 (EDT)
Received: from socrates.bennee.com
 (static.88-198-71-155.clients.your-server.de [88.198.71.155])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0701D48C9F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Mar 2015 12:56:26 -0400 (EDT)
In-Reply-To: <1426266176-14933-1-git-send-email-alex.bennee@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

VGhpcyBoZWxwcyByZS1mYWN0b3IgYXdheSBzb21lIG9mIHRoZSByZXBldGl0aXZlIGNvZGUgYW5k
IG1ha2VzIHRoZSBjb2RlCmZsb3cgbW9yZSBuaWNlbHkuCgpTaWduZWQtb2ZmLWJ5OiBBbGV4IEJl
bm7DqWUgPGFsZXguYmVubmVlQGxpbmFyby5vcmc+CgotLS0KdjMKICAtIE1vdmUgdG8gYmVmb3Jl
IHRoZSB1bi1xdWV1ZSBhY3RpdmUgcGF0Y2gKCmRpZmYgLS1naXQgYS92aXJ0L2t2bS9hcm0vdmdp
Yy5jIGIvdmlydC9rdm0vYXJtL3ZnaWMuYwppbmRleCAwY2M2YWI2Li42NjgyZDU4IDEwMDY0NAot
LS0gYS92aXJ0L2t2bS9hcm0vdmdpYy5jCisrKyBiL3ZpcnQva3ZtL2FybS92Z2ljLmMKQEAgLTk0
OSw2ICs5NDksMjAgQEAgc3RhdGljIHZvaWQgdmdpY19yZXRpcmVfZGlzYWJsZWRfaXJxcyhzdHJ1
Y3Qga3ZtX3ZjcHUgKnZjcHUpCiAJfQogfQogCitzdGF0aWMgdm9pZCB2Z2ljX3F1ZXVlX2lycV90
b19scihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIGludCBpcnEsCisJCQkJIGludCBscl9uciwgc3Ry
dWN0IHZnaWNfbHIgdmxyKQoreworCWlmICh2Z2ljX2Rpc3RfaXJxX2lzX3BlbmRpbmcodmNwdSwg
aXJxKSkgeworCQl2bHIuc3RhdGUgfD0gTFJfU1RBVEVfUEVORElORzsKKwkJa3ZtX2RlYnVnKCJT
ZXQgcGVuZGluZzogMHgleFxuIiwgdmxyLnN0YXRlKTsKKwl9CisKKwlpZiAoIXZnaWNfaXJxX2lz
X2VkZ2UodmNwdSwgaXJxKSkKKwkJdmxyLnN0YXRlIHw9IExSX0VPSV9JTlQ7CisKKwl2Z2ljX3Nl
dF9scih2Y3B1LCBscl9uciwgdmxyKTsKK30KKwogLyoKICAqIFF1ZXVlIGFuIGludGVycnVwdCB0
byBhIENQVSB2aXJ0dWFsIGludGVyZmFjZS4gUmV0dXJuIHRydWUgb24gc3VjY2VzcywKICAqIG9y
IGZhbHNlIGlmIGl0IHdhc24ndCBwb3NzaWJsZSB0byBxdWV1ZSBpdC4KQEAgLTk3Niw4ICs5OTAs
NyBAQCBib29sIHZnaWNfcXVldWVfaXJxKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdTggc2dpX3Nv
dXJjZV9pZCwgaW50IGlycSkKIAkJaWYgKHZsci5zb3VyY2UgPT0gc2dpX3NvdXJjZV9pZCkgewog
CQkJa3ZtX2RlYnVnKCJMUiVkIHBpZ2d5YmFjayBmb3IgSVJRJWRcbiIsIGxyLCB2bHIuaXJxKTsK
IAkJCUJVR19PTighdGVzdF9iaXQobHIsIHZnaWNfY3B1LT5scl91c2VkKSk7Ci0JCQl2bHIuc3Rh
dGUgfD0gTFJfU1RBVEVfUEVORElORzsKLQkJCXZnaWNfc2V0X2xyKHZjcHUsIGxyLCB2bHIpOwor
CQkJdmdpY19xdWV1ZV9pcnFfdG9fbHIodmNwdSwgaXJxLCBsciwgdmxyKTsKIAkJCXJldHVybiB0
cnVlOwogCQl9CiAJfQpAQCAtOTk0LDExICsxMDA3LDggQEAgYm9vbCB2Z2ljX3F1ZXVlX2lycShz
dHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHU4IHNnaV9zb3VyY2VfaWQsIGludCBpcnEpCiAKIAl2bHIu
aXJxID0gaXJxOwogCXZsci5zb3VyY2UgPSBzZ2lfc291cmNlX2lkOwotCXZsci5zdGF0ZSA9IExS
X1NUQVRFX1BFTkRJTkc7Ci0JaWYgKCF2Z2ljX2lycV9pc19lZGdlKHZjcHUsIGlycSkpCi0JCXZs
ci5zdGF0ZSB8PSBMUl9FT0lfSU5UOwotCi0JdmdpY19zZXRfbHIodmNwdSwgbHIsIHZscik7CisJ
dmxyLnN0YXRlID0gMDsKKwl2Z2ljX3F1ZXVlX2lycV90b19scih2Y3B1LCBpcnEsIGxyLCB2bHIp
OwogCiAJcmV0dXJuIHRydWU7CiB9Ci0tIAoyLjMuMgoKX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMu
Y3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlz
dGluZm8va3ZtYXJtCg==
