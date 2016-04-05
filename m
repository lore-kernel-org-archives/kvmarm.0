From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH] arm64: KVM: Warn when PARange is less than 40 bits
Date: Tue,  5 Apr 2016 16:11:47 +0100
Message-ID: <1459869107-6367-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 051814053F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Apr 2016 11:10:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HQuPs7D8cj6m for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Apr 2016 11:10:35 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE9D140402
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Apr 2016 11:10:34 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

We always thought that 40bits of PA range would be the minimum people
would actually build. Anything less is terrifyingly small.

Turns out that we were both right and wrong. Nobody has ever built
such a system, but the ARM Foundation Model has a PARange set to 36bits.
Just because we can. Oh well. Now, the KVM API explicitely says that
we offer a 40bit PA space to the VM, so we shouldn't run KVM on
the Foundation Model at all.

That being said, this patch offers a less agressive alternative, and
loudly warns about the configuration being unsupported. You'll still
be able to run VMs (at your own risks, though).

This is just a workaround until we have a proper userspace API where
we report the PARange to userspace.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h  |  6 ++----
 arch/arm64/include/asm/kvm_asm.h  |  2 +-
 arch/arm64/include/asm/kvm_host.h |  7 ++++---
 arch/arm64/kvm/hyp/s2-setup.c     | 39 +++++++++++++++++++++++++++++++++++++--
 4 files changed, 44 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 0e391db..b73db9c 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -149,8 +149,7 @@
  */
 #define VTCR_EL2_FLAGS		(VTCR_EL2_TG0_64K | VTCR_EL2_SH0_INNER | \
 				 VTCR_EL2_ORGN0_WBWA | VTCR_EL2_IRGN0_WBWA | \
-				 VTCR_EL2_SL0_LVL1 | VTCR_EL2_T0SZ_40B | \
-				 VTCR_EL2_RES1)
+				 VTCR_EL2_SL0_LVL1 | VTCR_EL2_RES1)
 #define VTTBR_X		(38 - VTCR_EL2_T0SZ_40B)
 #else
 /*
@@ -161,8 +160,7 @@
  */
 #define VTCR_EL2_FLAGS		(VTCR_EL2_TG0_4K | VTCR_EL2_SH0_INNER | \
 				 VTCR_EL2_ORGN0_WBWA | VTCR_EL2_IRGN0_WBWA | \
-				 VTCR_EL2_SL0_LVL1 | VTCR_EL2_T0SZ_40B | \
-				 VTCR_EL2_RES1)
+				 VTCR_EL2_SL0_LVL1 | VTCR_EL2_RES1)
 #define VTTBR_X		(37 - VTCR_EL2_T0SZ_40B)
 #endif
 
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index eb7490d..40a0a24 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -54,7 +54,7 @@ extern void __vgic_v3_init_lrs(void);
 
 extern u32 __kvm_get_mdcr_el2(void);
 
-extern void __init_stage2_translation(void);
+extern u32 __init_stage2_translation(void);
 
 #endif
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index b7e82a7..f5c6bd2 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -369,11 +369,12 @@ int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
 int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 			       struct kvm_device_attr *attr);
 
-/* #define kvm_call_hyp(f, ...) __kvm_call_hyp(kvm_ksym_ref(f), ##__VA_ARGS__) */
-
 static inline void __cpu_init_stage2(void)
 {
-	kvm_call_hyp(__init_stage2_translation);
+	u32 parange = kvm_call_hyp(__init_stage2_translation);
+
+	WARN_ONCE(parange < 40,
+		  "PARange is %d bits, unsupported configuration!", parange);
 }
 
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/hyp/s2-setup.c b/arch/arm64/kvm/hyp/s2-setup.c
index bfc54fd..bbbab0d 100644
--- a/arch/arm64/kvm/hyp/s2-setup.c
+++ b/arch/arm64/kvm/hyp/s2-setup.c
@@ -20,9 +20,10 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_hyp.h>
 
-void __hyp_text __init_stage2_translation(void)
+u32 __hyp_text __init_stage2_translation(void)
 {
 	u64 val = VTCR_EL2_FLAGS;
+	u64 parange;
 	u64 tmp;
 
 	/*
@@ -30,7 +31,39 @@ void __hyp_text __init_stage2_translation(void)
 	 * bits in VTCR_EL2. Amusingly, the PARange is 4 bits, while
 	 * PS is only 3. Fortunately, bit 19 is RES0 in VTCR_EL2...
 	 */
-	val |= (read_sysreg(id_aa64mmfr0_el1) & 7) << 16;
+	parange = read_sysreg(id_aa64mmfr0_el1) & 7;
+	val |= parange << 16;
+
+	/* Compute the actual PARange... */
+	switch (parange) {
+	case 0:
+		parange = 32;
+		break;
+	case 1:
+		parange = 36;
+		break;
+	case 2:
+		parange = 40;
+		break;
+	case 3:
+		parange = 42;
+		break;
+	case 4:
+		parange = 44;
+		break;
+	case 5:
+	default:
+		parange = 48;
+		break;
+	}
+
+	/*
+	 * ... and clamp it to 40 bits, unless we have some braindead
+	 * HW that implements less than that. In all cases, we'll
+	 * return that value for the rest of the kernel to decide what
+	 * to do.
+	 */
+	val |= 64 - (parange > 40 ? 40 : parange);
 
 	/*
 	 * Read the VMIDBits bits from ID_AA64MMFR1_EL1 and set the VS
@@ -40,4 +73,6 @@ void __hyp_text __init_stage2_translation(void)
 	val |= (tmp == 2) ? VTCR_EL2_VS : 0;
 
 	write_sysreg(val, vtcr_el2);
+
+	return parange;
 }
-- 
2.1.4
