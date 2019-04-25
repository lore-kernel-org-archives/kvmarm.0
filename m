From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 1/5] KVM: arm/arm64: arch_timer: Fix CNTP_TVAL calculation
Date: Thu, 25 Apr 2019 14:48:52 +0100
Message-ID: <20190425134857.26109-2-marc.zyngier@arm.com>
References: <20190425134857.26109-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C6EAE4A477
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Apr 2019 09:49:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hu5th-jz7tkL for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Apr 2019 09:49:16 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4265A4A4B0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Apr 2019 09:49:16 -0400 (EDT)
In-Reply-To: <20190425134857.26109-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, Heyi Guo <guoheyi@huawei.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

RnJvbTogV2VpIEh1YW5nIDx3ZWlAcmVkaGF0LmNvbT4KClJlY2VudGx5IHRoZSBnZW5lcmljIHRp
bWVyIHRlc3Qgb2Yga3ZtLXVuaXQtdGVzdHMgZmFpbGVkIHRvIGNvbXBsZXRlCihzdGFsbGVkKSB3
aGVuIGEgcGh5c2ljYWwgdGltZXIgaXMgYmVpbmcgdXNlZC4gVGhpcyBpc3N1ZSBpcyBjYXVzZWQK
YnkgaW5jb3JyZWN0IHVwZGF0ZSBvZiBDTlRQX0NWQUwgd2hlbiBDTlRQX1RWQUwgaXMgYmVpbmcg
YWNjZXNzZWQsCmludHJvZHVjZWQgYnkgJ0NvbW1pdCA4NDEzNWQzZDE4ZGEgKCJLVk06IGFybS9h
cm02NDogY29uc29saWRhdGUgYXJjaAp0aW1lciB0cmFwIGhhbmRsZXJzIiknLiBBY2NvcmRpbmcg
dG8gQXJtIEFSTSwgdGhlIHJlYWQvd3JpdGUgYmVoYXZpb3IKb2YgYWNjZXNzZXMgdG8gdGhlIFRW
QUwgcmVnaXN0ZXJzIGlzIGV4cGVjdGVkIHRvIGJlOgoKICAqIFJFQUQ6IFRpbWVyVmFsdWUgPSAo
Q29tcGFyZVZhbHVlIOKAkyAoQ291bnRlciAtIE9mZnNldCkKICAqIFdSSVRFOiBDb21wYXJlVmFs
dWUgPSAoKENvdW50ZXIgLSBPZmZzZXQpICsgU2lnbihUaW1lclZhbHVlKQoKVGhpcyBwYXRjaCBm
aXhlcyB0aGUgVFZBTCByZWFkL3dyaXRlIGNvZGUgcGF0aCBhY2NvcmRpbmcgdG8gdGhlCnNwZWNp
ZmljYXRpb24uCgpGaXhlczogODQxMzVkM2QxOGRhICgiS1ZNOiBhcm0vYXJtNjQ6IGNvbnNvbGlk
YXRlIGFyY2ggdGltZXIgdHJhcCBoYW5kbGVycyIpClNpZ25lZC1vZmYtYnk6IFdlaSBIdWFuZyA8
d2VpQHJlZGhhdC5jb20+ClttYXo6IGNvbW1pdCBtZXNzYWdlIHRpZHktdXBdClNpZ25lZC1vZmYt
Ynk6IE1hcmMgWnluZ2llciA8bWFyYy56eW5naWVyQGFybS5jb20+Ci0tLQogdmlydC9rdm0vYXJt
L2FyY2hfdGltZXIuYyB8IDQgKystLQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwg
MiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS92aXJ0L2t2bS9hcm0vYXJjaF90aW1lci5jIGIv
dmlydC9rdm0vYXJtL2FyY2hfdGltZXIuYwppbmRleCAzNDE3ZjJkYmMzNjYuLmQ0MzMwOGRjMzYx
NyAxMDA2NDQKLS0tIGEvdmlydC9rdm0vYXJtL2FyY2hfdGltZXIuYworKysgYi92aXJ0L2t2bS9h
cm0vYXJjaF90aW1lci5jCkBAIC04MTIsNyArODEyLDcgQEAgc3RhdGljIHU2NCBrdm1fYXJtX3Rp
bWVyX3JlYWQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LAogCiAJc3dpdGNoICh0cmVnKSB7CiAJY2Fz
ZSBUSU1FUl9SRUdfVFZBTDoKLQkJdmFsID0ga3ZtX3BoeXNfdGltZXJfcmVhZCgpIC0gdGltZXIt
PmNudHZvZmYgLSB0aW1lci0+Y250X2N2YWw7CisJCXZhbCA9IHRpbWVyLT5jbnRfY3ZhbCAtIGt2
bV9waHlzX3RpbWVyX3JlYWQoKSArIHRpbWVyLT5jbnR2b2ZmOwogCQlicmVhazsKIAogCWNhc2Ug
VElNRVJfUkVHX0NUTDoKQEAgLTg1OCw3ICs4NTgsNyBAQCBzdGF0aWMgdm9pZCBrdm1fYXJtX3Rp
bWVyX3dyaXRlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwKIHsKIAlzd2l0Y2ggKHRyZWcpIHsKIAlj
YXNlIFRJTUVSX1JFR19UVkFMOgotCQl0aW1lci0+Y250X2N2YWwgPSB2YWwgLSBrdm1fcGh5c190
aW1lcl9yZWFkKCkgLSB0aW1lci0+Y250dm9mZjsKKwkJdGltZXItPmNudF9jdmFsID0ga3ZtX3Bo
eXNfdGltZXJfcmVhZCgpIC0gdGltZXItPmNudHZvZmYgKyB2YWw7CiAJCWJyZWFrOwogCiAJY2Fz
ZSBUSU1FUl9SRUdfQ1RMOgotLSAKMi4yMC4xCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5j
b2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5m
by9rdm1hcm0K
