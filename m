Return-Path: <SRS0=Jx+E=QE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E064C433FE
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 15:38:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2EBAD61A79
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 15:38:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2EBAD61A79
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D67344B1E1;
	Wed, 17 Nov 2021 10:38:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MpjQUppIdvcL; Wed, 17 Nov 2021 10:38:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A65354B1FB;
	Wed, 17 Nov 2021 10:38:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ACD184B1BD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 10:38:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xjTBuYOXxcRc for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Nov 2021 10:38:10 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A569A4B187
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 10:38:08 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 64D051FB;
 Wed, 17 Nov 2021 07:38:08 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1065A3F5A1;
 Wed, 17 Nov 2021 07:38:06 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, mark.rutland@arm.com
Subject: [RFC PATCH v5 36/38] KVM: arm64: Add PMSIDR_EL1 to the SPE register
 context
Date: Wed, 17 Nov 2021 15:38:40 +0000
Message-Id: <20211117153842.302159-37-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211117153842.302159-1-alexandru.elisei@arm.com>
References: <20211117153842.302159-1-alexandru.elisei@arm.com>
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
register context to prevent KVM injecting undefined exceptions.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/sys_regs.c         | 22 +++++++++++++++++++---
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 102e1c087798..95306ca8f1bc 100644
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
index be8801f87567..132bd6da84e2 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -599,6 +599,18 @@ static unsigned int spe_visibility(const struct kvm_vcpu *vcpu,
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
@@ -609,10 +621,14 @@ static bool access_spe_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
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
@@ -1620,7 +1636,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SPE_SYS_REG(SYS_PMSFCR_EL1), .reg = PMSFCR_EL1 },
 	{ SPE_SYS_REG(SYS_PMSEVFR_EL1), .reg = PMSEVFR_EL1 },
 	{ SPE_SYS_REG(SYS_PMSLATFR_EL1), .reg = PMSLATFR_EL1 },
-	{ SPE_SYS_REG(SYS_PMSIDR_EL1), .reset = NULL },
+	{ SPE_SYS_REG(SYS_PMSIDR_EL1), .reset = reset_pmsidr, .reg = PMSIDR_EL1 },
 	{ SPE_SYS_REG(SYS_PMBLIMITR_EL1), .reg = PMBLIMITR_EL1 },
 	{ SPE_SYS_REG(SYS_PMBPTR_EL1), .reg = PMBPTR_EL1 },
 	{ SPE_SYS_REG(SYS_PMBSR_EL1), .reg = PMBSR_EL1 },
-- 
2.33.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
