From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH 7/7] ARM: KVM: Unlock vgic-v3 support
Date: Mon, 18 Jul 2016 11:48:19 +0100
Message-ID: <1468838899-34909-8-git-send-email-vladimir.murzin@arm.com>
References: <1468838899-34909-1-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 63C0C49B34
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2016 06:42:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id t-3D2ZDPVoUe for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jul 2016 06:42:45 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8550D49B6A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2016 06:42:44 -0400 (EDT)
In-Reply-To: <1468838899-34909-1-git-send-email-vladimir.murzin@arm.com>
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
Cc: marc.zyngier@arm.com, andre.przywara@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

It is time to get access to common version of vgic-v3.

We basically need to tell build system how to pick it up and undo
KVM_ARM_VGIC_V3 guarding introduced in 4f64cb6 "arm/arm64: KVM: Only
allow 64bit hosts to build VGICv3" coupled with stubs removal.

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
 arch/arm64/kvm/Kconfig              |    4 ---
 include/kvm/arm_vgic.h              |    8 ------
 virt/kvm/arm/vgic/vgic-kvm-device.c |    8 ------
 virt/kvm/arm/vgic/vgic-mmio.c       |    2 --
 virt/kvm/arm/vgic/vgic.h            |   53 -----------------------------------
 10 files changed, 30 insertions(+), 77 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 96387d4..7b663c9 100644
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
index 91a4ed9..31e8ec0 100644
--- a/arch/arm/include/asm/kvm_hyp.h
+++ b/arch/arm/include/asm/kvm_hyp.h
@@ -91,6 +91,8 @@
 
 #define VFP_FPEXC	__ACCESS_VFP(FPEXC)
 
+#define ID_PFR1		__ACCESS_CP15(c0, 0, c1, 1)
+
 /* AArch64 compatibility macros, only for the timer so far */
 #define read_sysreg_el0(r)		read_sysreg(r##_el0)
 #define write_sysreg_el0(v, r)		write_sysreg(v, r##_el0)
@@ -106,6 +108,9 @@ void __timer_restore_state(struct kvm_vcpu *vcpu);
 void __vgic_v2_save_state(struct kvm_vcpu *vcpu);
 void __vgic_v2_restore_state(struct kvm_vcpu *vcpu);
 
+void __vgic_v3_save_state(struct kvm_vcpu *vcpu);
+void __vgic_v3_restore_state(struct kvm_vcpu *vcpu);
+
 void __sysreg_save_state(struct kvm_cpu_context *ctxt);
 void __sysreg_restore_state(struct kvm_cpu_context *ctxt);
 
diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
index 5e28df8..166a7eb 100644
--- a/arch/arm/kvm/Makefile
+++ b/arch/arm/kvm/Makefile
@@ -26,7 +26,9 @@ obj-y += $(KVM)/arm/vgic/vgic.o
 obj-y += $(KVM)/arm/vgic/vgic-init.o
 obj-y += $(KVM)/arm/vgic/vgic-irqfd.o
 obj-y += $(KVM)/arm/vgic/vgic-v2.o
+obj-y += $(KVM)/arm/vgic/vgic-v3.o
 obj-y += $(KVM)/arm/vgic/vgic-mmio.o
 obj-y += $(KVM)/arm/vgic/vgic-mmio-v2.o
+obj-y += $(KVM)/arm/vgic/vgic-mmio-v3.o
 obj-y += $(KVM)/arm/vgic/vgic-kvm-device.o
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
index aa2e34e..99e5ec80 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -16,9 +16,6 @@ menuconfig VIRTUALIZATION
 
 if VIRTUALIZATION
 
-config KVM_ARM_VGIC_V3
-	bool
-
 config KVM
 	bool "Kernel-based Virtual Machine (KVM) support"
 	depends on OF
@@ -34,7 +31,6 @@ config KVM
 	select KVM_VFIO
 	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_IRQFD
-	select KVM_ARM_VGIC_V3
 	select KVM_ARM_PMU if HW_PERF_EVENTS
 	---help---
 	  Support hosting virtualized guest machines.
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 1264037..06be297 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -159,7 +159,6 @@ struct vgic_v2_cpu_if {
 };
 
 struct vgic_v3_cpu_if {
-#ifdef CONFIG_KVM_ARM_VGIC_V3
 	u32		vgic_hcr;
 	u32		vgic_vmcr;
 	u32		vgic_sre;	/* Restored only, change ignored */
@@ -169,7 +168,6 @@ struct vgic_v3_cpu_if {
 	u32		vgic_ap0r[4];
 	u32		vgic_ap1r[4];
 	u64		vgic_lr[VGIC_V3_MAX_LRS];
-#endif
 };
 
 struct vgic_cpu {
@@ -224,13 +222,7 @@ bool kvm_vcpu_has_pending_irqs(struct kvm_vcpu *vcpu);
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
index 0130c4b..c4ae083a 100644
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
@@ -217,12 +215,10 @@ void kvm_register_vgic_device(unsigned long type)
 		kvm_register_device_ops(&kvm_arm_vgic_v2_ops,
 					KVM_DEV_TYPE_ARM_VGIC_V2);
 		break;
-#ifdef CONFIG_KVM_ARM_VGIC_V3
 	case KVM_DEV_TYPE_ARM_VGIC_V3:
 		kvm_register_device_ops(&kvm_arm_vgic_v3_ops,
 					KVM_DEV_TYPE_ARM_VGIC_V3);
 		break;
-#endif
 	}
 }
 
@@ -382,8 +378,6 @@ struct kvm_device_ops kvm_arm_vgic_v2_ops = {
 
 /* V3 ops */
 
-#ifdef CONFIG_KVM_ARM_VGIC_V3
-
 static int vgic_v3_set_attr(struct kvm_device *dev,
 			    struct kvm_device_attr *attr)
 {
@@ -427,5 +421,3 @@ struct kvm_device_ops kvm_arm_vgic_v3_ops = {
 	.has_attr = vgic_v3_has_attr,
 };
 
-#endif /* CONFIG_KVM_ARM_VGIC_V3 */
-
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index 9f6fab7..6678aca 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -503,11 +503,9 @@ int vgic_register_dist_iodev(struct kvm *kvm, gpa_t dist_base_address,
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
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 7b300ca..6c2aa35 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -59,7 +59,6 @@ int vgic_v2_map_resources(struct kvm *kvm);
 int vgic_register_dist_iodev(struct kvm *kvm, gpa_t dist_base_address,
 			     enum vgic_type);
 
-#ifdef CONFIG_KVM_ARM_VGIC_V3
 void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu);
 void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu);
 void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
@@ -71,58 +70,6 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu);
 int vgic_v3_probe(const struct gic_kvm_info *info);
 int vgic_v3_map_resources(struct kvm *kvm);
 int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t dist_base_address);
-#else
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
-#endif
 
 void kvm_register_vgic_device(unsigned long type);
 int vgic_lazy_init(struct kvm *kvm);
-- 
1.7.9.5
