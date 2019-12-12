Return-Path: <SRS0=bs2E=2C=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C184C00454
	for <kvmarm@archiver.kernel.org>; Thu, 12 Dec 2019 17:28:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 10EDD21655
	for <kvmarm@archiver.kernel.org>; Thu, 12 Dec 2019 17:28:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 10EDD21655
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF0424AEC5;
	Thu, 12 Dec 2019 12:28:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3AVWnHR-lWf8; Thu, 12 Dec 2019 12:28:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E24B04AEB8;
	Thu, 12 Dec 2019 12:28:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E4424AEBC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Dec 2019 12:28:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NxsqvrRsQTDO for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Dec 2019 12:28:48 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 511A44AC88
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Dec 2019 12:28:48 -0500 (EST)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by cheepnis.misterjones.org with esmtpsa
 (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128) (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1ifSGa-00069s-F9; Thu, 12 Dec 2019 18:28:44 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 7/8] KVM: arm64: Ensure 'params' is initialised when looking
 up sys register
Date: Thu, 12 Dec 2019 17:28:23 +0000
Message-Id: <20191212172824.11523-8-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191212172824.11523-1-maz@kernel.org>
References: <20191212172824.11523-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, rkrcmar@redhat.com,
 alexandru.elisei@arm.com, ard.biesheuvel@linaro.org, christoffer.dall@arm.com,
 eric.auger@redhat.com, james.morse@arm.com, justin.he@arm.com,
 mark.rutland@arm.com, linmiaohe@huawei.com, steven.price@arm.com,
 will@kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: Jia He <justin.he@arm.com>, kvm@vger.kernel.org,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>, Will Deacon <will@kernel.org>,
 stable@vger.kernel.org, Steven Price <steven.price@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

RnJvbTogV2lsbCBEZWFjb24gPHdpbGxAa2VybmVsLm9yZz4KCkNvbW1pdCA0YjkyN2I5NGQ1ZGYg
KCJLVk06IGFybS9hcm02NDogdmdpYzogSW50cm9kdWNlIGZpbmRfcmVnX2J5X2lkKCkiKQppbnRy
b2R1Y2VkICdmaW5kX3JlZ19ieV9pZCgpJywgd2hpY2ggbG9va3MgdXAgYSBzeXN0ZW0gcmVnaXN0
ZXIgb25seSBpZgp0aGUgJ2lkJyBpbmRleCBwYXJhbWV0ZXIgaWRlbnRpZmllcyBhIHZhbGlkIHN5
c3RlbSByZWdpc3Rlci4gQXMgcGFydCBvZgp0aGUgcGF0Y2gsIGV4aXN0aW5nIGNhbGxlcnMgb2Yg
J2ZpbmRfcmVnKCknIHdlcmUgcG9ydGVkIG92ZXIgdG8gdGhlIG5ldwppbnRlcmZhY2UsIGJ1dCB0
aGlzIGJyZWFrcyAnaW5kZXhfdG9fc3lzX3JlZ19kZXNjKCknIGluIHRoZSBjYXNlIHRoYXQgdGhl
CmluaXRpYWwgbG9va3VwIGluIHRoZSB2Q1BVIHRhcmdldCB0YWJsZSBmYWlscyBiZWNhdXNlIHdl
IHdpbGwgdGhlbiBjYWxsCmludG8gJ2ZpbmRfcmVnKCknIGZvciB0aGUgc3lzdGVtIHJlZ2lzdGVy
IHRhYmxlIHdpdGggYW4gdW5pbml0aWFsaXNlZAoncGFyYW0nIGFzIHRoZSBrZXkgdG8gdGhlIGxv
b2t1cC4KCkdDQyAxMCBpcyBicmlnaHQgZW5vdWdoIHRvIHNwb3QgdGhpcyAoYW1vbmdzdCBhIHRv
bm5lIG9mIGZhbHNlIHBvc2l0aXZlcywKYnV0IGhleSEpOgoKICB8IGFyY2gvYXJtNjQva3ZtL3N5
c19yZWdzLmM6IEluIGZ1bmN0aW9uIOKAmGluZGV4X3RvX3N5c19yZWdfZGVzYy5wYXJ0LjAuaXNy
YeKAmToKICB8IGFyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmM6OTgzOjMzOiB3YXJuaW5nOiDigJhw
YXJhbXMuT3Ay4oCZIG1heSBiZSB1c2VkIHVuaW5pdGlhbGl6ZWQgaW4gdGhpcyBmdW5jdGlvbiBb
LVdtYXliZS11bmluaXRpYWxpemVkXQogIHwgICA5ODMgfCAgICh1MzIpKHgpLT5DUm4sICh1MzIp
KHgpLT5DUm0sICh1MzIpKHgpLT5PcDIpOwogIHwgWy4uLl0KClJldmVydCB0aGUgaHVuayBvZiA0
YjkyN2I5NGQ1ZGYgd2hpY2ggYnJlYWtzICdpbmRleF90b19zeXNfcmVnX2Rlc2MoKScgc28KdGhh
dCB0aGUgb2xkIGJlaGF2aW91ciBvZiBjaGVja2luZyB0aGUgaW5kZXggdXBmcm9udCBpcyByZXN0
b3JlZC4KCkZpeGVzOiA0YjkyN2I5NGQ1ZGYgKCJLVk06IGFybS9hcm02NDogdmdpYzogSW50cm9k
dWNlIGZpbmRfcmVnX2J5X2lkKCkiKQpTaWduZWQtb2ZmLWJ5OiBXaWxsIERlYWNvbiA8d2lsbEBr
ZXJuZWwub3JnPgpTaWduZWQtb2ZmLWJ5OiBNYXJjIFp5bmdpZXIgPG1hekBrZXJuZWwub3JnPgpD
YzogPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+Ckxpbms6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3Jn
L3IvMjAxOTEyMTIwOTQwNDkuMTI0MzctMS13aWxsQGtlcm5lbC5vcmcKLS0tCiBhcmNoL2FybTY0
L2t2bS9zeXNfcmVncy5jIHwgNSArKysrLQogMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygr
KSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmMg
Yi9hcmNoL2FybTY0L2t2bS9zeXNfcmVncy5jCmluZGV4IGJkMmFjMzc5NmQ4ZC4uZDc4YjcyNmQ0
NzIyIDEwMDY0NAotLS0gYS9hcmNoL2FybTY0L2t2bS9zeXNfcmVncy5jCisrKyBiL2FyY2gvYXJt
NjQva3ZtL3N5c19yZWdzLmMKQEAgLTIzNjQsOCArMjM2NCwxMSBAQCBzdGF0aWMgY29uc3Qgc3Ry
dWN0IHN5c19yZWdfZGVzYyAqaW5kZXhfdG9fc3lzX3JlZ19kZXNjKHN0cnVjdCBrdm1fdmNwdSAq
dmNwdSwKIAlpZiAoKGlkICYgS1ZNX1JFR19BUk1fQ09QUk9DX01BU0spICE9IEtWTV9SRUdfQVJN
NjRfU1lTUkVHKQogCQlyZXR1cm4gTlVMTDsKIAorCWlmICghaW5kZXhfdG9fcGFyYW1zKGlkLCAm
cGFyYW1zKSkKKwkJcmV0dXJuIE5VTEw7CisKIAl0YWJsZSA9IGdldF90YXJnZXRfdGFibGUodmNw
dS0+YXJjaC50YXJnZXQsIHRydWUsICZudW0pOwotCXIgPSBmaW5kX3JlZ19ieV9pZChpZCwgJnBh
cmFtcywgdGFibGUsIG51bSk7CisJciA9IGZpbmRfcmVnKCZwYXJhbXMsIHRhYmxlLCBudW0pOwog
CWlmICghcikKIAkJciA9IGZpbmRfcmVnKCZwYXJhbXMsIHN5c19yZWdfZGVzY3MsIEFSUkFZX1NJ
WkUoc3lzX3JlZ19kZXNjcykpOwogCi0tIAoyLjIwLjEKCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3Rz
LmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xp
c3RpbmZvL2t2bWFybQo=
