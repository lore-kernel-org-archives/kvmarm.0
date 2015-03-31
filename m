From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v2 04/10] KVM: arm: guest debug,
 add stub KVM_SET_GUEST_DEBUG ioctl
Date: Tue, 31 Mar 2015 16:08:02 +0100
Message-ID: <1427814488-28467-5-git-send-email-alex.bennee@linaro.org>
References: <1427814488-28467-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 980FB4A6CE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Mar 2015 11:01:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6JwdzCu7Hsa6 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 Mar 2015 11:01:16 -0400 (EDT)
Received: from socrates.bennee.com
 (static.88-198-71-155.clients.your-server.de [88.198.71.155])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D62024A6BF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Mar 2015 11:01:15 -0400 (EDT)
In-Reply-To: <1427814488-28467-1-git-send-email-alex.bennee@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org, agraf@suse.de, drjones@redhat.com, pbonzini@redhat.com, zhichao.huang@linaro.org
Cc: Russell King <linux@arm.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Gleb Natapov <gleb@kernel.org>, jan.kiszka@siemens.com, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, dahi@linux.vnet.ibm.com, r65777@freescale.com, bp@suse.de
List-Id: kvmarm@lists.cs.columbia.edu

VGhpcyBjb21taXQgYWRkcyBhIHN0dWIgZnVuY3Rpb24gdG8gc3VwcG9ydCB0aGUgS1ZNX1NFVF9H
VUVTVF9ERUJVRwppb2N0bC4gQ3VycmVudGx5IGFueSBvcGVyYXRpb24gZmxhZyB3aWxsIHJldHVy
biBFSU5WQUwuIEFjdHVhbApmdW5jdGlvbmFsaXR5IHdpbGwgYmUgYWRkZWQgd2l0aCBmdXJ0aGVy
IHBhdGNoZXMuCgpTaWduZWQtb2ZmLWJ5OiBBbGV4IEJlbm7DqWUgPGFsZXguYmVubmVlQGxpbmFy
by5vcmc+LgoKLS0tCnYyCiAgLSBzaW1wbGlmaWVkIGZvcm0gb2YgdGhlIGlvY3RsIChzdHVmZiB3
aWxsIGdvIGludG8gc2V0dXBfZGVidWcpCgpkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi92aXJ0
dWFsL2t2bS9hcGkudHh0IGIvRG9jdW1lbnRhdGlvbi92aXJ0dWFsL2t2bS9hcGkudHh0CmluZGV4
IGIxMTJlZmMuLjA2YzUwNjQgMTAwNjQ0Ci0tLSBhL0RvY3VtZW50YXRpb24vdmlydHVhbC9rdm0v
YXBpLnR4dAorKysgYi9Eb2N1bWVudGF0aW9uL3ZpcnR1YWwva3ZtL2FwaS50eHQKQEAgLTI2MDQs
NyArMjYwNCw3IEBAIGhhbmRsZWQuCiA0Ljg3IEtWTV9TRVRfR1VFU1RfREVCVUcKIAogQ2FwYWJp
bGl0eTogS1ZNX0NBUF9TRVRfR1VFU1RfREVCVUcKLUFyY2hpdGVjdHVyZXM6IHg4NiwgczM5MCwg
cHBjCitBcmNoaXRlY3R1cmVzOiB4ODYsIHMzOTAsIHBwYywgYXJtNjQKIFR5cGU6IHZjcHUgaW9j
dGwKIFBhcmFtZXRlcnM6IHN0cnVjdCBrdm1fZ3Vlc3RfZGVidWcgKGluKQogUmV0dXJuczogMCBv
biBzdWNjZXNzOyAtMSBvbiBlcnJvcgpkaWZmIC0tZ2l0IGEvYXJjaC9hcm0va3ZtL2FybS5jIGIv
YXJjaC9hcm0va3ZtL2FybS5jCmluZGV4IDU1NjBmNzQuLjQ0NTkzM2QgMTAwNjQ0Ci0tLSBhL2Fy
Y2gvYXJtL2t2bS9hcm0uYworKysgYi9hcmNoL2FybS9rdm0vYXJtLmMKQEAgLTE4Myw2ICsxODMs
NyBAQCBpbnQga3ZtX3ZtX2lvY3RsX2NoZWNrX2V4dGVuc2lvbihzdHJ1Y3Qga3ZtICprdm0sIGxv
bmcgZXh0KQogCWNhc2UgS1ZNX0NBUF9BUk1fUFNDSToKIAljYXNlIEtWTV9DQVBfQVJNX1BTQ0lf
MF8yOgogCWNhc2UgS1ZNX0NBUF9SRUFET05MWV9NRU06CisJY2FzZSBLVk1fQ0FQX1NFVF9HVUVT
VF9ERUJVRzoKIAkJciA9IDE7CiAJCWJyZWFrOwogCWNhc2UgS1ZNX0NBUF9DT0FMRVNDRURfTU1J
TzoKQEAgLTMwMywxMCArMzA0LDIxIEBAIHZvaWQga3ZtX2FyY2hfdmNwdV9wdXQoc3RydWN0IGt2
bV92Y3B1ICp2Y3B1KQogCWt2bV9hcm1fc2V0X3J1bm5pbmdfdmNwdShOVUxMKTsKIH0KIAorI2Rl
ZmluZSBLVk1fR1VFU1REQkdfVkFMSUQgKEtWTV9HVUVTVERCR19FTkFCTEUpCisKIGludCBrdm1f
YXJjaF92Y3B1X2lvY3RsX3NldF9ndWVzdF9kZWJ1ZyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsCiAJ
CQkJCXN0cnVjdCBrdm1fZ3Vlc3RfZGVidWcgKmRiZykKIHsKLQlyZXR1cm4gLUVJTlZBTDsKKwlp
ZiAoZGJnLT5jb250cm9sICYgS1ZNX0dVRVNUREJHX0VOQUJMRSkgeworCQlpZiAoZGJnLT5jb250
cm9sICYgfktWTV9HVUVTVERCR19WQUxJRCkKKwkJCXJldHVybiAtRUlOVkFMOworCisJCXZjcHUt
Pmd1ZXN0X2RlYnVnID0gZGJnLT5jb250cm9sOworCX0gZWxzZSB7CisJCS8qIElmIG5vdCBlbmFi
bGVkIGNsZWFyIGFsbCBmbGFncyAqLworCQl2Y3B1LT5ndWVzdF9kZWJ1ZyA9IDA7CisJfQorCXJl
dHVybiAwOwogfQogCiAKLS0gCjIuMy40CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1
bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9r
dm1hcm0K
