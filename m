Return-Path: <SRS0=u4Cy=NQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D838C4338F
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 16:20:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 14AB361153
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 16:20:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 14AB361153
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BDF274B29B;
	Wed, 25 Aug 2021 12:20:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VGHV0PrUX95S; Wed, 25 Aug 2021 12:20:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C5D74B2E0;
	Wed, 25 Aug 2021 12:19:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 333834B2F8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 12:19:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IoBBFocEXHBI for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Aug 2021 12:18:55 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AD4C4B2A3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 12:18:12 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 183DC14BF;
 Wed, 25 Aug 2021 09:18:12 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BDAE53F66F;
 Wed, 25 Aug 2021 09:18:10 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v4 37/39] KVM: arm64: Add PMSIDR_EL1 to the SPE register
 context
Date: Wed, 25 Aug 2021 17:18:13 +0100
Message-Id: <20210825161815.266051-38-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210825161815.266051-1-alexandru.elisei@arm.com>
References: <20210825161815.266051-1-alexandru.elisei@arm.com>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

PMSIDR_EL1 is not part of the VCPU register context because the profiling
control registers were not trapped and the register is read-only. With the
introduction of the KVM_ARM_VCPU_SPE_STOP API, KVM will start trapping
accesses to the profiling control registers, add PMSIDR_EL1 to the VCPU
register context to prevent undefined exceptions in the guest.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/sys_regs.c         | 22 +++++++++++++++++++---
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index cc46f1406196..f866c4556ff9 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -247,6 +247,7 @@ enum vcpu_sysreg {
 	PMSFCR_EL1,     /* Sampling Filter Control Register */
 	PMSEVFR_EL1,    /* Sampling Event Filter Register */
 	PMSLATFR_EL1,   /* Sampling Latency Filter Register */
+	PMSIDR_EL1,	/* Sampling Profiling ID Register */
 	PMBLIMITR_EL1,  /* Profiling Buffer Limit Address Register */
 	PMBPTR_EL1,     /* Profiling Buffer Write Pointer Register */
 	PMBSR_EL1,      /* Profiling Buffer Status/syndrome Register */
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index cc711b081f31..1a85a0cedbec 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -603,6 +603,18 @@ static unsigned int spe_visibility(const struct kvm_vcpu *vcpu,
 	return REG_HIDDEN;
 }
 
+static void reset_pmsidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	/*
+	 * When SPE is stopped by userspace, the guest reads the in-memory value
+	 * of the register. When SPE is resumed, accesses to the control
+	 * registers are not trapped and the guest reads the hardware
+	 * value. Reset PMSIDR_EL1 to the hardware value to avoid mistmatches
+	 * between the two.
+	 */
+	vcpu_write_sys_reg(vcpu, read_sysreg_s(SYS_PMSIDR_EL1), PMSIDR_EL1);
+}
+
 static bool access_spe_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			   const struct sys_reg_desc *r)
 {	int reg = r->reg;
@@ -613,10 +625,14 @@ static bool access_spe_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 				  *vcpu_pc(vcpu), *vcpu_cpsr(vcpu));
 	}
 
-	if (p->is_write)
+	if (p->is_write) {
+		if (reg == PMSIDR_EL1)
+			return write_to_read_only(vcpu, p, r);
+
 		kvm_spe_write_sysreg(vcpu, reg, val);
-	else
+	} else {
 		p->regval = kvm_spe_read_sysreg(vcpu, reg);
+	}
 
 	return true;
 }
@@ -1568,7 +1584,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SPE_SYS_REG(SYS_PMSFCR_EL1), .reg = PMSFCR_EL1 },
 	{ SPE_SYS_REG(SYS_PMSEVFR_EL1), .reg = PMSEVFR_EL1 },
 	{ SPE_SYS_REG(SYS_PMSLATFR_EL1), .reg = PMSLATFR_EL1 },
-	{ SPE_SYS_REG(SYS_PMSIDR_EL1), .reset = NULL },
+	{ SPE_SYS_REG(SYS_PMSIDR_EL1), .reset = reset_pmsidr, .reg = PMSIDR_EL1 },
 	{ SPE_SYS_REG(SYS_PMBLIMITR_EL1), .reg = PMBLIMITR_EL1 },
 	{ SPE_SYS_REG(SYS_PMBPTR_EL1), .reg = PMBPTR_EL1 },
 	{ SPE_SYS_REG(SYS_PMBSR_EL1), .reg = PMBSR_EL1 },
-- 
2.33.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
