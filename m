From: Will Deacon <will.deacon@arm.com>
Subject: [PATCH] arm64: KVM: Add braces to multi-line if statement in virtual
 PMU code
Date: Fri,  1 Apr 2016 12:12:22 +0100
Message-ID: <1459509142-13524-1-git-send-email-will.deacon@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CAD8840F77
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2016 07:11:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zfhhWu3JblLc for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Apr 2016 07:11:23 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A2C1E40C9D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2016 07:11:23 -0400 (EDT)
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
Cc: marc.zyngier@arm.com, Will Deacon <will.deacon@arm.com>, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

VGhlIGtlcm5lbCBpcyB3cml0dGVuIGluIEMsIG5vdCBweXRob24sIHNvIHdlIG5lZWQgYnJhY2Vz
IGFyb3VuZAptdWx0aS1saW5lIGlmIHN0YXRlbWVudHMuIEdDQyA2IGFjdHVhbGx5IHdhcm5zIGFi
b3V0IHRoaXMsIHRoYW5rcyB0byB0aGUKZmFudGFzdGljIG5ldyAiLVdtaXNsZWFkaW5nLWluZGVu
dGF0aW9uIiBmbGFnOgoKIHwgdmlydC9rdm0vYXJtL3BtdS5jOiBJbiBmdW5jdGlvbiDigJhrdm1f
cG11X292ZXJmbG93X3N0YXR1c+KAmToKIHwgdmlydC9rdm0vYXJtL3BtdS5jOjE5ODozOiB3YXJu
aW5nOiBzdGF0ZW1lbnQgaXMgaW5kZW50ZWQgYXMgaWYgaXQgd2VyZSBndWFyZGVkIGJ5Li4uIFst
V21pc2xlYWRpbmctaW5kZW50YXRpb25dCiB8ICAgIHJlZyAmPSB2Y3B1X3N5c19yZWcodmNwdSwg
UE1DTlRFTlNFVF9FTDApOwogfCAgICBefn4KIHwgYXJjaC9hcm02NC9rdm0vLi4vLi4vLi4vdmly
dC9rdm0vYXJtL3BtdS5jOjE5NjoyOiBub3RlOiAuLi50aGlzIOKAmGlm4oCZIGNsYXVzZSwgYnV0
IGl0IGlzIG5vdAogfCAgIGlmICgodmNwdV9zeXNfcmVnKHZjcHUsIFBNQ1JfRUwwKSAmIEFSTVY4
X1BNVV9QTUNSX0UpKQogfCAgIF5+CgpBcyBpdCB0dXJucyBvdXQsIHRoaXMgcGFydGljdWxhciBj
YXNlIGlzIGhhcm1sZXNzICh3ZSBqdXN0IGRvIHNvbWUgJj0Kb3BlcmF0aW9ucyB3aXRoIDApLCBi
dXQgd29ydGggZml4aW5nIG5vbmV0aGVsZXNzLgoKU2lnbmVkLW9mZi1ieTogV2lsbCBEZWFjb24g
PHdpbGwuZGVhY29uQGFybS5jb20+Ci0tLQogdmlydC9rdm0vYXJtL3BtdS5jIHwgMyArKy0KIDEg
ZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQg
YS92aXJ0L2t2bS9hcm0vcG11LmMgYi92aXJ0L2t2bS9hcm0vcG11LmMKaW5kZXggYjU3NTRjNmM1
NTA4Li41NzVjN2FhMzBkN2UgMTAwNjQ0Ci0tLSBhL3ZpcnQva3ZtL2FybS9wbXUuYworKysgYi92
aXJ0L2t2bS9hcm0vcG11LmMKQEAgLTE5MywxMSArMTkzLDEyIEBAIHN0YXRpYyB1NjQga3ZtX3Bt
dV9vdmVyZmxvd19zdGF0dXMoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQogewogCXU2NCByZWcgPSAw
OwogCi0JaWYgKCh2Y3B1X3N5c19yZWcodmNwdSwgUE1DUl9FTDApICYgQVJNVjhfUE1VX1BNQ1Jf
RSkpCisJaWYgKCh2Y3B1X3N5c19yZWcodmNwdSwgUE1DUl9FTDApICYgQVJNVjhfUE1VX1BNQ1Jf
RSkpIHsKIAkJcmVnID0gdmNwdV9zeXNfcmVnKHZjcHUsIFBNT1ZTU0VUX0VMMCk7CiAJCXJlZyAm
PSB2Y3B1X3N5c19yZWcodmNwdSwgUE1DTlRFTlNFVF9FTDApOwogCQlyZWcgJj0gdmNwdV9zeXNf
cmVnKHZjcHUsIFBNSU5URU5TRVRfRUwxKTsKIAkJcmVnICY9IGt2bV9wbXVfdmFsaWRfY291bnRl
cl9tYXNrKHZjcHUpOworCX0KIAogCXJldHVybiByZWc7CiB9Ci0tIAoyLjEuNAoKX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlz
dAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEu
ZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
