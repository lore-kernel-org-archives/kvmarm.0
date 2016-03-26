From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v4 12/12] KVM: arm64: enable ITS emulation as a virtual MSI
 controller
Date: Sat, 26 Mar 2016 02:14:10 +0000
Message-ID: <1458958450-19662-13-git-send-email-andre.przywara@arm.com>
References: <1458958450-19662-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 629F740F77
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Mar 2016 22:13:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lMVbGTPMJHro for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Mar 2016 22:13:37 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F5C0499A1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Mar 2016 22:13:37 -0400 (EDT)
In-Reply-To: <1458958450-19662-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
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
 arch/arm64/kvm/reset.c            | 10 ++++++++++
 include/kvm/vgic/vgic.h           |  6 ++++++
 virt/kvm/arm/vgic.c               |  5 +++++
 virt/kvm/arm/vgic/its-emul.c      |  3 ++-
 virt/kvm/arm/vgic/vgic.c          |  8 ++++++++
 virt/kvm/arm/vgic/vgic_mmio.c     | 12 ++++++++++--
 8 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 8f7351d..536f19b 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -2150,7 +2150,7 @@ after pausing the vcpu, but before it is resumed.
 4.71 KVM_SIGNAL_MSI
 
 Capability: KVM_CAP_SIGNAL_MSI
-Architectures: x86
+Architectures: x86 arm64
 Type: vm ioctl
 Parameters: struct kvm_msi (in)
 Returns: >0 on delivery, 0 if guest blocked the MSI, and -1 on error
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 3f0e1ce..71c9ebc 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -37,6 +37,7 @@ config KVM
 	select HAVE_KVM_IRQFD
 	select KVM_ARM_VGIC_V3
 	select KVM_ARM_PMU if HW_PERF_EVENTS
+	select HAVE_KVM_MSI
 	---help---
 	  Support hosting virtualized guest machines.
 	  We don't support KVM with 16K page tables yet, due to the multiple
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 2ba7c8d..43c3836 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -84,6 +84,16 @@ int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_VCPU_ATTRIBUTES:
 		r = 1;
 		break;
+	case KVM_CAP_MSI_DEVID:
+#ifdef CONFIG_KVM_NEW_VGIC
+		if (!kvm)
+			r = -EINVAL;
+		else
+			r = kvm->arch.vgic.msis_require_devid;
+#else
+		r = -EINVAL;
+#endif
+		break;
 	default:
 		r = 0;
 	}
diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
index ea98133..c50890f 100644
--- a/include/kvm/vgic/vgic.h
+++ b/include/kvm/vgic/vgic.h
@@ -115,6 +115,7 @@ struct vgic_io_device {
 
 struct vgic_its {
 	bool			enabled;
+	struct vgic_io_device	iodev;
 	spinlock_t		lock;
 	u64			cbaser;
 	int			creadr;
@@ -133,6 +134,9 @@ struct vgic_dist {
 	/* vGIC model the kernel emulates for the guest (GICv2 or GICv3) */
 	u32			vgic_model;
 
+	/* Do injected MSIs require an additional device ID? */
+	bool			msis_require_devid;
+
 	int			nr_spis;
 
 	/* TODO: Consider moving to global state */
@@ -280,4 +284,6 @@ static inline int kvm_vgic_get_max_vcpus(void)
 
 bool vgic_has_its(struct kvm *kvm);
 
+int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi);
+
 #endif /* __ASM_ARM_KVM_VGIC_VGIC_H */
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 079b0a7..3f01f7b 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -2470,3 +2470,8 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 {
 	return 0;
 }
+
+int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi)
+{
+	return -ENODEV;
+}
diff --git a/virt/kvm/arm/vgic/its-emul.c b/virt/kvm/arm/vgic/its-emul.c
index 166551d..f9d289a 100644
--- a/virt/kvm/arm/vgic/its-emul.c
+++ b/virt/kvm/arm/vgic/its-emul.c
@@ -1098,8 +1098,9 @@ int vits_init(struct kvm *kvm)
 		return ret;
 
 	its->enabled = false;
+	dist->msis_require_devid = true;
 
-	return -ENXIO;
+	return 0;
 }
 
 void vits_destroy(struct kvm *kvm)
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 1de2478..82bfb33 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -622,3 +622,11 @@ bool vgic_has_its(struct kvm *kvm)
 
 	return !IS_VGIC_ADDR_UNDEF(dist->vgic_its_base);
 }
+
+int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi)
+{
+	if (vgic_has_its(kvm))
+		return vits_inject_msi(kvm, msi);
+	else
+		return -ENODEV;
+}
diff --git a/virt/kvm/arm/vgic/vgic_mmio.c b/virt/kvm/arm/vgic/vgic_mmio.c
index 086555e..065934f 100644
--- a/virt/kvm/arm/vgic/vgic_mmio.c
+++ b/virt/kvm/arm/vgic/vgic_mmio.c
@@ -619,7 +619,12 @@ static int vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
 	case GICD_TYPER:
 		value = vcpu->kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
 		value = (value >> 5) - 1;
-		value |= (INTERRUPT_ID_BITS_SPIS - 1) << 19;
+		if (vgic_has_its(vcpu->kvm)) {
+			value |= (INTERRUPT_ID_BITS_ITS - 1) << 19;
+			value |= GICD_TYPER_LPIS;
+		} else {
+			value |= (INTERRUPT_ID_BITS_SPIS - 1) << 19;
+		}
 		break;
 	case GICD_IIDR:
 		value = (PRODUCT_ID_KVM << 24) | (IMPLEMENTER_ARM << 0);
@@ -742,7 +747,8 @@ static int vgic_mmio_write_v3r_misc(struct kvm_vcpu *vcpu,
 
 	if (vgic_has_its(vcpu->kvm) && !dist->lpis_enabled &&
 	    (reg & GICR_CTLR_ENABLE_LPIS)) {
-		/* Eventually do something */
+		vgic_enable_lpis(vcpu);
+		dist->lpis_enabled = true;
 	}
 
 	return 0;
@@ -772,6 +778,8 @@ static int vgic_mmio_read_v3r_typer(struct kvm_vcpu *vcpu,
 	value |= ((target_vcpu_id & 0xffff) << 8);
 	if (target_vcpu_id == atomic_read(&vcpu->kvm->online_vcpus) - 1)
 		value |= GICR_TYPER_LAST;
+	if (vgic_has_its(vcpu->kvm))
+		value |= GICR_TYPER_PLPIS;
 
 	write_mask64(value, addr & 7, len, val);
 	return 0;
-- 
2.7.3
