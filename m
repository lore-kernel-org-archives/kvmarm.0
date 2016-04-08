From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 3/4] arm64: KVM: Warn when PARange is less than 40 bits
Date: Fri,  8 Apr 2016 11:52:14 +0200
Message-ID: <1460109135-6612-4-git-send-email-christoffer.dall@linaro.org>
References: <1460109135-6612-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1460109135-6612-1-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

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
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/include/asm/kvm_arm.h  |  6 ++----
 arch/arm64/include/asm/kvm_asm.h  |  2 +-
 arch/arm64/include/asm/kvm_host.h |  7 ++++---
 arch/arm64/kvm/hyp/s2-setup.c     | 39 +++++++++++++++++++++++++++++++++++++--
 4 files changed, 44 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 4150fd8..3f29887 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -151,8 +151,7 @@
  */
 #define VTCR_EL2_FLAGS		(VTCR_EL2_TG0_64K | VTCR_EL2_SH0_INNER | \
 				 VTCR_EL2_ORGN0_WBWA | VTCR_EL2_IRGN0_WBWA | \
-				 VTCR_EL2_SL0_LVL1 | VTCR_EL2_T0SZ_40B | \
-				 VTCR_EL2_RES1)
+				 VTCR_EL2_SL0_LVL1 | VTCR_EL2_RES1)
 #define VTTBR_X		(38 - VTCR_EL2_T0SZ_40B)
 #else
 /*
@@ -163,8 +162,7 @@
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
index 227ed47..4cd4196 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -370,11 +370,12 @@ int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
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
index 5a9f3bf..bcbe761 100644
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
@@ -42,4 +75,6 @@ void __hyp_text __init_stage2_translation(void)
 			VTCR_EL2_VS_8BIT;
 
 	write_sysreg(val, vtcr_el2);
+
+	return parange;
 }
-- 
2.1.2.330.g565301e.dirty

