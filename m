Return-Path: <SRS0=Vsle=TB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8D3FC43219
	for <kvmarm@archiver.kernel.org>; Wed,  1 May 2019 16:11:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 350D7208C3
	for <kvmarm@archiver.kernel.org>; Wed,  1 May 2019 16:11:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 350D7208C3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 80B564A4FC;
	Wed,  1 May 2019 12:11:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id H-qAHDDEZoLg; Wed,  1 May 2019 12:11:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A25E4A4F2;
	Wed,  1 May 2019 12:11:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 92DF04A4C5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 May 2019 12:11:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NzY08Wcy7yjT for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 May 2019 12:11:11 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B7474A380
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 May 2019 12:11:11 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AA7B4A78;
 Wed,  1 May 2019 09:11:10 -0700 (PDT)
Received: from moonbear.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 245663F719;
 Wed,  1 May 2019 09:11:07 -0700 (PDT)
From: Kristina Martsenko <kristina.martsenko@arm.com>
To: Marc Zyngier <marc.zyngier@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH] KVM: arm64: fix ptrauth ID register masking logic
Date: Wed,  1 May 2019 17:10:08 +0100
Message-Id: <20190501161008.31498-1-kristina.martsenko@arm.com>
X-Mailer: git-send-email 2.11.0
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu,
 Amit Kachhap <amit.kachhap@arm.com>, Dave P Martin <dave.martin@arm.com>,
 linux-arm-kernel@lists.infradead.org
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
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190501161008.pnHrYXJIv3UuPc3fSkPjzgUn8Lr1DQCNVjJBkMzaCOs@z>

When a VCPU doesn't have pointer auth, we want to hide all four pointer
auth ID register fields from the guest, not just one of them.

Fixes: 384b40caa8af ("KVM: arm/arm64: Context-switch ptrauth registers")
Reported-by: Andrew Murray <andrew.murray@arm.com>
Fsck-up-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
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
2.11.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
