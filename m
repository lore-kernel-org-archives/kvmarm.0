Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BD13145A17
	for <kvmarm@lists.linux.dev>; Fri,  4 Oct 2024 11:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728040051; cv=none; b=o9PIYUgTrT/4aUQPbYPlw08LCNbJpVlhGGpMTMMIk8HTreE3uel4oKb7GNR59VIikLJ3NkUvqNYrNmEDhyQ6zuan+Y37vAqvIo7IlKBh/0OI+o01BYcylkpbyjEAQb7cr7uaWqyUFlWtw6NUNGHSoq+0Rfv9lHCWHcS0YUzxwxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728040051; c=relaxed/simple;
	bh=8Qz4Kai9zY2jS1pMoM3hwVozIuJP/LIz/lhGcCQd/4E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mG7+SryXC5Sq0+lpInZGd74RY+VTBnVM61CJ9thpJJJX6m8+h1hSTOmmMd5dQQs3rSVozW3X5bfFp7CP8ejaQyfzRZDvbST0xZlTJSJbbbNKG+5ilFGxhNxFyi0iRtqMEvDXHAfU24DhxgeKOGUQNyKw91VnLGRjEuDKE0Bd6Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5E153152B;
	Fri,  4 Oct 2024 04:07:59 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3CAA63F640;
	Fri,  4 Oct 2024 04:07:28 -0700 (PDT)
From: Joey Gouly <joey.gouly@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: anshuman.khandual@arm.com,
	james.morse@arm.com,
	joey.gouly@arm.com,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jing Zhang <jingzhangos@google.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v4 4/7] KVM: arm64: Fix missing traps of guest accesses to the MPAM registers
Date: Fri,  4 Oct 2024 12:07:11 +0100
Message-Id: <20241004110714.2051604-5-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241004110714.2051604-1-joey.gouly@arm.com>
References: <20241004110714.2051604-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: James Morse <james.morse@arm.com>

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
registers by injecting an UNDEF. This stops KVM from spamming the host
log, but doesn't yet hide the feature from the id registers.

With MPAM v1.0 we can trap the MPAMIDR_EL1 register only if
ARM64_HAS_MPAM_HCR, with v1.1 an additional MPAM2_EL2.TIDR bit traps
MPAMIDR_EL1 on platforms that don't have MPAMHCR_EL2. Enable one of
these if either is supported. If neither is supported, the guest can
discover that the CPU has MPAM support, and how many PARTID etc the
host has ... but it can't influence anything, so its harmless.

Fixes: 011e5f5bf529f ("arm64/cpufeature: Add remaining feature bits in ID_AA64PFR0 register")
CC: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/linux-arm-kernel/20200925160102.118858-1-james.morse@arm.com/
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 arch/arm64/include/asm/cpufeature.h     |  2 +-
 arch/arm64/include/asm/kvm_arm.h        |  1 +
 arch/arm64/include/asm/mpam.h           |  2 +-
 arch/arm64/kernel/image-vars.h          |  5 ++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 32 +++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c               | 11 +++++++++
 6 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 1abe55e62e63..985d966787b1 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -845,7 +845,7 @@ static inline bool system_supports_poe(void)
 		alternative_has_cap_unlikely(ARM64_HAS_S1POE);
 }
 
-static inline bool cpus_support_mpam(void)
+static __always_inline bool cpus_support_mpam(void)
 {
 	return alternative_has_cap_unlikely(ARM64_MPAM);
 }
diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 109a85ee6910..16afb7a79b15 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -103,6 +103,7 @@
 #define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)
 
 #define HCRX_HOST_FLAGS (HCRX_EL2_MSCEn | HCRX_EL2_TCR2En | HCRX_EL2_EnFPM)
+#define MPAMHCR_HOST_FLAGS	0
 
 /* TCR_EL2 Registers bits */
 #define TCR_EL2_DS		(1UL << 32)
diff --git a/arch/arm64/include/asm/mpam.h b/arch/arm64/include/asm/mpam.h
index d3ef0b5cd456..3ffe0f34ffff 100644
--- a/arch/arm64/include/asm/mpam.h
+++ b/arch/arm64/include/asm/mpam.h
@@ -15,7 +15,7 @@
 DECLARE_STATIC_KEY_FALSE(arm64_mpam_has_hcr);
 
 /* check whether all CPUs have MPAM virtualisation support */
-static inline bool mpam_cpus_have_mpam_hcr(void)
+static __always_inline bool mpam_cpus_have_mpam_hcr(void)
 {
 	if (IS_ENABLED(CONFIG_ARM64_MPAM))
 		return static_branch_unlikely(&arm64_mpam_has_hcr);
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 8f5422ed1b75..9934e4cc76e9 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -101,6 +101,11 @@ KVM_NVHE_ALIAS(nvhe_hyp_panic_handler);
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
index 46d52e8a3df3..b886d82ade5f 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -29,6 +29,7 @@
 #include <asm/kvm_nested.h>
 #include <asm/fpsimd.h>
 #include <asm/debug-monitors.h>
+#include <asm/mpam.h>
 #include <asm/processor.h>
 #include <asm/traps.h>
 
@@ -204,6 +205,35 @@ static inline void __deactivate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 		__deactivate_fgt(hctxt, vcpu, kvm, HAFGRTR_EL2);
 }
 
+static inline void  __activate_traps_mpam(struct kvm_vcpu *vcpu)
+{
+	u64 r = MPAM2_EL2_TRAPMPAM0EL1 | MPAM2_EL2_TRAPMPAM1EL1;
+
+	if (!cpus_support_mpam())
+		return;
+
+	/* trap guest access to MPAMIDR_EL1 */
+	if (mpam_cpus_have_mpam_hcr()) {
+		write_sysreg_s(MPAMHCR_EL2_TRAP_MPAMIDR_EL1, SYS_MPAMHCR_EL2);
+	} else {
+		/* From v1.1 TIDR can trap MPAMIDR, set it unconditionally */
+		r |= MPAM2_EL2_TIDR;
+	}
+
+	write_sysreg_s(r, SYS_MPAM2_EL2);
+}
+
+static inline void __deactivate_traps_mpam(void)
+{
+	if (!cpus_support_mpam())
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
@@ -244,6 +274,7 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 	}
 
 	__activate_traps_hfgxtr(vcpu);
+	__activate_traps_mpam(vcpu);
 }
 
 static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
@@ -263,6 +294,7 @@ static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
 		write_sysreg_s(HCRX_HOST_FLAGS, SYS_HCRX_EL2);
 
 	__deactivate_traps_hfgxtr(vcpu);
+	__deactivate_traps_mpam();
 }
 
 static inline void ___activate_traps(struct kvm_vcpu *vcpu, u64 hcr)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index dad88e31f953..8b1a6cedc49e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -544,6 +544,14 @@ static bool trap_oslar_el1(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static bool trap_mpam(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+		      const struct sys_reg_desc *r)
+{
+	kvm_inject_undefined(vcpu);
+
+	return false;
+}
+
 static bool trap_oslsr_el1(struct kvm_vcpu *vcpu,
 			   struct sys_reg_params *p,
 			   const struct sys_reg_desc *r)
@@ -2517,8 +2525,11 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_LOREA_EL1), trap_loregion },
 	{ SYS_DESC(SYS_LORN_EL1), trap_loregion },
 	{ SYS_DESC(SYS_LORC_EL1), trap_loregion },
+	{ SYS_DESC(SYS_MPAMIDR_EL1), trap_mpam },
 	{ SYS_DESC(SYS_LORID_EL1), trap_loregion },
 
+	{ SYS_DESC(SYS_MPAM1_EL1), trap_mpam },
+	{ SYS_DESC(SYS_MPAM0_EL1), trap_mpam },
 	{ SYS_DESC(SYS_VBAR_EL1), access_rw, reset_val, VBAR_EL1, 0 },
 	{ SYS_DESC(SYS_DISR_EL1), NULL, reset_val, DISR_EL1, 0 },
 
-- 
2.25.1

