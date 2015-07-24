From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 03/11] KVM: arm/arm64: vgic: Convert struct vgic_lr to use
 bitfields
Date: Fri, 24 Jul 2015 16:55:01 +0100
Message-ID: <1437753309-17989-4-git-send-email-marc.zyngier@arm.com>
References: <1437753309-17989-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 434E45927A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jul 2015 11:43:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id neiGW8pDjHxO for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Jul 2015 11:43:03 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0927F59254
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jul 2015 11:43:03 -0400 (EDT)
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

QXMgd2UncmUgYWJvdXQgdG8gY3JhbSBtb3JlIGluZm9ybWF0aW9uIGluIHRoZSB2Z2ljX2xyIHN0
cnVjdHVyZQooSFcgaW50ZXJydXB0IG51bWJlciBhbmQgYWRkaXRpb25hbCBzdGF0ZSBpbmZvcm1h
dGlvbiksIHdlIHN3aXRjaAp0byBhIGxheW91dCBzaW1pbGFyIHRvIHRoZSBIVydzOgoKLSB1c2Ug
Yml0ZmllbGRzIHRvIHNhdmUgc3BhY2UgKHdlIGRvbid0IG5lZWQgbW9yZSB0aGFuIDEwIGJpdHMK
ICB0byByZXByZXNlbnQgdGhlIGlycSBudW1iZXJzKQotIHNvdXJjZSBDUFUgYW5kIEhXIGludGVy
cnVwdCBjYW4gc2hhcmUgdGhlIHNhbWUgZmllbGQsIGFzCiAgYSBTR0kgZG9lc24ndCBoYXZlIGEg
cGh5c2ljYWwgbGluZS4KClJldmlld2VkLWJ5OiBBbGV4IEJlbm7DqWUgPGFsZXguYmVubmVlQGxp
bmFyby5vcmc+ClJldmlld2VkLWJ5OiBDaHJpc3RvZmZlciBEYWxsIDxjaHJpc3RvZmZlci5kYWxs
QGxpbmFyby5vcmc+ClNpZ25lZC1vZmYtYnk6IE1hcmMgWnluZ2llciA8bWFyYy56eW5naWVyQGFy
bS5jb20+Ci0tLQogaW5jbHVkZS9rdm0vYXJtX3ZnaWMuaCB8IDEwICsrKysrKystLS0KIDEgZmls
ZSBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEv
aW5jbHVkZS9rdm0vYXJtX3ZnaWMuaCBiL2luY2x1ZGUva3ZtL2FybV92Z2ljLmgKaW5kZXggMTMz
ZWEwMC4uYTg4MWUzOSAxMDA2NDQKLS0tIGEvaW5jbHVkZS9rdm0vYXJtX3ZnaWMuaAorKysgYi9p
bmNsdWRlL2t2bS9hcm1fdmdpYy5oCkBAIC05NSwxMSArOTUsMTUgQEAgZW51bSB2Z2ljX3R5cGUg
ewogI2RlZmluZSBMUl9TVEFURV9BQ1RJVkUJCSgxIDw8IDEpCiAjZGVmaW5lIExSX1NUQVRFX01B
U0sJCSgzIDw8IDApCiAjZGVmaW5lIExSX0VPSV9JTlQJCSgxIDw8IDIpCisjZGVmaW5lIExSX0hX
CQkJKDEgPDwgMykKIAogc3RydWN0IHZnaWNfbHIgewotCXUxNglpcnE7Ci0JdTgJc291cmNlOwot
CXU4CXN0YXRlOworCXVuc2lnbmVkIGlycToxMDsKKwl1bmlvbiB7CisJCXVuc2lnbmVkIGh3aXJx
OjEwOworCQl1bnNpZ25lZCBzb3VyY2U6MzsKKwl9OworCXVuc2lnbmVkIHN0YXRlOjQ7CiB9Owog
CiBzdHJ1Y3QgdmdpY192bWNyIHsKLS0gCjIuMS40CgpfX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5j
cy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0
aW5mby9rdm1hcm0K
