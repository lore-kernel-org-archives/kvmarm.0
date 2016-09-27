From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 46/50] ARM: KVM: Support vgic-v3
Date: Tue, 27 Sep 2016 20:05:54 +0200
Message-ID: <20160927180558.14699-47-christoffer.dall@linaro.org>
References: <20160927180558.14699-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF0D649B77
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:57:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6HHOreF39ZEV for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Sep 2016 13:57:13 -0400 (EDT)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 851C349BE5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:57:10 -0400 (EDT)
Received: by mail-wm0-f44.google.com with SMTP id w84so190377366wmg.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 11:06:33 -0700 (PDT)
In-Reply-To: <20160927180558.14699-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Vladimir Murzin <vladimir.murzin@arm.com>

This patch allows to build and use vgic-v3 in 32-bit mode.

Unfortunately, it can not be split in several steps without extra
stubs to keep patches independent and bisectable.  For instance,
virt/kvm/arm/vgic/vgic-v3.c uses function from vgic-v3-sr.c, handling
access to GICv3 cpu interface from the guest requires vgic_v3.vgic_sre
to be already defined.

It is how support has been done:

* handle SGI requests from the guest

* report configured SRE on access to GICv3 cpu interface from the guest

* required vgic-v3 macros are provided via uapi.h

* static keys are used to select GIC backend

* to make vgic-v3 build KVM_ARM_VGIC_V3 guard is removed along with
  the static inlines

Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/include/asm/kvm_asm.h      |  3 +++
 arch/arm/include/asm/kvm_host.h     |  5 ++++
 arch/arm/include/asm/kvm_hyp.h      |  3 +++
 arch/arm/include/uapi/asm/kvm.h     |  7 +++++
 arch/arm/kvm/Makefile               |  2 ++
 arch/arm/kvm/coproc.c               | 35 ++++++++++++++++++++++++
 arch/arm/kvm/hyp/Makefile           |  1 +
 arch/arm/kvm/hyp/switch.c           | 12 +++++++--
 arch/arm64/kvm/Kconfig              |  4 ---
 include/kvm/arm_vgic.h              |  8 ------
 virt/kvm/arm/vgic/vgic-kvm-device.c |  8 ------
 virt/kvm/arm/vgic/vgic-mmio.c       |  2 --
 virt/kvm/arm/vgic/vgic-mmio.h       |  2 --
 virt/kvm/arm/vgic/vgic.h            | 54 -------------------------------------
 14 files changed, 66 insertions(+), 80 deletions(-)

diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
index 05e47fa..d7ea6bc 100644
--- a/arch/arm/include/asm/kvm_asm.h
+++ b/arch/arm/include/asm/kvm_asm.h
@@ -72,6 +72,9 @@ extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 extern void __init_stage2_translation(void);
 
 extern void __kvm_hyp_reset(unsigned long);
+
+extern u64 __vgic_v3_get_ich_vtr_el2(void);
+extern void __vgic_v3_init_lrs(void);
 #endif
 
 #endif /* __ARM_KVM_ASM_H__ */
diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index de338d9..c2c40a7 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -39,7 +39,12 @@
 
 #include <kvm/arm_vgic.h>
 
+
+#ifdef CONFIG_ARM_GIC_V3
+#define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
+#else
 #define KVM_MAX_VCPUS VGIC_V2_MAX_CPUS
+#endif
 
 #define KVM_REQ_VCPU_EXIT	8
 
diff --git a/arch/arm/include/asm/kvm_hyp.h b/arch/arm/include/asm/kvm_hyp.h
index e604ad68..343135e 100644
--- a/arch/arm/include/asm/kvm_hyp.h
+++ b/arch/arm/include/asm/kvm_hyp.h
@@ -106,6 +106,9 @@ void __vgic_v2_restore_state(struct kvm_vcpu *vcpu);
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
index 339ec88..f19842e 100644
--- a/arch/arm/kvm/Makefile
+++ b/arch/arm/kvm/Makefile
@@ -27,8 +27,10 @@ obj-y += $(KVM)/arm/vgic/vgic.o
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
index 1bb2b79..3e5e419 100644
--- a/arch/arm/kvm/coproc.c
+++ b/arch/arm/kvm/coproc.c
@@ -228,6 +228,35 @@ bool access_vm_reg(struct kvm_vcpu *vcpu,
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
+	reg = (u64)*vcpu_reg(vcpu, p->Rt2) << 32;
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
@@ -361,10 +390,16 @@ static const struct coproc_reg cp15_regs[] = {
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
index 9da16fd..92678b7 100644
--- a/arch/arm/kvm/hyp/switch.c
+++ b/arch/arm/kvm/hyp/switch.c
@@ -14,6 +14,7 @@
  * You should have received a copy of the GNU General Public License
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
+#include <linux/jump_label.h>
 
 #include <asm/kvm_asm.h>
 #include <asm/kvm_hyp.h>
@@ -83,14 +84,21 @@ static void __hyp_text __deactivate_vm(struct kvm_vcpu *vcpu)
 	write_sysreg(read_sysreg(MIDR), VPIDR);
 }
 
+
 static void __hyp_text __vgic_save_state(struct kvm_vcpu *vcpu)
 {
-	__vgic_v2_save_state(vcpu);
+	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+		__vgic_v3_save_state(vcpu);
+	else
+		__vgic_v2_save_state(vcpu);
 }
 
 static void __hyp_text __vgic_restore_state(struct kvm_vcpu *vcpu)
 {
-	__vgic_v2_restore_state(vcpu);
+	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
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
index 8d22adc..002f092 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -225,7 +225,6 @@ struct vgic_v2_cpu_if {
 };
 
 struct vgic_v3_cpu_if {
-#ifdef CONFIG_KVM_ARM_VGIC_V3
 	u32		vgic_hcr;
 	u32		vgic_vmcr;
 	u32		vgic_sre;	/* Restored only, change ignored */
@@ -235,7 +234,6 @@ struct vgic_v3_cpu_if {
 	u32		vgic_ap0r[4];
 	u32		vgic_ap1r[4];
 	u64		vgic_lr[VGIC_V3_MAX_LRS];
-#endif
 };
 
 struct vgic_cpu {
@@ -304,13 +302,7 @@ bool kvm_vcpu_has_pending_irqs(struct kvm_vcpu *vcpu);
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
index 89ef9bc..ce1f4ed 100644
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
@@ -434,8 +430,6 @@ struct kvm_device_ops kvm_arm_vgic_v2_ops = {
 	.has_attr = vgic_v2_has_attr,
 };
 
-#ifdef CONFIG_KVM_ARM_VGIC_V3
-
 static int vgic_v3_set_attr(struct kvm_device *dev,
 			    struct kvm_device_attr *attr)
 {
@@ -478,5 +472,3 @@ struct kvm_device_ops kvm_arm_vgic_v3_ops = {
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
2.9.0
