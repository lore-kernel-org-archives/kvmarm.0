From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 01/11] arm/arm64: KVM: Fix ordering of timer/GIC on guest
 entry
Date: Fri, 24 Jul 2015 16:54:59 +0100
Message-ID: <1437753309-17989-2-git-send-email-marc.zyngier@arm.com>
References: <1437753309-17989-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 52C6159234
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jul 2015 11:43:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dYHlzEYHmZPV for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Jul 2015 11:43:00 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B4B35922E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jul 2015 11:42:59 -0400 (EDT)
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

QXMgd2Ugbm93IGluamVjdCB0aGUgdGltZXIgaW50ZXJydXB0IHdoZW4gd2UncmUgYWJvdXQgdG8g
ZW50ZXIKdGhlIGd1ZXN0LCBpdCBtYWtlcyBhIGxvdCBtb3JlIHNlbnNlIHRvIG1ha2Ugc3VyZSB0
aGlzIGhhcHBlbnMKYmVmb3JlIHRoZSB2Z2ljIGNvZGUgcXVldWVzIHRoZSBwZW5kaW5nIGludGVy
cnVwdHMuCgpPdGhlcndpc2UsIHdlIGdldCB0aGUgaW50ZXJydXB0IG9uIHRoZSBmb2xsb3dpbmcg
ZXhpdCwgd2hpY2ggaXMKbm90IGdyZWF0IGZvciBsYXRlbmN5IChhbmQgbGVhZHMgdG8gYWxsIGtp
bmQgb2YgYml6YXJyZSBpc3N1ZXMKd2hlbiB1c2luZyB3aXRoIGFjdGl2ZSBpbnRlcnJ1cHRzIGF0
IHRoZSBIVyBsZXZlbCkuCgpTaWduZWQtb2ZmLWJ5OiBNYXJjIFp5bmdpZXIgPG1hcmMuenluZ2ll
ckBhcm0uY29tPgpSZXZpZXdlZC1ieTogQWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5hcm8u
b3JnPgpSZXZpZXdlZC1ieTogQ2hyaXN0b2ZmZXIgRGFsbCA8Y2hyaXN0b2ZmZXIuZGFsbEBsaW5h
cm8ub3JnPgotLS0KIGFyY2gvYXJtL2t2bS9hcm0uYyB8IDcgKysrLS0tLQogMSBmaWxlIGNoYW5n
ZWQsIDMgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9hcmNoL2Fy
bS9rdm0vYXJtLmMgYi9hcmNoL2FybS9rdm0vYXJtLmMKaW5kZXggOWNlNWNmMC4uMTE0MWQyMSAx
MDA2NDQKLS0tIGEvYXJjaC9hcm0va3ZtL2FybS5jCisrKyBiL2FyY2gvYXJtL2t2bS9hcm0uYwpA
QCAtNTIzLDggKzUyMyw4IEBAIGludCBrdm1fYXJjaF92Y3B1X2lvY3RsX3J1bihzdHJ1Y3Qga3Zt
X3ZjcHUgKnZjcHUsIHN0cnVjdCBrdm1fcnVuICpydW4pCiAJCWlmICh2Y3B1LT5hcmNoLnBhdXNl
KQogCQkJdmNwdV9wYXVzZSh2Y3B1KTsKIAotCQlrdm1fdmdpY19mbHVzaF9od3N0YXRlKHZjcHUp
OwogCQlrdm1fdGltZXJfZmx1c2hfaHdzdGF0ZSh2Y3B1KTsKKwkJa3ZtX3ZnaWNfZmx1c2hfaHdz
dGF0ZSh2Y3B1KTsKIAogCQlwcmVlbXB0X2Rpc2FibGUoKTsKIAkJbG9jYWxfaXJxX2Rpc2FibGUo
KTsKQEAgLTU0MCw4ICs1NDAsOCBAQCBpbnQga3ZtX2FyY2hfdmNwdV9pb2N0bF9ydW4oc3RydWN0
IGt2bV92Y3B1ICp2Y3B1LCBzdHJ1Y3Qga3ZtX3J1biAqcnVuKQogCQlpZiAocmV0IDw9IDAgfHwg
bmVlZF9uZXdfdm1pZF9nZW4odmNwdS0+a3ZtKSkgewogCQkJbG9jYWxfaXJxX2VuYWJsZSgpOwog
CQkJcHJlZW1wdF9lbmFibGUoKTsKLQkJCWt2bV90aW1lcl9zeW5jX2h3c3RhdGUodmNwdSk7CiAJ
CQlrdm1fdmdpY19zeW5jX2h3c3RhdGUodmNwdSk7CisJCQlrdm1fdGltZXJfc3luY19od3N0YXRl
KHZjcHUpOwogCQkJY29udGludWU7CiAJCX0KIApAQCAtNTg3LDkgKzU4Nyw4IEBAIGludCBrdm1f
YXJjaF92Y3B1X2lvY3RsX3J1bihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHN0cnVjdCBrdm1fcnVu
ICpydW4pCiAJCXRyYWNlX2t2bV9leGl0KGt2bV92Y3B1X3RyYXBfZ2V0X2NsYXNzKHZjcHUpLCAq
dmNwdV9wYyh2Y3B1KSk7CiAJCXByZWVtcHRfZW5hYmxlKCk7CiAKLQotCQlrdm1fdGltZXJfc3lu
Y19od3N0YXRlKHZjcHUpOwogCQlrdm1fdmdpY19zeW5jX2h3c3RhdGUodmNwdSk7CisJCWt2bV90
aW1lcl9zeW5jX2h3c3RhdGUodmNwdSk7CiAKIAkJcmV0ID0gaGFuZGxlX2V4aXQodmNwdSwgcnVu
LCByZXQpOwogCX0KLS0gCjIuMS40CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJp
YS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1h
cm0K
