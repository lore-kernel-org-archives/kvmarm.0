Return-Path: <SRS0=Jx+E=QE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61D74C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 15:38:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0B92B61AA3
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 15:38:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0B92B61AA3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ADC0C4B190;
	Wed, 17 Nov 2021 10:38:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oJ9uwBhqcB6p; Wed, 17 Nov 2021 10:38:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EE9844B1E7;
	Wed, 17 Nov 2021 10:38:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 131D34B1AC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 10:38:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P9X0Qf60v1mI for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Nov 2021 10:37:59 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AB6AA4B1A3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 10:37:58 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 76B0BED1;
 Wed, 17 Nov 2021 07:37:58 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CFDBF3F5A1;
 Wed, 17 Nov 2021 07:37:56 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, mark.rutland@arm.com
Subject: [RFC PATCH v5 31/38] KVM: arm64: Save/restore PMSNEVFR_EL1 on VCPU
 put/load
Date: Wed, 17 Nov 2021 15:38:35 +0000
Message-Id: <20211117153842.302159-32-alexandru.elisei@arm.com>
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

FEAT_SPEv1p2 introduced a new register, PMSNEVFR_EL1. The SPE driver is not
using the register, so save the register to the guest context on vcpu_put()
and restore it on vcpu_load() since it will not be touched by the host, and
the value programmed by the guest doesn't affect the host.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/include/asm/kvm_spe.h  |  6 ++++++
 arch/arm64/include/asm/sysreg.h   |  1 +
 arch/arm64/kvm/arm.c              |  2 ++
 arch/arm64/kvm/spe.c              | 29 +++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c         |  1 +
 6 files changed, 40 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 082994f5fb0e..3eef642d7bba 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -239,6 +239,7 @@ enum vcpu_sysreg {
 
        /* Statistical Profiling Extension Registers. */
 	PMSCR_EL1,      /* Statistical Profiling Control Register */
+	PMSNEVFR_EL1,   /* Sampling Inverted Event Filter Register */
 	PMSICR_EL1,     /* Sampling Interval Counter Register */
 	PMSIRR_EL1,     /* Sampling Interval Reload Register */
 	PMSFCR_EL1,     /* Sampling Filter Control Register */
diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
index 7c2d5695120a..ce92d5f1db19 100644
--- a/arch/arm64/include/asm/kvm_spe.h
+++ b/arch/arm64/include/asm/kvm_spe.h
@@ -27,6 +27,9 @@ int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu);
 void kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val);
 u64 kvm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg);
 
+void kvm_spe_vcpu_load(struct kvm_vcpu *vcpu);
+void kvm_spe_vcpu_put(struct kvm_vcpu *vcpu);
+
 int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 int kvm_spe_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 int kvm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
@@ -50,6 +53,9 @@ static inline int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 static inline void kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val) {}
 static inline u64 kvm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg) { return 0; }
 
+static inline void kvm_spe_vcpu_load(struct kvm_vcpu *vcpu) {}
+static inline void kvm_spe_vcpu_put(struct kvm_vcpu *vcpu) {}
+
 static inline int kvm_spe_set_attr(struct kvm_vcpu *vcpu,
 				   struct kvm_device_attr *attr)
 {
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index e8201aef165d..36c3185663ff 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -943,6 +943,7 @@
 
 #define ID_AA64DFR0_PMSVER_8_2		0x1
 #define ID_AA64DFR0_PMSVER_8_3		0x2
+#define ID_AA64DFR0_PMSVER_8_7		0x3
 
 #define ID_DFR0_PERFMON_SHIFT		24
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 5270f3b9886c..a4f17f7bf943 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -460,6 +460,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	if (vcpu_has_ptrauth(vcpu))
 		vcpu_ptrauth_disable(vcpu);
 	kvm_arch_vcpu_load_debug_state_flags(vcpu);
+	kvm_spe_vcpu_load(vcpu);
 
 	if (!cpumask_empty(vcpu->arch.supported_cpus) &&
 	    !cpumask_test_cpu(smp_processor_id(), vcpu->arch.supported_cpus))
@@ -468,6 +469,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
+	kvm_spe_vcpu_put(vcpu);
 	kvm_arch_vcpu_put_debug_state_flags(vcpu);
 	kvm_arch_vcpu_put_fp(vcpu);
 	if (has_vhe())
diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
index e8a8aa7f10b9..9c0567dadff1 100644
--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ -66,6 +66,35 @@ u64 kvm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg)
 	return __vcpu_sys_reg(vcpu, reg);
 }
 
+static unsigned int kvm_spe_get_pmsver(void)
+{
+	u64 dfr0 = read_sysreg(id_aa64dfr0_el1);
+
+	return cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_PMSVER_SHIFT);
+}
+
+void kvm_spe_vcpu_load(struct kvm_vcpu *vcpu)
+{
+	if (!kvm_vcpu_has_spe(vcpu))
+		return;
+
+	if (kvm_spe_get_pmsver() < ID_AA64DFR0_PMSVER_8_7)
+		return;
+
+	write_sysreg_s(__vcpu_sys_reg(vcpu, PMSNEVFR_EL1), SYS_PMSNEVFR_EL1);
+}
+
+void kvm_spe_vcpu_put(struct kvm_vcpu *vcpu)
+{
+	if (!kvm_vcpu_has_spe(vcpu))
+		return;
+
+	if (kvm_spe_get_pmsver() < ID_AA64DFR0_PMSVER_8_7)
+		return;
+
+	__vcpu_sys_reg(vcpu, PMSNEVFR_EL1) = read_sysreg_s(SYS_PMSNEVFR_EL1);
+}
+
 static bool kvm_vcpu_supports_spe(struct kvm_vcpu *vcpu)
 {
 	if (!kvm_supports_spe())
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 2026eaebcc31..21b6b8bc1f25 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1614,6 +1614,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_PAR_EL1), NULL, reset_unknown, PAR_EL1 },
 
 	{ SPE_SYS_REG(SYS_PMSCR_EL1), .reg = PMSCR_EL1 },
+	{ SPE_SYS_REG(SYS_PMSNEVFR_EL1), .reg = PMSNEVFR_EL1 },
 	{ SPE_SYS_REG(SYS_PMSICR_EL1), .reg = PMSICR_EL1 },
 	{ SPE_SYS_REG(SYS_PMSIRR_EL1), .reg = PMSIRR_EL1 },
 	{ SPE_SYS_REG(SYS_PMSFCR_EL1), .reg = PMSFCR_EL1 },
-- 
2.33.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
