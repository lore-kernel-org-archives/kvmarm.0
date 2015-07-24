From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 02/11] arm/arm64: KVM: Move vgic handling to a
 non-preemptible section
Date: Fri, 24 Jul 2015 16:55:00 +0100
Message-ID: <1437753309-17989-3-git-send-email-marc.zyngier@arm.com>
References: <1437753309-17989-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5953659220
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jul 2015 11:43:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lBHG8zBrwQq6 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Jul 2015 11:43:01 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7862259234
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jul 2015 11:43:01 -0400 (EDT)
In-Reply-To: <1437753309-17989-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

QXMgd2UncmUgYWJvdXQgdG8gaW50cm9kdWNlIHNvbWUgc2VyaW91cyBHSUMtcG9raW5nIHRvIHRo
ZSB2Z2ljIGNvZGUsCml0IGlzIGltcG9ydGFudCB0byBtYWtlIHN1cmUgdGhhdCB3ZSdyZSBnb2lu
ZyB0byBwb2tlIHRoZSBwYXJ0IG9mCnRoZSBHSUMgdGhhdCBiZWxvbmdzIHRvIHRoZSBDUFUgd2Un
cmUgYWJvdXQgdG8gcnVuIG9uIChvdGhlcndpc2UsCndlJ2QgZW5kIHVwIHdpdGggc29tZSB1bmV4
cGVjdGVkIGludGVycnVwdHMgZmlyaW5nKS4uLgoKSW50cm9kdWNpbmcgYSBub24tcHJlZW1wdGli
bGUgc2VjdGlvbiBpbiBrdm1fYXJjaF92Y3B1X2lvY3RsX3J1bgpwcmV2ZW50cyB0aGUgcHJvYmxl
bSBmcm9tIG9jY3VyaW5nLgoKUmV2aWV3ZWQtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVA
bGluYXJvLm9yZz4KUmV2aWV3ZWQtYnk6IENocmlzdG9mZmVyIERhbGwgPGNocmlzdG9mZmVyLmRh
bGxAbGluYXJvLm9yZz4KU2lnbmVkLW9mZi1ieTogTWFyYyBaeW5naWVyIDxtYXJjLnp5bmdpZXJA
YXJtLmNvbT4KLS0tCiBhcmNoL2FybS9rdm0vYXJtLmMgfCAxOCArKysrKysrKysrKysrKystLS0K
IDEgZmlsZSBjaGFuZ2VkLCAxNSBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQoKZGlmZiAt
LWdpdCBhL2FyY2gvYXJtL2t2bS9hcm0uYyBiL2FyY2gvYXJtL2t2bS9hcm0uYwppbmRleCAxMTQx
ZDIxLi5mMWJmNDE4IDEwMDY0NAotLS0gYS9hcmNoL2FybS9rdm0vYXJtLmMKKysrIGIvYXJjaC9h
cm0va3ZtL2FybS5jCkBAIC01MjMsMTAgKzUyMywyMCBAQCBpbnQga3ZtX2FyY2hfdmNwdV9pb2N0
bF9ydW4oc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBzdHJ1Y3Qga3ZtX3J1biAqcnVuKQogCQlpZiAo
dmNwdS0+YXJjaC5wYXVzZSkKIAkJCXZjcHVfcGF1c2UodmNwdSk7CiAKKwkJLyoKKwkJICogRGlz
YXJtaW5nIHRoZSBiYWNrZ3JvdW5kIHRpbWVyIG11c3QgYmUgZG9uZSBpbiBhCisJCSAqIHByZWVt
cHRpYmxlIGNvbnRleHQsIGFzIHRoaXMgY2FsbCBtYXkgc2xlZXAuCisJCSAqLwogCQlrdm1fdGlt
ZXJfZmx1c2hfaHdzdGF0ZSh2Y3B1KTsKLQkJa3ZtX3ZnaWNfZmx1c2hfaHdzdGF0ZSh2Y3B1KTsK
IAorCQkvKgorCQkgKiBQcmVwYXJpbmcgdGhlIGludGVycnVwdHMgdG8gYmUgaW5qZWN0ZWQgYWxz
bworCQkgKiBpbnZvbHZlcyBwb2tpbmcgdGhlIEdJQywgd2hpY2ggbXVzdCBiZSBkb25lIGluIGEK
KwkJICogbm9uLXByZWVtcHRpYmxlIGNvbnRleHQuCisJCSAqLwogCQlwcmVlbXB0X2Rpc2FibGUo
KTsKKwkJa3ZtX3ZnaWNfZmx1c2hfaHdzdGF0ZSh2Y3B1KTsKKwogCQlsb2NhbF9pcnFfZGlzYWJs
ZSgpOwogCiAJCS8qCkBAIC01MzksOCArNTQ5LDggQEAgaW50IGt2bV9hcmNoX3ZjcHVfaW9jdGxf
cnVuKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgc3RydWN0IGt2bV9ydW4gKnJ1bikKIAogCQlpZiAo
cmV0IDw9IDAgfHwgbmVlZF9uZXdfdm1pZF9nZW4odmNwdS0+a3ZtKSkgewogCQkJbG9jYWxfaXJx
X2VuYWJsZSgpOwotCQkJcHJlZW1wdF9lbmFibGUoKTsKIAkJCWt2bV92Z2ljX3N5bmNfaHdzdGF0
ZSh2Y3B1KTsKKwkJCXByZWVtcHRfZW5hYmxlKCk7CiAJCQlrdm1fdGltZXJfc3luY19od3N0YXRl
KHZjcHUpOwogCQkJY29udGludWU7CiAJCX0KQEAgLTU4NSw5ICs1OTUsMTEgQEAgaW50IGt2bV9h
cmNoX3ZjcHVfaW9jdGxfcnVuKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgc3RydWN0IGt2bV9ydW4g
KnJ1bikKIAkJICovCiAJCWt2bV9ndWVzdF9leGl0KCk7CiAJCXRyYWNlX2t2bV9leGl0KGt2bV92
Y3B1X3RyYXBfZ2V0X2NsYXNzKHZjcHUpLCAqdmNwdV9wYyh2Y3B1KSk7Ci0JCXByZWVtcHRfZW5h
YmxlKCk7CiAKIAkJa3ZtX3ZnaWNfc3luY19od3N0YXRlKHZjcHUpOworCisJCXByZWVtcHRfZW5h
YmxlKCk7CisKIAkJa3ZtX3RpbWVyX3N5bmNfaHdzdGF0ZSh2Y3B1KTsKIAogCQlyZXQgPSBoYW5k
bGVfZXhpdCh2Y3B1LCBydW4sIHJldCk7Ci0tIAoyLjEuNAoKX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlz
dHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4v
bGlzdGluZm8va3ZtYXJtCg==
