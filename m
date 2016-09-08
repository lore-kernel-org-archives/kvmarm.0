From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH v3 8/8] ARM: KVM: Support vgic-v3
Date: Thu,  8 Sep 2016 17:06:50 +0100
Message-ID: <1473350810-10857-9-git-send-email-vladimir.murzin@arm.com>
References: <1473350810-10857-1-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C8A149B5C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Sep 2016 11:59:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RLJ+0NWAknTb for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Sep 2016 11:59:46 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D26749B4A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Sep 2016 11:59:45 -0400 (EDT)
In-Reply-To: <1473350810-10857-1-git-send-email-vladimir.murzin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, andre.przywara@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch allows to build and use vgic-v3 in 32-bit mode.

Unfortunately, it can not be split in several steps without extra
stubs to keep patches independent and bisectable.
For instance, virt/kvm/arm/vgic/vgic-v3.c uses function from
vgic-v3-sr.c, handling access to GICv3 cpu interface from the guest
requires vgic_v3.vgic_sre to be already defined.

It is how support has been done:

* vgic-v3 save/restore routines are written in such way that they map
  arm64 system register naming nicely, but it does not fit to arm
  world. To keep virt/kvm/arm/hyp/vgic-v3-sr.c untouched we create a
  mapping with a function for each register mapping the 32-bit to the
  64-bit accessors

* report configured SRE on access to GICv3 cpu interface from the guest

* required vgic-v3 macros are provided via uapi.h

* static keys are used to select GIC backend

* to make vgic-v3 build KVM_ARM_VGIC_V3 guard is removed along with
  the static inlines

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
---
 arch/arm/include/asm/arch_gicv3.h   |   64 +++++++++++++++++++++++++++++++++++
 arch/arm/include/asm/kvm_asm.h      |    3 ++
 arch/arm/include/asm/kvm_hyp.h      |    3 ++
 arch/arm/include/uapi/asm/kvm.h     |    7 ++++
 arch/arm/kvm/Makefile               |    2 ++
 arch/arm/kvm/coproc.c               |   36 ++++++++++++++++++++
 arch/arm/kvm/hyp/Makefile           |    1 +
 arch/arm/kvm/hyp/switch.c           |   12 +++++--
 arch/arm64/kvm/Kconfig              |    4 ---
 include/kvm/arm_vgic.h              |    8 -----
 virt/kvm/arm/vgic/vgic-kvm-device.c |    8 -----
 virt/kvm/arm/vgic/vgic-mmio.c       |    2 --
 virt/kvm/arm/vgic/vgic-mmio.h       |    2 --
 virt/kvm/arm/vgic/vgic.h            |   54 -----------------------------
 14 files changed, 126 insertions(+), 80 deletions(-)

diff --git a/arch/arm/include/asm/arch_gicv3.h b/arch/arm/include/asm/arch_gicv3.h
index af25c32..f93f6bd 100644
--- a/arch/arm/include/asm/arch_gicv3.h
+++ b/arch/arm/include/asm/arch_gicv3.h
@@ -96,6 +96,70 @@
 #define ICH_AP1R2			__AP1Rx(2)
 #define ICH_AP1R3			__AP1Rx(3)
 
+/* A32-to-A64 mappings used by VGIC save/restore */
+
+#define CPUIF_MAP(a32, a64)			\
+static inline void write_ ## a64(u32 val)	\
+{						\
+	write_sysreg(val, a32);			\
+}						\
+static inline u32 read_ ## a64(void)		\
+{						\
+	return read_sysreg(a32); 		\
+}						\
+
+#define CPUIF_MAP_LO_HI(a32lo, a32hi, a64)	\
+static inline void write_ ## a64(u64 val)	\
+{						\
+	write_sysreg((u32)val, a32lo);		\
+	write_sysreg((u32)(val >> 32), a32hi);	\
+}						\
+static inline u64 read_ ## a64(void)		\
+{						\
+	u64 val = read_sysreg(a32lo);		\
+						\
+	val |=	(u64)read_sysreg(a32hi) << 32;	\
+						\
+	return val; 				\
+}
+
+CPUIF_MAP(ICH_HCR, ICH_HCR_EL2)
+CPUIF_MAP(ICH_VTR, ICH_VTR_EL2)
+CPUIF_MAP(ICH_MISR, ICH_MISR_EL2)
+CPUIF_MAP(ICH_EISR, ICH_EISR_EL2)
+CPUIF_MAP(ICH_ELSR, ICH_ELSR_EL2)
+CPUIF_MAP(ICH_VMCR, ICH_VMCR_EL2)
+CPUIF_MAP(ICH_AP0R3, ICH_AP0R3_EL2)
+CPUIF_MAP(ICH_AP0R2, ICH_AP0R2_EL2)
+CPUIF_MAP(ICH_AP0R1, ICH_AP0R1_EL2)
+CPUIF_MAP(ICH_AP0R0, ICH_AP0R0_EL2)
+CPUIF_MAP(ICH_AP1R3, ICH_AP1R3_EL2)
+CPUIF_MAP(ICH_AP1R2, ICH_AP1R2_EL2)
+CPUIF_MAP(ICH_AP1R1, ICH_AP1R1_EL2)
+CPUIF_MAP(ICH_AP1R0, ICH_AP1R0_EL2)
+CPUIF_MAP(ICC_HSRE, ICC_SRE_EL2)
+CPUIF_MAP(ICC_SRE, ICC_SRE_EL1)
+
+CPUIF_MAP_LO_HI(ICH_LR15, ICH_LRC15, ICH_LR15_EL2)
+CPUIF_MAP_LO_HI(ICH_LR14, ICH_LRC14, ICH_LR14_EL2)
+CPUIF_MAP_LO_HI(ICH_LR13, ICH_LRC13, ICH_LR13_EL2)
+CPUIF_MAP_LO_HI(ICH_LR12, ICH_LRC12, ICH_LR12_EL2)
+CPUIF_MAP_LO_HI(ICH_LR11, ICH_LRC11, ICH_LR11_EL2)
+CPUIF_MAP_LO_HI(ICH_LR10, ICH_LRC10, ICH_LR10_EL2)
+CPUIF_MAP_LO_HI(ICH_LR9, ICH_LRC9, ICH_LR9_EL2)
+CPUIF_MAP_LO_HI(ICH_LR8, ICH_LRC8, ICH_LR8_EL2)
+CPUIF_MAP_LO_HI(ICH_LR7, ICH_LRC7, ICH_LR7_EL2)
+CPUIF_MAP_LO_HI(ICH_LR6, ICH_LRC6, ICH_LR6_EL2)
+CPUIF_MAP_LO_HI(ICH_LR5, ICH_LRC5, ICH_LR5_EL2)
+CPUIF_MAP_LO_HI(ICH_LR4, ICH_LRC4, ICH_LR4_EL2)
+CPUIF_MAP_LO_HI(ICH_LR3, ICH_LRC3, ICH_LR3_EL2)
+CPUIF_MAP_LO_HI(ICH_LR2, ICH_LRC2, ICH_LR2_EL2)
+CPUIF_MAP_LO_HI(ICH_LR1, ICH_LRC1, ICH_LR1_EL2)
+CPUIF_MAP_LO_HI(ICH_LR0, ICH_LRC0, ICH_LR0_EL2)
+
+#define read_gicreg(r)                 read_##r()
+#define write_gicreg(v, r)             write_##r(v)
+
 /* Low-level accessors */
 
 static inline void gic_write_eoir(u32 irq)
diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
index 58faff5..dfccf94 100644
--- a/arch/arm/include/asm/kvm_asm.h
+++ b/arch/arm/include/asm/kvm_asm.h
@@ -68,6 +68,9 @@ extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 extern void __init_stage2_translation(void);
 
 extern void __kvm_hyp_reset(unsigned long);
+
+extern u64 __vgic_v3_get_ich_vtr_el2(void);
+extern void __vgic_v3_init_lrs(void);
 #endif
 
 #endif /* __ARM_KVM_ASM_H__ */
diff --git a/arch/arm/include/asm/kvm_hyp.h b/arch/arm/include/asm/kvm_hyp.h
index 0b475d2..ed96cf9 100644
--- a/arch/arm/include/asm/kvm_hyp.h
+++ b/arch/arm/include/asm/kvm_hyp.h
@@ -104,6 +104,9 @@ void __vgic_v2_restore_state(struct kvm_vcpu *vcpu);
 void __sysreg_save_state(struct kvm_cpu_context *ctxt);
 void __sysreg_restore_state(struct kvm_cpu_context *ctxt);
 
+void __vgic_v3_save_state(struct kvm_vcpu *vcpu);
+void __vgic_v3_restore_state(struct kvm_vcpu *vcpu);
+
 void asmlinkage __vfp_save_state(struct vfp_hard_struct *vfp);
 void asmlinkage __vfp_restore_state(struct vfp_hard_struct *vfp);
 static inline bool __vfp_enabled(void)
diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
index a2b3eb3..b38c10c 100644
--- a/arch/arm/include/uapi/asm/kvm.h
+++ b/arch/arm/include/uapi/asm/kvm.h
@@ -84,6 +84,13 @@ struct kvm_regs {
 #define KVM_VGIC_V2_DIST_SIZE		0x1000
 #define KVM_VGIC_V2_CPU_SIZE		0x2000
 
+/* Supported VGICv3 address types  */
+#define KVM_VGIC_V3_ADDR_TYPE_DIST	2
+#define KVM_VGIC_V3_ADDR_TYPE_REDIST	3
+
+#define KVM_VGIC_V3_DIST_SIZE		SZ_64K
+#define KVM_VGIC_V3_REDIST_SIZE		(2 * SZ_64K)
+
 #define KVM_ARM_VCPU_POWER_OFF		0 /* CPU is started in OFF state */
 #define KVM_ARM_VCPU_PSCI_0_2		1 /* CPU uses PSCI v0.2 */
 
diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
index 10d77a6..043d817f 100644
--- a/arch/arm/kvm/Makefile
+++ b/arch/arm/kvm/Makefile
@@ -26,8 +26,10 @@ obj-y += $(KVM)/arm/vgic/vgic.o
 obj-y += $(KVM)/arm/vgic/vgic-init.o
 obj-y += $(KVM)/arm/vgic/vgic-irqfd.o
 obj-y += $(KVM)/arm/vgic/vgic-v2.o
+obj-y += $(KVM)/arm/vgic/vgic-v3.o
 obj-y += $(KVM)/arm/vgic/vgic-mmio.o
 obj-y += $(KVM)/arm/vgic/vgic-mmio-v2.o
+obj-y += $(KVM)/arm/vgic/vgic-mmio-v3.o
 obj-y += $(KVM)/arm/vgic/vgic-kvm-device.o
 obj-y += $(KVM)/irqchip.o
 obj-y += $(KVM)/arm/arch_timer.o
diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
index 1bb2b79..10c0244 100644
--- a/arch/arm/kvm/coproc.c
+++ b/arch/arm/kvm/coproc.c
@@ -228,6 +228,36 @@ bool access_vm_reg(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static bool access_gic_sgi(struct kvm_vcpu *vcpu,
+			   const struct coproc_params *p,
+			   const struct coproc_reg *r)
+{
+	u64 reg;
+
+	if (!p->is_write)
+		return read_from_write_only(vcpu, p);
+
+	reg = *vcpu_reg(vcpu, p->Rt2);
+	reg <<= 32;
+	reg |= *vcpu_reg(vcpu, p->Rt1) ;
+
+	vgic_v3_dispatch_sgi(vcpu, reg);
+
+	return true;
+}
+
+static bool access_gic_sre(struct kvm_vcpu *vcpu,
+			   const struct coproc_params *p,
+			   const struct coproc_reg *r)
+{
+	if (p->is_write)
+		return ignore_write(vcpu, p);
+
+	*vcpu_reg(vcpu, p->Rt1) = vcpu->arch.vgic_cpu.vgic_v3.vgic_sre;
+
+	return true;
+}
+
 /*
  * We could trap ID_DFR0 and tell the guest we don't support performance
  * monitoring.  Unfortunately the patch to make the kernel check ID_DFR0 was
@@ -361,10 +391,16 @@ static const struct coproc_reg cp15_regs[] = {
 	{ CRn(10), CRm( 3), Op1( 0), Op2( 1), is32,
 			access_vm_reg, reset_unknown, c10_AMAIR1},
 
+	/* ICC_SGI1R */
+	{ CRm64(12), Op1( 0), is64, access_gic_sgi},
+
 	/* VBAR: swapped by interrupt.S. */
 	{ CRn(12), CRm( 0), Op1( 0), Op2( 0), is32,
 			NULL, reset_val, c12_VBAR, 0x00000000 },
 
+	/* ICC_SRE */
+	{ CRn(12), CRm(12), Op1( 0), Op2(5), is32, access_gic_sre },
+
 	/* CONTEXTIDR/TPIDRURW/TPIDRURO/TPIDRPRW: swapped by interrupt.S. */
 	{ CRn(13), CRm( 0), Op1( 0), Op2( 1), is32,
 			access_vm_reg, reset_val, c13_CID, 0x00000000 },
diff --git a/arch/arm/kvm/hyp/Makefile b/arch/arm/kvm/hyp/Makefile
index 8dfa5f7..3023bb5 100644
--- a/arch/arm/kvm/hyp/Makefile
+++ b/arch/arm/kvm/hyp/Makefile
@@ -5,6 +5,7 @@
 KVM=../../../../virt/kvm
 
 obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/vgic-v2-sr.o
+obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/vgic-v3-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/timer-sr.o
 
 obj-$(CONFIG_KVM_ARM_HOST) += tlb.o
diff --git a/arch/arm/kvm/hyp/switch.c b/arch/arm/kvm/hyp/switch.c
index b13caa9..8409dd5 100644
--- a/arch/arm/kvm/hyp/switch.c
+++ b/arch/arm/kvm/hyp/switch.c
@@ -14,6 +14,7 @@
  * You should have received a copy of the GNU General Public License
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
+#include <linux/jump_label.h>
 
 #include <asm/kvm_asm.h>
 #include <asm/kvm_hyp.h>
@@ -74,14 +75,21 @@ static void __hyp_text __deactivate_vm(struct kvm_vcpu *vcpu)
 	write_sysreg(read_sysreg(MIDR), VPIDR);
 }
 
+
 static void __hyp_text __vgic_save_state(struct kvm_vcpu *vcpu)
 {
-	__vgic_v2_save_state(vcpu);
+	if (static_branch_unlikely(&kvm_gicv3_cpuif))
+		__vgic_v3_save_state(vcpu);
+	else
+		__vgic_v2_save_state(vcpu);
 }
 
 static void __hyp_text __vgic_restore_state(struct kvm_vcpu *vcpu)
 {
-	__vgic_v2_restore_state(vcpu);
+	if (static_branch_unlikely(&kvm_gicv3_cpuif))
+		__vgic_v3_restore_state(vcpu);
+	else
+		__vgic_v2_restore_state(vcpu);
 }
 
 static bool __hyp_text __populate_fault_info(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 7ba9164..6eaf12c 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -19,9 +19,6 @@ if VIRTUALIZATION
 config KVM_ARM_VGIC_V3_ITS
 	bool
 
-config KVM_ARM_VGIC_V3
-	bool
-
 config KVM
 	bool "Kernel-based Virtual Machine (KVM) support"
 	depends on OF
@@ -37,7 +34,6 @@ config KVM
 	select KVM_VFIO
 	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_IRQFD
-	select KVM_ARM_VGIC_V3
 	select KVM_ARM_VGIC_V3_ITS
 	select KVM_ARM_PMU if HW_PERF_EVENTS
 	select HAVE_KVM_MSI
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 19b698e..7462138 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -217,7 +217,6 @@ struct vgic_v2_cpu_if {
 };
 
 struct vgic_v3_cpu_if {
-#ifdef CONFIG_KVM_ARM_VGIC_V3
 	u32		vgic_hcr;
 	u32		vgic_vmcr;
 	u32		vgic_sre;	/* Restored only, change ignored */
@@ -227,7 +226,6 @@ struct vgic_v3_cpu_if {
 	u32		vgic_ap0r[4];
 	u32		vgic_ap1r[4];
 	u64		vgic_lr[VGIC_V3_MAX_LRS];
-#endif
 };
 
 struct vgic_cpu {
@@ -294,13 +292,7 @@ bool kvm_vcpu_has_pending_irqs(struct kvm_vcpu *vcpu);
 void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu);
 void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu);
 
-#ifdef CONFIG_KVM_ARM_VGIC_V3
 void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg);
-#else
-static inline void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg)
-{
-}
-#endif
 
 /**
  * kvm_vgic_get_max_vcpus - Get the maximum number of VCPUs allowed by HW
diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
index f3811b3..4dc026a 100644
--- a/virt/kvm/arm/vgic/vgic-kvm-device.c
+++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
@@ -71,7 +71,6 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
 		addr_ptr = &vgic->vgic_cpu_base;
 		alignment = SZ_4K;
 		break;
-#ifdef CONFIG_KVM_ARM_VGIC_V3
 	case KVM_VGIC_V3_ADDR_TYPE_DIST:
 		type_needed = KVM_DEV_TYPE_ARM_VGIC_V3;
 		addr_ptr = &vgic->vgic_dist_base;
@@ -82,7 +81,6 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
 		addr_ptr = &vgic->vgic_redist_base;
 		alignment = SZ_64K;
 		break;
-#endif
 	default:
 		r = -ENODEV;
 		goto out;
@@ -219,7 +217,6 @@ int kvm_register_vgic_device(unsigned long type)
 		ret = kvm_register_device_ops(&kvm_arm_vgic_v2_ops,
 					      KVM_DEV_TYPE_ARM_VGIC_V2);
 		break;
-#ifdef CONFIG_KVM_ARM_VGIC_V3
 	case KVM_DEV_TYPE_ARM_VGIC_V3:
 		ret = kvm_register_device_ops(&kvm_arm_vgic_v3_ops,
 					      KVM_DEV_TYPE_ARM_VGIC_V3);
@@ -230,7 +227,6 @@ int kvm_register_vgic_device(unsigned long type)
 		ret = kvm_vgic_register_its_device();
 #endif
 		break;
-#endif
 	}
 
 	return ret;
@@ -392,8 +388,6 @@ struct kvm_device_ops kvm_arm_vgic_v2_ops = {
 
 /* V3 ops */
 
-#ifdef CONFIG_KVM_ARM_VGIC_V3
-
 static int vgic_v3_set_attr(struct kvm_device *dev,
 			    struct kvm_device_attr *attr)
 {
@@ -436,5 +430,3 @@ struct kvm_device_ops kvm_arm_vgic_v3_ops = {
 	.get_attr = vgic_v3_get_attr,
 	.has_attr = vgic_v3_has_attr,
 };
-
-#endif /* CONFIG_KVM_ARM_VGIC_V3 */
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index 3bad3c5..e18b30d 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -550,11 +550,9 @@ int vgic_register_dist_iodev(struct kvm *kvm, gpa_t dist_base_address,
 	case VGIC_V2:
 		len = vgic_v2_init_dist_iodev(io_device);
 		break;
-#ifdef CONFIG_KVM_ARM_VGIC_V3
 	case VGIC_V3:
 		len = vgic_v3_init_dist_iodev(io_device);
 		break;
-#endif
 	default:
 		BUG_ON(1);
 	}
diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
index 80f92ce..4c34d39 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.h
+++ b/virt/kvm/arm/vgic/vgic-mmio.h
@@ -162,12 +162,10 @@ unsigned int vgic_v2_init_dist_iodev(struct vgic_io_device *dev);
 
 unsigned int vgic_v3_init_dist_iodev(struct vgic_io_device *dev);
 
-#ifdef CONFIG_KVM_ARM_VGIC_V3
 u64 vgic_sanitise_outer_cacheability(u64 reg);
 u64 vgic_sanitise_inner_cacheability(u64 reg);
 u64 vgic_sanitise_shareability(u64 reg);
 u64 vgic_sanitise_field(u64 reg, u64 field_mask, int field_shift,
 			u64 (*sanitise_fn)(u64));
-#endif
 
 #endif
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 100045f..9d9e014 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -72,7 +72,6 @@ static inline void vgic_get_irq_kref(struct vgic_irq *irq)
 	kref_get(&irq->refcount);
 }
 
-#ifdef CONFIG_KVM_ARM_VGIC_V3
 void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu);
 void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu);
 void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
@@ -91,60 +90,7 @@ bool vgic_has_its(struct kvm *kvm);
 int kvm_vgic_register_its_device(void);
 void vgic_enable_lpis(struct kvm_vcpu *vcpu);
 int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi);
-#endif
-
 #else
-static inline void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu)
-{
-}
-
-static inline void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
-{
-}
-
-static inline void vgic_v3_populate_lr(struct kvm_vcpu *vcpu,
-				       struct vgic_irq *irq, int lr)
-{
-}
-
-static inline void vgic_v3_clear_lr(struct kvm_vcpu *vcpu, int lr)
-{
-}
-
-static inline void vgic_v3_set_underflow(struct kvm_vcpu *vcpu)
-{
-}
-
-static inline
-void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
-{
-}
-
-static inline
-void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
-{
-}
-
-static inline void vgic_v3_enable(struct kvm_vcpu *vcpu)
-{
-}
-
-static inline int vgic_v3_probe(const struct gic_kvm_info *info)
-{
-	return -ENODEV;
-}
-
-static inline int vgic_v3_map_resources(struct kvm *kvm)
-{
-	return -ENODEV;
-}
-
-static inline int vgic_register_redist_iodevs(struct kvm *kvm,
-					      gpa_t dist_base_address)
-{
-	return -ENODEV;
-}
-
 static inline int vgic_register_its_iodevs(struct kvm *kvm)
 {
 	return -ENODEV;
-- 
1.7.9.5
