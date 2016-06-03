From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v5 13/13] KVM: arm64: enable ITS emulation as a virtual MSI controller
Date: Fri,  3 Jun 2016 15:02:52 +0100
Message-ID: <1464962572-3925-14-git-send-email-andre.przywara@arm.com>
References: <1464962572-3925-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1464962572-3925-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
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
 include/kvm/vgic/vgic.h           |  5 +++++
 virt/kvm/arm/vgic.c               |  5 +++++
 virt/kvm/arm/vgic/vgic-init.c     |  3 +++
 virt/kvm/arm/vgic/vgic-its.c      |  2 ++
 virt/kvm/arm/vgic/vgic-mmio-v3.c  | 14 ++++++++++----
 virt/kvm/arm/vgic/vgic.c          |  8 ++++++++
 9 files changed, 45 insertions(+), 5 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index bf76639..f60b137 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -2156,7 +2156,7 @@ after pausing the vcpu, but before it is resumed.
 4.71 KVM_SIGNAL_MSI
 
 Capability: KVM_CAP_SIGNAL_MSI
-Architectures: x86
+Architectures: x86 arm64
 Type: vm ioctl
 Parameters: struct kvm_msi (in)
 Returns: >0 on delivery, 0 if guest blocked the MSI, and -1 on error
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index c4f26ef..446686a 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -36,6 +36,7 @@ config KVM
 	select HAVE_KVM_IRQFD
 	select KVM_ARM_VGIC_V3
 	select KVM_ARM_PMU if HW_PERF_EVENTS
+	select HAVE_KVM_MSI
 	---help---
 	  Support hosting virtualized guest machines.
 	  We don't support KVM with 16K page tables yet, due to the multiple
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 6ec9dfe..409d188 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -86,6 +86,16 @@ int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
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
index dec63f0..52c920f 100644
--- a/include/kvm/vgic/vgic.h
+++ b/include/kvm/vgic/vgic.h
@@ -143,6 +143,9 @@ struct vgic_dist {
 	/* vGIC model the kernel emulates for the guest (GICv2 or GICv3) */
 	u32			vgic_model;
 
+	/* Do injected MSIs require an additional device ID? */
+	bool			msis_require_devid;
+
 	int			nr_spis;
 
 	/* TODO: Consider moving to global state */
@@ -281,4 +284,6 @@ static inline int kvm_vgic_get_max_vcpus(void)
 	return kvm_vgic_global_state.max_gic_vcpus;
 }
 
+int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi);
+
 #endif /* __ASM_ARM_KVM_VGIC_VGIC_H */
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index c3bfbb9..26db30a 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -2438,3 +2438,8 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 {
 	return 0;
 }
+
+int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi)
+{
+	return -ENODEV;
+}
diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index adf3c1d..08e9e18 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -254,6 +254,9 @@ int vgic_init(struct kvm *kvm)
 	if (ret)
 		goto out;
 
+	if (vgic_has_its(kvm))
+		dist->msis_require_devid = true;
+
 	list_for_each_entry(its, &kvm->arch.vits_list, its_list) {
 		ret = vits_init(kvm, its);
 		if (ret)
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index c257b08..f868b5b 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1104,6 +1104,8 @@ int vits_init(struct kvm *kvm, struct vgic_its *its)
 				      SZ_64K, &iodev->dev);
 	mutex_unlock(&kvm->slots_lock);
 
+	its->enabled = false;
+
 	return ret;
 }
 
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 04cc393..4105e19 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -63,7 +63,12 @@ static unsigned long vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
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
@@ -155,9 +160,8 @@ static void vgic_mmio_write_v3r_ctlr(struct kvm_vcpu *vcpu,
 
 	vgic_cpu->lpis_enabled = val & GICR_CTLR_ENABLE_LPIS;
 
-	if (!was_enabled && vgic_cpu->lpis_enabled) {
-		/* Eventually do something */
-	}
+	if (!was_enabled && vgic_cpu->lpis_enabled)
+		vgic_enable_lpis(vcpu);
 }
 
 static unsigned long vgic_mmio_read_v3r_typer(struct kvm_vcpu *vcpu,
@@ -171,6 +175,8 @@ static unsigned long vgic_mmio_read_v3r_typer(struct kvm_vcpu *vcpu,
 	value |= ((target_vcpu_id & 0xffff) << 8);
 	if (target_vcpu_id == atomic_read(&vcpu->kvm->online_vcpus) - 1)
 		value |= GICR_TYPER_LAST;
+	if (vgic_has_its(vcpu->kvm))
+		value |= GICR_TYPER_PLPIS;
 
 	return extract_bytes(value, addr & 7, len);
 }
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 6812ff1..44a1fe2 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -617,3 +617,11 @@ bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq)
 
 	return map_is_active;
 }
+
+int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi)
+{
+	if (vgic_has_its(kvm))
+		return vits_inject_msi(kvm, msi);
+	else
+		return -ENODEV;
+}
-- 
2.8.2

