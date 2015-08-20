From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 04/25] KVM: arm: introduce kvm_arm_init/setup/clear_debug
Date: Thu, 20 Aug 2015 17:28:42 +0100
Message-ID: <1440088143-4722-5-git-send-email-marc.zyngier@arm.com>
References: <1440088143-4722-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1440088143-4722-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, Mario Smarduch <m.smarduch@samsung.com>, "Suzuki K. Poulose" <suzuki.poulose@arm.com>, Vladimir Murzin <vladimir.murzin@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

=46rom: Alex Benn=C3=A9e <alex.bennee@linaro.org>

This is a precursor for later patches which will need to do more to
setup debug state before entering the hyp.S switch code. The existing
functionality for setting mdcr_el2 has been moved out of hyp.S and now
uses the value kept in vcpu->arch.mdcr_el2.

As the assembler used to previously mask and preserve MDCR_EL2.HPMN I'v=
e
had to add a mechanism to save the value of mdcr_el2 as a per-cpu
variable during the initialisation code. The kernel never sets this
number so we are assuming the bootcode has set up the correct value
here.

This also moves the conditional setting of the TDA bit from the hyp cod=
e
into the C code which is currently used for the lazy debug register
context switch code.

Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_host.h   |  4 ++
 arch/arm/kvm/arm.c                |  6 +++
 arch/arm64/include/asm/kvm_asm.h  |  2 +
 arch/arm64/include/asm/kvm_host.h |  5 +++
 arch/arm64/kernel/asm-offsets.c   |  1 +
 arch/arm64/kvm/Makefile           |  2 +-
 arch/arm64/kvm/debug.c            | 81 +++++++++++++++++++++++++++++++=
++++++++
 arch/arm64/kvm/hyp.S              | 19 ++++-----
 8 files changed, 108 insertions(+), 12 deletions(-)
 create mode 100644 arch/arm64/kvm/debug.c

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm=
_host.h
index e896d2c..2b0bc8c 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -231,4 +231,8 @@ static inline void kvm_arch_sync_events(struct kvm =
*kvm) {}
 static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {=
}
=20
+static inline void kvm_arm_init_debug(void) {}
+static inline void kvm_arm_setup_debug(struct kvm_vcpu *vcpu) {}
+static inline void kvm_arm_clear_debug(struct kvm_vcpu *vcpu) {}
+
 #endif /* __ARM_KVM_HOST_H__ */
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 1b693cb..77151b1 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -543,6 +543,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, =
struct kvm_run *run)
 			continue;
 		}
=20
+		kvm_arm_setup_debug(vcpu);
+
 		/**************************************************************
 		 * Enter the guest
 		 */
@@ -557,6 +559,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, =
struct kvm_run *run)
 		 * Back from guest
 		 *************************************************************/
=20
+		kvm_arm_clear_debug(vcpu);
+
 		/*
 		 * We may have taken a host interrupt in HYP mode (ie
 		 * while executing the guest). This interrupt is still
@@ -914,6 +918,8 @@ static void cpu_init_hyp_mode(void *dummy)
 	vector_ptr =3D (unsigned long)__kvm_hyp_vector;
=20
 	__cpu_init_hyp_mode(boot_pgd_ptr, pgd_ptr, hyp_stack_ptr, vector_ptr)=
;
+
+	kvm_arm_init_debug();
 }
=20
 static int hyp_init_cpu_notify(struct notifier_block *self,
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/=
kvm_asm.h
index 3c5fe68..f5e40da 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -132,6 +132,8 @@ extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
=20
 extern u64 __vgic_v3_get_ich_vtr_el2(void);
=20
+extern u32 __kvm_get_mdcr_el2(void);
+
 #endif
=20
 #endif /* __ARM_KVM_ASM_H__ */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm=
/kvm_host.h
index 2709db2..c90c6a4 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -103,6 +103,7 @@ struct kvm_vcpu_arch {
=20
 	/* HYP configuration */
 	u64 hcr_el2;
+	u32 mdcr_el2;
=20
 	/* Exception Information */
 	struct kvm_vcpu_fault_info fault;
@@ -227,4 +228,8 @@ static inline void kvm_arch_sync_events(struct kvm =
*kvm) {}
 static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {=
}
=20
+void kvm_arm_init_debug(void);
+void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
+void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-of=
fsets.c
index c99701a..5c900d4 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -117,6 +117,7 @@ int main(void)
   DEFINE(VCPU_HPFAR_EL2,	offsetof(struct kvm_vcpu, arch.fault.hpfar_el=
2));
   DEFINE(VCPU_DEBUG_FLAGS,	offsetof(struct kvm_vcpu, arch.debug_flags)=
);
   DEFINE(VCPU_HCR_EL2,		offsetof(struct kvm_vcpu, arch.hcr_el2));
+  DEFINE(VCPU_MDCR_EL2,	offsetof(struct kvm_vcpu, arch.mdcr_el2));
   DEFINE(VCPU_IRQ_LINES,	offsetof(struct kvm_vcpu, arch.irq_lines));
   DEFINE(VCPU_HOST_CONTEXT,	offsetof(struct kvm_vcpu, arch.host_cpu_co=
ntext));
   DEFINE(VCPU_TIMER_CNTV_CTL,	offsetof(struct kvm_vcpu, arch.timer_cpu=
=2Ecntv_ctl));
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index f90f4aa..1949fe5 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -17,7 +17,7 @@ kvm-$(CONFIG_KVM_ARM_HOST) +=3D $(ARM)/psci.o $(ARM)/=
perf.o
=20
 kvm-$(CONFIG_KVM_ARM_HOST) +=3D emulate.o inject_fault.o regmap.o
 kvm-$(CONFIG_KVM_ARM_HOST) +=3D hyp.o hyp-init.o handle_exit.o
-kvm-$(CONFIG_KVM_ARM_HOST) +=3D guest.o reset.o sys_regs.o sys_regs_ge=
neric_v8.o
+kvm-$(CONFIG_KVM_ARM_HOST) +=3D guest.o debug.o reset.o sys_regs.o sys=
_regs_generic_v8.o
=20
 kvm-$(CONFIG_KVM_ARM_HOST) +=3D $(KVM)/arm/vgic.o
 kvm-$(CONFIG_KVM_ARM_HOST) +=3D $(KVM)/arm/vgic-v2.o
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
new file mode 100644
index 0000000..faf0e1f
--- /dev/null
+++ b/arch/arm64/kvm/debug.c
@@ -0,0 +1,81 @@
+/*
+ * Debug and Guest Debug support
+ *
+ * Copyright (C) 2015 - Linaro Ltd
+ * Author: Alex Benn=C3=A9e <alex.bennee@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/=
>.
+ */
+
+#include <linux/kvm_host.h>
+
+#include <asm/kvm_arm.h>
+
+static DEFINE_PER_CPU(u32, mdcr_el2);
+
+/**
+ * kvm_arm_init_debug - grab what we need for debug
+ *
+ * Currently the sole task of this function is to retrieve the initial
+ * value of mdcr_el2 so we can preserve MDCR_EL2.HPMN which has
+ * presumably been set-up by some knowledgeable bootcode.
+ *
+ * It is called once per-cpu during CPU hyp initialisation.
+ */
+
+void kvm_arm_init_debug(void)
+{
+	__this_cpu_write(mdcr_el2, kvm_call_hyp(__kvm_get_mdcr_el2));
+}
+
+
+/**
+ * kvm_arm_setup_debug - set up debug related stuff
+ *
+ * @vcpu:	the vcpu pointer
+ *
+ * This is called before each entry into the hypervisor to setup any
+ * debug related registers. Currently this just ensures we will trap
+ * access to:
+ *  - Performance monitors (MDCR_EL2_TPM/MDCR_EL2_TPMCR)
+ *  - Debug ROM Address (MDCR_EL2_TDRA)
+ *  - OS related registers (MDCR_EL2_TDOSA)
+ *
+ * Additionally, KVM only traps guest accesses to the debug registers =
if
+ * the guest is not actively using them (see the KVM_ARM64_DEBUG_DIRTY
+ * flag on vcpu->arch.debug_flags).  Since the guest must not interfer=
e
+ * with the hardware state when debugging the guest, we must ensure th=
at
+ * trapping is enabled whenever we are debugging the guest using the
+ * debug registers.
+ */
+
+void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
+{
+	bool trap_debug =3D !(vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY)=
;
+
+	vcpu->arch.mdcr_el2 =3D __this_cpu_read(mdcr_el2) & MDCR_EL2_HPMN_MAS=
K;
+	vcpu->arch.mdcr_el2 |=3D (MDCR_EL2_TPM |
+				MDCR_EL2_TPMCR |
+				MDCR_EL2_TDRA |
+				MDCR_EL2_TDOSA);
+
+	/* Trap on access to debug registers? */
+	if (trap_debug)
+		vcpu->arch.mdcr_el2 |=3D MDCR_EL2_TDA;
+
+}
+
+void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
+{
+	/* Nothing to do yet */
+}
diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
index 17a8fb1..b3176e6 100644
--- a/arch/arm64/kvm/hyp.S
+++ b/arch/arm64/kvm/hyp.S
@@ -770,17 +770,8 @@
 	mov	x2, #(1 << 15)	// Trap CP15 Cr=3D15
 	msr	hstr_el2, x2
=20
-	mrs	x2, mdcr_el2
-	and	x2, x2, #MDCR_EL2_HPMN_MASK
-	orr	x2, x2, #(MDCR_EL2_TPM | MDCR_EL2_TPMCR)
-	orr	x2, x2, #(MDCR_EL2_TDRA | MDCR_EL2_TDOSA)
-
-	// Check for KVM_ARM64_DEBUG_DIRTY, and set debug to trap
-	// if not dirty.
-	ldr	x3, [x0, #VCPU_DEBUG_FLAGS]
-	tbnz	x3, #KVM_ARM64_DEBUG_DIRTY_SHIFT, 1f
-	orr	x2, x2,  #MDCR_EL2_TDA
-1:
+	// Monitor Debug Config - see kvm_arm_setup_debug()
+	ldr	x2, [x0, #VCPU_MDCR_EL2]
 	msr	mdcr_el2, x2
 .endm
=20
@@ -1285,4 +1276,10 @@ ENTRY(__kvm_hyp_vector)
 	ventry	el1_error_invalid		// Error 32-bit EL1
 ENDPROC(__kvm_hyp_vector)
=20
+
+ENTRY(__kvm_get_mdcr_el2)
+	mrs	x0, mdcr_el2
+	ret
+ENDPROC(__kvm_get_mdcr_el2)
+
 	.popsection
--=20
2.1.4

