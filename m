From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 10/12] arm/arm64: KVM: vgic: Do not save GICH_HCR / ICH_HCR_EL2
Date: Fri, 19 Jun 2015 13:53:14 +0100
Message-ID: <1434718396-13110-11-git-send-email-marc.zyngier@arm.com>
References: <1434718396-13110-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1434718396-13110-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Andre Przywara <andre.przywara@arm.com>, Firo Yang <firogm@gmail.com>, Tiejun Chen <tiejun.chen@intel.com>, Eric Auger <eric.auger@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

The GIC Hypervisor Configuration Register is used to enable
the delivery of virtual interupts to a guest, as well as to
define in which conditions maintenance interrupts are delivered
to the host.

This register doesn't contain any information that we need to
read back (the EOIcount is utterly useless for us).

So let's save ourselves some cycles, and not save it before
writing zero to it.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/interrupts_head.S  | 3 ---
 arch/arm64/kvm/vgic-v2-switch.S | 3 ---
 arch/arm64/kvm/vgic-v3-switch.S | 2 --
 3 files changed, 8 deletions(-)

diff --git a/arch/arm/kvm/interrupts_head.S b/arch/arm/kvm/interrupts_head.S
index 48efe2e..702740d 100644
--- a/arch/arm/kvm/interrupts_head.S
+++ b/arch/arm/kvm/interrupts_head.S
@@ -412,7 +412,6 @@ vcpu	.req	r0		@ vcpu pointer always in r0
 	add	r11, vcpu, #VCPU_VGIC_CPU
 
 	/* Save all interesting registers */
-	ldr	r3, [r2, #GICH_HCR]
 	ldr	r4, [r2, #GICH_VMCR]
 	ldr	r5, [r2, #GICH_MISR]
 	ldr	r6, [r2, #GICH_EISR0]
@@ -420,7 +419,6 @@ vcpu	.req	r0		@ vcpu pointer always in r0
 	ldr	r8, [r2, #GICH_ELRSR0]
 	ldr	r9, [r2, #GICH_ELRSR1]
 	ldr	r10, [r2, #GICH_APR]
-ARM_BE8(rev	r3, r3	)
 ARM_BE8(rev	r4, r4	)
 ARM_BE8(rev	r5, r5	)
 ARM_BE8(rev	r6, r6	)
@@ -429,7 +427,6 @@ ARM_BE8(rev	r8, r8	)
 ARM_BE8(rev	r9, r9	)
 ARM_BE8(rev	r10, r10	)
 
-	str	r3, [r11, #VGIC_V2_CPU_HCR]
 	str	r4, [r11, #VGIC_V2_CPU_VMCR]
 	str	r5, [r11, #VGIC_V2_CPU_MISR]
 #ifdef CONFIG_CPU_ENDIAN_BE8
diff --git a/arch/arm64/kvm/vgic-v2-switch.S b/arch/arm64/kvm/vgic-v2-switch.S
index f002fe1..3f00071 100644
--- a/arch/arm64/kvm/vgic-v2-switch.S
+++ b/arch/arm64/kvm/vgic-v2-switch.S
@@ -47,7 +47,6 @@ __save_vgic_v2_state:
 	add	x3, x0, #VCPU_VGIC_CPU
 
 	/* Save all interesting registers */
-	ldr	w4, [x2, #GICH_HCR]
 	ldr	w5, [x2, #GICH_VMCR]
 	ldr	w6, [x2, #GICH_MISR]
 	ldr	w7, [x2, #GICH_EISR0]
@@ -55,7 +54,6 @@ __save_vgic_v2_state:
 	ldr	w9, [x2, #GICH_ELRSR0]
 	ldr	w10, [x2, #GICH_ELRSR1]
 	ldr	w11, [x2, #GICH_APR]
-CPU_BE(	rev	w4,  w4  )
 CPU_BE(	rev	w5,  w5  )
 CPU_BE(	rev	w6,  w6  )
 CPU_BE(	rev	w7,  w7  )
@@ -64,7 +62,6 @@ CPU_BE(	rev	w9,  w9  )
 CPU_BE(	rev	w10, w10 )
 CPU_BE(	rev	w11, w11 )
 
-	str	w4, [x3, #VGIC_V2_CPU_HCR]
 	str	w5, [x3, #VGIC_V2_CPU_VMCR]
 	str	w6, [x3, #VGIC_V2_CPU_MISR]
 CPU_LE(	str	w7, [x3, #VGIC_V2_CPU_EISR] )
diff --git a/arch/arm64/kvm/vgic-v3-switch.S b/arch/arm64/kvm/vgic-v3-switch.S
index 617a012..3c20730 100644
--- a/arch/arm64/kvm/vgic-v3-switch.S
+++ b/arch/arm64/kvm/vgic-v3-switch.S
@@ -48,13 +48,11 @@
 	dsb	st
 
 	// Save all interesting registers
-	mrs_s	x4, ICH_HCR_EL2
 	mrs_s	x5, ICH_VMCR_EL2
 	mrs_s	x6, ICH_MISR_EL2
 	mrs_s	x7, ICH_EISR_EL2
 	mrs_s	x8, ICH_ELSR_EL2
 
-	str	w4, [x3, #VGIC_V3_CPU_HCR]
 	str	w5, [x3, #VGIC_V3_CPU_VMCR]
 	str	w6, [x3, #VGIC_V3_CPU_MISR]
 	str	w7, [x3, #VGIC_V3_CPU_EISR]
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe kvm" in
