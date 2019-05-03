Return-Path: <SRS0=WQmE=TD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9A8DC004C9
	for <kvmarm@archiver.kernel.org>; Fri,  3 May 2019 12:44:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 898662075E
	for <kvmarm@archiver.kernel.org>; Fri,  3 May 2019 12:44:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 898662075E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4141B4A4FE;
	Fri,  3 May 2019 08:44:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kIhCQallb8Vx; Fri,  3 May 2019 08:44:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 846B84A503;
	Fri,  3 May 2019 08:44:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E66644A4BD
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 May 2019 08:44:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wD3AbZ2fqS+C for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 May 2019 08:44:53 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A780D4A4C5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 May 2019 08:44:53 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 51D3580D;
 Fri,  3 May 2019 05:44:53 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com
 (filthy-habits.cambridge.arm.com [10.1.197.61])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1B1493F220;
 Fri,  3 May 2019 05:44:49 -0700 (PDT)
From: Marc Zyngier <marc.zyngier@arm.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 03/56] KVM: arm64: Delete orphaned declaration for
 __fpsimd_enabled()
Date: Fri,  3 May 2019 13:43:34 +0100
Message-Id: <20190503124427.190206-4-marc.zyngier@arm.com>
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

RnJvbTogRGF2ZSBNYXJ0aW4gPERhdmUuTWFydGluQGFybS5jb20+CgpfX2Zwc2ltZF9lbmFibGVk
KCkgbm8gbG9uZ2VyIGV4aXN0cywgYnV0IGEgZGFuZ2xpbmcgZGVjbGFyYXRpb24gaGFzCnN1cnZp
dmVkIGluIGt2bV9oeXAuaC4KClRoaXMgcGF0Y2ggZ2V0cyByaWQgb2YgaXQuCgpTaWduZWQtb2Zm
LWJ5OiBEYXZlIE1hcnRpbiA8RGF2ZS5NYXJ0aW5AYXJtLmNvbT4KUmV2aWV3ZWQtYnk6IEFsZXgg
QmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4KVGVzdGVkLWJ5OiB6aGFuZy5sZWkgPHpo
YW5nLmxlaUBqcC5mdWppdHN1LmNvbT4KU2lnbmVkLW9mZi1ieTogTWFyYyBaeW5naWVyIDxtYXJj
Lnp5bmdpZXJAYXJtLmNvbT4KLS0tCiBhcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9oeXAuaCB8
IDEgLQogMSBmaWxlIGNoYW5nZWQsIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9hcmNoL2Fy
bTY0L2luY2x1ZGUvYXNtL2t2bV9oeXAuaCBiL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2h5
cC5oCmluZGV4IDRkYTc2NWYyY2NhNS4uZWY4YjgzOTRkM2QxIDEwMDY0NAotLS0gYS9hcmNoL2Fy
bTY0L2luY2x1ZGUvYXNtL2t2bV9oeXAuaAorKysgYi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2
bV9oeXAuaApAQCAtMTQ5LDcgKzE0OSw2IEBAIHZvaWQgX19kZWJ1Z19zd2l0Y2hfdG9faG9zdChz
dHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpOwogCiB2b2lkIF9fZnBzaW1kX3NhdmVfc3RhdGUoc3RydWN0
IHVzZXJfZnBzaW1kX3N0YXRlICpmcF9yZWdzKTsKIHZvaWQgX19mcHNpbWRfcmVzdG9yZV9zdGF0
ZShzdHJ1Y3QgdXNlcl9mcHNpbWRfc3RhdGUgKmZwX3JlZ3MpOwotYm9vbCBfX2Zwc2ltZF9lbmFi
bGVkKHZvaWQpOwogCiB2b2lkIGFjdGl2YXRlX3RyYXBzX3ZoZV9sb2FkKHN0cnVjdCBrdm1fdmNw
dSAqdmNwdSk7CiB2b2lkIGRlYWN0aXZhdGVfdHJhcHNfdmhlX3B1dCh2b2lkKTsKLS0gCjIuMjAu
MQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJt
IG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMu
Y3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
