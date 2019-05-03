Return-Path: <SRS0=WQmE=TD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA254C43219
	for <kvmarm@archiver.kernel.org>; Fri,  3 May 2019 12:48:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A2A212081C
	for <kvmarm@archiver.kernel.org>; Fri,  3 May 2019 12:48:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A2A212081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F7CC4A5AD;
	Fri,  3 May 2019 08:48:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Qwru52Jp-yOS; Fri,  3 May 2019 08:48:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A2104A5A1;
	Fri,  3 May 2019 08:48:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA7384A517
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 May 2019 08:48:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BlLAUZOLB-NC for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 May 2019 08:47:59 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9691C4A5A5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 May 2019 08:47:59 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3C7071684;
 Fri,  3 May 2019 05:47:59 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com
 (filthy-habits.cambridge.arm.com [10.1.197.61])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 045BC3F220;
 Fri,  3 May 2019 05:47:55 -0700 (PDT)
From: Marc Zyngier <marc.zyngier@arm.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 56/56] KVM: arm64: Fix ptrauth ID register masking logic
Date: Fri,  3 May 2019 13:44:27 +0100
Message-Id: <20190503124427.190206-57-marc.zyngier@arm.com>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

From: Kristina Martsenko <kristina.martsenko@arm.com>

When a VCPU doesn't have pointer auth, we want to hide all four pointer
auth ID register fields from the guest, not just one of them.

Fixes: 384b40caa8af ("KVM: arm/arm64: Context-switch ptrauth registers")
Reported-by: Andrew Murray <andrew.murray@arm.com>
Fscked-up-by: Marc Zyngier <marc.zyngier@arm.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Tested-by: Andrew Murray <andrew.murray@arm.com>
Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 9d02643bc601..857b226bcdde 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1088,10 +1088,10 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 	if (id == SYS_ID_AA64PFR0_EL1 && !vcpu_has_sve(vcpu)) {
 		val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
 	} else if (id == SYS_ID_AA64ISAR1_EL1 && !vcpu_has_ptrauth(vcpu)) {
-		val &= ~(0xfUL << ID_AA64ISAR1_APA_SHIFT) |
-			(0xfUL << ID_AA64ISAR1_API_SHIFT) |
-			(0xfUL << ID_AA64ISAR1_GPA_SHIFT) |
-			(0xfUL << ID_AA64ISAR1_GPI_SHIFT);
+		val &= ~((0xfUL << ID_AA64ISAR1_APA_SHIFT) |
+			 (0xfUL << ID_AA64ISAR1_API_SHIFT) |
+			 (0xfUL << ID_AA64ISAR1_GPA_SHIFT) |
+			 (0xfUL << ID_AA64ISAR1_GPI_SHIFT));
 	}
 
 	return val;
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
