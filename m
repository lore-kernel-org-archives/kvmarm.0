Return-Path: <SRS0=qFti=EC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AE3FC55178
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 17:26:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 24F2621D42
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 17:26:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 24F2621D42
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD31B4B54E;
	Tue, 27 Oct 2020 13:26:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EDekxhX5v+E2; Tue, 27 Oct 2020 13:26:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B40994B567;
	Tue, 27 Oct 2020 13:26:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2001B4B354
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 13:26:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5gFUPvCsEzoQ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Oct 2020 13:26:31 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B6804B55A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 13:26:29 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2F387139F;
 Tue, 27 Oct 2020 10:26:29 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 265E53F719;
 Tue, 27 Oct 2020 10:26:28 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH v3 11/16] KVM: arm64: Add SPE system registers to VCPU
 context
Date: Tue, 27 Oct 2020 17:27:00 +0000
Message-Id: <20201027172705.15181-12-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027172705.15181-1-alexandru.elisei@arm.com>
References: <20201027172705.15181-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Cc: maz@kernel.org, will@kernel.org
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

Add the SPE system registers to the VCPU context. Omitted are PMBIDR_EL1,
which cannot be trapped, and PMSIR_EL1, which is a read-only register. The
registers are simply stored in the sys_regs array on a write, and returned
on a read; complete emulation and save/restore on world switch will be
added in a future patch.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_host.h | 11 +++++++
 arch/arm64/kvm/spe.c              | 10 +++++++
 arch/arm64/kvm/sys_regs.c         | 48 ++++++++++++++++++++++++-------
 include/kvm/arm_spe.h             |  9 ++++++
 4 files changed, 68 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 27f581750c6e..bcecc6224c59 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -194,6 +194,17 @@ enum vcpu_sysreg {
 	CNTP_CVAL_EL0,
 	CNTP_CTL_EL0,
 
+	/* Statistical Profiling Extension Registers. */
+	PMSCR_EL1,	/* Statistical Profiling Control Register */
+	PMSICR_EL1,	/* Sampling Interval Counter Register */
+	PMSIRR_EL1,	/* Sampling Interval Reload Register */
+	PMSFCR_EL1,	/* Sampling Filter Control Register */
+	PMSEVFR_EL1,	/* Sampling Event Filter Register */
+	PMSLATFR_EL1,	/* Sampling Latency Filter Register */
+	PMBLIMITR_EL1,	/* Profiling Buffer Limit Address Register */
+	PMBPTR_EL1,	/* Profiling Buffer Write Pointer Register */
+	PMBSR_EL1,	/* Profiling Buffer Status/syndrome Register */
+
 	/* 32bit specific registers. Keep them at the end of the range */
 	DACR32_EL2,	/* Domain Access Control Register */
 	IFSR32_EL2,	/* Instruction Fault Status Register */
diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
index 316ff8dfed5b..0e365a51cac7 100644
--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ -12,6 +12,16 @@
 
 #include <asm/kvm_mmu.h>
 
+void kvm_arm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val)
+{
+	__vcpu_sys_reg(vcpu, reg) = val;
+}
+
+u64 kvm_arm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg)
+{
+	return __vcpu_sys_reg(vcpu, reg);
+}
+
 void kvm_arm_spe_notify_vcpu_init(struct kvm_vcpu *vcpu)
 {
 	vcpu->kvm->arch.spe.finalized = false;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index aa776c006a2a..2871484993ec 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -244,9 +244,37 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static bool access_spe_reg(struct kvm_vcpu *vcpu,
+			   struct sys_reg_params *p,
+			   const struct sys_reg_desc *r)
+{
+	u64 val = p->regval;
+	int reg = r->reg;
+	u32 sr = sys_reg((u32)r->Op0, (u32)r->Op1,
+			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
+
+	if (sr == SYS_PMSIDR_EL1) {
+		/* Ignore writes. */
+		if (!p->is_write)
+			p->regval = read_sysreg_s(SYS_PMSIDR_EL1);
+		goto out;
+	}
+
+	if (p->is_write)
+		kvm_arm_spe_write_sysreg(vcpu, reg, val);
+	else
+		p->regval = kvm_arm_spe_read_sysreg(vcpu, reg);
+
+out:
+	return true;
+}
+
 static unsigned int spe_visibility(const struct kvm_vcpu *vcpu,
 				   const struct sys_reg_desc *r)
 {
+	if (vcpu_has_spe(vcpu))
+		return 0;
+
 	return REG_HIDDEN_GUEST | REG_HIDDEN_USER;
 }
 
@@ -1598,16 +1626,16 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_FAR_EL1), access_vm_reg, reset_unknown, FAR_EL1 },
 	{ SYS_DESC(SYS_PAR_EL1), NULL, reset_unknown, PAR_EL1 },
 
-	{ SYS_DESC(SYS_PMSCR_EL1), .visibility = spe_visibility },
-	{ SYS_DESC(SYS_PMSICR_EL1), .visibility = spe_visibility },
-	{ SYS_DESC(SYS_PMSIRR_EL1), .visibility = spe_visibility },
-	{ SYS_DESC(SYS_PMSFCR_EL1), .visibility = spe_visibility },
-	{ SYS_DESC(SYS_PMSEVFR_EL1), .visibility = spe_visibility },
-	{ SYS_DESC(SYS_PMSLATFR_EL1), .visibility = spe_visibility },
-	{ SYS_DESC(SYS_PMSIDR_EL1), .visibility = spe_visibility },
-	{ SYS_DESC(SYS_PMBLIMITR_EL1), .visibility = spe_visibility },
-	{ SYS_DESC(SYS_PMBPTR_EL1), .visibility = spe_visibility },
-	{ SYS_DESC(SYS_PMBSR_EL1), .visibility = spe_visibility },
+	{ SYS_DESC(SYS_PMSCR_EL1), access_spe_reg, reset_val, PMSCR_EL1, 0, .visibility = spe_visibility },
+	{ SYS_DESC(SYS_PMSICR_EL1), access_spe_reg, reset_val, PMSICR_EL1, 0, .visibility = spe_visibility },
+	{ SYS_DESC(SYS_PMSIRR_EL1), access_spe_reg, reset_val, PMSIRR_EL1, 0, .visibility = spe_visibility },
+	{ SYS_DESC(SYS_PMSFCR_EL1), access_spe_reg, reset_val, PMSFCR_EL1, 0, .visibility = spe_visibility },
+	{ SYS_DESC(SYS_PMSEVFR_EL1), access_spe_reg, reset_val, PMSEVFR_EL1, 0, .visibility = spe_visibility },
+	{ SYS_DESC(SYS_PMSLATFR_EL1), access_spe_reg, reset_val, PMSEVFR_EL1, 0, .visibility = spe_visibility },
+	{ SYS_DESC(SYS_PMSIDR_EL1), access_spe_reg, .visibility = spe_visibility },
+	{ SYS_DESC(SYS_PMBLIMITR_EL1), access_spe_reg, reset_val, PMBLIMITR_EL1, 0, .visibility = spe_visibility },
+	{ SYS_DESC(SYS_PMBPTR_EL1), access_spe_reg, reset_unknown, PMBPTR_EL1, .visibility = spe_visibility },
+	{ SYS_DESC(SYS_PMBSR_EL1), access_spe_reg, reset_val, PMBSR_EL1, 0, .visibility = spe_visibility },
 
 	{ SYS_DESC(SYS_PMINTENSET_EL1), access_pminten, reset_unknown, PMINTENSET_EL1 },
 	{ SYS_DESC(SYS_PMINTENCLR_EL1), access_pminten, reset_unknown, PMINTENSET_EL1 },
diff --git a/include/kvm/arm_spe.h b/include/kvm/arm_spe.h
index 7f9f3a03aadb..a2429edc4483 100644
--- a/include/kvm/arm_spe.h
+++ b/include/kvm/arm_spe.h
@@ -38,6 +38,9 @@ int kvm_arm_vm_spe_has_attr(struct kvm *vcpu, struct kvm_device_attr *attr);
 
 void kvm_arm_spe_notify_vcpu_init(struct kvm_vcpu *vcpu);
 
+void kvm_arm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val);
+u64 kvm_arm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg);
+
 #else
 #define kvm_arm_supports_spe()	false
 
@@ -87,5 +90,11 @@ static inline int kvm_arm_vm_spe_has_attr(struct kvm *vcpu,
 
 static inline void kvm_arm_spe_notify_vcpu_init(struct kvm_vcpu *vcpu) {}
 
+static inline void kvm_arm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val) {}
+static inline u64 kvm_arm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg)
+{
+	return 0;
+}
+
 #endif /* CONFIG_KVM_ARM_SPE */
 #endif /* __ASM_ARM_KVM_SPE_H */
-- 
2.29.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
