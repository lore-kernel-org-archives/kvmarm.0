From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 4/4] arm64: KVM: Implement workaround for Cortex-A76 erratum
 1165522
Date: Mon,  5 Nov 2018 14:36:16 +0000
Message-ID: <20181105143617.120602-5-marc.zyngier@arm.com>
References: <20181105143617.120602-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 42AE64A339
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Nov 2018 09:36:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rPbWOslx0GYQ for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Nov 2018 09:36:58 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5613C4A322
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Nov 2018 09:36:56 -0500 (EST)
In-Reply-To: <20181105143617.120602-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Early versions of Cortex-A76 can end-up with corrupt TLBs if they
speculate an AT instruction in during a guest switch while the
S1/S2 system registers are in an inconsistent state.

Work around it by:
- Mandating VHE
- Make sure that S1 and S2 system registers are consistent before
  clearing HCR_EL2.TGE, which allows AT to target the EL1 translation
  regime

These two things together ensure that we cannot hit this erratum.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 Documentation/arm64/silicon-errata.txt |  1 +
 arch/arm64/Kconfig                     | 12 ++++++++++++
 arch/arm64/include/asm/cpucaps.h       |  3 ++-
 arch/arm64/include/asm/kvm_host.h      |  3 +++
 arch/arm64/include/asm/kvm_hyp.h       |  6 ++++++
 arch/arm64/kernel/cpu_errata.c         |  8 ++++++++
 arch/arm64/kvm/hyp/switch.c            | 14 ++++++++++++++
 7 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/Documentation/arm64/silicon-errata.txt b/Documentation/arm64/silicon-errata.txt
index 76ccded8b74c..04f0bc4690c6 100644
--- a/Documentation/arm64/silicon-errata.txt
+++ b/Documentation/arm64/silicon-errata.txt
@@ -57,6 +57,7 @@ stable kernels.
 | ARM            | Cortex-A73      | #858921         | ARM64_ERRATUM_858921        |
 | ARM            | Cortex-A55      | #1024718        | ARM64_ERRATUM_1024718       |
 | ARM            | Cortex-A76      | #1188873        | ARM64_ERRATUM_1188873       |
+| ARM            | Cortex-A76      | #1165522        | ARM64_ERRATUM_1165522       |
 | ARM            | MMU-500         | #841119,#826419 | N/A                         |
 |                |                 |                 |                             |
 | Cavium         | ThunderX ITS    | #22375, #24313  | CAVIUM_ERRATUM_22375        |
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 787d7850e064..a68bc6cc2167 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -497,6 +497,18 @@ config ARM64_ERRATUM_1188873
 
 	  If unsure, say Y.
 
+config ARM64_ERRATUM_1165522
+	bool "Cortex-A76: Speculative AT instruction using out-of-context translation regime could cause subsequent request to generate an incorrect translation"
+	default y
+	help
+	  This option adds work arounds for ARM Cortex-A76 erratum 1165522
+
+	  Affected Cortex-A76 cores (r0p0, r1p0, r2p0) could end-up with
+	  corrupted TLBs by speculating an AT instruction during a guest
+	  context switch.
+
+	  If unsure, say Y.
+
 config CAVIUM_ERRATUM_22375
 	bool "Cavium erratum 22375, 24313"
 	default y
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 6e2d254c09eb..62d8cd15fdf2 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -54,7 +54,8 @@
 #define ARM64_HAS_CRC32				33
 #define ARM64_SSBS				34
 #define ARM64_WORKAROUND_1188873		35
+#define ARM64_WORKAROUND_1165522		36
 
-#define ARM64_NCAPS				36
+#define ARM64_NCAPS				37
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7d6e974d024a..8f486026ac87 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -435,6 +435,9 @@ static inline bool kvm_arch_sve_requires_vhe(void)
 static inline bool kvm_arch_impl_requires_vhe(void)
 {
 	/* Some implementations have defects that confine them to VHE */
+	if (cpus_have_cap(ARM64_WORKAROUND_1165522))
+		return true;
+
 	return false;
 }
 
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 23aca66767f9..9681360d0959 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -163,6 +163,12 @@ static __always_inline void __hyp_text __load_guest_stage2(struct kvm *kvm)
 {
 	write_sysreg(kvm->arch.vtcr, vtcr_el2);
 	write_sysreg(kvm->arch.vttbr, vttbr_el2);
+
+	/*
+	 * ARM erratum 1165522 requires the actual execution of the
+	 * above before we can switch to the guest translation regime.
+	 */
+	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_1165522));
 }
 
 #endif /* __ARM64_KVM_HYP_H__ */
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index a509e35132d2..476e738e6c46 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -739,6 +739,14 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.capability = ARM64_WORKAROUND_1188873,
 		ERRATA_MIDR_RANGE(MIDR_CORTEX_A76, 0, 0, 2, 0),
 	},
+#endif
+#ifdef CONFIG_ARM64_ERRATUM_1165522
+	{
+		/* Cortex-A76 r0p0 to r2p0 */
+		.desc = "ARM erratum 1165522",
+		.capability = ARM64_WORKAROUND_1165522,
+		ERRATA_MIDR_RANGE(MIDR_CORTEX_A76, 0, 0, 2, 0),
+	},
 #endif
 	{
 	}
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 51d5d966d9e5..322109183853 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -143,6 +143,13 @@ static void deactivate_traps_vhe(void)
 {
 	extern char vectors[];	/* kernel exception vectors */
 	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
+
+	/*
+	 * ARM erratum 1165522 requires the actual execution of the
+	 * above before we can switch to the host translation regime.
+	 */
+	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_1165522));
+
 	write_sysreg(CPACR_EL1_DEFAULT, cpacr_el1);
 	write_sysreg(vectors, vbar_el1);
 }
@@ -499,6 +506,13 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 
 	sysreg_save_host_state_vhe(host_ctxt);
 
+	/*
+	 * ARM erratum 1165522 requires us to have all the translation
+	 * context in place before we clear HCR_TGE. All the offending
+	 * guest sysregs are loaded in kvm_vcpu_load_sysregs, and
+	 * __activate_vm has the stage-2 configuration. Once this is
+	 * done, __activate_trap clears HCR_TGE (among other things).
+	 */
 	__activate_vm(vcpu->kvm);
 	__activate_traps(vcpu);
 
-- 
2.19.1
