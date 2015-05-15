From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v4 04/12] KVM: arm: guest debug,
 add stub KVM_SET_GUEST_DEBUG ioctl
Date: Fri, 15 May 2015 15:27:07 +0100
Message-ID: <1431700035-23479-5-git-send-email-alex.bennee@linaro.org>
References: <1431700035-23479-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 93EE851691
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2015 10:17:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JIpD4blsgeTn for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 May 2015 10:17:20 -0400 (EDT)
Received: from socrates.bennee.com
 (static.88-198-71-155.clients.your-server.de [88.198.71.155])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AEEFA51686
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2015 10:17:20 -0400 (EDT)
In-Reply-To: <1431700035-23479-1-git-send-email-alex.bennee@linaro.org>
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
VUVTVF9ERUJVRwppb2N0bC4gQW55IHVuc3VwcG9ydGVkIGZsYWcgd2lsbCByZXR1cm4gLUVJTlZB
TC4gRm9yIG5vdywgb25seQpLVk1fR1VFU1REQkdfRU5BQkxFIGlzIHN1cHBvcnRlZCwgYWx0aG91
Z2ggaXQgd29uJ3QgaGF2ZSBhbnkgZWZmZWN0cy4KClNpZ25lZC1vZmYtYnk6IEFsZXggQmVubsOp
ZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4uClJldmlld2VkLWJ5OiBDaHJpc3RvZmZlciBEYWxs
IDxjaHJpc3RvZmZlci5kYWxsQGxpbmFyby5vcmc+CgotLS0KdjIKICAtIHNpbXBsaWZpZWQgZm9y
bSBvZiB0aGUgaW9jdGwgKHN0dWZmIHdpbGwgZ28gaW50byBzZXR1cF9kZWJ1ZykKdjMKIC0gS1ZN
X0dVRVNUREJHX1ZBTElELT5LVk1fR1VFU1REQkdfVkFMSURfTUFTSwogLSBtb3ZlIG1hc2sgY2hl
Y2sgdG8gdGhlIHRvcCBvZiBmdW5jdGlvbgogLSBhZGQgaW9jdGwgZG9jIGhlYWRlcgogLSBzcGxp
dCBjYXBhYmlsaXR5IGludG8gc2VwYXJhdGUgcGF0Y2gKIC0gdHdlYWtlZCBjb21taXQgd29yZGlu
ZyB3LnIudCByZXR1cm4gb2YgLUVJTlZBTAp2NAogLSBhZGQgci1iLXRhZwoKZGlmZiAtLWdpdCBh
L0RvY3VtZW50YXRpb24vdmlydHVhbC9rdm0vYXBpLnR4dCBiL0RvY3VtZW50YXRpb24vdmlydHVh
bC9rdm0vYXBpLnR4dAppbmRleCBjMzRjMzJkLi5iYTYzNWM3IDEwMDY0NAotLS0gYS9Eb2N1bWVu
dGF0aW9uL3ZpcnR1YWwva3ZtL2FwaS50eHQKKysrIGIvRG9jdW1lbnRhdGlvbi92aXJ0dWFsL2t2
bS9hcGkudHh0CkBAIC0yNjQ1LDcgKzI2NDUsNyBAQCBoYW5kbGVkLgogNC44NyBLVk1fU0VUX0dV
RVNUX0RFQlVHCiAKIENhcGFiaWxpdHk6IEtWTV9DQVBfU0VUX0dVRVNUX0RFQlVHCi1BcmNoaXRl
Y3R1cmVzOiB4ODYsIHMzOTAsIHBwYworQXJjaGl0ZWN0dXJlczogeDg2LCBzMzkwLCBwcGMsIGFy
bTY0CiBUeXBlOiB2Y3B1IGlvY3RsCiBQYXJhbWV0ZXJzOiBzdHJ1Y3Qga3ZtX2d1ZXN0X2RlYnVn
IChpbikKIFJldHVybnM6IDAgb24gc3VjY2VzczsgLTEgb24gZXJyb3IKZGlmZiAtLWdpdCBhL2Fy
Y2gvYXJtL2t2bS9hcm0uYyBiL2FyY2gvYXJtL2t2bS9hcm0uYwppbmRleCBkOTYzMWVjLi41MmEx
ZDRkMzggMTAwNjQ0Ci0tLSBhL2FyY2gvYXJtL2t2bS9hcm0uYworKysgYi9hcmNoL2FybS9rdm0v
YXJtLmMKQEAgLTMwMiwxMCArMzAyLDMxIEBAIHZvaWQga3ZtX2FyY2hfdmNwdV9wdXQoc3RydWN0
IGt2bV92Y3B1ICp2Y3B1KQogCWt2bV9hcm1fc2V0X3J1bm5pbmdfdmNwdShOVUxMKTsKIH0KIAor
I2RlZmluZSBLVk1fR1VFU1REQkdfVkFMSURfTUFTSyAoS1ZNX0dVRVNUREJHX0VOQUJMRSkKKwor
LyoqCisgKiBrdm1fYXJjaF92Y3B1X2lvY3RsX3NldF9ndWVzdF9kZWJ1ZyAtIHNldCB1cCBndWVz
dCBkZWJ1Z2dpbmcKKyAqIEBrdm06CXBvaW50ZXIgdG8gdGhlIEtWTSBzdHJ1Y3QKKyAqIEBrdm1f
Z3Vlc3RfZGVidWc6IHRoZSBpb2N0bCBkYXRhIGJ1ZmZlcgorICoKKyAqIFRoaXMgc2V0cyB1cCBh
bmQgZW5hYmxlcyB0aGUgVk0gZm9yIGd1ZXN0IGRlYnVnZ2luZy4gVXNlcnNwYWNlCisgKiBwYXNz
ZXMgaW4gYSBjb250cm9sIGZsYWcgdG8gZW5hYmxlIGRpZmZlcmVudCBkZWJ1ZyB0eXBlcyBhbmQK
KyAqIHBvdGVudGlhbGx5IG90aGVyIGFyY2hpdGVjdHVyZSBzcGVjaWZpYyBpbmZvcm1hdGlvbiBp
biB0aGUgcmVzdCBvZgorICogdGhlIHN0cnVjdHVyZS4KKyAqLwogaW50IGt2bV9hcmNoX3ZjcHVf
aW9jdGxfc2V0X2d1ZXN0X2RlYnVnKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwKIAkJCQkJc3RydWN0
IGt2bV9ndWVzdF9kZWJ1ZyAqZGJnKQogewotCXJldHVybiAtRUlOVkFMOworCWlmIChkYmctPmNv
bnRyb2wgJiB+S1ZNX0dVRVNUREJHX1ZBTElEX01BU0spCisJCXJldHVybiAtRUlOVkFMOworCisJ
aWYgKGRiZy0+Y29udHJvbCAmIEtWTV9HVUVTVERCR19FTkFCTEUpIHsKKwkJdmNwdS0+Z3Vlc3Rf
ZGVidWcgPSBkYmctPmNvbnRyb2w7CisJfSBlbHNlIHsKKwkJLyogSWYgbm90IGVuYWJsZWQgY2xl
YXIgYWxsIGZsYWdzICovCisJCXZjcHUtPmd1ZXN0X2RlYnVnID0gMDsKKwl9CisJcmV0dXJuIDA7
CiB9CiAKIAotLSAKMi4zLjUKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVk
dQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
