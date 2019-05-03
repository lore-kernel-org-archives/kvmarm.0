Return-Path: <SRS0=WQmE=TD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BCDEC04AAA
	for <kvmarm@archiver.kernel.org>; Fri,  3 May 2019 12:45:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D196B2089E
	for <kvmarm@archiver.kernel.org>; Fri,  3 May 2019 12:45:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D196B2089E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 895A44A4CE;
	Fri,  3 May 2019 08:45:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3By5qnkGx6HV; Fri,  3 May 2019 08:45:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 504234A505;
	Fri,  3 May 2019 08:45:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EFDD84A4F8
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 May 2019 08:45:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HnxIbdOxvJFM for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 May 2019 08:45:15 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BABE14A4CE
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 May 2019 08:45:14 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 63E3C1684;
 Fri,  3 May 2019 05:45:14 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com
 (filthy-habits.cambridge.arm.com [10.1.197.61])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2CD753F220;
 Fri,  3 May 2019 05:45:11 -0700 (PDT)
From: Marc Zyngier <marc.zyngier@arm.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 09/56] KVM: arm64: Add a vcpu flag to control SVE visibility
 for the guest
Date: Fri,  3 May 2019 13:43:40 +0100
Message-Id: <20190503124427.190206-10-marc.zyngier@arm.com>
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

RnJvbTogRGF2ZSBNYXJ0aW4gPERhdmUuTWFydGluQGFybS5jb20+CgpTaW5jZSBTVkUgd2lsbCBi
ZSBlbmFibGVkIG9yIGRpc2FibGVkIG9uIGEgcGVyLXZjcHUgYmFzaXMsIGEgZmxhZwppcyBuZWVk
ZWQgaW4gb3JkZXIgdG8gdHJhY2sgd2hpY2ggdmNwdXMgaGF2ZSBpdCBlbmFibGVkLgoKVGhpcyBw
YXRjaCBhZGRzIGEgc3VpdGFibGUgZmxhZyBhbmQgYSBoZWxwZXIgZm9yIGNoZWNraW5nIGl0LgoK
U2lnbmVkLW9mZi1ieTogRGF2ZSBNYXJ0aW4gPERhdmUuTWFydGluQGFybS5jb20+ClJldmlld2Vk
LWJ5OiBBbGV4IEJlbm7DqWUgPGFsZXguYmVubmVlQGxpbmFyby5vcmc+ClRlc3RlZC1ieTogemhh
bmcubGVpIDx6aGFuZy5sZWlAanAuZnVqaXRzdS5jb20+ClNpZ25lZC1vZmYtYnk6IE1hcmMgWnlu
Z2llciA8bWFyYy56eW5naWVyQGFybS5jb20+Ci0tLQogYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9r
dm1faG9zdC5oIHwgNCArKysrCiAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspCgpkaWZm
IC0tZ2l0IGEvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1faG9zdC5oIGIvYXJjaC9hcm02NC9p
bmNsdWRlL2FzbS9rdm1faG9zdC5oCmluZGV4IDZkMTAxMDBmZjg3MC4uYWQ0ZjdmMDA0NDk4IDEw
MDY0NAotLS0gYS9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmgKKysrIGIvYXJjaC9h
cm02NC9pbmNsdWRlL2FzbS9rdm1faG9zdC5oCkBAIC0zMjgsNiArMzI4LDEwIEBAIHN0cnVjdCBr
dm1fdmNwdV9hcmNoIHsKICNkZWZpbmUgS1ZNX0FSTTY0X0ZQX0hPU1QJCSgxIDw8IDIpIC8qIGhv
c3QgRlAgcmVncyBsb2FkZWQgKi8KICNkZWZpbmUgS1ZNX0FSTTY0X0hPU1RfU1ZFX0lOX1VTRQko
MSA8PCAzKSAvKiBiYWNrdXAgZm9yIGhvc3QgVElGX1NWRSAqLwogI2RlZmluZSBLVk1fQVJNNjRf
SE9TVF9TVkVfRU5BQkxFRAkoMSA8PCA0KSAvKiBTVkUgZW5hYmxlZCBmb3IgRUwwICovCisjZGVm
aW5lIEtWTV9BUk02NF9HVUVTVF9IQVNfU1ZFCQkoMSA8PCA1KSAvKiBTVkUgZXhwb3NlZCB0byBn
dWVzdCAqLworCisjZGVmaW5lIHZjcHVfaGFzX3N2ZSh2Y3B1KSAoc3lzdGVtX3N1cHBvcnRzX3N2
ZSgpICYmIFwKKwkJCSAgICAoKHZjcHUpLT5hcmNoLmZsYWdzICYgS1ZNX0FSTTY0X0dVRVNUX0hB
U19TVkUpKQogCiAjZGVmaW5lIHZjcHVfZ3BfcmVncyh2KQkJKCYodiktPmFyY2guY3R4dC5ncF9y
ZWdzKQogCi0tIAoyLjIwLjEKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVk
dQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
