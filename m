Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 888C3C433FE
	for <kvmarm@archiver.kernel.org>; Wed, 25 May 2022 16:57:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 28BCE4B2FF;
	Wed, 25 May 2022 12:57:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tuZXh7mMOc1Q; Wed, 25 May 2022 12:57:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 012054B306;
	Wed, 25 May 2022 12:57:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A62114B26A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 May 2022 12:57:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GudfoKHgkVtw for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 May 2022 12:57:07 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 10FFB4B2EE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 May 2022 12:57:06 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 910631474;
 Wed, 25 May 2022 09:57:05 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2D6293F66F;
 Wed, 25 May 2022 09:57:04 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 andre.przywara@arm.com
Subject: [PATCH kvmtool 2/2] mips: Do not emulate a serial device
Date: Wed, 25 May 2022 17:57:04 +0100
Message-Id: <20220525165704.186754-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220525165704.186754-1-alexandru.elisei@arm.com>
References: <20220525165704.186754-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
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

Q29tbWl0IDQ1YjQ5NjhlMGRlMSAoImh3L3NlcmlhbDogQVJNL2FybTY0OiBVc2UgTU1JTyBhdCBo
aWdoZXIgYWRkcmVzc2VzIikKY2hhbmdlZCBob3cgdGhlIGFkZHJlc3MgZm9yIHRoZSBVQVJUIGlz
IGNvbXB1dGVkIGJ5IHVzaW5nIEtWTV9JT1BPUlRfQVJFQS4KVGhlIHN5bWJvbCBpcyBub3QgZGVm
aW5lZCBmb3IgTUlQUywgd2hpY2ggcmVzdWx0cyBpbiB0aGUgZm9sbG93aW5nCmNvbXBpbGF0aW9u
IGVycm9yOgoKaHcvc2VyaWFsLmM6MjE6Mjc6IGVycm9yOiDigJhLVk1fSU9QT1JUX0FSRUHigJkg
dW5kZWNsYXJlZCBoZXJlIChub3QgaW4gYSBmdW5jdGlvbik7IGRpZCB5b3UgbWVhbiDigJhLVk1f
TUlQU19JT1BPUlRfQVJFQeKAmT8KICAgMjEgfCAjZGVmaW5lIHNlcmlhbF9pb2Jhc2VfMCAgKEtW
TV9JT1BPUlRfQVJFQSArIDB4M2Y4KQogICAgICB8ICAgICAgICAgICAgICAgICAgICAgICAgICAg
Xn5+fn5+fn5+fn5+fn5+Cmh3L3NlcmlhbC5jOjI5OjI3OiBub3RlOiBpbiBleHBhbnNpb24gb2Yg
bWFjcm8g4oCYc2VyaWFsX2lvYmFzZV8w4oCZCiAgIDI5IHwgI2RlZmluZSBzZXJpYWxfaW9iYXNl
KG5yKSBzZXJpYWxfaW9iYXNlXyMjbnIKICAgICAgfCAgICAgICAgICAgICAgICAgICAgICAgICAg
IF5+fn5+fn5+fn5+fn5+Cmh3L3NlcmlhbC5jOjkyOjE1OiBub3RlOiBpbiBleHBhbnNpb24gb2Yg
bWFjcm8g4oCYc2VyaWFsX2lvYmFzZeKAmQogICA5MiB8ICAgLmlvYmFzZSAgID0gc2VyaWFsX2lv
YmFzZSgwKSwKICAgICAgfCAgICAgICAgICAgICAgIF5+fn5+fn5+fn5+fn4KCkJlZm9yZSB0aGUg
Y29tbWl0LCB0aGUgc2VyaWFsIHdhcyBwbGFjZWQgYXQgYWRkcmVzc2VzIDB4M2Y4LCAweDJmOCwK
MHgzZTggYW5kIDB4MmU4LiBIb3dldmVyLCBNSVBTIHB1dHMgdGhlIFJBTSBhdCB0aG9zZSBhZGRy
ZXNzZXMsIHVwIHRvCktWTV9NTUlPX1NUQVJULCB3aGljaCBpcyAweDEwMDAwMDAwLiBNZWFuaW5n
IHRoYXQgc2VyaWFsIGRldmljZQplbXVsYXRpb24gbmV2ZXIgd29ya2VkLCBhcyB0aG9zZSBhZGRy
ZXNzZXMgd2VyZSBwYXJ0IG9mIGEgdmFsaWQgbWVtc2xvdApyZXByZXNlbnRpbmcgbWVtb3J5LiBU
aGlzIGhhcyBiZWVuIHRoZSBjYXNlIHNpbmNlIGNvbW1pdCA3MjgxYThkYjE5OWIKKCJrdm0gdG9v
bHMsIG1pcHM6IEFkZCBNSVBTIHN1cHBvcnQiKSBmcm9tIDIwMTQuCgpBIHF1aWNrIGV4YW1pbmF0
aW9uIG9mIHRoZSBNSVBTIGNvZGUgcmV2ZWFscyB0aGF0IHRoZSBhcmNoaXRlY3R1cmUgcmVsaWVz
Cm9uIGh5cGVyY2FsbHMgZnJvbSB0aGUgZ3Vlc3QgYW5kIHRoZSB2aXJ0aW8gY29uc29sZSBmb3Ig
aW5wdXQgYW5kIG91dHB1dC4KU2luY2Ugbm9ib2R5IGNvbXBsYWluZWQgYWJvdXQgdGhlIG1pc3Np
bmcgc2VyaWFsIGRldmljZSwgYXNzdW1lIHRoYXQgaXQgaXMKaW5kZWVkIG5vdCBuZWVkZWQgYW5k
IGRvIG5vdCBjb21waWxlIGl0IGZvciBNSVBTLgoKU2lnbmVkLW9mZi1ieTogQWxleGFuZHJ1IEVs
aXNlaSA8YWxleGFuZHJ1LmVsaXNlaUBhcm0uY29tPgotLS0KIE1ha2VmaWxlICAgfCA3ICsrKysr
LS0KIG1pcHMva3ZtLmMgfCA1ICsrKysrCiAyIGZpbGVzIGNoYW5nZWQsIDEwIGluc2VydGlvbnMo
KyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvTWFrZWZpbGUgYi9NYWtlZmlsZQppbmRl
eCA5ZTY3Yzc2MzdiMWUuLjY0NjQ0NDZhOWYyNCAxMDA2NDQKLS0tIGEvTWFrZWZpbGUKKysrIGIv
TWFrZWZpbGUKQEAgLTU2LDcgKzU2LDYgQEAgT0JKUwkrPSBkaXNrL2NvcmUubwogT0JKUwkrPSBm
cmFtZWJ1ZmZlci5vCiBPQkpTCSs9IGd1ZXN0X2NvbXBhdC5vCiBPQkpTCSs9IGh3L3J0Yy5vCi1P
QkpTCSs9IGh3L3NlcmlhbC5vCiBPQkpTCSs9IGlycS5vCiBPQkpTCSs9IGt2bS1jcHUubwogT0JK
UwkrPSBrdm0ubwpAQCAtMTI3LDYgKzEyNiw3IEBAIGVuZGlmCiBpZmVxICgkKEFSQ0gpLHg4NikK
IAlERUZJTkVTICs9IC1EQ09ORklHX1g4NgogCU9CSlMJKz0gaHcvaTgwNDIubworCU9CSlMJKz0g
aHcvc2VyaWFsLm8KIAlPQkpTCSs9IHg4Ni9ib290Lm8KIAlPQkpTCSs9IHg4Ni9jcHVpZC5vCiAJ
T0JKUwkrPSB4ODYvaW50ZXJydXB0Lm8KQEAgLTE0NCw2ICsxNDQsNyBAQCBlbmRpZgogIyBQT1dF
Ui9wcGM6ICBBY3R1YWxseSBvbmx5IHN1cHBvcnQgcHBjNjQgY3VycmVudGx5LgogaWZlcSAoJChB
UkNIKSwgcG93ZXJwYykKIAlERUZJTkVTICs9IC1EQ09ORklHX1BQQworCU9CSlMJKz0gaHcvc2Vy
aWFsLm8KIAlPQkpTCSs9IHBvd2VycGMvYm9vdC5vCiAJT0JKUwkrPSBwb3dlcnBjL2lvcG9ydC5v
CiAJT0JKUwkrPSBwb3dlcnBjL2t2bS5vCkBAIC0xNjEsNyArMTYyLDggQEAgZW5kaWYKIAogIyBB
Uk0KIE9CSlNfQVJNX0NPTU1PTgkJOj0gYXJtL2ZkdC5vIGFybS9naWMubyBhcm0vZ2ljdjJtLm8g
YXJtL2lvcG9ydC5vIFwKLQkJCSAgIGFybS9rdm0ubyBhcm0va3ZtLWNwdS5vIGFybS9wY2kubyBh
cm0vdGltZXIubworCQkJICAgYXJtL2t2bS5vIGFybS9rdm0tY3B1Lm8gYXJtL3BjaS5vIGFybS90
aW1lci5vIFwKKwkJCSAgIGh3L3NlcmlhbC5vCiBIRFJTX0FSTV9DT01NT04JCTo9IGFybS9pbmNs
dWRlCiBpZmVxICgkKEFSQ0gpLCBhcm0pCiAJREVGSU5FUwkJKz0gLURDT05GSUdfQVJNCkBAIC0y
MDMsNiArMjA1LDcgQEAgZW5kaWYKIGlmZXEgKCQoQVJDSCkscmlzY3YpCiAJREVGSU5FUwkJKz0g
LURDT05GSUdfUklTQ1YKIAlBUkNIX0lOQ0xVREUJOj0gcmlzY3YvaW5jbHVkZQorCU9CSlMJCSs9
IGh3L3NlcmlhbC5vCiAJT0JKUwkJKz0gcmlzY3YvZmR0Lm8KIAlPQkpTCQkrPSByaXNjdi9pb3Bv
cnQubwogCU9CSlMJCSs9IHJpc2N2L2lycS5vCmRpZmYgLS1naXQgYS9taXBzL2t2bS5jIGIvbWlw
cy9rdm0uYwppbmRleCAzNDcwZGJiMmU0MzMuLmU2NjhjYmJlZmIyNSAxMDA2NDQKLS0tIGEvbWlw
cy9rdm0uYworKysgYi9taXBzL2t2bS5jCkBAIC0xLDMgKzEsNCBAQAorI2luY2x1ZGUgImt2bS84
MjUwLXNlcmlhbC5oIgogI2luY2x1ZGUgImt2bS9rdm0uaCIKICNpbmNsdWRlICJrdm0vaW9wb3J0
LmgiCiAjaW5jbHVkZSAia3ZtL3ZpcnRpby1jb25zb2xlLmgiCkBAIC0zNTksMyArMzYwLDcgQEAg
Ym9vbCBrdm1fX2FyY2hfbG9hZF9rZXJuZWxfaW1hZ2Uoc3RydWN0IGt2bSAqa3ZtLCBpbnQgZmRf
a2VybmVsLCBpbnQgZmRfaW5pdHJkLAogdm9pZCBpb3BvcnRfX21hcF9pcnEodTggKmlycSkKIHsK
IH0KKwordm9pZCBzZXJpYWw4MjUwX19pbmplY3Rfc3lzcnEoc3RydWN0IGt2bSAqa3ZtLCBjaGFy
IHN5c3JxKQoreworfQotLSAKMi4zNi4xCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1
bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9r
dm1hcm0K
