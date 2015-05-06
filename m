From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v3 04/12] KVM: arm: guest debug,
 add stub KVM_SET_GUEST_DEBUG ioctl
Date: Wed,  6 May 2015 17:23:19 +0100
Message-ID: <1430929407-3487-5-git-send-email-alex.bennee@linaro.org>
References: <1430929407-3487-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 952425095B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 May 2015 12:14:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JHoylbOoz4ax for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 May 2015 12:14:09 -0400 (EDT)
Received: from socrates.bennee.com
 (static.88-198-71-155.clients.your-server.de [88.198.71.155])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9E0A15089E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 May 2015 12:14:09 -0400 (EDT)
In-Reply-To: <1430929407-3487-1-git-send-email-alex.bennee@linaro.org>
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
ZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4uCgotLS0KdjIKICAtIHNpbXBsaWZpZWQgZm9ybSBv
ZiB0aGUgaW9jdGwgKHN0dWZmIHdpbGwgZ28gaW50byBzZXR1cF9kZWJ1ZykKdjMKIC0gS1ZNX0dV
RVNUREJHX1ZBTElELT5LVk1fR1VFU1REQkdfVkFMSURfTUFTSwogLSBtb3ZlIG1hc2sgY2hlY2sg
dG8gdGhlIHRvcCBvZiBmdW5jdGlvbgogLSBhZGQgaW9jdGwgZG9jIGhlYWRlcgogLSBzcGxpdCBj
YXBhYmlsaXR5IGludG8gc2VwYXJhdGUgcGF0Y2gKIC0gdHdlYWtlZCBjb21taXQgd29yZGluZyB3
LnIudCByZXR1cm4gb2YgLUVJTlZBTAoKZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vdmlydHVh
bC9rdm0vYXBpLnR4dCBiL0RvY3VtZW50YXRpb24vdmlydHVhbC9rdm0vYXBpLnR4dAppbmRleCBj
YjkwMDI1Li40YjAxMzJmIDEwMDY0NAotLS0gYS9Eb2N1bWVudGF0aW9uL3ZpcnR1YWwva3ZtL2Fw
aS50eHQKKysrIGIvRG9jdW1lbnRhdGlvbi92aXJ0dWFsL2t2bS9hcGkudHh0CkBAIC0yNjQ1LDcg
KzI2NDUsNyBAQCBoYW5kbGVkLgogNC44NyBLVk1fU0VUX0dVRVNUX0RFQlVHCiAKIENhcGFiaWxp
dHk6IEtWTV9DQVBfU0VUX0dVRVNUX0RFQlVHCi1BcmNoaXRlY3R1cmVzOiB4ODYsIHMzOTAsIHBw
YworQXJjaGl0ZWN0dXJlczogeDg2LCBzMzkwLCBwcGMsIGFybTY0CiBUeXBlOiB2Y3B1IGlvY3Rs
CiBQYXJhbWV0ZXJzOiBzdHJ1Y3Qga3ZtX2d1ZXN0X2RlYnVnIChpbikKIFJldHVybnM6IDAgb24g
c3VjY2VzczsgLTEgb24gZXJyb3IKZGlmZiAtLWdpdCBhL2FyY2gvYXJtL2t2bS9hcm0uYyBiL2Fy
Y2gvYXJtL2t2bS9hcm0uYwppbmRleCBkOTYzMWVjLi41MmExZDRkMzggMTAwNjQ0Ci0tLSBhL2Fy
Y2gvYXJtL2t2bS9hcm0uYworKysgYi9hcmNoL2FybS9rdm0vYXJtLmMKQEAgLTMwMiwxMCArMzAy
LDMxIEBAIHZvaWQga3ZtX2FyY2hfdmNwdV9wdXQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQogCWt2
bV9hcm1fc2V0X3J1bm5pbmdfdmNwdShOVUxMKTsKIH0KIAorI2RlZmluZSBLVk1fR1VFU1REQkdf
VkFMSURfTUFTSyAoS1ZNX0dVRVNUREJHX0VOQUJMRSkKKworLyoqCisgKiBrdm1fYXJjaF92Y3B1
X2lvY3RsX3NldF9ndWVzdF9kZWJ1ZyAtIHNldCB1cCBndWVzdCBkZWJ1Z2dpbmcKKyAqIEBrdm06
CXBvaW50ZXIgdG8gdGhlIEtWTSBzdHJ1Y3QKKyAqIEBrdm1fZ3Vlc3RfZGVidWc6IHRoZSBpb2N0
bCBkYXRhIGJ1ZmZlcgorICoKKyAqIFRoaXMgc2V0cyB1cCBhbmQgZW5hYmxlcyB0aGUgVk0gZm9y
IGd1ZXN0IGRlYnVnZ2luZy4gVXNlcnNwYWNlCisgKiBwYXNzZXMgaW4gYSBjb250cm9sIGZsYWcg
dG8gZW5hYmxlIGRpZmZlcmVudCBkZWJ1ZyB0eXBlcyBhbmQKKyAqIHBvdGVudGlhbGx5IG90aGVy
IGFyY2hpdGVjdHVyZSBzcGVjaWZpYyBpbmZvcm1hdGlvbiBpbiB0aGUgcmVzdCBvZgorICogdGhl
IHN0cnVjdHVyZS4KKyAqLwogaW50IGt2bV9hcmNoX3ZjcHVfaW9jdGxfc2V0X2d1ZXN0X2RlYnVn
KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwKIAkJCQkJc3RydWN0IGt2bV9ndWVzdF9kZWJ1ZyAqZGJn
KQogewotCXJldHVybiAtRUlOVkFMOworCWlmIChkYmctPmNvbnRyb2wgJiB+S1ZNX0dVRVNUREJH
X1ZBTElEX01BU0spCisJCXJldHVybiAtRUlOVkFMOworCisJaWYgKGRiZy0+Y29udHJvbCAmIEtW
TV9HVUVTVERCR19FTkFCTEUpIHsKKwkJdmNwdS0+Z3Vlc3RfZGVidWcgPSBkYmctPmNvbnRyb2w7
CisJfSBlbHNlIHsKKwkJLyogSWYgbm90IGVuYWJsZWQgY2xlYXIgYWxsIGZsYWdzICovCisJCXZj
cHUtPmd1ZXN0X2RlYnVnID0gMDsKKwl9CisJcmV0dXJuIDA7CiB9CiAKIAotLSAKMi4zLjUKCl9f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWls
aW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNv
bHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
