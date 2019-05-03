Return-Path: <SRS0=WQmE=TD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6343FC004C9
	for <kvmarm@archiver.kernel.org>; Fri,  3 May 2019 12:45:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1EB052075E
	for <kvmarm@archiver.kernel.org>; Fri,  3 May 2019 12:45:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1EB052075E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C99194A4EC;
	Fri,  3 May 2019 08:45:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NssHtwlcIjP6; Fri,  3 May 2019 08:45:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A3A954A4CE;
	Fri,  3 May 2019 08:45:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B34204A510
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 May 2019 08:44:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MS-U2qKJC8Yl for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 May 2019 08:44:57 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 576784A4C5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 May 2019 08:44:57 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CB8D1374;
 Fri,  3 May 2019 05:44:56 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com
 (filthy-habits.cambridge.arm.com [10.1.197.61])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 94B493F220;
 Fri,  3 May 2019 05:44:53 -0700 (PDT)
From: Marc Zyngier <marc.zyngier@arm.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 04/56] KVM: arm64: Refactor kvm_arm_num_regs() for easier
 maintenance
Date: Fri,  3 May 2019 13:43:35 +0100
Message-Id: <20190503124427.190206-5-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190503124427.190206-1-marc.zyngier@arm.com>
References: <20190503124427.190206-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
 Kristina Martsenko <kristina.martsenko@arm.com>,
 "zhang . lei" <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>,
 kvmarm@lists.cs.columbia.edu, Amit Daniel Kachhap <amit.kachhap@arm.com>,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
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

RnJvbTogRGF2ZSBNYXJ0aW4gPERhdmUuTWFydGluQGFybS5jb20+Cgprdm1fYXJtX251bV9yZWdz
KCkgYWRkcyB0b2dldGhlciB2YXJpb3VzIHBhcnRpYWwgcmVnaXN0ZXIgY291bnRzIGluCmEgZnJl
ZWZvcm0gc3VtIGV4cHJlc3Npb24sIHdoaWNoIG1ha2VzIGl0IGhhcmRlciB0aGFuIG5lY2Vzc2Fy
eSB0bwpyZWFkIGRpZmZzIHRoYXQgYWRkLCBtb2RpZnkgb3IgcmVtb3ZlIGEgc2luZ2xlIHRlcm0g
aW4gdGhlIHN1bQood2hpY2ggaXMgZXhwZWN0ZWQgdG8gdGhlIGNvbW1vbiBjYXNlIHVuZGVyIG1h
aW50ZW5hbmNlKS4KClRoaXMgcGF0Y2ggcmVmYWN0b3JzIHRoZSBjb2RlIHRvIGFkZCB0aGUgdGVy
bSBvbmUgcGVyIGxpbmUsIGZvcgptYXhpbXVtIHJlYWRhYmlsaXR5LgoKU2lnbmVkLW9mZi1ieTog
RGF2ZSBNYXJ0aW4gPERhdmUuTWFydGluQGFybS5jb20+ClJldmlld2VkLWJ5OiBBbGV4IEJlbm7D
qWUgPGFsZXguYmVubmVlQGxpbmFyby5vcmc+ClRlc3RlZC1ieTogemhhbmcubGVpIDx6aGFuZy5s
ZWlAanAuZnVqaXRzdS5jb20+ClNpZ25lZC1vZmYtYnk6IE1hcmMgWnluZ2llciA8bWFyYy56eW5n
aWVyQGFybS5jb20+Ci0tLQogYXJjaC9hcm02NC9rdm0vZ3Vlc3QuYyB8IDEwICsrKysrKysrLS0K
IDEgZmlsZSBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0t
Z2l0IGEvYXJjaC9hcm02NC9rdm0vZ3Vlc3QuYyBiL2FyY2gvYXJtNjQva3ZtL2d1ZXN0LmMKaW5k
ZXggZGQ0MzZhNTBmY2U3Li42MjUxNGNiYTk1Y2EgMTAwNjQ0Ci0tLSBhL2FyY2gvYXJtNjQva3Zt
L2d1ZXN0LmMKKysrIGIvYXJjaC9hcm02NC9rdm0vZ3Vlc3QuYwpAQCAtMjU4LDggKzI1OCwxNCBA
QCBzdGF0aWMgaW50IGdldF90aW1lcl9yZWcoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBjb25zdCBz
dHJ1Y3Qga3ZtX29uZV9yZWcgKnJlZykKICAqLwogdW5zaWduZWQgbG9uZyBrdm1fYXJtX251bV9y
ZWdzKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkKIHsKLQlyZXR1cm4gbnVtX2NvcmVfcmVncygpICsg
a3ZtX2FybV9udW1fc3lzX3JlZ19kZXNjcyh2Y3B1KQotCQkrIGt2bV9hcm1fZ2V0X2Z3X251bV9y
ZWdzKHZjcHUpCSsgTlVNX1RJTUVSX1JFR1M7CisJdW5zaWduZWQgbG9uZyByZXMgPSAwOworCisJ
cmVzICs9IG51bV9jb3JlX3JlZ3MoKTsKKwlyZXMgKz0ga3ZtX2FybV9udW1fc3lzX3JlZ19kZXNj
cyh2Y3B1KTsKKwlyZXMgKz0ga3ZtX2FybV9nZXRfZndfbnVtX3JlZ3ModmNwdSk7CisJcmVzICs9
IE5VTV9USU1FUl9SRUdTOworCisJcmV0dXJuIHJlczsKIH0KIAogLyoqCi0tIAoyLjIwLjEKCl9f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWls
aW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNv
bHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
