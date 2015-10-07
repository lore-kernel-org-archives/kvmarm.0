From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v3 16/16] KVM: arm64: enable ITS emulation as a virtual MSI controller
Date: Wed,  7 Oct 2015 15:55:26 +0100
Message-ID: <1444229726-31559-17-git-send-email-andre.przywara@arm.com>
References: <1444229726-31559-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1444229726-31559-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: eric.auger@linaro.org, p.fedin@samsung.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
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
Changelog v2..v3:
- replace kmalloc with kcalloc
- adjust number of supported LPIs in comment

 Documentation/virtual/kvm/api.txt |  2 +-
 arch/arm64/kvm/Kconfig            |  1 +
 arch/arm64/kvm/reset.c            |  6 ++++++
 include/kvm/arm_vgic.h            |  6 ++++++
 virt/kvm/arm/its-emul.c           | 10 +++++++++-
 virt/kvm/arm/vgic-v3-emul.c       | 20 ++++++++++++++------
 virt/kvm/arm/vgic.c               |  8 ++++++++
 7 files changed, 45 insertions(+), 8 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index a302e0a..047e4e7 100644
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
index 5c7e920..e8d77f4 100644
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
index 4d7f78b4..a490f67 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -80,6 +80,12 @@ int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SET_GUEST_DEBUG:
 		r = 1;
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
index 7911059..35657f9 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -174,6 +174,7 @@ struct irq_phys_map_entry {
 
 struct vgic_its {
 	bool			enabled;
+	struct vgic_io_device	iodev;
 	spinlock_t		lock;
 	u64			cbaser;
 	int			creadr;
@@ -192,6 +193,9 @@ struct vgic_dist {
 	/* vGIC model the kernel emulates for the guest (GICv2 or GICv3) */
 	u32			vgic_model;
 
+	/* Do injected MSIs require an additional device ID? */
+	bool			msis_require_devid;
+
 	int			nr_cpus;
 	int			nr_irqs;
 
@@ -397,4 +401,6 @@ static inline int vgic_v3_probe(struct device_node *vgic_node,
 }
 #endif
 
+int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi);
+
 #endif
diff --git a/virt/kvm/arm/its-emul.c b/virt/kvm/arm/its-emul.c
index cd8526a..b40a7fc 100644
--- a/virt/kvm/arm/its-emul.c
+++ b/virt/kvm/arm/its-emul.c
@@ -1117,6 +1117,7 @@ int vits_init(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	struct vgic_its *its = &dist->its;
+	int ret;
 
 	dist->pendbaser = kcalloc(dist->nr_cpus, sizeof(u64), GFP_KERNEL);
 	if (!dist->pendbaser)
@@ -1131,9 +1132,16 @@ int vits_init(struct kvm *kvm)
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
index 90f3628..311b3ea 100644
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
+ * and provide 16 bits worth of LPI number space (to give 57344 LPIs).
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
@@ -539,7 +543,9 @@ static bool handle_mmio_ctlr_redist(struct kvm_vcpu *vcpu,
 			ACCESS_READ_VALUE | ACCESS_WRITE_VALUE);
 	if (vgic_has_its(vcpu->kvm) && !dist->lpis_enabled &&
 	    (reg & GICR_CTLR_ENABLE_LPIS)) {
-		/* Eventually do something */
+		vgic_enable_lpis(vcpu);
+		dist->lpis_enabled = true;
+		return true;
 	}
 	return false;
 }
@@ -566,6 +572,8 @@ static bool handle_mmio_typer_redist(struct kvm_vcpu *vcpu,
 	reg = redist_vcpu->vcpu_id << 8;
 	if (target_vcpu_id == atomic_read(&vcpu->kvm->online_vcpus) - 1)
 		reg |= GICR_TYPER_LAST;
+	if (vgic_has_its(vcpu->kvm))
+		reg |= GICR_TYPER_PLPIS;
 	vgic_reg_access(mmio, &reg, offset,
 			ACCESS_READ_VALUE | ACCESS_WRITE_IGNORED);
 	return false;
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 9ee87d3..372cb20 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -2571,3 +2571,11 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
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
2.5.1

