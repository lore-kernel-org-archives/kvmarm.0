From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v2 15/15] KVM: arm64: enable ITS emulation as a virtual MSI
 controller
Date: Fri, 10 Jul 2015 15:21:51 +0100
Message-ID: <1436538111-4294-16-git-send-email-andre.przywara@arm.com>
References: <1436538111-4294-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DF115858D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2015 10:10:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EeXdeK115HPc for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Jul 2015 10:10:44 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A603D585F4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2015 10:10:44 -0400 (EDT)
In-Reply-To: <1436538111-4294-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, christoffer.dall@linaro.org, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

If userspace has provided a base address for the ITS register frame,
we enable the bits that advertise LPIs in the GICv3.
When the guest has enabled LPIs and the ITS, we enable the emulation
part by initializing the ITS data structures and trapping on ITS
register frame accesses by the guest.
Also we enable the KVM_SIGNAL_MSI feature to allow userland to inject
MSIs into the guest. Not having enabled the ITS emulation will lead
to a -ENODEV when trying to inject a MSI.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 Documentation/virtual/kvm/api.txt |  2 +-
 arch/arm64/kvm/Kconfig            |  1 +
 arch/arm64/kvm/reset.c            |  6 ++++++
 include/kvm/arm_vgic.h            |  6 ++++++
 virt/kvm/arm/its-emul.c           | 10 +++++++++-
 virt/kvm/arm/vgic-v3-emul.c       | 20 ++++++++++++++------
 virt/kvm/arm/vgic.c               |  8 ++++++++
 7 files changed, 45 insertions(+), 8 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index cb04095..1b53155 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -2134,7 +2134,7 @@ after pausing the vcpu, but before it is resumed.
 4.71 KVM_SIGNAL_MSI
 
 Capability: KVM_CAP_SIGNAL_MSI
-Architectures: x86
+Architectures: x86 arm64
 Type: vm ioctl
 Parameters: struct kvm_msi (in)
 Returns: >0 on delivery, 0 if guest blocked the MSI, and -1 on error
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index bfffe8f..ff9722f 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -31,6 +31,7 @@ config KVM
 	select KVM_VFIO
 	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_IRQFD
+	select HAVE_KVM_MSI
 	---help---
 	  Support hosting virtualized guest machines.
 
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 866502b..aff209e 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -64,6 +64,12 @@ int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_EL1_32BIT:
 		r = cpu_has_32bit_el1();
 		break;
+	case KVM_CAP_MSI_DEVID:
+		if (!kvm)
+			r = -EINVAL;
+		else
+			r = kvm->arch.vgic.msis_require_devid;
+		break;
 	default:
 		r = 0;
 	}
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 9e1abf9..f50081c 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -162,6 +162,7 @@ struct vgic_io_device {
 
 struct vgic_its {
 	bool			enabled;
+	struct vgic_io_device	iodev;
 	spinlock_t		lock;
 	u64			cbaser;
 	int			creadr;
@@ -180,6 +181,9 @@ struct vgic_dist {
 	/* vGIC model the kernel emulates for the guest (GICv2 or GICv3) */
 	u32			vgic_model;
 
+	/* Do injected MSIs require an additional device ID? */
+	bool			msis_require_devid;
+
 	int			nr_cpus;
 	int			nr_irqs;
 
@@ -371,4 +375,6 @@ static inline int vgic_v3_probe(struct device_node *vgic_node,
 }
 #endif
 
+int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi);
+
 #endif
diff --git a/virt/kvm/arm/its-emul.c b/virt/kvm/arm/its-emul.c
index a1c12bb..b6caefd 100644
--- a/virt/kvm/arm/its-emul.c
+++ b/virt/kvm/arm/its-emul.c
@@ -1073,6 +1073,7 @@ int vits_init(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	struct vgic_its *its = &dist->its;
+	int ret;
 
 	dist->pendbaser = kmalloc(sizeof(u64) * dist->nr_cpus, GFP_KERNEL);
 	if (!dist->pendbaser)
@@ -1087,9 +1088,16 @@ int vits_init(struct kvm *kvm)
 	INIT_LIST_HEAD(&its->device_list);
 	INIT_LIST_HEAD(&its->collection_list);
 
+	ret = vgic_register_kvm_io_dev(kvm, dist->vgic_its_base,
+				       KVM_VGIC_V3_ITS_SIZE, vgicv3_its_ranges,
+				       -1, &its->iodev);
+	if (ret)
+		return ret;
+
 	its->enabled = false;
+	dist->msis_require_devid = true;
 
-	return -ENXIO;
+	return 0;
 }
 
 void vits_destroy(struct kvm *kvm)
diff --git a/virt/kvm/arm/vgic-v3-emul.c b/virt/kvm/arm/vgic-v3-emul.c
index 30bf7035..9fd1238 100644
--- a/virt/kvm/arm/vgic-v3-emul.c
+++ b/virt/kvm/arm/vgic-v3-emul.c
@@ -8,7 +8,6 @@
  *
  * Limitations of the emulation:
  * (RAZ/WI: read as zero, write ignore, RAO/WI: read as one, write ignore)
- * - We do not support LPIs (yet). TYPER.LPIS is reported as 0 and is RAZ/WI.
  * - We do not support the message based interrupts (MBIs) triggered by
  *   writes to the GICD_{SET,CLR}SPI_* registers. TYPER.MBIS is reported as 0.
  * - We do not support the (optional) backwards compatibility feature.
@@ -87,10 +86,10 @@ static bool handle_mmio_ctlr(struct kvm_vcpu *vcpu,
 /*
  * As this implementation does not provide compatibility
  * with GICv2 (ARE==1), we report zero CPUs in bits [5..7].
- * Also LPIs and MBIs are not supported, so we set the respective bits to 0.
- * Also we report at most 2**10=1024 interrupt IDs (to match 1024 SPIs).
+ * Also we report at most 2**10=1024 interrupt IDs (to match 1024 SPIs)
+ * and provide 16 bits worth of LPI number space (to give 8192 LPIs).
  */
-#define INTERRUPT_ID_BITS 10
+#define INTERRUPT_ID_BITS_SPIS 10
 static bool handle_mmio_typer(struct kvm_vcpu *vcpu,
 			      struct kvm_exit_mmio *mmio, phys_addr_t offset)
 {
@@ -98,7 +97,12 @@ static bool handle_mmio_typer(struct kvm_vcpu *vcpu,
 
 	reg = (min(vcpu->kvm->arch.vgic.nr_irqs, 1024) >> 5) - 1;
 
-	reg |= (INTERRUPT_ID_BITS - 1) << 19;
+	if (vgic_has_its(vcpu->kvm)) {
+		reg |= GICD_TYPER_LPIS;
+		reg |= (INTERRUPT_ID_BITS_ITS - 1) << 19;
+	} else {
+		reg |= (INTERRUPT_ID_BITS_SPIS - 1) << 19;
+	}
 
 	vgic_reg_access(mmio, &reg, offset,
 			ACCESS_READ_VALUE | ACCESS_WRITE_IGNORED);
@@ -543,7 +547,9 @@ static bool handle_mmio_ctlr_redist(struct kvm_vcpu *vcpu,
 	vgic_reg_access(mmio, &reg, offset,
 			ACCESS_READ_VALUE | ACCESS_WRITE_VALUE);
 	if (!dist->lpis_enabled && (reg & GICR_CTLR_ENABLE_LPIS)) {
-		/* Eventually do something */
+		vgic_enable_lpis(vcpu);
+		dist->lpis_enabled = true;
+		return true;
 	}
 	return false;
 }
@@ -570,6 +576,8 @@ static bool handle_mmio_typer_redist(struct kvm_vcpu *vcpu,
 	reg = redist_vcpu->vcpu_id << 8;
 	if (target_vcpu_id == atomic_read(&vcpu->kvm->online_vcpus) - 1)
 		reg |= GICR_TYPER_LAST;
+	if (vgic_has_its(vcpu->kvm))
+		reg |= GICR_TYPER_PLPIS;
 	vgic_reg_access(mmio, &reg, offset,
 			ACCESS_READ_VALUE | ACCESS_WRITE_IGNORED);
 	return false;
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 9dfd094..081a1ef 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -2246,3 +2246,11 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 {
 	return 0;
 }
+
+int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi)
+{
+	if (kvm->arch.vgic.vm_ops.inject_msi)
+		return kvm->arch.vgic.vm_ops.inject_msi(kvm, msi);
+	else
+		return -ENODEV;
+}
-- 
2.3.5
