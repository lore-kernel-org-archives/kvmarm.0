Return-Path: <SRS0=WQmE=TD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26B29C43219
	for <kvmarm@archiver.kernel.org>; Fri,  3 May 2019 12:46:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DAC252075E
	for <kvmarm@archiver.kernel.org>; Fri,  3 May 2019 12:46:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DAC252075E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 933D94A561;
	Fri,  3 May 2019 08:46:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EQohvGDUDGIt; Fri,  3 May 2019 08:46:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 517A14A50F;
	Fri,  3 May 2019 08:46:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 70D244A574
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 May 2019 08:46:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KHwDQAokIBZy for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 May 2019 08:46:14 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 69F9B4A4CB
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 May 2019 08:46:14 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2801D169E;
 Fri,  3 May 2019 05:46:14 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com
 (filthy-habits.cambridge.arm.com [10.1.197.61])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E53323F220;
 Fri,  3 May 2019 05:46:10 -0700 (PDT)
From: Marc Zyngier <marc.zyngier@arm.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 26/56] KVM: Document errors for KVM_GET_ONE_REG and
 KVM_SET_ONE_REG
Date: Fri,  3 May 2019 13:43:57 +0100
Message-Id: <20190503124427.190206-27-marc.zyngier@arm.com>
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

RnJvbTogRGF2ZSBNYXJ0aW4gPERhdmUuTWFydGluQGFybS5jb20+CgpLVk1fR0VUX09ORV9SRUcg
YW5kIEtWTV9TRVRfT05FX1JFRyByZXR1cm4gc29tZSBlcnJvciBjb2RlcyB0aGF0CmFyZSBub3Qg
ZG9jdW1lbnRlZCAoYnV0IGhvcGVmdWxseSBub3Qgc3VycHJpc2luZyBlaXRoZXIpLiAgVG8gZ2l2
ZQphbiBpbmRpY2F0aW9uIG9mIHdoYXQgdGhlc2UgbWF5IG1lYW4sIHRoaXMgcGF0Y2ggYWRkcyBi
cmllZgpkb2N1bWVudGF0aW9uLgoKU2lnbmVkLW9mZi1ieTogRGF2ZSBNYXJ0aW4gPERhdmUuTWFy
dGluQGFybS5jb20+ClNpZ25lZC1vZmYtYnk6IE1hcmMgWnluZ2llciA8bWFyYy56eW5naWVyQGFy
bS5jb20+Ci0tLQogRG9jdW1lbnRhdGlvbi92aXJ0dWFsL2t2bS9hcGkudHh0IHwgNiArKysrKysK
IDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9Eb2N1bWVudGF0
aW9uL3ZpcnR1YWwva3ZtL2FwaS50eHQgYi9Eb2N1bWVudGF0aW9uL3ZpcnR1YWwva3ZtL2FwaS50
eHQKaW5kZXggMmQ0ZjdjZTVlOTY3Li5jZDkyMGRkMTE5NWMgMTAwNjQ0Ci0tLSBhL0RvY3VtZW50
YXRpb24vdmlydHVhbC9rdm0vYXBpLnR4dAorKysgYi9Eb2N1bWVudGF0aW9uL3ZpcnR1YWwva3Zt
L2FwaS50eHQKQEAgLTE4NzEsNiArMTg3MSw5IEBAIEFyY2hpdGVjdHVyZXM6IGFsbAogVHlwZTog
dmNwdSBpb2N0bAogUGFyYW1ldGVyczogc3RydWN0IGt2bV9vbmVfcmVnIChpbikKIFJldHVybnM6
IDAgb24gc3VjY2VzcywgbmVnYXRpdmUgdmFsdWUgb24gZmFpbHVyZQorRXJyb3JzOgorIMKgRU5P
RU5UOiDCoMKgbm8gc3VjaCByZWdpc3RlcgorIMKgRUlOVkFMOiDCoMKgb3RoZXIgZXJyb3JzLCBz
dWNoIGFzIGJhZCBzaXplIGVuY29kaW5nIGZvciBhIGtub3duIHJlZ2lzdGVyCiAKIHN0cnVjdCBr
dm1fb25lX3JlZyB7CiAgICAgICAgX191NjQgaWQ7CkBAIC0yMTkyLDYgKzIxOTUsOSBAQCBBcmNo
aXRlY3R1cmVzOiBhbGwKIFR5cGU6IHZjcHUgaW9jdGwKIFBhcmFtZXRlcnM6IHN0cnVjdCBrdm1f
b25lX3JlZyAoaW4gYW5kIG91dCkKIFJldHVybnM6IDAgb24gc3VjY2VzcywgbmVnYXRpdmUgdmFs
dWUgb24gZmFpbHVyZQorRXJyb3JzOgorIMKgRU5PRU5UOiDCoMKgbm8gc3VjaCByZWdpc3Rlcgor
IMKgRUlOVkFMOiDCoMKgb3RoZXIgZXJyb3JzLCBzdWNoIGFzIGJhZCBzaXplIGVuY29kaW5nIGZv
ciBhIGtub3duIHJlZ2lzdGVyCiAKIFRoaXMgaW9jdGwgYWxsb3dzIHRvIHJlY2VpdmUgdGhlIHZh
bHVlIG9mIGEgc2luZ2xlIHJlZ2lzdGVyIGltcGxlbWVudGVkCiBpbiBhIHZjcHUuIFRoZSByZWdp
c3RlciB0byByZWFkIGlzIGluZGljYXRlZCBieSB0aGUgImlkIiBmaWVsZCBvZiB0aGUKLS0gCjIu
MjAuMQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3Zt
YXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlz
dHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
