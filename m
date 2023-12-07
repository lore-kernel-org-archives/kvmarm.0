Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E4BC4437C
	for <kvmarm@lists.linux.dev>; Thu,  7 Dec 2023 15:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9C3E91576;
	Thu,  7 Dec 2023 07:09:11 -0800 (PST)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.197.60])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 966D83F762;
	Thu,  7 Dec 2023 07:08:24 -0800 (PST)
From: James Morse <james.morse@arm.com>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Morse <james.morse@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>
Subject: [PATCH v2 3/4] KVM: arm64: Fix missing traps of guest accesses to the MPAM registers
Date: Thu,  7 Dec 2023 15:08:03 +0000
Message-Id: <20231207150804.3425468-4-james.morse@arm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231207150804.3425468-1-james.morse@arm.com>
References: <20231207150804.3425468-1-james.morse@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 011e5f5bf529f ("arm64/cpufeature: Add remaining feature bits in
ID_AA64PFR0 register") exposed the MPAM field of AA64PFR0_EL1 to guests,
but didn't add trap handling.

If you are unlucky, this results in an MPAM aware guest being delivered
an undef during boot. The host prints:
| kvm [97]: Unsupported guest sys_reg access at: ffff800080024c64 [00000005]
| { Op0( 3), Op1( 0), CRn(10), CRm( 5), Op2( 0), func_read },

Which results in:
| Internal error: Oops - Undefined instruction: 0000000002000000 [#1] PREEMPT SMP
| Modules linked in:
| CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.6.0-rc7-00559-gd89c186d50b2 #14616
| Hardware name: linux,dummy-virt (DT)
| pstate: 00000005 (nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
| pc : test_has_mpam+0x18/0x30
| lr : test_has_mpam+0x10/0x30
| sp : ffff80008000bd90
...
| Call trace:
|  test_has_mpam+0x18/0x30
|  update_cpu_capabilities+0x7c/0x11c
|  setup_cpu_features+0x14/0xd8
|  smp_cpus_done+0x24/0xb8
|  smp_init+0x7c/0x8c
|  kernel_init_freeable+0xf8/0x280
|  kernel_init+0x24/0x1e0
|  ret_from_fork+0x10/0x20
| Code: 910003fd 97ffffde 72001c00 54000080 (d538a500)
| ---[ end trace 0000000000000000 ]---
| Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
| ---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b ]---

Add the support to enable the traps, and handle the three guest accessible
registers as RAZ/WI. This allows guests to keep the invariant id-register
value, while advertising that MPAM isn't really supported.

With MPAM v1.0 we can trap the MPAMIDR_EL1 register only if
ARM64_HAS_MPAM_HCR, with v1.1 an additional MPAM2_EL2.TIDR bit traps
MPAMIDR_EL1 on platforms that don't have MPAMHCR_EL2. Enable one of
these if either is supported. If neither is supported, the guest can
discover that the CPU has MPAM support, and how many PARTID etc the
host has ... but it can't influence anything, so its harmless.

Full support for the feature would only expose MPAM to the guest
if a psuedo-device has been created to describe the virt->phys partid
mapping the VMM expects. This will depend on ARM64_HAS_MPAM_HCR.

Fixes: 011e5f5bf529 ("arm64/cpufeature: Add remaining feature bits in ID_AA64PFR0 register")
CC: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/linux-arm-kernel/20200925160102.118858-1-james.morse@arm.com/
Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h        |  1 +
 arch/arm64/include/asm/mpam.h           |  4 ++--
 arch/arm64/kernel/image-vars.h          |  5 ++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 32 +++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c               | 20 ++++++++++++++++
 5 files changed, 60 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index b85f46a73e21..87aa442c2622 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -106,6 +106,7 @@
 	(HCRX_EL2_SMPME | HCRX_EL2_TCR2En | \
 	 (cpus_have_final_cap(ARM64_HAS_MOPS) ? (HCRX_EL2_MSCEn | HCRX_EL2_MCE2) : 0))
 #define HCRX_HOST_FLAGS (HCRX_EL2_MSCEn | HCRX_EL2_TCR2En)
+#define MPAMHCR_HOST_FLAGS	0
 
 /* TCR_EL2 Registers bits */
 #define TCR_EL2_RES1		((1U << 31) | (1 << 23))
diff --git a/arch/arm64/include/asm/mpam.h b/arch/arm64/include/asm/mpam.h
index 82d4f6008aeb..dd11e97d8317 100644
--- a/arch/arm64/include/asm/mpam.h
+++ b/arch/arm64/include/asm/mpam.h
@@ -50,7 +50,7 @@
 DECLARE_STATIC_KEY_FALSE(arm64_mpam_has_hcr);
 
 /* check whether all CPUs have MPAM support */
-static inline bool mpam_cpus_have_feature(void)
+static __always_inline bool mpam_cpus_have_feature(void)
 {
 	if (IS_ENABLED(CONFIG_ARM64_MPAM))
 		return cpus_have_final_cap(ARM64_MPAM);
@@ -58,7 +58,7 @@ static inline bool mpam_cpus_have_feature(void)
 }
 
 /* check whether all CPUs have MPAM virtualisation support */
-static inline bool mpam_cpus_have_mpam_hcr(void)
+static __always_inline bool mpam_cpus_have_mpam_hcr(void)
 {
 	if (IS_ENABLED(CONFIG_ARM64_MPAM))
 		return static_branch_unlikely(&arm64_mpam_has_hcr);
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 5e4dc72ab1bd..b30046aaa171 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -66,6 +66,11 @@ KVM_NVHE_ALIAS(nvhe_hyp_panic_handler);
 /* Vectors installed by hyp-init on reset HVC. */
 KVM_NVHE_ALIAS(__hyp_stub_vectors);
 
+/* Additional static keys for cpufeatures */
+#ifdef CONFIG_ARM64_MPAM
+KVM_NVHE_ALIAS(arm64_mpam_has_hcr);
+#endif
+
 /* Static keys which are set if a vGIC trap should be handled in hyp. */
 KVM_NVHE_ALIAS(vgic_v2_cpuif_trap);
 KVM_NVHE_ALIAS(vgic_v3_cpuif_trap);
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index f99d8af0b9af..277373871b44 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -27,6 +27,7 @@
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_nested.h>
+#include <asm/mpam.h>
 #include <asm/fpsimd.h>
 #include <asm/debug-monitors.h>
 #include <asm/processor.h>
@@ -173,6 +174,35 @@ static inline void __deactivate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 	write_sysreg_s(ctxt_sys_reg(hctxt, HDFGWTR_EL2), SYS_HDFGWTR_EL2);
 }
 
+static inline void  __activate_traps_mpam(struct kvm_vcpu *vcpu)
+{
+	u64 r = MPAM_SYSREG_TRAP_MPAM0_EL1 | MPAM_SYSREG_TRAP_MPAM1_EL1;
+
+	if (!mpam_cpus_have_feature())
+		return;
+
+	/* trap guest access to MPAMIDR_EL1 */
+	if (mpam_cpus_have_mpam_hcr()) {
+		write_sysreg_s(MPAMHCR_TRAP_MPAMIDR, SYS_MPAMHCR_EL2);
+	} else {
+		/* From v1.1 TIDR can trap MPAMIDR, set it unconditionally */
+		r |= MPAM_SYSREG_TRAP_IDR;
+	}
+
+	write_sysreg_s(r, SYS_MPAM2_EL2);
+}
+
+static inline void __deactivate_traps_mpam(void)
+{
+	if (!mpam_cpus_have_feature())
+		return;
+
+	write_sysreg_s(0, SYS_MPAM2_EL2);
+
+	if (mpam_cpus_have_mpam_hcr())
+		write_sysreg_s(MPAMHCR_HOST_FLAGS, SYS_MPAMHCR_EL2);
+}
+
 static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 {
 	/* Trap on AArch32 cp15 c15 (impdef sysregs) accesses (EL1 or EL0) */
@@ -213,6 +243,7 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 	}
 
 	__activate_traps_hfgxtr(vcpu);
+	__activate_traps_mpam(vcpu);
 }
 
 static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
@@ -232,6 +263,7 @@ static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
 		write_sysreg_s(HCRX_HOST_FLAGS, SYS_HCRX_EL2);
 
 	__deactivate_traps_hfgxtr(vcpu);
+	__deactivate_traps_mpam();
 }
 
 static inline void ___activate_traps(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 4735e1b37fb3..15fb9f54e308 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -411,6 +411,23 @@ static bool trap_oslar_el1(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static bool workaround_bad_mpam_abi(struct kvm_vcpu *vcpu,
+				    struct sys_reg_params *p,
+				    const struct sys_reg_desc *r)
+{
+	/*
+	 * The ID register can't be removed without breaking migration,
+	 * but MPAMIDR_EL1 can advertise all-zeroes, indicating there are zero
+	 * PARTID/PMG supported by the CPU, allowing the other two trapped
+	 * registers (MPAM1_EL1 and MPAM0_EL1) to be treated as RAZ/WI.
+	 * Emulating MPAM1_EL1 as RAZ/WI means the guest sees the MPAMEN bit
+	 * as clear, and realises MPAM isn't usable on this CPU.
+	 */
+	p->regval = 0;
+
+	return true;
+}
+
 static bool trap_oslsr_el1(struct kvm_vcpu *vcpu,
 			   struct sys_reg_params *p,
 			   const struct sys_reg_desc *r)
@@ -2275,8 +2292,11 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_LOREA_EL1), trap_loregion },
 	{ SYS_DESC(SYS_LORN_EL1), trap_loregion },
 	{ SYS_DESC(SYS_LORC_EL1), trap_loregion },
+	{ SYS_DESC(SYS_MPAMIDR_EL1), workaround_bad_mpam_abi },
 	{ SYS_DESC(SYS_LORID_EL1), trap_loregion },
 
+	{ SYS_DESC(SYS_MPAM1_EL1), workaround_bad_mpam_abi },
+	{ SYS_DESC(SYS_MPAM0_EL1), workaround_bad_mpam_abi },
 	{ SYS_DESC(SYS_VBAR_EL1), access_rw, reset_val, VBAR_EL1, 0 },
 	{ SYS_DESC(SYS_DISR_EL1), NULL, reset_val, DISR_EL1, 0 },
 
-- 
2.39.2

