From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH v2 7/7] ARM: KVM: Unlock vgic-v3 support
Date: Tue, 16 Aug 2016 11:46:58 +0100
Message-ID: <1471344418-19568-8-git-send-email-vladimir.murzin@arm.com>
References: <1471344418-19568-1-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A0F3349B46
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Aug 2016 06:39:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4CEfNlgUIN77 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Aug 2016 06:39:54 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FA9649B83
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Aug 2016 06:39:52 -0400 (EDT)
In-Reply-To: <1471344418-19568-1-git-send-email-vladimir.murzin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: marc.zyngier@arm.com, andre.przywara@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

It is time to get access to common version of vgic-v3.

We basically would need to tell build system how to pick it up and
undo KVM_ARM_VGIC_V3 guarding introduced in 4f64cb6 ("arm/arm64: KVM:
Only allow 64bit hosts to build VGICv3") and remove stubs. However,
since vgic got ITS support KVM_ARM_VGIC_V3 tend to protect a little
bit more than just plain vgic-v3 - this guard is used for ITS too
which is not supported in 32-bit world yet.  So, along with removal of
KVM_ARM_VGIC_V3 guard introduce the new one - KVM_ARM_VGIC_V3_ITS to
protect ITS related code.

The only unpleasant part is how we decide which save/restore sequence to
use under __vgic_save_state() - we don't have patching framework in hand
like arm64, so have to check runtime on every invocation.

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
---
 arch/arm/include/asm/kvm_host.h     |    4 +++
 arch/arm/include/asm/kvm_hyp.h      |    5 ++++
 arch/arm/kvm/Makefile               |    2 ++
 arch/arm/kvm/hyp/Makefile           |    1 +
 arch/arm/kvm/hyp/switch.c           |   20 +++++++++++--
 arch/arm64/kvm/Kconfig              |    4 +--
 include/kvm/arm_vgic.h              |    8 ------
 virt/kvm/arm/vgic/vgic-kvm-device.c |   10 ++-----
 virt/kvm/arm/vgic/vgic-mmio-v3.c    |    2 ++
 virt/kvm/arm/vgic/vgic-mmio.c       |    2 --
 virt/kvm/arm/vgic/vgic-mmio.h       |    3 --
 virt/kvm/arm/vgic/vgic.h            |   54 ++---------------------------------
 12 files changed, 38 insertions(+), 77 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index de338d9..1312597 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -39,7 +39,11 @@
 
 #include <kvm/arm_vgic.h>
 
+#ifdef CONFIG_ARM_GIC_V3
+#define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
+#else
 #define KVM_MAX_VCPUS VGIC_V2_MAX_CPUS
+#endif
 
 #define KVM_REQ_VCPU_EXIT	8
 
diff --git a/arch/arm/include/asm/kvm_hyp.h b/arch/arm/include/asm/kvm_hyp.h
index e604ad68..95669b3 100644
--- a/arch/arm/include/asm/kvm_hyp.h
+++ b/arch/arm/include/asm/kvm_hyp.h
@@ -88,6 +88,8 @@
 
 #define VFP_FPEXC	__ACCESS_VFP(FPEXC)
 
+#define ID_PFR1		__ACCESS_CP15(c0, 0, c1, 1)
+
 /* AArch64 compatibility macros, only for the timer so far */
 #define read_sysreg_el0(r)		read_sysreg(r##_el0)
 #define write_sysreg_el0(v, r)		write_sysreg(v, r##_el0)
@@ -103,6 +105,9 @@ void __timer_restore_state(struct kvm_vcpu *vcpu);
 void __vgic_v2_save_state(struct kvm_vcpu *vcpu);
 void __vgic_v2_restore_state(struct kvm_vcpu *vcpu);
 
+void __vgic_v3_save_state(struct kvm_vcpu *vcpu);
+void __vgic_v3_restore_state(struct kvm_vcpu *vcpu);
+
 void __sysreg_save_state(struct kvm_cpu_context *ctxt);
 void __sysreg_restore_state(struct kvm_cpu_context *ctxt);
 
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
index b13caa9..9666bae 100644
--- a/arch/arm/kvm/hyp/switch.c
+++ b/arch/arm/kvm/hyp/switch.c
@@ -15,6 +15,8 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
+#include <linux/irqchip/arm-gic-v3.h>
+
 #include <asm/kvm_asm.h>
 #include <asm/kvm_hyp.h>
 
@@ -74,14 +76,28 @@ static void __hyp_text __deactivate_vm(struct kvm_vcpu *vcpu)
 	write_sysreg(read_sysreg(MIDR), VPIDR);
 }
 
+static bool __hyp_text __has_useable_gicv3_cpuif(void)
+{
+	if (IS_ENABLED(CONFIG_ARM_GIC_V3) && (read_sysreg(ID_PFR1) >> 28))
+		return !!(read_sysreg(ICC_HSRE) & ICC_SRE_EL2_SRE);
+	else
+		return false;
+}
+
 static void __hyp_text __vgic_save_state(struct kvm_vcpu *vcpu)
 {
-	__vgic_v2_save_state(vcpu);
+	if (__has_useable_gicv3_cpuif())
+		__vgic_v3_save_state(vcpu);
+	else
+		__vgic_v2_save_state(vcpu);
 }
 
 static void __hyp_text __vgic_restore_state(struct kvm_vcpu *vcpu)
 {
-	__vgic_v2_restore_state(vcpu);
+	if (__has_useable_gicv3_cpuif())
+		__vgic_v3_restore_state(vcpu);
+	else
+		__vgic_v2_restore_state(vcpu);
 }
 
 static bool __hyp_text __populate_fault_info(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 9c9edc9..6eaf12c 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -16,7 +16,7 @@ menuconfig VIRTUALIZATION
 
 if VIRTUALIZATION
 
-config KVM_ARM_VGIC_V3
+config KVM_ARM_VGIC_V3_ITS
 	bool
 
 config KVM
@@ -34,7 +34,7 @@ config KVM
 	select KVM_VFIO
 	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_IRQFD
-	select KVM_ARM_VGIC_V3
+	select KVM_ARM_VGIC_V3_ITS
 	select KVM_ARM_PMU if HW_PERF_EVENTS
 	select HAVE_KVM_MSI
 	select HAVE_KVM_IRQCHIP
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
index 1813f93..e4f0c33 100644
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
@@ -219,15 +217,15 @@ int kvm_register_vgic_device(unsigned long type)
 		ret = kvm_register_device_ops(&kvm_arm_vgic_v2_ops,
 					      KVM_DEV_TYPE_ARM_VGIC_V2);
 		break;
-#ifdef CONFIG_KVM_ARM_VGIC_V3
 	case KVM_DEV_TYPE_ARM_VGIC_V3:
 		ret = kvm_register_device_ops(&kvm_arm_vgic_v3_ops,
 					      KVM_DEV_TYPE_ARM_VGIC_V3);
+#ifdef CONFIG_KVM_ARM_VGIC_V3_ITS
 		if (ret)
 			break;
 		ret = kvm_vgic_register_its_device();
-		break;
 #endif
+		break;
 	}
 
 	return ret;
@@ -389,8 +387,6 @@ struct kvm_device_ops kvm_arm_vgic_v2_ops = {
 
 /* V3 ops */
 
-#ifdef CONFIG_KVM_ARM_VGIC_V3
-
 static int vgic_v3_set_attr(struct kvm_device *dev,
 			    struct kvm_device_attr *attr)
 {
@@ -433,5 +429,3 @@ struct kvm_device_ops kvm_arm_vgic_v3_ops = {
 	.get_attr = vgic_v3_get_attr,
 	.has_attr = vgic_v3_has_attr,
 };
-
-#endif /* CONFIG_KVM_ARM_VGIC_V3 */
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index cc20b60..4709dd65 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -42,6 +42,7 @@ u64 update_64bit_reg(u64 reg, unsigned int offset, unsigned int len,
 	return reg | ((u64)val << lower);
 }
 
+#ifdef CONFIG_KVM_ARM_VGIC_V3_ITS
 bool vgic_has_its(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
@@ -51,6 +52,7 @@ bool vgic_has_its(struct kvm *kvm)
 
 	return dist->has_its;
 }
+#endif
 
 static unsigned long vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
 					    gpa_t addr, unsigned int len)
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
index 80f92ce..9098aca 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.h
+++ b/virt/kvm/arm/vgic/vgic-mmio.h
@@ -162,12 +162,9 @@ unsigned int vgic_v2_init_dist_iodev(struct vgic_io_device *dev);
 
 unsigned int vgic_v3_init_dist_iodev(struct vgic_io_device *dev);
 
-#ifdef CONFIG_KVM_ARM_VGIC_V3
 u64 vgic_sanitise_outer_cacheability(u64 reg);
 u64 vgic_sanitise_inner_cacheability(u64 reg);
 u64 vgic_sanitise_shareability(u64 reg);
 u64 vgic_sanitise_field(u64 reg, u64 field_mask, int field_shift,
 			u64 (*sanitise_fn)(u64));
 #endif
-
-#endif
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 1d8e21d..633c512 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -72,7 +72,6 @@ static inline void vgic_get_irq_kref(struct vgic_irq *irq)
 	kref_get(&irq->refcount);
 }
 
-#ifdef CONFIG_KVM_ARM_VGIC_V3
 void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu);
 void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu);
 void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
@@ -84,62 +83,13 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu);
 int vgic_v3_probe(const struct gic_kvm_info *info);
 int vgic_v3_map_resources(struct kvm *kvm);
 int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t dist_base_address);
+
+#ifdef CONFIG_KVM_ARM_VGIC_V3_ITS
 bool vgic_has_its(struct kvm *kvm);
 int kvm_vgic_register_its_device(void);
 void vgic_enable_lpis(struct kvm_vcpu *vcpu);
 int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi);
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
 static inline bool vgic_has_its(struct kvm *kvm)
 {
 	return false;
-- 
1.7.9.5
