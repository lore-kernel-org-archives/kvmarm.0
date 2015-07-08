From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 03/10] KVM: arm/arm64: vgic: Convert struct vgic_lr to use
 bitfields
Date: Wed,  8 Jul 2015 18:56:35 +0100
Message-ID: <1436378202-20224-4-git-send-email-marc.zyngier@arm.com>
References: <1436378202-20224-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D9E7A581A7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jul 2015 13:45:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uBtnX8Pz+yDh for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Jul 2015 13:45:20 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 80F8D581A6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jul 2015 13:45:20 -0400 (EDT)
In-Reply-To: <1436378202-20224-1-git-send-email-marc.zyngier@arm.com>
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
cGh5c2ljYWwgbGluZS4KClNpZ25lZC1vZmYtYnk6IE1hcmMgWnluZ2llciA8bWFyYy56eW5naWVy
QGFybS5jb20+ClJldmlld2VkLWJ5OiBBbGV4IEJlbm7DqWUgPGFsZXguYmVubmVlQGxpbmFyby5v
cmc+Ci0tLQogaW5jbHVkZS9rdm0vYXJtX3ZnaWMuaCB8IDEwICsrKysrKystLS0KIDEgZmlsZSBj
aGFuZ2VkLCA3IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvaW5j
bHVkZS9rdm0vYXJtX3ZnaWMuaCBiL2luY2x1ZGUva3ZtL2FybV92Z2ljLmgKaW5kZXggMTMzZWEw
MC4uNGY5ZmExZCAxMDA2NDQKLS0tIGEvaW5jbHVkZS9rdm0vYXJtX3ZnaWMuaAorKysgYi9pbmNs
dWRlL2t2bS9hcm1fdmdpYy5oCkBAIC05NSwxMSArOTUsMTUgQEAgZW51bSB2Z2ljX3R5cGUgewog
I2RlZmluZSBMUl9TVEFURV9BQ1RJVkUJCSgxIDw8IDEpCiAjZGVmaW5lIExSX1NUQVRFX01BU0sJ
CSgzIDw8IDApCiAjZGVmaW5lIExSX0VPSV9JTlQJCSgxIDw8IDIpCisjZGVmaW5lIExSX0hXCQkJ
KDEgPDwgMykKIAogc3RydWN0IHZnaWNfbHIgewotCXUxNglpcnE7Ci0JdTgJc291cmNlOwotCXU4
CXN0YXRlOworCXVuc2lnbmVkIGlycToxMDsKKwl1bmlvbiB7CisJCXVuc2lnbmVkIGh3aXJxOjEw
OworCQl1bnNpZ25lZCBzb3VyY2U6ODsKKwl9OworCXVuc2lnbmVkIHN0YXRlOjQ7CiB9OwogCiBz
dHJ1Y3QgdmdpY192bWNyIHsKLS0gCjIuMS40CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5j
b2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5m
by9rdm1hcm0K
