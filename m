Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACAFB4D90C5
	for <kvmarm@lists.linux.dev>; Thu,  3 Sep 2026 16:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788451637; cv=none; b=pw/0Ez3yGrYIHSyh/RtYb/pLPzneGsMpGhL6OVJ8EzB+jktQdJ8Pkn/HHb7IFSumf1xmDzLqNh6nMOzebyeBaJF27SEbgSipuzYqNuKsqGuN8Z3xRx3LOwsPSwAJvuLCI3t4uNLZUnyGcEl0Pkc3Iu67ml0lIJcgNFB1G4vCO5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788451637; c=relaxed/simple;
	bh=Cmn6iv3SMU7S8944+qV17OTrWO5xivJ/UGViCesseJI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fm8M8oRYklBxnpIqoHGbjRYz/+AZ9n6/rBvnjYkPbOUFsR+mHulzWheo8kWFmzc8amaIKewA+UMnoWX6103lyBtUo78NBU2esdYdAOcOPq3KZz/L8cQu1wBTLOCMDaRgzLB/Xl+AE0yz/aocNgWnCwTJW/n98TfA44CrEZSrnPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=nakQJXZs; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="nakQJXZs"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6FBD01650;
	Thu,  3 Sep 2026 09:07:11 -0700 (PDT)
Received: from e140010.cambridge.arm.com (e140010.arm.com [10.2.213.25])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 68C773F673;
	Thu,  3 Sep 2026 09:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788451635; bh=Cmn6iv3SMU7S8944+qV17OTrWO5xivJ/UGViCesseJI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=nakQJXZsfQZzU8barIH5vIkAOIlQQvTKjw99Dp+AX7laBIGd42NRYKdMbvFDvJYwy
	 mkofBd85Lzcz/4rhN9wxce2tfcMcPIDPgDuR2fjaJLPK6FwCEtB0yNeAr6ARQ+MuUi
	 yNW2QouWiSLt7oneUOHqSegS8wP01HIsoQHqL+Oc=
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oupton@kernel.org,
	fuad.tabba@linux.dev,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	will@kernel.org,
	mark.rutland@arm.com,
	linux-perf-users@vger.kernel.org,
	catalin.marinas@arm.com,
	james.clark@linaro.org
Subject: [RFC PATCH v7 19/28] KVM: arm64: VHE: Context switch SPE state
Date: Thu,  3 Sep 2026 17:06:14 +0100
Message-ID: <20260903160623.315525-20-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260903160623.315525-1-alexandru.elisei@arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Save and restore the SPE register state when a VCPU is run. The SPE
resources are shared between the guest and the host (the resources are not
partitioned) so KVM has to save the host state, change the owning
translation regime, and then restore the guest state before entering a
guest. The sequence is performed in reverse when exiting a guest.

Somewhat unexpectedly, the owning regime is not modified in
kvm_arm_setup_mdcr_el2(), where MDCR_EL2 is written in the VHE case. That's
because after kvm_arm_setup_mdcr_el2() there is a window where the VCPU
runs with interrupts enabled, and during this window perf on the host might
install a new event on the physical CPU via an IPI. If the owning regime
were modified in kvm_arm_setup_mdcr_el2(), the buffer would use the guest
EL1 translation tables to write to memory, leading at best to buffer
management events due to faults, at worst to random memory corruption.

Note that now the host now stops profiling KVM in
__kvm_spe_save_host_state_vhe(), as opposed to when the guest starts
executing with PMSCR_EL1.{E1SPE,E0SPE} = {0,0} following the ERET to EL1.

Buffer management event interrupts will be handled later.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |   1 +
 arch/arm64/include/asm/kvm_hyp.h  |  26 +++-
 arch/arm64/include/asm/kvm_spe.h  |   4 +
 arch/arm64/kvm/arm.c              |   4 +-
 arch/arm64/kvm/hyp/vhe/Makefile   |   1 +
 arch/arm64/kvm/hyp/vhe/debug-sr.c |  18 +++
 arch/arm64/kvm/hyp/vhe/spe-sr.c   | 209 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/vhe/switch.c   |   9 ++
 arch/arm64/kvm/spe.c              |   9 ++
 9 files changed, 279 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/vhe/spe-sr.c

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index b92b19229c36..81abfb705aeb 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -796,6 +796,7 @@ struct kvm_host_data {
 		struct kvm_guest_debug_arch regs;
 		/* Statistical profiling extension */
 		u64 pmscr_el1;
+		u64 pmscr_el2;
 		u64 pmblimitr_el1;
 		/* Self-hosted trace */
 		u64 trfcr_el1;
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 4974492744cc..a98c0d445260 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -119,7 +119,31 @@ void __debug_switch_to_host(struct kvm_vcpu *vcpu);
 #ifdef __KVM_NVHE_HYPERVISOR__
 void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu);
 void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu);
-#endif
+#else
+#ifdef CONFIG_KVM_ARM_SPE
+void __kvm_spe_save_host_state_vhe(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt);
+void __kvm_spe_restore_guest_state_vhe(struct kvm_vcpu *vcpu, struct kvm_cpu_context *guest_ctxt);
+void __kvm_spe_save_guest_state_vhe(struct kvm_vcpu *vcpu, struct kvm_cpu_context *guest_ctxt);
+void __kvm_spe_restore_host_state_vhe(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt);
+#else
+static inline void __kvm_spe_save_host_state_vhe(struct kvm_vcpu *vcpu,
+						 struct kvm_cpu_context *host_ctxt)
+{
+}
+static inline void __kvm_spe_restore_guest_state_vhe(struct kvm_vcpu *vcpu,
+						     struct kvm_cpu_context *guest_ctxt)
+{
+}
+static inline void __kvm_spe_save_guest_state_vhe(struct kvm_vcpu *vcpu,
+						  struct kvm_cpu_context *guest_ctxt)
+{
+}
+static inline void __kvm_spe_restore_host_state_vhe(struct kvm_vcpu *vcpu,
+						    struct kvm_cpu_context *host_ctxt)
+{
+}
+#endif /* CONFIG_KVM_ARM_SPE */
+#endif /* __KVM_NVHE_HYPERVISOR__ */
 
 u64 __guest_enter(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
index 618051dcf59f..ad0ad6ace93c 100644
--- a/arch/arm64/include/asm/kvm_spe.h
+++ b/arch/arm64/include/asm/kvm_spe.h
@@ -30,6 +30,7 @@ bool kvm_supports_spe(void);
 bool kvm_vcpu_spe_initialized(struct kvm_vcpu *vcpu);
 
 int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu);
+void kvm_vcpu_put_spe_vhe(struct kvm_vcpu *vcpu);
 void kvm_spe_destroy_vm(struct kvm *kvm);
 
 void kvm_spe_finalize_idregs(struct kvm *kvm);
@@ -68,6 +69,9 @@ static inline int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 {
 	return 0;
 }
+static inline void kvm_vcpu_put_spe_vhe(struct kvm_vcpu *vcpu)
+{
+}
 static inline void kvm_spe_destroy_vm(struct kvm *kvm)
 {
 }
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index c9a026c61ce7..5992efc4f94b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -804,8 +804,10 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 
 	kvm_vcpu_put_debug(vcpu);
 	kvm_arch_vcpu_put_fp(vcpu);
-	if (has_vhe())
+	if (has_vhe()) {
+		kvm_vcpu_put_spe_vhe(vcpu);
 		kvm_vcpu_put_vhe(vcpu);
+	}
 	kvm_timer_vcpu_put(vcpu);
 	kvm_vgic_put(vcpu);
 	kvm_vcpu_pmu_restore_host(vcpu);
diff --git a/arch/arm64/kvm/hyp/vhe/Makefile b/arch/arm64/kvm/hyp/vhe/Makefile
index d6b3475145c0..e757d7a24212 100644
--- a/arch/arm64/kvm/hyp/vhe/Makefile
+++ b/arch/arm64/kvm/hyp/vhe/Makefile
@@ -11,3 +11,4 @@ CFLAGS_switch.o += -Wno-override-init
 obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o
 obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../hyp-entry.o ../exception.o ../vgic-v5-sr.o
+obj-$(CONFIG_KVM_ARM_SPE) += spe-sr.o
diff --git a/arch/arm64/kvm/hyp/vhe/debug-sr.c b/arch/arm64/kvm/hyp/vhe/debug-sr.c
index 0100339b09e0..7b03f2611259 100644
--- a/arch/arm64/kvm/hyp/vhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/debug-sr.c
@@ -13,9 +13,27 @@
 void __debug_switch_to_guest(struct kvm_vcpu *vcpu)
 {
 	__debug_switch_to_guest_common(vcpu);
+	if (vcpu_has_spe(vcpu)) {
+		u64 mdcr_el2 = vcpu->arch.mdcr_el2;
+
+		mdcr_el2 &= ~MDCR_EL2_E2PB;
+		/* Set buffer owner to EL1 and trap the buffer registers. */
+		mdcr_el2 |= FIELD_PREP(MDCR_EL2_E2PB, MDCR_EL2_E2PB_EL1_TRAP);
+
+		/* Do not trap sampling control registers. */
+		mdcr_el2 &= ~MDCR_EL2_TPMS;
+		write_sysreg(mdcr_el2, mdcr_el2);
+		/* Synchronise MDCR_EL2 and HCR_EL2 writes. */
+		isb();
+	}
 }
 
 void __debug_switch_to_host(struct kvm_vcpu *vcpu)
 {
+	if (vcpu_has_spe(vcpu)) {
+		write_sysreg(*host_data_ptr(host_debug_state.mdcr_el2), mdcr_el2);
+		/* Synchronise MDCR_EL2 and HCR_EL2 writes. */
+		isb();
+	}
 	__debug_switch_to_host_common(vcpu);
 }
diff --git a/arch/arm64/kvm/hyp/vhe/spe-sr.c b/arch/arm64/kvm/hyp/vhe/spe-sr.c
new file mode 100644
index 000000000000..978620ad99fa
--- /dev/null
+++ b/arch/arm64/kvm/hyp/vhe/spe-sr.c
@@ -0,0 +1,209 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2021 - ARM Ltd
+ */
+
+#include <linux/kvm_host.h>
+
+#include <asm/kvm_hyp.h>
+#include <asm/kprobes.h>
+#include <asm/kvm_spe.h>
+
+static void __kvm_spe_save_sampling_regs(struct kvm *kvm, struct kvm_cpu_context *ctxt)
+{
+	/*
+	 * This is dependent on the VM features, and not the hardware features,
+	 * even for the host, because (a) guest accesses to PMSNEVFR_EL1 and
+	 * PMSDSFR_EL1 result in an undefined exception in the guest and (b)
+	 * they don't affect the guest unless the guest explicitly enables them,
+	 * and a well-behaved guest shouldn't enable them when the corresponding
+	 * feature is not advertised.
+	 */
+	if (kvm_spe_has_feat_spe_fne(kvm))
+		ctxt_sys_reg(ctxt, PMSNEVFR_EL1) = read_sysreg_s(SYS_PMSNEVFR_EL1);
+	ctxt_sys_reg(ctxt, PMSICR_EL1) = read_sysreg_s(SYS_PMSICR_EL1);
+	ctxt_sys_reg(ctxt, PMSIRR_EL1) = read_sysreg_s(SYS_PMSIRR_EL1);
+	ctxt_sys_reg(ctxt, PMSFCR_EL1) = read_sysreg_s(SYS_PMSFCR_EL1);
+	ctxt_sys_reg(ctxt, PMSEVFR_EL1) = read_sysreg_s(SYS_PMSEVFR_EL1);
+	ctxt_sys_reg(ctxt, PMSLATFR_EL1) = read_sysreg_s(SYS_PMSLATFR_EL1);
+	if (kvm_spe_has_feat_spe_fds(kvm))
+		ctxt_sys_reg(ctxt, PMSDSFR_EL1) = read_sysreg_s(SYS_PMSDSFR_EL1);
+}
+
+static void __kvm_spe_restore_sampling_regs(struct kvm *kvm, struct kvm_cpu_context *ctxt)
+{
+	if (kvm_spe_has_feat_spe_fne(kvm))
+		write_sysreg_s(ctxt_sys_reg(ctxt, PMSNEVFR_EL1), SYS_PMSNEVFR_EL1);
+	write_sysreg_s(ctxt_sys_reg(ctxt, PMSICR_EL1), SYS_PMSICR_EL1);
+	write_sysreg_s(ctxt_sys_reg(ctxt, PMSIRR_EL1), SYS_PMSIRR_EL1);
+	write_sysreg_s(ctxt_sys_reg(ctxt, PMSFCR_EL1), SYS_PMSFCR_EL1);
+	write_sysreg_s(ctxt_sys_reg(ctxt, PMSEVFR_EL1), SYS_PMSEVFR_EL1);
+	write_sysreg_s(ctxt_sys_reg(ctxt, PMSLATFR_EL1), SYS_PMSLATFR_EL1);
+	if (kvm_spe_has_feat_spe_fds(kvm))
+		write_sysreg_s(ctxt_sys_reg(ctxt, PMSDSFR_EL1), SYS_PMSDSFR_EL1);
+}
+
+/*
+ * Before
+ *  - PMSCR_EL2.E2SPE = 0 or 1
+ *  - PMBLIMITR_EL1.E = 0 or 1
+ *  - PMBSR_EL1.S = 0 or 1
+ *
+ * After:
+ *  - PMSCR_EL2.E2SPE = 0
+ *  - PMBLIMITR_EL1.E = 0
+ *  - PMBSR_EL1.S = 0
+ */
+void __kvm_spe_save_host_state_vhe(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt)
+{
+	u64 pmblimitr, pmscr_el2, pmbsr;
+
+	pmscr_el2 = read_sysreg_el2(SYS_PMSCR);
+	if (FIELD_GET(PMSCR_EL1_E1SPE, pmscr_el2)) {
+		write_sysreg_el2(0, SYS_PMSCR);
+		isb();
+	}
+
+	pmblimitr = read_sysreg_s(SYS_PMBLIMITR_EL1);
+	if (FIELD_GET(PMBLIMITR_EL1_E, pmblimitr)) {
+		psb_csync();
+		dsb(nsh);
+		write_sysreg_s(0, SYS_PMBLIMITR_EL1);
+		/* Update PMBPTR_EL1 and PMBSR_EL1. */
+		isb();
+	}
+
+	pmbsr = read_sysreg_s(SYS_PMBSR_EL1);
+	if (FIELD_GET(PMBSR_EL1_S, pmbsr)) {
+		write_sysreg_s(0, SYS_PMBSR_EL1);
+		isb();
+	}
+
+	__kvm_spe_save_sampling_regs(vcpu->kvm, host_ctxt);
+
+	ctxt_sys_reg(host_ctxt, PMBLIMITR_EL1) = pmblimitr;
+	ctxt_sys_reg(host_ctxt, PMBPTR_EL1) = read_sysreg_s(SYS_PMBPTR_EL1);
+	ctxt_sys_reg(host_ctxt, PMBSR_EL1) = pmbsr;
+
+	*host_data_ptr(host_debug_state.pmscr_el2) = pmscr_el2;
+}
+NOKPROBE_SYMBOL(__kvm_spe_save_host_state_vhe);
+
+static bool __kvm_spe_profiling_buffer_enabled(u64 pmblimitr, u64 pmbsr)
+{
+	return FIELD_GET(PMBLIMITR_EL1_E, pmblimitr) && !FIELD_GET(PMBSR_EL1_S, pmbsr);
+}
+
+/*
+ * Before:
+ *  - PMSCR_EL2.E2PE = 0
+ *  - PMBLIMITR_EL1.E = 0
+ *  - PMBSR_EL1.S = 0
+ *
+ * After:
+ *  - PMSCR_EL2.E2SPE = 0
+ *  - PMBLIMITR_EL1.E = 0 or 1
+ *  - PMBSR_EL1.S = 0
+ */
+void __kvm_spe_restore_guest_state_vhe(struct kvm_vcpu *vcpu, struct kvm_cpu_context *guest_ctxt)
+{
+	u64 pmblimitr, pmbsr;
+
+	pmbsr = ctxt_sys_reg(guest_ctxt, PMBSR_EL1);
+	pmblimitr = ctxt_sys_reg(guest_ctxt, PMBLIMITR_EL1);
+	if (__kvm_spe_profiling_buffer_enabled(pmblimitr, pmbsr)) {
+		write_sysreg_s(ctxt_sys_reg(guest_ctxt, PMBPTR_EL1), SYS_PMBPTR_EL1);
+		isb();
+		write_sysreg_s(pmblimitr, SYS_PMBLIMITR_EL1);
+		isb();
+		/* A buffer management event preserves fields in PMBSR_EL1 */
+		write_sysreg_s(pmbsr, SYS_PMBSR_EL1);
+	}
+
+	__kvm_spe_restore_sampling_regs(vcpu->kvm, guest_ctxt);
+
+	write_sysreg_el1(ctxt_sys_reg(guest_ctxt, PMSCR_EL1), SYS_PMSCR);
+	write_sysreg_el2(0, SYS_PMSCR);
+}
+NOKPROBE_SYMBOL(__kvm_spe_restore_guest_state_vhe);
+
+/*
+ * Before:
+ *  - PMSCR_EL2.E2SPE = 0
+ *  - PMBLIMITR_EL1.E = 0 or 1
+ *  - PMBSR_EL1.S = 0 or 1
+ *
+ * After:
+ *  - PMSCR_EL2.E2SPE = 0
+ *  - PMBLIMITR_EL1.E = 0
+ *  - PMBSR_EL1.S = 0
+ */
+void __kvm_spe_save_guest_state_vhe(struct kvm_vcpu *vcpu, struct kvm_cpu_context *guest_ctxt)
+{
+	u64 pmblimitr, pmbsr;
+
+	pmblimitr = ctxt_sys_reg(guest_ctxt, PMBLIMITR_EL1);
+	pmbsr = ctxt_sys_reg(guest_ctxt, PMBSR_EL1);
+
+	/*
+	 * Update PMBPTR_EL1 and PMBSR_EL1 only if profiling was enabled
+	 * when the guest state was resumed.
+	 */
+	if (__kvm_spe_profiling_buffer_enabled(pmblimitr, pmbsr)) {
+		psb_csync();
+		dsb(nsh);
+		write_sysreg_s(0, SYS_PMBLIMITR_EL1);
+		/* Advance PMBPTR_EL1. */
+		isb();
+
+		/* Hardware updates to PMBSR_EL1 are not handled, yet. */
+		ctxt_sys_reg(guest_ctxt, PMBPTR_EL1) = read_sysreg_s(SYS_PMBPTR_EL1);
+	}
+
+	__kvm_spe_save_sampling_regs(vcpu->kvm, guest_ctxt);
+
+	ctxt_sys_reg(guest_ctxt, PMSCR_EL1) = read_sysreg_el1(SYS_PMSCR);
+}
+NOKPROBE_SYMBOL(__kvm_spe_save_guest_state_vhe);
+
+/*
+ * Before:
+ *  - PMSCR_EL2.E2SPE = 0
+ *  - PMBLIMITR_EL1.E = 0
+ *  - PMBSR_EL1.S = 0
+ *
+ * After:
+ *  - PMSCR_EL2.E2SPE = 0 or 1
+ *  - PMBLIMITR_EL1.E = 0 or 1
+ *  - PMBSR_EL1.S = 0 or 1
+ */
+void __kvm_spe_restore_host_state_vhe(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt)
+{
+	u64 pmbsr, pmblimitr;
+
+	/* Synchronise MDCR_EL2.{E2PB,TPMS} write. */
+	isb();
+
+	pmbsr = ctxt_sys_reg(host_ctxt, PMBSR_EL1);
+	pmblimitr = ctxt_sys_reg(host_ctxt, PMBLIMITR_EL1);
+
+	write_sysreg_s(pmbsr, SYS_PMBSR_EL1);
+	write_sysreg_s(ctxt_sys_reg(host_ctxt, PMBPTR_EL1), SYS_PMBPTR_EL1);
+	/*
+	 * If the enable bit is set:
+	 *  - If PMBSR_EL1.S = 0, synchronise the write to PMBPTR_EL1.
+	 *  - If PMBSR_EL1.S = 1, synchronise the write to PMBSR_EL1, which
+	 *  disables the buffer.
+	 */
+	if (FIELD_GET(PMBLIMITR_EL1_E, pmblimitr))
+		isb();
+
+	write_sysreg_s(pmblimitr, SYS_PMBLIMITR_EL1);
+	if (__kvm_spe_profiling_buffer_enabled(pmblimitr, pmbsr))
+		isb();
+
+	__kvm_spe_restore_sampling_regs(vcpu->kvm, host_ctxt);
+
+	write_sysreg_el2(*host_data_ptr(host_debug_state.pmscr_el2), SYS_PMSCR);
+}
+NOKPROBE_SYMBOL(__kvm_spe_restore_host_state_vhe);
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 7875911c0506..a6817a10ae3b 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -613,6 +613,8 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	fpsimd_lazy_switch_to_guest(vcpu);
 
 	sysreg_save_host_state_vhe(host_ctxt);
+	if (vcpu_has_spe(vcpu))
+		__kvm_spe_save_host_state_vhe(vcpu, host_ctxt);
 
 	/*
 	 * Note that ARM erratum 1165522 requires us to configure both stage 1
@@ -625,7 +627,10 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	__kvm_adjust_pc(vcpu);
 
 	sysreg_restore_guest_state_vhe(guest_ctxt);
+
 	__debug_switch_to_guest(vcpu);
+	if (vcpu_has_spe(vcpu))
+		__kvm_spe_restore_guest_state_vhe(vcpu, guest_ctxt);
 
 	do {
 		/* Jump in the fire! */
@@ -635,12 +640,16 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	} while (fixup_guest_exit(vcpu, &exit_code));
 
 	sysreg_save_guest_state_vhe(guest_ctxt);
+	if (vcpu_has_spe(vcpu))
+		__kvm_spe_save_guest_state_vhe(vcpu, guest_ctxt);
 
 	__deactivate_traps(vcpu);
 
 	sysreg_restore_host_state_vhe(host_ctxt);
 
 	__debug_switch_to_host(vcpu);
+	if (vcpu_has_spe(vcpu))
+		__kvm_spe_restore_host_state_vhe(vcpu, host_ctxt);
 
 	/*
 	 * Ensure that all system register writes above have taken effect
diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
index 3b285b45332b..af1e19cb8e9a 100644
--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ -100,6 +100,15 @@ int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+void kvm_vcpu_put_spe_vhe(struct kvm_vcpu *vcpu)
+{
+	if (!vcpu_has_spe(vcpu) || unlikely(vcpu_on_unsupported_cpu(vcpu)))
+		return;
+
+	/* See kvm_debug_init_vhe() */
+	write_sysreg_el1(0, SYS_PMSCR);
+}
+
 void kvm_spe_destroy_vm(struct kvm *kvm)
 {
 	struct arm_spe_pmu *spe_pmu;
-- 
2.43.0

